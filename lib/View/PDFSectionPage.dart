import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:remote_tree/Model/Section.dart';
import 'dart:io';
class PDFSectionPage extends StatefulWidget {
  final PDFSection _section;

  PDFSectionPage(this._section);
  @override
  _PDFSectionPageState createState() => _PDFSectionPageState();
}

class _PDFSectionPageState extends State<PDFSectionPage> {

  @override
  Widget build(BuildContext context) {
    var section = widget._section;
    var pdf = const PDF(
      //Qui posso usare un PDFcontroller per gestire robe in più
    ).cachedFromUrl(
      section.link,
      placeholder: (double progress) => Center(child: CircularProgressIndicator()),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
      ),
      body: pdf
    );

  }
}
