import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jammui/homepage/comingsoon.dart';
import 'package:jammui/homepage/settings/btech/btechyear.dart';
import 'package:jammui/homepage/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:jammui/theme.dart';
import 'dart:io';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedCourse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;
  String? username;
  File? _profileImage; // Add profile image field
  DateTime? currentBackPressTime;

  // Define the new green color (#33b864) and its variations
  final Color primaryGreen = const Color(0xFF33b864); // Main green
  final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
  final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUsername();
    _loadProfileImage(); // Load profile image
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _fetchUsername() async {
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (doc.exists) {
          setState(() {
            username = doc['name'] ?? doc['username'] ?? user?.displayName ?? "Student";
          });
        } else {
          setState(() {
            username = user?.displayName ?? "Student";
          });
        }
      } catch (e) {
        print("Error fetching username: $e");
        setState(() {
          username = user?.displayName ?? "Student";
        });
      }
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          final imagePath = userDoc['profileImagePath'];
          if (imagePath != null) {
            final file = File(imagePath);
            if (await file.exists()) {
              setState(() {
                _profileImage = file;
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToSettings() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    ).then((_) {
      _loadProfileImage(); // Reload image when returning from Settings
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryGreen, darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: Text(
                  username ?? "Student",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  user?.email ?? "student@example.com",
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Text(
                          (username?.isNotEmpty == true)
                              ? username![0].toUpperCase()
                              : "S",
                          style: TextStyle(
                            fontSize: 24,
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: primaryGreen),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.settings, color: primaryGreen),
                title: const Text('Settings'),
                onTap: _navigateToSettings,
              ),
            ],
          ),
        ),
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
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGreen, darkGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                                onPressed: _openDrawer,
                              ),
                              CircleAvatar(
                                radius: 30, // Increased radius (default is typically around 20)
                                backgroundColor: Colors.white,
                                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                                child: _profileImage == null
                                    ? Icon(
                                  Icons.person,
                                  color: primaryGreen,
                                )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                          child: Column(
                            children: [
                              Text(
                                'Hello ${username ?? "Student"}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Select your course to get started',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildCourseCard(
                          context,
                          'B.TECH',
                          Icons.school,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BtechYearSelection(),
                              ),
                            );
                          },
                        ),
                        _buildCourseCard(
                          context,
                          'M.Tech',
                          Icons.computer,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComingSoonPage(),
                              ),
                            );
                          },
                        ),
                        _buildCourseCard(
                          context,
                          'PSC',
                          Icons.science,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComingSoonPage(),
                              ),
                            );
                          },
                        ),
                        _buildCourseCard(
                          context,
                          'GATE',
                          Icons.gite,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComingSoonPage(),
                              ),
                            );
                          },
                        ),
                        _buildCourseCard(
                          context,
                          'KEAM',
                          Icons.gite,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComingSoonPage(),
                              ),
                            );
                          },
                        ),
                        _buildCourseCard(
                          context,
                          'MAT',
                          Icons.gite,
                          primaryGreen,
                          lightGreen,
                          darkGreen,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComingSoonPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context,
      String title,
      IconData icon,
      Color primaryColor,
      Color accentColor,
      Color darkColor,
      VoidCallback onTap) {
    return Card(
      elevation: 6,
      shadowColor: darkColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accentColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.8),
                darkColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 42,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}