
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import 'video_upload_screen.dart';

class PanditBookingDashboard extends StatelessWidget {
  const PanditBookingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    // Use the actual logged-in pandit's ID
    final panditId = user?.id ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pandit Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Available Bookings'),
              Tab(text: 'My Bookings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamProvider<List<Booking>>.value(
              value: BookingService().getAvailableBookings(),
              initialData: const [],
              child: const AvailableBookingList(),
            ),
            StreamProvider<List<Booking>>.value(
              value: BookingService().getPanditBookings(panditId),
              initialData: const [],
              child: const AssignedBookingList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailableBookingList extends StatelessWidget {
  const AvailableBookingList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<List<Booking>>(context);
    final user = Provider.of<AppUser?>(context);

    if (bookings.isEmpty) {
      return const Center(child: Text('No available bookings found.'));
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
                Text('Booking Type: ${booking.bookingType.toString().split('.').last}'),
                if (booking.bookingType == BookingType.offline) Text('Address: ${booking.address}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        BookingService().updateBookingStatus(booking.id, BookingStatus.cancelled);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Reject'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          BookingService().assignPandit(booking.id, user.id);
                        }
                      },
                      child: const Text('Accept'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AssignedBookingList extends StatelessWidget {
  const AssignedBookingList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<List<Booking>>(context);

    if (bookings.isEmpty) {
      return const Center(child: Text('No assigned bookings found.'));
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
                Text('Status: ${booking.status.toString().split('.').last}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (booking.status == BookingStatus.assigned)
                      ElevatedButton(
                        onPressed: () {
                          BookingService().updateBookingStatus(booking.id, BookingStatus.completed);
                        },
                        child: const Text('Mark as Complete'),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoUploadScreen(bookingId: booking.id),
                          ),
                        );
                      },
                      child: const Text('Upload Proof'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
