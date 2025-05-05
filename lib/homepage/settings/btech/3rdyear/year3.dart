import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/aad.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/ccw.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/cd.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/cg.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/dataanalaytics.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/dcc.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ieft.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/python.dart';

class Year3Page extends StatefulWidget {
  const Year3Page({super.key});

  @override
  _Year3PageState createState() => _Year3PageState();
}

class _Year3PageState extends State<Year3Page>
    with SingleTickerProviderStateMixin {
  String? selectedSemester;
  AnimationController? _animationController;
  Animation<double>? _animation;

  // Define the new green color scheme from btechyear.dart
  final Color primaryGreen = const Color(0xFF33b864); // Main green
  final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
  final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

  // Subjects for Semester 6
  final List<Map<String, dynamic>> sem6CoreSubjects = [
    {
      'title': 'Compiler Design',
      'icon': Icons.code,
      'page': const CompilerDesignPage(),
      'description':
      'Study of programming language translation and compiler construction'
    },
    {
      'title': 'Algorithm Analysis and Design',
      'icon': Icons.auto_graph,
      'page': const AlgorithmAnalysisPage(),
      'description': 'Techniques for designing and analyzing algorithms'
    },
    {
      'title': 'Computer Graphics',
      'icon': Icons.gradient,
      'page': const ComputerGraphicsPage(),
      'description':
      'Principles and techniques for digital visual content creation'
    },
    {
      'title': 'IEFT',
      'icon': Icons.currency_rupee,
      'page': const IeftPage(),
      'description': 'Industrial Economics and Foreign Trade'
    },
    {
      'title': 'Comprehensive Course Work',
      'icon': Icons.menu_book,
      'page': const ComprehensiveCourseWorkPage(),
      'description': 'Integrated applied course covering multiple domains'
    },
  ];

  final List<Map<String, dynamic>> sem6ElectiveOptions = [
    {
      'title': 'Data Analytics',
      'icon': Icons.analytics,
      'page': const DataAnalyticsPage(),
      'description': 'Statistical analysis and interpretation of data sets'
    },
    {
      'title': 'Python',
      'icon': Icons.code,
      'page': const PythonPage(),
      'description': 'Programming with Python for various applications'
    },
    {
      'title': 'Data and Computer Communication',
      'icon': Icons.router,
      'page': const DataAndComputerCommunicationPage(),
      'description': 'Principles of data transmission and networking'
    },
  ];

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
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _selectSemester(String semester) {
    setState(() {
      selectedSemester = semester;
    });
    _animationController!.forward();
  }

  void _backToSemesterSelection() {
    _animationController!.reverse().then((_) {
      setState(() {
        selectedSemester = null;
      });
    });
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
              lightGreen.withOpacity(0.4), // Updated to light green
              Colors.white,
            ],
          ),
        ),
        child: selectedSemester == null
            ? _buildSemesterSelection()
            : FadeTransition(
          opacity: _animation!,
          child: _buildSubjectsView(),
        ),
      ),
    );
  }

  // Widget to display semester selection buttons
  Widget _buildSemesterSelection() {
    return Column(
      children: [
        // Add the "Select Your Semester" container
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
                'Select Your Semester',
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
                'Access study materials for your academic semester',
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
        // Rest of the semester selection UI
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      _buildSemesterCard(
                        context,
                        'Semester 5',
                        'Fall Semester',
                        Icons.calendar_today,
                            () => _selectSemester('Semester 5'),
                      ),
                      const SizedBox(height: 20),
                      _buildSemesterCard(
                        context,
                        'Semester 6',
                        'Spring Semester',
                        Icons.calendar_month,
                            () => _selectSemester('Semester 6'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shadowColor: primaryGreen.withOpacity(0.3), // Updated shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // Increased radius for consistency
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: lightGreen, // Updated splash color
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, lightGreen.withOpacity(0.15)], // Updated gradient
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: lightGreen.withOpacity(0.4), // Updated background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: primaryGreen, // Updated icon color
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.black54, // Updated for contrast
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: primaryGreen.withOpacity(0.7), // Updated arrow color
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display subjects based on selected semester
  Widget _buildSubjectsView() {
    if (selectedSemester == 'Semester 5') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: darkGreen.withOpacity(0.6), // Updated to dark green
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGreen, // Updated text color
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Semester 5 materials are being prepared',
              style: TextStyle(
                fontSize: 16,
                color: darkGreen.withOpacity(0.7), // Updated text color
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Add the "Select Your Subject" container
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
                'Select Your Subject',
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
                'Access study materials for your subjects',
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
        // Rest of the subject selection UI
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Core Subjects Section
                Text(
                  'Core Subjects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Updated to primary green
                  ),
                ),
                const SizedBox(height: 16),
                ...sem6CoreSubjects.map((subject) => _buildSubjectCard(
                  context,
                  subject['title'],
                  subject['description'],
                  subject['icon'],
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => subject['page']),
                  ),
                )),

                const SizedBox(height: 30),

                // Elective Subjects Section
                Text(
                  'Elective Subjects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Updated to primary green
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose one of the following electives',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54, // Updated for contrast
                  ),
                ),
                const SizedBox(height: 16),

                ...sem6ElectiveOptions.map((subject) => _buildSubjectCard(
                  context,
                  subject['title'],
                  subject['description'],
                  subject['icon'],
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => subject['page']),
                  ),
                  isElective: true,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      VoidCallback onTap, {
        bool isElective = false,
      }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isElective
            ? BorderSide(
          color: primaryGreen.withOpacity(0.3), // Updated border color
          width: 1,
        )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: lightGreen, // Updated splash color
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isElective
                      ? lightGreen.withOpacity(0.4) // Updated elective background
                      : primaryGreen, // Updated core subject background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isElective
                      ? primaryGreen // Updated elective icon color
                      : Colors.white, // Core subjects keep white
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54, // Updated for contrast
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: primaryGreen.withOpacity(0.7), // Updated arrow color
              ),
            ],
          ),
        ),
      ),
    );
  }
}