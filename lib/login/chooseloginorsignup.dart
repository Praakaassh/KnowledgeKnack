import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jammui/login/loginpage.dart';
import 'package:jammui/homepage/homepage.dart';
import 'package:jammui/login/personaldetails.dart';
import 'package:jammui/login/signuppage.dart';

class ChooseSignupOrLogin extends StatefulWidget {
  const ChooseSignupOrLogin({super.key});

  @override
  _ChooseSignupOrLoginState createState() => _ChooseSignupOrLoginState();
}

class _ChooseSignupOrLoginState extends State<ChooseSignupOrLogin>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  AnimationController? _animationController;
  Animation<double>? _animation;

  final Color primaryGreen = const Color(0xFF33b864);
  final Color lightGreen = const Color(0xFFB2F2BB);
  final Color darkGreen = const Color(0xFF1F7A4D);

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _checkIfLoggedIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _checkUserDetails(context);
    }
  }

  Future<User?> _signInWithGoogle(BuildContext context) async {
    if (!mounted) return null;

    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        if (!mounted) return null;
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return null;
      await _checkUserDetails(context);

      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      if (!mounted) return null;
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  Future<void> _checkUserDetails(BuildContext context) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!mounted) return;

      bool detailsCompleted =
          userDoc.exists && userDoc['detailsCompleted'] == true;

      setState(() {
        _isLoading = false;
      });

      if (detailsCompleted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PersonalDetailsPage()),
        );
      }
    } catch (e) {
      print('Error checking details: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    'Welcome to Knowledge Knack!',
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
                    'Your journey starts here',
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
              child: FadeTransition(
                opacity: _animation!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: primaryGreen,
                          fontFamily: 'Gupter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Log in, create an account, or sign in with Google to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildButtonCard(
                        context,
                        title: 'Log In',
                        onTap: _isLoading
                            ? null
                            : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ),
                        backgroundColor: primaryGreen,
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      _buildButtonCard(
                        context,
                        title: 'Create Account',
                        onTap: _isLoading
                            ? null
                            : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        ),
                        backgroundColor: Colors.white,
                        textColor: primaryGreen,
                        borderColor: primaryGreen,
                      ),
                      const SizedBox(height: 12),
                      _buildButtonCard(
                        context,
                        title: 'Sign in with Google',
                        onTap: _isLoading ? null : () => _signInWithGoogle(context),
                        backgroundColor: Colors.white,
                        textColor: darkGreen,
                        borderColor: darkGreen,
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'assets/images/google_logo.png',
                            height: 20,
                          ),
                        ),
                      ),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonCard(
      BuildContext context, {
        required String title,
        required VoidCallback? onTap,
        required Color backgroundColor,
        required Color textColor,
        Color? borderColor,
        Widget? icon,
      }) {
    return Card(
      elevation: 5,
      shadowColor: primaryGreen.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: borderColor != null
            ? BorderSide(color: borderColor, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: lightGreen,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}