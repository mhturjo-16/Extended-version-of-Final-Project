// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  final AuthService authService = AuthService();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // current user আনা
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/signin', (route) => false);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No user logged in'))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text('Email: ${user.email ?? 'N/A'}'),
                  Text('User ID: ${user.id ?? 'N/A'}'),
                  Text('Created At: ${user.createdAt ?? 'N/A'}'),
                ],
              ),
            ),
    );
  }
}
