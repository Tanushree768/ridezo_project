import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ridezo_project/screens/authentication_screens/signin_screen.dart';
import 'package:ridezo_project/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if user is logged in and email is verified
  final prefs = await SharedPreferences.getInstance();
  final bool hasLoggedIn = prefs.getBool('hasLoggedIn') ?? false;
  final User? user = FirebaseAuth.instance.currentUser;
  final bool isAuthenticated = user != null && user.emailVerified;

  // Determine the initial screen
  Widget initialScreen = isAuthenticated && hasLoggedIn
      ? const RideShareHomeScreen()
      : const SignInScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: initialScreen,
    );
  }
}
