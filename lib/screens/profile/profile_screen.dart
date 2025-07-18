import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({Key? key, required this.userName}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasLoggedIn', false);
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/images/profile_placeholder.png',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: navigate to edit profile screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings'),
            onTap: () {
              // go to settings
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            ),
            title: const Text('Billing Details'),
            onTap: () {
              // go to billing details
            },
          ),
          ListTile(
            leading: const Icon(Icons.group, color: Colors.grey),
            title: const Text('User Management'),
            onTap: () {
              // go to user management
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.grey),
            title: const Text('Information'),
            onTap: () {
              // go to info screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
