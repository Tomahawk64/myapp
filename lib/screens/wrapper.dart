import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Firebase auth stream directly to distinguish loading vs logged out
    return StreamBuilder<fb_auth.User?>(
      stream: fb_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final appUser = Provider.of<AppUser?>(context);
        if (snapshot.data == null) {
          return const LoginScreen();
        }
        if (appUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const HomeScreen();
      },
    );
  }
}
