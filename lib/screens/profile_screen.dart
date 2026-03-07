
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AppUser?>(context);
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = Provider.of<AppUser?>(context, listen: false);
      if (user != null) {
        final updatedUser = user.copyWith(displayName: _nameController.text);

        try {
          await _userService.update(user.id, updatedUser);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating profile: $e')),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: user.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await _authService.signOut();
                  if (mounted) {
                    navigator.popUntil((route) => route.isFirst);
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
