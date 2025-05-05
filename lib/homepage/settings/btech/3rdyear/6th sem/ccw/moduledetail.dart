import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/mocktest.dart';
import 'package:jammui/subjectresource.dart';
import 'package:provider/provider.dart';

import '../../../../../../main.dart';
import 'module.dart';

// Define color constants globally (consistent with ccw.dart, year3.dart, etc.)
const Color primaryGreen = Color(0xFF33b864); // Main green (#33b864)
const Color lightGreen = Color(0xFFB2F2BB); // Lighter green
const Color darkGreen = Color(0xFF1F7A4D); // Darker green

class ModuleDetailsPage extends StatelessWidget {
  final String subject;
  final String module;
  final Color subjectColor;

  const ModuleDetailsPage({
    super.key,
    required this.subject,
    required this.module,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightGreen.withOpacity(0.4), // Updated to light green
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Curved Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryGreen, darkGreen], // Green gradient
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: darkGreen.withOpacity(0.3), // Updated shadow color
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    module,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select a resource to view',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildButton(
                      context,
                      title: 'Notes',
                      onPressed: () {
                        String folderPath = 'BTECH/3rd Year/6th Sem/CCW/$subject/$module';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectResourcesPage(
                              folderPath: folderPath,
                              title: '$subject - $module',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      title: 'Mock Test 1',
                      onPressed: () {
                        final pageProvider = Provider.of<CurrentPageProvider>(context, listen: false);
                        pageProvider.setCurrentPage('mocktest');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MockTestPage(
                              subject: subject,
                              module: module,
                              subjectColor: primaryGreen,
                              mockTestNumber: 'Mock Test 1',
                            ),
                          ),
                        ).then((_) {
                          pageProvider.setCurrentPage('home');
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      title: 'Mock Test 2',
                      onPressed: () {
                        Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('mocktest');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MockTestPage(
                              subject: subject,
                              module: module,
                              subjectColor: primaryGreen,
                              mockTestNumber: 'Mock Test 2',
                            ),
                          ),
                        ).then((_) {
                          Provider.of<CurrentPageProvider>(context, listen: false).setCurrentPage('home');
                        });
                      },
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

  Widget _buildButton(BuildContext context, {required String title, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen.withOpacity(0.8), // Updated to primaryGreen
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4, // Add shadow for depth
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}