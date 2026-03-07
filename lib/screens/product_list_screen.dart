
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: StreamProvider<List<Product>>.value(
        value: ProductService().getProducts(),
        initialData: const [],
        child: const ProductList(),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);

    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.network(product.imageUrl),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(product.description),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} added to cart')),
                        );
                      },
                      child: const Text('Add to Cart'),
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
