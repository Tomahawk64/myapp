
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import './signup_screen.dart';
import './wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _error = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      setState(() => _error = '');
                      final navigator = Navigator.of(context);
                      final user = await authService.signInWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                      if (user != null && mounted) {
                        navigator.pushReplacement(
                          MaterialPageRoute(builder: (context) => const Wrapper()),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        switch (e.code) {
                          case 'user-not-found':
                            _error = 'No account found with that email.';
                            break;
                          case 'wrong-password':
                          case 'invalid-credential':
                            _error = 'Incorrect password. Please try again.';
                            break;
                          case 'invalid-email':
                            _error = 'The email address is not valid.';
                            break;
                          case 'user-disabled':
                            _error = 'This account has been disabled.';
                            break;
                          case 'too-many-requests':
                            _error = 'Too many attempts. Please try again later.';
                            break;
                          default:
                            _error = 'Login failed. Please try again.';
                        }
                      });
                    } catch (e) {
                      setState(() => _error = 'An unexpected error occurred.');
                    }
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                ),
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
