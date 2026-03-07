
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// Agora-powered video consultation screen.
///
/// Requires:
///   1. Set [AppConfig.agoraAppId] in lib/config/app_config.dart
///   2. CAMERA and RECORD_AUDIO permissions (AndroidManifest.xml / Info.plist)
///   3. For production: a token server — set [AppConfig.agoraTokenServerUrl]
class VideoCallScreen extends StatefulWidget {
  final String channelId;
  final String sessionId;

  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.sessionId,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RtcEngine? _engine;
  bool _localVideoEnabled = true;
  bool _audioMuted = false;
  int? _remoteUid;
  bool _joined = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initAgora();
    }
  }

  Future<void> _initAgora() async {
    if (AppConfig.agoraAppId == 'YOUR_AGORA_APP_ID') {
      setState(() => _error =
          'Agora App ID not configured.\nSet AppConfig.agoraAppId in lib/config/app_config.dart');
      return;
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: AppConfig.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (mounted) setState(() => _joined = true);
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (mounted) setState(() => _remoteUid = remoteUid);
          },
          onUserOffline: (connection, remoteUid, reason) {
            if (mounted) setState(() => _remoteUid = null);
          },
          onError: (err, msg) {
            if (mounted) setState(() => _error = 'Agora error [$err]: $msg');
          },
        ),
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();

      await _engine!.joinChannel(
        token: '', // TODO: fetch token from your token server
        channelId: widget.channelId,
        uid: 0, // 0 = let Agora auto-assign
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _leaveChannel() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Web: Agora WebRTC requires a separate JS integration
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Video Consultation'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_off, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'Video calls are available on the mobile app.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Video Consultation'),
        actions: [
          if (_joined)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                backgroundColor: Colors.green.shade700,
                label: const Text('LIVE',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                avatar: const Icon(Icons.circle, color: Colors.white, size: 10),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── Remote video (fullscreen) ─────────────────────────────────
          if (_remoteUid != null && _engine != null)
            AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine!,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.channelId),
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 100, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _error ??
                          (_joined
                              ? 'Waiting for other party to join...'
                              : 'Connecting to call...'),
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    if (!_joined && _error == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: CircularProgressIndicator(color: Colors.white54),
                      ),
                  ],
                ),
              ),
            ),

          // ── Local video (picture-in-picture) ──────────────────────────
          if (_engine != null && _joined && _localVideoEnabled)
            Positioned(
              top: 16,
              right: 16,
              width: 110,
              height: 165,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white54, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
            ),

          // ── Control bar ───────────────────────────────────────────────
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ControlButton(
                  icon: _audioMuted ? Icons.mic_off : Icons.mic,
                  label: _audioMuted ? 'Unmute' : 'Mute',
                  color: _audioMuted ? Colors.red : Colors.white,
                  onTap: () async {
                    setState(() => _audioMuted = !_audioMuted);
                    await _engine?.muteLocalAudioStream(_audioMuted);
                  },
                ),
                _ControlButton(
                  icon: Icons.call_end,
                  label: 'End',
                  color: Colors.white,
                  backgroundColor: Colors.red,
                  size: 64,
                  onTap: _leaveChannel,
                ),
                _ControlButton(
                  icon: _localVideoEnabled ? Icons.videocam : Icons.videocam_off,
                  label: _localVideoEnabled ? 'Camera' : 'No Cam',
                  color: _localVideoEnabled ? Colors.white : Colors.red,
                  onTap: () async {
                    setState(() => _localVideoEnabled = !_localVideoEnabled);
                    await _engine?.muteLocalVideoStream(!_localVideoEnabled);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? backgroundColor;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.size = 52,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: color, size: size * 0.48),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
