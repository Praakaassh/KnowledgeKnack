import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jammui/login/loginpage.dart';
import '../firebase.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmPasswordcontroller = TextEditingController();

  final Color primaryGreen = const Color(0xFF33b864);
  final Color lightGreen = const Color(0xFFB2F2BB);
  final Color darkGreen = const Color(0xFF1F7A4D);

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmPasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightGreen.withOpacity(0.4),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryGreen, darkGreen],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: darkGreen.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join Knowledge Knack today',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    TextField(
                      controller: _usernamecontroller,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        prefixIcon: Icon(Icons.person, color: primaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        prefixIcon: Icon(Icons.email, color: primaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        prefixIcon: Icon(Icons.lock, color: primaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: darkGreen),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryGreen, width: 2),
                        ),
                        prefixIcon: Icon(Icons.lock, color: primaryGreen),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      shadowColor: primaryGreen.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: InkWell(
                        onTap: _signUp,
                        borderRadius: BorderRadius.circular(18),
                        splashColor: lightGreen,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [primaryGreen, darkGreen],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: darkGreen),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: primaryGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernamecontroller.text.trim();
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();
    String confirmPassword = _confirmPasswordcontroller.text.trim();

    // Check if any field is empty
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: darkGreen)),
            content: const Text("Please fill in all fields."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: primaryGreen)),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: darkGreen)),
            content: const Text("Passwords do not match."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: primaryGreen)),
              ),
            ],
          );
        },
      );
      return;
    }

    // Validate password against your policy
    String? passwordError = _validatePassword(password);
    if (passwordError != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: darkGreen)),
            content: Text(passwordError),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: primaryGreen)),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Attempt to sign up with Firebase
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        // Save user details to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': username,
          'detailsCompleted': false,
          'createdAt': DateTime.now().toIso8601String(),
        });

        // Navigate to the login page after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      String errorMessage = "An error occurred. Please try again.";

      if (e.code == 'weak-password') {
        errorMessage = "The password is too weak. It must be at least 6 characters long.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The email address is already in use by another account.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is invalid.";
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: darkGreen)),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: primaryGreen)),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle any other errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: darkGreen)),
            content: Text("An unexpected error occurred. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK", style: TextStyle(color: primaryGreen)),
              ),
            ],
          );
        },
      );
    }
  }

// Password validation function
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return "Password must be at least 6 characters long.";
    }
    if (password.length > 4096) {
      return "Password must be at most 4096 characters long.";
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one numeric character.";
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character.";
    }
    return null;
  }

}