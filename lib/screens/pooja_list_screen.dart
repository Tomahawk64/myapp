
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pooja_package.dart';
import '../services/pooja_package_service.dart';
import 'book_pooja_screen.dart';

class PoojaListScreen extends StatelessWidget {
  const PoojaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Pooja'),
      ),
      body: StreamProvider<List<PoojaPackage>>.value(
        value: PoojaPackageService().getPoojaPackages(),
        initialData: const [],
        child: const PoojaList(),
      ),
    );
  }
}

class PoojaList extends StatelessWidget {
  const PoojaList({super.key});

  @override
  Widget build(BuildContext context) {
    final poojas = Provider.of<List<PoojaPackage>>(context);

    return ListView.builder(
      itemCount: poojas.length,
      itemBuilder: (context, index) {
        final pooja = poojas[index];
        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(pooja.imageUrl),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pooja.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(pooja.description),
                    const SizedBox(height: 8),
                    Text(
                      '\$${pooja.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookPoojaScreen(poojaPackage: pooja),
                          ),
                        );
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
