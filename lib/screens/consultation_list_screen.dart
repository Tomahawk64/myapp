
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/consultation_session.dart';
import 'consultation_chat_screen.dart';

class ConsultationListScreen extends StatelessWidget {
  const ConsultationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final consultationService = Provider.of<ConsultationSessionService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Consultations'),
      ),
      body: StreamProvider<List<ConsultationSession>>.value(
        value: consultationService.getUserSessions(user!.id),
        initialData: const [],
        child: const ConsultationList(),
      ),
    );
  }
}

class ConsultationList extends StatelessWidget {
  const ConsultationList({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = Provider.of<List<ConsultationSession>>(context);

    if (sessions.isEmpty) {
      return const Center(child: Text('No consultations found.'));
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.all(16),
          child: ListTile(
            title: Text('Consultation with Pandit ${session.panditId}'),
            subtitle: Text('Status: ${session.status.toString().split('.').last}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultationChatScreen(sessionId: session.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
