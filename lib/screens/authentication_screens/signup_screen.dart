import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridezo_project/reusable_widgets/reusable_widget.dart';
import 'package:ridezo_project/screens/authentication_screens/signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign up", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Create a New Account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Name
            TextField(
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 15),

            // Email with @northsouth.edu hint
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                suffixText: '@northsouth.edu',
                suffixStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 15),

            // University Name
            TextField(
              decoration: InputDecoration(
                hintText: 'University Name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 15),

            // NSU ID
            TextField(
              decoration: InputDecoration(
                hintText: 'NSU ID',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 15),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 15),

            // Confirm Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.grey[200],
                border: border,
              ),
            ),
            const SizedBox(height: 30),

            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                // sign up logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}    
