import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;
  final String fileName;
  final Color subjectColor;

  const PdfViewerPage({
    Key? key,
    required this.filePath,
    required this.fileName,
    required this.subjectColor,
  }) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            onRender: (pages) {
              setState(() {
                _isLoading = false;
              });
            },
            onError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading PDF: $error')),
              );
              setState(() {
                _isLoading = false;
              });
            },
            onPageError: (page, error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error on page $page: $error')),
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.grey.withOpacity(0.5), // Dull background
              child: Center(
                child: CircularProgressIndicator(
                  color: widget.subjectColor, // Match with subjectColor
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}