import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridezo_project/reusable_widgets/reusable_widget.dart';
import 'package:ridezo_project/screens/authentication_screens/reset_password.dart';
import 'package:ridezo_project/screens/authentication_screens/signup_screen.dart';
import 'package:ridezo_project/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = _emailTextController.text.trim();
    final password = _passwordTextController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(email: email)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),

                // Header Image
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/car1.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                const Text(
                  'Welcome to RideZO',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),

                const Text(
                  'Connect with fellow students for convenient and affordable rides.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),

                SizedBox(height: screenHeight * 0.045),

                reusableTextField(
                  "Enter your Email",
                  Icons.person_2_outlined,
                  false,
                  _emailTextController,
                ),
                SizedBox(height: screenHeight * 0.02),

                reusableTextField(
                  "Enter Password",
                  Icons.lock,
                  true,
                  _passwordTextController,
                ),
                SizedBox(height: screenHeight * 0.035),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(167, 133, 211, 178),
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _login(context),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),
                signUpOption(),
                SizedBox(height: screenHeight * 0.025),

                Align(
                  alignment: Alignment.center,
                  child: forgetPassword(context),
                ),

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return TextButton(
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPassword()),
        );
      },
    );
  }
}
