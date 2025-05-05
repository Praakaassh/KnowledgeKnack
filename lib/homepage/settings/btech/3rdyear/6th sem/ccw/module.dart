import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/mocktest.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/moduledetail.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/subjectmock.dart';
import 'package:jammui/subjectresource.dart';


// Define color constants globally (consistent with ccw.dart, year3.dart, etc.)
const Color primaryGreen = Color(0xFF33b864); // Main green (#33b864)
const Color lightGreen = Color(0xFFB2F2BB); // Lighter green
const Color darkGreen = Color(0xFF1F7A4D); // Darker green

class SubjectModulesPage extends StatefulWidget {
  final String subject;
  final String fullName;
  final Color subjectColor;

  const SubjectModulesPage({
    super.key,
    required this.subject,
    required this.fullName,
    required this.subjectColor,
  });

  @override
  State<SubjectModulesPage> createState() => _SubjectModulesPageState();
}

class _SubjectModulesPageState extends State<SubjectModulesPage> {
  final List<String> modules = [
    'Module 1',
    'Module 2',
    'Module 3',
    'Module 4',
    'Module 5',
  ];

  final List<String> questionBank = ['Question Bank'];
  final List<String> syllabus = ['Syllabus'];
  final List<String> mockTest = ['Mock Test']; // New Mock Test option

  // Track visibility for staggered animation
  late List<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = List.filled(
      modules.length + questionBank.length + syllabus.length + mockTest.length,
      false,
    );
    // Staggered fade-in animation
    for (int i = 0; i < _isVisible.length; i++) {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Curved Header
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
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select a module or resource to view',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Modules Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(modules.length, (index) {
                    return AnimatedOpacity(
                      opacity: _isVisible[index] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildModuleCard(modules[index], context),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),
              // Syllabus Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  opacity: _isVisible[modules.length] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _buildSyllabusCard(syllabus[0], context),
                ),
              ),
              const SizedBox(height: 30),
              // Mock Test Section (New)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  opacity: _isVisible[modules.length + syllabus.length] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _buildMockTestCard(mockTest[0], context),
                ),
              ),
              const SizedBox(height: 30),
              // Question Bank Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  opacity: _isVisible[modules.length + syllabus.length + mockTest.length] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: _buildQuestionBankCard(questionBank[0], context),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(String module, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetailsPage(
                subject: widget.subject,
                module: module,
                subjectColor: primaryGreen,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.book,
                  size: 36,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  module,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryGreen.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyllabusCard(String syllabus, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: primaryGreen.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: () {
          String folderPath = 'BTECH/3rd Year/6th Sem/CCW/${widget.subject}/syllabus';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectResourcesPage(
                folderPath: folderPath,
                title: '${widget.subject} - $syllabus',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 36,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  syllabus,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryGreen.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockTestCard(String mockTest, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: primaryGreen.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectWiseMockTestPage(
                subject: widget.subject,
                subjectColor: primaryGreen,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.quiz,
                  size: 36,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  mockTest,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryGreen.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionBankCard(String questionBank, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: primaryGreen.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: () {
          String folderPath = 'BTECH/3rd Year/6th Sem/CCW/${widget.subject}/Question Bank';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubjectResourcesPage(
                folderPath: folderPath,
                title: '${widget.subject} - $questionBank',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.question_answer,
                  size: 36,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  questionBank,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryGreen.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}