
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import 'submit_review_screen.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: StreamProvider<List<Booking>>.value(
          value: BookingService().getUserBookings(user!.id),
          initialData: const [],
          child: TabBarView(
            children: [
              BookingList(status: const [BookingStatus.pending, BookingStatus.confirmed, BookingStatus.assigned]),
              BookingList(status: const [BookingStatus.completed]),
              BookingList(status: const [BookingStatus.cancelled]),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final List<BookingStatus> status;

  const BookingList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<List<Booking>>(context)
        .where((booking) => status.contains(booking.status))
        .toList();

    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings found.'));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.poojaId, // Changed from poojaName
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('Date: ${booking.date.toLocal()} '.split(' ')[0]),
                // Text('Time: ${booking.time}'),
                Text('Price: \$${booking.price.toStringAsFixed(2)}'),
                Text('Status: ${booking.status.toString().split('.').last}'),
                if (booking.status == BookingStatus.completed && booking.panditId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmitReviewScreen(
                              bookingId: booking.id,
                              panditId: booking.panditId!,
                            ),
                          ),
                        );
                      },
                      child: const Text('Rate this Pooja'),
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
