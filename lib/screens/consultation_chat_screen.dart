
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/chat_message.dart';
import '../models/consultation_session.dart';
import '../models/consultation_status.dart';
import '../services/consultation_session_service.dart';
import 'video_call_screen.dart';

class ConsultationChatScreen extends StatefulWidget {
  final String sessionId;

  const ConsultationChatScreen({super.key, required this.sessionId});

  @override
  State<ConsultationChatScreen> createState() => _ConsultationChatScreenState();
}

class _ConsultationChatScreenState extends State<ConsultationChatScreen> {
  final _messageController = TextEditingController();
  Timer? _uiUpdateTimer;
  final ConsultationSessionService _consultationService = ConsultationSessionService();

  @override
  void initState() {
    super.initState();

    _consultationService.startSession(widget.sessionId).catchError((e) {
      debugPrint("Error starting session: $e");
    });

    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return StreamProvider<ConsultationSession?>.value(
      value: _consultationService.getSessionStream(widget.sessionId),
      initialData: null,
      catchError: (_, error) {
        debugPrint("Error in session stream: $error");
        return null;
      },
      child: Consumer<ConsultationSession?>(
        builder: (context, session, _) {
          if (session == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Chat')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          Duration remainingTime = Duration.zero;
          bool isSessionActive = session.status == ConsultationStatus.active.name && session.endTime != null;

          if (isSessionActive) {
            remainingTime = session.endTime!.difference(DateTime.now());
            if (remainingTime.isNegative) {
              remainingTime = Duration.zero;
            }
          }

          final minutes = remainingTime.inMinutes.toString().padLeft(2, '0');
          final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

          return Scaffold(
            appBar: AppBar(
              title: const Text('Live Consultation'),
              actions: [
                if (isSessionActive && session.channelId != null)
                  IconButton(
                    icon: const Icon(Icons.videocam),
                    tooltip: 'Join Video Call',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoCallScreen(
                          channelId: session.channelId!,
                          sessionId: widget.sessionId,
                        ),
                      ),
                    ),
                  ),
                if (isSessionActive)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Chip(
                        avatar: Icon(Icons.timer, color: Theme.of(context).colorScheme.primary),
                        label: Text(
                          '$minutes:$seconds',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamProvider<List<ChatMessage>>.value(
                    value: _consultationService.getMessages(widget.sessionId),
                    initialData: const [],
                    child: MessageList(currentUser: user),
                  ),
                ),
                if (isSessionActive && remainingTime > Duration.zero)
                  _buildMessageInputField(context, user, session)
                else
                  _buildSessionEndedBanner(session.status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionEndedBanner(String status) {
    String message;
    if (status == ConsultationStatus.completed.name) {
      message = 'This session has been completed.';
    } else if (status == ConsultationStatus.expired.name) {
      message = 'This session has expired.';
    } else if (status == ConsultationStatus.cancelled.name) {
      message = 'This session was cancelled.';
    } else {
      message = 'The chat is currently unavailable.';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.grey.shade300,
      child: Text(message, textAlign: TextAlign.center),
    );
  }

  Widget _buildMessageInputField(
    BuildContext context,
    AppUser? user,
    ConsultationSession session,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onSubmitted: (text) => _sendMessage(user, session.id),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(user, session.id),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              _consultationService.extendSession(widget.sessionId, 10).then((_) {
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Session extended by 10 minutes!')),
                  );
                }
              });
            },
            tooltip: 'Extend Session by 10 minutes',
          ),
        ],
      ),
    );
  }

  void _sendMessage(AppUser? user, String sessionId) {
    if (_messageController.text.isNotEmpty && user != null) {
      final message = ChatMessage(
        id: '',
        sessionId: sessionId,
        senderId: user.id,
        messageType: MessageType.text,
        messageText: _messageController.text,
        timestamp: DateTime.now(),
      );
      _consultationService.sendMessage(message).catchError((e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send message: ${e.toString()}')),
          );
        }
      });
      _messageController.clear();
    }
  }
}

class MessageList extends StatelessWidget {
  final AppUser? currentUser;

  const MessageList({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<ChatMessage>>(context);

    if (currentUser == null) {
      return const Center(child: Text("Not logged in."));
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUser!.id;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.messageText ?? '',
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
