
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/chat_message.dart';
import '../models/consultation_session.dart';
import '../services/consultation_session_service.dart';

class ConsultationChatScreen extends StatefulWidget {
  final String sessionId;

  const ConsultationChatScreen({super.key, required this.sessionId});

  @override
  State<ConsultationChatScreen> createState() => _ConsultationChatScreenState();
}

class _ConsultationChatScreenState extends State<ConsultationChatScreen> {
  final _messageController = TextEditingController();
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    final consultationService = Provider.of<ConsultationSessionService>(context, listen: false);

    // Attempt to start the session. The service handles the logic.
    // This should ideally be triggered by a more explicit user action.
    consultationService.startSession(widget.sessionId).catchError((e) {
      // Handle cases where the session can't be started, e.g., show a dialog
      debugPrint("Error starting session: $e");
    });

    // This timer is only for updating the UI every second to show a live countdown.
    // It does not control the session's actual state.
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {}); // Force a rebuild to update the countdown timer display
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
    final consultationService = Provider.of<ConsultationSessionService>(context, listen: false);

    return StreamProvider<ConsultationSession?>.value(
      value: consultationService.getSessionStream(widget.sessionId),
      initialData: null,
      catchError: (_, error) {
        debugPrint("Error in session stream: $error");
        return null; // Return null or a default session object on error
      },
      child: Consumer<ConsultationSession?>(
        builder: (context, session, _) {
          if (session == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Chat')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          // UI-only calculation for remaining time.
          Duration remainingTime = Duration.zero;
          bool isSessionActive = session.status == ConsultationStatus.active && session.endTime != null;

          if (isSessionActive) {
            remainingTime = session.endTime!.difference(DateTime.now());
            if (remainingTime.isNegative) {
              remainingTime = Duration.zero;
              // The session has expired. The UI will update, and server rules will block new messages.
            }
          }

          final minutes = remainingTime.inMinutes.toString().padLeft(2, '0');
          final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

          return Scaffold(
            appBar: AppBar(
              title: const Text('Live Consultation'),
              actions: [
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
                    value: consultationService.getMessages(widget.sessionId),
                    initialData: const [],
                    child: const MessageList(),
                  ),
                ),
                // Show input field only if the session is active and time remains.
                if (isSessionActive && remainingTime > Duration.zero)
                  _buildMessageInputField(context, user, consultationService, session)
                else
                  _buildSessionEndedBanner(session.status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionEndedBanner(ConsultationStatus status) {
    String message;
    switch (status) {
      case ConsultationStatus.completed:
        message = 'This session has been completed.';
        break;
      case ConsultationStatus.expired:
        message = 'This session has expired.';
        break;
      case ConsultationStatus.cancelled:
        message = 'This session was cancelled.';
        break;
      default:
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
    ConsultationSessionService consultationService,
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
              onSubmitted: (text) => _sendMessage(user, consultationService, session.id),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(user, consultationService, session.id),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // This should eventually be tied to a payment flow.
              consultationService.extendSession(widget.sessionId, 10).then((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
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

  void _sendMessage(AppUser? user, ConsultationSessionService consultationService, String sessionId) {
    if (_messageController.text.isNotEmpty && user != null) {
      final message = ChatMessage(
        id: '',
        sessionId: sessionId,
        senderId: user.id,
        messageType: MessageType.text,
        content: _messageController.text,
        timestamp: DateTime.now(), // Firestore will use server timestamp eventually
      );
      consultationService.sendMessage(message).catchError((e) {
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
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<ChatMessage>>(context);
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const Center(child: Text("Not logged in."));
    }

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == user.id;
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
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
