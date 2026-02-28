import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumeScreen extends StatelessWidget {
  final String pdfUrl;
  const ResumeScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Resume"),
        backgroundColor: const Color(0xFF2666A6),
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
