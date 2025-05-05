import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jammui/homepage/settings/btech/3rdyear/6th%20sem/ccw/ccw.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SyllabusPage extends StatefulWidget {
  final Color subjectColor;

  const SyllabusPage({super.key, required this.subjectColor});

  @override
  State<SyllabusPage> createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  late Future<ListResult> _filesFuture;

  // Define the green color scheme from year3.dart
  final Color primaryGreen = const Color(0xFF33b864); // Main green
  final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
  final Color darkGreen = const Color(0xFF1F7A4D);
  
  get http => null; // Darker green

  @override
  void initState() {
    super.initState();
    _filesFuture = FirebaseStorage.instance
        .ref('BTECH/3rd Year/6th Sem/CCW/syllabus')
        .listAll();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> _downloadPdf(String url, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void _previewPdf(BuildContext context, Reference fileRef) async {
    try {
      final downloadUrl = await fileRef.getDownloadURL();
      final fileName = fileRef.name;
      final filePath = await _downloadPdf(downloadUrl, fileName);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            filePath: filePath,
            fileName: fileName,
            subjectColor: widget.subjectColor,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error previewing PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the AppBar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightGreen.withOpacity(0.4), // Consistent with theme
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Add the "Course Syllabus" container
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
                    'Course Syllabus',
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
                    'Access syllabus files for your subject',
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
            // Rest of the syllabus files UI
            Expanded(
              child: FutureBuilder<ListResult>(
                future: _filesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: widget.subjectColor),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: darkGreen),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                    return Center(
                      child: Text(
                        'No syllabus files available',
                        style: TextStyle(color: darkGreen),
                      ),
                    );
                  }

                  final files = snapshot.data!.items;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final fileRef = files[index];
                      final fileName = fileRef.name;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: Text(fileName, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Preview or download PDF', style: TextStyle(color: Colors.black54)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility, color: Color(0xFF33b864)),
                                onPressed: () => _previewPdf(context, fileRef),
                                tooltip: 'Preview',
                              ),
                              IconButton(
                                icon: Icon(Icons.download, color: Color(0xFF33b864)),
                                onPressed: () async {
                                  try {
                                    final downloadUrl = await fileRef.getDownloadURL();
                                    await _launchUrl(downloadUrl);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error downloading file: $e')),
                                    );
                                  }
                                },
                                tooltip: 'Download',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}