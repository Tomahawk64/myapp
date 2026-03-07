
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/consultation_session.dart';
import '../models/consultation_status.dart';
import '../services/consultation_session_service.dart';
import 'consultation_chat_screen.dart';

class ConsultationListScreen extends StatelessWidget {
  const ConsultationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Consultations')),
      body: StreamProvider<List<ConsultationSession>>.value(
        value: ConsultationSessionService().getUserSessions(user.id),
        initialData: const [],
        child: const _ConsultationList(),
      ),
    );
  }
}

class _ConsultationList extends StatelessWidget {
  const _ConsultationList();

  @override
  Widget build(BuildContext context) {
    final sessions = Provider.of<List<ConsultationSession>>(context);

    if (sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call_rounded, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No consultations yet.\nBook one from the Pandits screen.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isActive = session.status == ConsultationStatus.active.name;
        final statusColor = _statusColor(session.status);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withValues(alpha: 0.15),
              child: Icon(
                isActive ? Icons.videocam : Icons.video_call,
                color: statusColor,
              ),
            ),
            title: Text(
              'Consultation session',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${session.status}',
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
                Text(
                  'Duration: ${session.durationMinutes} min',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: isActive
                ? const Chip(
                    label: Text('LIVE',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.green,
                  )
                : const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ConsultationChatScreen(sessionId: session.id),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'active' => Colors.green,
      'completed' => Colors.blue,
      'cancelled' => Colors.red,
      'expired' => Colors.orange,
      _ => Colors.grey,
    };
  }
}
