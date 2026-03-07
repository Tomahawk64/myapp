
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import './wrapper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _error = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                    return 'Please enter a password';
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
                      final user = await authService.createUserWithEmailAndPassword(
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
                          case 'weak-password':
                            _error = 'Password must be at least 6 characters.';
                            break;
                          case 'email-already-in-use':
                            _error = 'An account already exists with that email.';
                            break;
                          case 'invalid-email':
                            _error = 'The email address is not valid.';
                            break;
                          default:
                            _error = 'Sign up failed. Please try again.';
                        }
                      });
                    } catch (e) {
                      setState(() => _error = 'An unexpected error occurred.');
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context), // Go back to the login screen
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
