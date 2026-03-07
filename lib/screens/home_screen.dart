
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/user.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/user_profile_header.dart';
import 'admin_dashboard_screen.dart';
import 'booking_history_screen.dart';
import 'consultation_list_screen.dart';
import 'pandit_booking_dashboard.dart';
import 'pandit_consultation_dashboard.dart';
import 'pooja_list_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = Provider.of<AppUser?>(context);

    final List<Map<String, dynamic>> userCategories = [
      {'icon': Icons.book, 'title': 'Book a Pooja', 'screen': const PoojaListScreen()},
      {'icon': Icons.video_call, 'title': 'Online Consultation', 'screen': const ConsultationListScreen()},
      {'icon': Icons.shopping_cart, 'title': 'Shop', 'screen': const ProductListScreen()},
      {'icon': Icons.history, 'title': 'My Bookings', 'screen': const BookingHistoryScreen()},
    ];

    final List<Map<String, dynamic>> panditCategories = [
      {'icon': Icons.dashboard, 'title': 'Booking Dashboard', 'screen': const PanditBookingDashboard()},
      {'icon': Icons.all_inbox, 'title': 'Consultation Dashboard', 'screen': const PanditConsultationDashboard()},
    ];

    final List<Map<String, dynamic>> adminCategories = [
      {'icon': Icons.admin_panel_settings, 'title': 'Admin Dashboard', 'screen': const AdminDashboardScreen()},
    ];

    List<Map<String, dynamic>> getCategoriesForRole(UserRole? role) {
      switch (role) {
        case UserRole.admin:
          return adminCategories;
        case UserRole.pandit:
          return panditCategories;
        case UserRole.user:
        default:
          return userCategories;
      }
    }

    final categories = getCategoriesForRole(user?.role)
        .where((category) => category['title']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileHeader(),
            custom.SearchBar(onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      icon: category['icon'] as IconData,
                      title: category['title'] as String,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => category['screen'] as Widget),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
