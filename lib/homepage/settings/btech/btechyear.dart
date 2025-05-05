import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/year1.dart';
import 'package:jammui/homepage/settings/btech/year2.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/year3.dart';
import 'package:jammui/homepage/settings/btech/year4.dart';
import 'package:jammui/homepage/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BtechYearSelection extends StatelessWidget {
  const BtechYearSelection({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the new green color (#33b864) and its variations
    final Color primaryGreen = const Color(0xFF33b864); // Main green
    final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
    final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

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
                    'Select Your Year',
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
                    'Access study materials for your academic year',
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
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildYearCard(
                        context,
                        'First Year',
                        'Foundation courses for engineering',
                        Icons.looks_one_rounded,
                        primaryGreen,
                        lightGreen,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Year1Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildYearCard(
                        context,
                        'Second Year',
                        'Core engineering subjects',
                        Icons.looks_two_rounded,
                        primaryGreen,
                        lightGreen,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Year2Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildYearCard(
                        context,
                        'Third Year',
                        'Advanced specialized courses',
                        Icons.looks_3_rounded,
                        primaryGreen,
                        lightGreen,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Year3Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildYearCard(
                        context,
                        'Fourth Year',
                        'Specialization and project work',
                        Icons.looks_4_rounded,
                        primaryGreen,
                        lightGreen,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Year4Page()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
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

  Widget _buildYearCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color primaryColor,
      Color accentColor,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 5,
      shadowColor: primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accentColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, accentColor.withOpacity(0.15)],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 38,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}