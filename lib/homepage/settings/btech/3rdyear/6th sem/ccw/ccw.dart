import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/exam.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/mocktest.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/module.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/questionbank.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/syllabus.dart';
import 'package:jammui/subjectresource.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../../../main.dart';
import '../../../../../../pdfviewer.dart';

// Define color constants globally
const Color primaryGreen = Color(0xFF33b864); // Main green
const Color lightGreen = Color(0xFFB2F2BB); // Lighter green
const Color darkGreen = Color(0xFF1F7A4D); // Darker green

class ComprehensiveCourseWorkPage extends StatefulWidget {
  const ComprehensiveCourseWorkPage({super.key});

  @override
  State<ComprehensiveCourseWorkPage> createState() =>
      _ComprehensiveCourseWorkPageState();
}

class _ComprehensiveCourseWorkPageState
    extends State<ComprehensiveCourseWorkPage> {
  final List<String> subjects = [
    'COA', // Computer Organization and Architecture
    'DBMS', // Database Management Systems
    'DS', // Data Structures
    'OS', // Operating Systems
    'FLAT', // Formal Languages and Automata Theory
    'Know More', // New option
    'PYQ', // Previous Year Questions
    'Exam', // Exam Preparation
    'Syllabus', // Course Syllabus (moved under Exam)
    'Question Bank', // Question Bank
  ];

  // Map for full subject names
  final Map<String, String> subjectFullNames = {
    'COA': 'Computer Organization and Architecture',
    'DBMS': 'Database Management Systems',
    'DS': 'Data Structures',
    'OS': 'Operating Systems',
    'FLAT': 'Formal Languages and Automata Theory',
    'Know More': 'Know More About Comprehensive Course Work',
    'PYQ': 'Previous Year Questions',
    'Exam': 'Exam Preparation',
    'Syllabus': 'Course Syllabus',
    'Question Bank': 'Question Bank',
  };

  // Track visibility of each item
  final List<bool> _isVisible = List.filled(10, false); // Updated to 10 items

  @override
  void initState() {
    super.initState();
    // Trigger staggered fade-in
    for (int i = 0; i < subjects.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted) {
          setState(() {
            _isVisible[i] = true;
          });
        }
      });
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
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Comprehensive Course Work',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select a subject to access study materials',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Subjects List with Staggered Fade-In
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: subjects.length + 2, // +2 for "Subjects" and "Exam" titles
                itemBuilder: (context, index) {
                  // Add "Subjects" title at the start
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Subjects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    );
                  }

                  // Add "Exam" title before the Exam section
                  if (index == subjects.length - 4) { // Before 'Exam'
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Exam',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    );
                  }

                  // Adjust index for subjects list
                  final adjustedIndex = index > subjects.length - 4
                      ? index - 2
                      : index > 0
                      ? index - 1
                      : index;

                  if (adjustedIndex >= subjects.length) return const SizedBox.shrink();

                  final subject = subjects[adjustedIndex];
                  final fullName = subjectFullNames[subject] ?? subject;
                  final subjectColor = _getSubjectColor(subject);

                  return AnimatedOpacity(
                    opacity: _isVisible[adjustedIndex] ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: subjectColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getSubjectIcon(subject),
                            color: subjectColor,
                          ),
                        ),
                        title: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        subtitle: Text(
                          fullName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          final pageProvider = Provider.of<CurrentPageProvider>(context, listen: false);
                          if (['COA', 'DBMS', 'DS', 'OS', 'FLAT'].contains(subject)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectModulesPage(
                                  subject: subject,
                                  fullName: fullName,
                                  subjectColor: subjectColor,
                                ),
                              ),
                            );
                          } else if (subject == 'Syllabus') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SyllabusPage(
                                  subjectColor: subjectColor,
                                ),
                              ),
                            );
                          } else if (subject == 'Know More') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectResourcesPage(
                                  folderPath: 'BTECH/3rd Year/6th Sem/CCW/Know More',
                                ),
                              ),
                            );
                          } else if (subject == 'PYQ') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectResourcesPage(
                                  folderPath: 'BTECH/3rd Year/6th Sem/CCW/PYQ',
                                ),
                              ),
                            );
                          } else if (subject == 'Exam') {
                            pageProvider.setCurrentPage('exam');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamPage(
                                  subject: 'Comprehensive',
                                  module: 'Practice Exam',
                                  subjectColor: subjectColor,
                                ),
                              ),
                            ).then((_) {
                              pageProvider.setCurrentPage('home');
                            });
                          } else if (subject == 'Question Bank') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestionBankPage(
                                  subjectColor: subjectColor,
                                ),
                              ),
                            );
                          }
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: primaryGreen.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get an appropriate icon for each subject
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'COA':
        return Icons.memory;
      case 'DBMS':
        return Icons.storage;
      case 'DS':
        return Icons.account_tree;
      case 'OS':
        return Icons.desktop_windows;
      case 'FLAT':
        return Icons.auto_graph;
      case 'Syllabus':
        return Icons.book;
      case 'Know More':
        return Icons.school;
      case 'PYQ':
        return Icons.history_edu;
      case 'Exam':
        return Icons.quiz;
      case 'Question Bank':
        return Icons.question_answer;
      default:
        return Icons.school;
    }
  }

  // Method to get a unique color for each subject (for icons)
  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'COA':
        return Colors.blue;
      case 'DBMS':
        return Colors.green;
      case 'DS':
        return Colors.orange;
      case 'OS':
        return Colors.purple;
      case 'FLAT':
        return Colors.red;
      case 'Syllabus':
        return Colors.brown;
      case 'Know More':
        return Colors.pink;
      case 'PYQ':
        return Colors.teal;
      case 'Exam':
        return Colors.indigo;
      case 'Question Bank':
        return Colors.cyan;
      default:
        return Colors.blueGrey;
    }
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;
  final String fileName;
  final Color subjectColor;

  const PdfViewerPage({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Color(0xFF33b864),
        foregroundColor: Colors.white,
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
        child: PDFView(
          filePath: filePath,
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading PDF: $error')),
            );
          },
          onPageError: (page, error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error on page $page: $error')),
            );
          },
        ),
      ),
    );
  }
}