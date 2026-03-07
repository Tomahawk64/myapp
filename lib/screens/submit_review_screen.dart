
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class SubmitReviewScreen extends StatefulWidget {
  final String bookingId;
  final String panditId;

  const SubmitReviewScreen({
    super.key,
    required this.bookingId,
    required this.panditId,
  });

  @override
  State<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends State<SubmitReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rating:'),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _comment = value!;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _rating > 0) {
                      _formKey.currentState!.save();

                      if (user != null) {
                        final newReview = Review(
                          id: '',
                          userId: user.id,
                          entityId: widget.panditId,
                          entityType: 'pandit',
                          rating: _rating.toDouble(),
                          comment: _comment,
                          createdAt: DateTime.now(),
                        );

                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          await ReviewService().createReview(newReview);
                          if (mounted) {
                            navigator.pop();
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Review submitted successfully!'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Failed to submit review: $e'),
                              ),
                            );
                          }
                        }
                      }
                    } else if (_rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please provide a rating.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
