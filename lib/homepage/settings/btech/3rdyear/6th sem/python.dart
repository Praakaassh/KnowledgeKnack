


import 'package:flutter/material.dart';


class PythonPage extends StatefulWidget {
  const PythonPage({super.key});

  @override
  _PythonPageState createState() => _PythonPageState();
}

class _PythonPageState extends State<PythonPage> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  // Define the green color scheme from year3.dart
  final Color primaryGreen = const Color(0xFF33b864); // Main green
  final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
  final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    // Start the animation when the page loads
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
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
              lightGreen.withOpacity(0.4), // Light green gradient
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header matching BtechYearSelection and Year3Page
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
              child: const Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Python',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Materials coming soon',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 0.9),// 90% opacity
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Coming Soon Content with FadeTransition
            Expanded(
              child: FadeTransition(
                opacity: _animation!,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.construction,
                        size: 64,
                        color: darkGreen.withOpacity(0.6), // Dark green icon
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkGreen, // Dark green text
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Python materials are being prepared',
                        style: TextStyle(
                          fontSize: 16,
                          color: darkGreen.withOpacity(0.7), // Dark green text with opacity
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
}