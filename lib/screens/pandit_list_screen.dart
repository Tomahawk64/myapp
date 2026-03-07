
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pandit_profile.dart';
import '../services/pandit_service.dart';
import '../services/review_service.dart';

class PanditListScreen extends StatefulWidget {
  const PanditListScreen({super.key});

  @override
  State<PanditListScreen> createState() => _PanditListScreenState();
}

class _PanditListScreenState extends State<PanditListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Consultation'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search for a pandit',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamProvider<List<PanditProfile>>.value(
              value: PanditService().getPandits(),
              initialData: const [],
              child: PanditList(searchQuery: _searchQuery),
            ),
          ),
        ],
      ),
    );
  }
}

class PanditList extends StatelessWidget {
  final String searchQuery;

  const PanditList({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final pandits = Provider.of<List<PanditProfile>>(context)
        .where((pandit) =>
            pandit.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: pandits.length,
      itemBuilder: (context, index) {
        final pandit = pandits[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PanditDetailsScreen(pandit: pandit),
            ),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      pandit.profileImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pandit.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pandit.specializations.join(', '),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<double>(
                        stream: ReviewService().getPanditAverageRating(pandit.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final rating = snapshot.data!;
                            return Row(
                              children: [
                                Text(rating.toStringAsFixed(1), style: Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ],
                            );
                          } else {
                            return const Text('No ratings yet', style: TextStyle(fontSize: 12));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PanditDetailsScreen extends StatelessWidget {
  final PanditProfile pandit;

  const PanditDetailsScreen({super.key, required this.pandit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pandit.name),
      ),
      body: Center(
        child: Text('Details for ${pandit.name}'),
      ),
    );
  }
}
