import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jammui/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

// Define a global key to access state across pages
final GlobalKey<_SettingsPageState> settingsPageKey = GlobalKey<_SettingsPageState>();

// Create a notifier class to manage profile image updates
class ProfileImageNotifier extends ChangeNotifier {
  static final ProfileImageNotifier _instance = ProfileImageNotifier._internal();
  factory ProfileImageNotifier() => _instance;
  ProfileImageNotifier._internal();

  File? _profileImage;

  File? get profileImage => _profileImage;

  void updateProfileImage(File image) {
    _profileImage = image;
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();

    // Load profile image
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final imagePath = userDoc['profileImagePath'];
          if (imagePath != null) {
            final file = File(imagePath);
            if (await file.exists()) {
              setState(() {
                _profileImage = file;
              });
              
              // Update the global notifier
              ProfileImageNotifier().updateProfileImage(file);
            }
          }
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Copy the image to app documents directory for persistence
        final directory = await getApplicationDocumentsDirectory();
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid ?? 'user';
        final imagePath = '${directory.path}/profile_$userId.jpg';

        // Copy the picked file to our app's directory
        final pickedImage = File(pickedFile.path);
        final savedImage = await pickedImage.copy(imagePath);

        // Save the path in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'profileImagePath': imagePath,
        }, SetOptions(merge: true));

        // Save the path in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', imagePath);

        // Clear the image cache to ensure the new image is loaded
        imageCache.clear();
        imageCache.clearLiveImages();

        setState(() {
          _profileImage = savedImage;
          _isLoading = false;
        });
        
        // Update the global notifier with the new image
        ProfileImageNotifier().updateProfileImage(savedImage);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFB2F2BB).withOpacity(0.4),
        ),
        child: Column(
          children: [
            // Curved Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: const Color(0xFF33b864),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize your app experience',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Main content with fade animation
            Expanded(
              child: FadeTransition(
                opacity: _animation!,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      // Profile Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Profile Picture
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  // Profile Image
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Color(0xFF33b864),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor: const Color(0xFF33b864).withOpacity(0.3),
                                          backgroundImage: _profileImage != null
                                              ? FileImage(_profileImage!)
                                              : null,
                                          child: _profileImage == null
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Color(0xFF33b864),
                                                )
                                              : null,
                                        ),

                                  // Edit Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF33b864),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: _uploadProfileImage,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // User Name
                              Text(
                                user?.displayName ?? 'User',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // User Email
                              Text(
                                user?.email ?? 'No email',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // App Preferences section
                      Text(
                        'App Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Dark Mode Card
                      _buildSettingCard(
                        context,
                        title: 'Dark Mode',
                        subtitle: 'Switch between light and dark themes',
                        icon: Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.black,
                        ),
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) => themeProvider.toggleTheme(),
                          activeColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // About section
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // About Card
                      _buildSettingCard(
                        context,
                        title: 'About Knowledge Knack',
                        subtitle: 'Learn more about the app',
                        icon: Icon(
                          Icons.info,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutPage()),
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      // Account section
                      Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Logout Card
                      _buildSettingCard(
                        context,
                        title: 'Logout',
                        subtitle: 'Sign out from your account',
                        icon: Icon(
                          Icons.logout,
                          color: Colors.red[700],
                        ),
                        titleColor: Colors.red[700],
                        onTap: () {
                          _showLogoutConfirmationDialog(context);
                        },
                      ),

                      const SizedBox(height: 20),
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

  Widget _buildSettingCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required Icon icon,
        Widget? trailing,
        VoidCallback? onTap,
        Color? titleColor,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: const Color(0xFF33b864),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: const Color(0xFF33b864)),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/chooseLoginOrSignup', (route) => false);
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// AboutPage implementation remains unchanged
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF33B864), // Your primary color
              Color(0xFF1E8449), // Your secondary color
            ],
          ),
        ),
        child: Column(
          children: [
            // Stylish Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF33B864), // Your primary color
                    Color(0xFF1E8449), // Your secondary color
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo/Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFE0E0FF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text(
                      'Knowledge Knack',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Your Ultimate Study Companion',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content with Animations
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('About Knowledge Knack'),
                            const SizedBox(height: 16),
                            _buildDescriptionCard(
                              'Knowledge Knack is a comprehensive study companion designed specifically for B.Tech students at KTU University. This app provides seamless access to curated study materials, previous year questions, and exam preparation resources, all intuitively organized by year, semester, and subject.',
                            ),
                            const SizedBox(height: 30),
                            _buildSectionHeader('Key Features'),
                            const SizedBox(height: 16),
                            _buildFeatureItem(
                              context,
                              Icons.folder_special,
                              'Organized Resources',
                              'Access modules, question banks, and previous year questions for various subjects.',
                            ),
                            _buildFeatureItem(
                              context,
                              Icons.dark_mode,
                              'Sleek Dark Mode',
                              'Switch between light and dark themes for comfortable studying any time of day.',
                            ),
                            _buildFeatureItem(
                              context,
                              Icons.school,
                              'Exam Preparation',
                              'Prepare effectively with dedicated exam resources and interactive mock tests.',
                            ),
                            _buildFeatureItem(
                              context,
                              Icons.touch_app,
                              'Intuitive Interface',
                              'Navigate seamlessly through years, semesters, and subjects with our modern UI.',
                            ),
                            const SizedBox(height: 30),
                            _buildContactSection(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF33B864).withOpacity(0.3),
            const Color(0xFF1E8449).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Developed with ❤️ by the students of',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Marian Engineering College',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.email),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.chat),
              const SizedBox(width: 16),
              _buildSocialButton(Icons.smart_toy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}