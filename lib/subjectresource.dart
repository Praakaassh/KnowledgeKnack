import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jammui/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';

class SubjectResourcesPage extends StatefulWidget {
  final String folderPath;
  final String? title; // Added optional title parameter

  const SubjectResourcesPage({
    super.key,
    required this.folderPath,
    this.title, // Optional title parameter
  });

  @override
  State<SubjectResourcesPage> createState() => _SubjectResourcesPageState();
}

class _SubjectResourcesPageState extends State<SubjectResourcesPage> {
  late Future<ListResult> _listResult;
  String _displayTitle = '';
  bool _isLoading = false;

  // Define the green color scheme from year3.dart
  final Color primaryGreen = const Color(0xFF33b864); // Main green
  final Color lightGreen = const Color(0xFFB2F2BB); // Lighter green
  final Color darkGreen = const Color(0xFF1F7A4D); // Darker green

  @override
  void initState() {
    super.initState();
    _listResult = _fetchFiles();

    // Use provided title if available, otherwise extract from path
    if (widget.title != null) {
      _displayTitle = widget.title!;
    } else {
      // Extract subject name from the folder path (last segment)
      final pathSegments = widget.folderPath.split('/');
      if (pathSegments.length >= 2) {
        // Try to format title as "Subject - Module"
        final lastSegment = pathSegments.last;
        final secondLastSegment = pathSegments[pathSegments.length - 2];
        if (lastSegment.startsWith('Module') || lastSegment == 'Question Bank') {
          _displayTitle = '$secondLastSegment - $lastSegment';
        } else {
          _displayTitle = lastSegment;
        }
      } else {
        _displayTitle = pathSegments.last;
      }
    }
  }

  Future<ListResult> _fetchFiles() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final folderRef = storageRef.child(widget.folderPath);

      print('Fetching files from: ${folderRef.fullPath}');

      final listResult = await folderRef.listAll();

      print('Fetched ${listResult.items.length} files');

      return listResult;
    } catch (e) {
      print('Error fetching files: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      throw Exception('Failed to load files: $e');
    }
  }

  Future<String> _getDownloadUrl(Reference ref) async {
    try {
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get URL for ${ref.name}: $e');
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening file...')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  Future<void> _previewPdf(String url, String fileName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        _openPdf(filePath, fileName);
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          _openPdf(filePath, fileName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download file: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error previewing PDF: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openPdf(String filePath, String fileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(
          filePath: filePath,
          fileName: fileName,
          subjectColor: primaryGreen, // Use primary green
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Header
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
                      Text(
                        _displayTitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Access study materials for your subject',
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
                // Resources List
                Expanded(
                  child: FutureBuilder<ListResult>(
                    future: _listResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                const SizedBox(height: 16),
                                Text('Error: ${snapshot.error}'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _listResult = _fetchFiles();
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open, size: 48, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No files available.'),
                            ],
                          ),
                        );
                      } else {
                        final items = snapshot.data!.items;
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final fileName = item.name;
                            final fileType = _getFileType(fileName);
                            final isPdf = fileName.toLowerCase().endsWith('.pdf');

                            return FutureBuilder<String>(
                              future: _getDownloadUrl(item),
                              builder: (context, urlSnapshot) {
                                if (urlSnapshot.connectionState == ConnectionState.waiting) {
                                  return ListTile(
                                    leading: _getFileIcon(fileType),
                                    title: Text(item.name),
                                    trailing: const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                } else if (urlSnapshot.hasError) {
                                  return ListTile(
                                    leading: _getFileIcon(fileType),
                                    title: Text(item.name),
                                    subtitle: Text('Error: ${urlSnapshot.error}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () {
                                        setState(() {});
                                      },
                                    ),
                                  );
                                } else {
                                  final url = urlSnapshot.data!;
                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: _getFileIcon(fileType),
                                          title: Text(item.name),
                                          subtitle: Text(fileType),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              if (isPdf)
                                                TextButton.icon(
                                                  icon: Icon(Icons.visibility,
                                                  color: primaryGreen, // Use primary green
                                                  ),
                                                  label: const Text('View'),
                                                  onPressed: () => _previewPdf(url, fileName),
                                                ),
                                              const SizedBox(width: 8),
                                              TextButton.icon(
                                                icon: Icon(Icons.download,
                                                color: primaryGreen), // Use primary green
                                                label: const Text('Download'),
                                                onPressed: () => _launchUrl(url),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading PDF...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to determine file type based on extension
  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'ppt':
      case 'pptx':
        return 'Presentation';
      case 'xls':
      case 'xlsx':
        return 'Spreadsheet';
      case 'txt':
        return 'Text Document';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'Image';
      default:
        return extension.toUpperCase();
    }
  }

  // Helper method to get appropriate icon for file type
  Icon _getFileIcon(String fileType) {
    switch (fileType) {
      case 'PDF Document':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'Word Document':
        return const Icon(Icons.description, color: Colors.blue);
      case 'Presentation':
        return const Icon(Icons.slideshow, color: Colors.orange);
      case 'Spreadsheet':
        return const Icon(Icons.table_chart, color: Colors.green);
      case 'Text Document':
        return const Icon(Icons.text_snippet, color: Colors.teal);
      case 'Image':
        return const Icon(Icons.image, color: Colors.purple);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }
}