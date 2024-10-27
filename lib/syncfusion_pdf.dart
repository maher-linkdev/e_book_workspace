import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SyncfusionPdf extends StatefulWidget {
  final String url;

  const SyncfusionPdf({super.key, required this.url});

  @override
  State<SyncfusionPdf> createState() => _SyncfusionPdfState();
}

class _SyncfusionPdfState extends State<SyncfusionPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late PdfDocument _pdfDocument;
  late File _pdfFile;
  Uint8List? _pdfBytes;
  int _currentPageNumber = 0;
  PdfViewerController _pdfViewerController = PdfViewerController();
  List<String> pagesTitles = [];

  //
  // Future<String> getFirstLineOfPage(int pageNumber) async {
  //   //PDFDOC From Flutter_pdf_text package
  //   PDFDoc pdfDoc = await PDFDoc.fromFile(_pdfFile);
  //   PDFPage page = pdfDoc.pageAt(pageNumber);
  //   String pageText = await page.text;
  //   List<String> lines = pageText.split('\n');
  //   String firstLine = lines.firstWhere((line) => line.trim().length > 3, orElse: () => "No title");
  //
  //   return firstLine;
  // }

  init() async {
    _pdfFile = await savePdfInFileFromUrl(widget.url);
    _pdfBytes = await _pdfFile.readAsBytes();
    _pdfDocument = PdfDocument(inputBytes: _pdfBytes);
    // final page3Title = await getFirstLineOfPage(3);
    //  print("page3Title ${page3Title}");

    //LOOP OVER BOOKMARKS - CONTROL BOOK MARKS
    // for (var i = 0; i < _pdfDocument.bookmarks.count; i++) {
    //   final bookmark = _pdfDocument.bookmarks[0];
    //   print("bookmark ${bookmark.title}, ${bookmark.destination}");
    // }
    // PdfBookmark bookmark = _pdfDocument.bookmarks.add('Chapter 1');
    // //Sets the destination page and locaiton
    // bookmark.destination = PdfDestination(_pdfDocument.pages[1], Offset(10, 10));

    setState(() {
      _pdfBytes = Uint8List.fromList(_pdfDocument.saveSync());
    });
  }

  addBookmark() async {
    PdfBookmark bookmark = _pdfDocument.bookmarks.add('Chapter o9323');
    //Sets the destination page and locaiton
    bookmark.destination = PdfDestination(_pdfDocument.pages[_currentPageNumber], Offset(10, 10));
    _pdfViewerController.saveDocument();
    await _pdfDocument.save();
  }

  Future<File> savePdfInFileFromUrl(String url) async {
    final filename = url.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    print("file path ${dir.path}/$filename");
    Dio dio = Dio();
    await dio.download(url, file.path);
    return file;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pdfBytes != null
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SfPdfViewer.memory(
                    _pdfBytes!,
                    controller: _pdfViewerController,
                    key: _pdfViewerKey,
                    onPageChanged: (pageChangedDetails) {
                      print('onPageChanged ${pageChangedDetails.newPageNumber}');
                      _currentPageNumber = pageChangedDetails.newPageNumber;
                    },
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      _pdfViewerKey.currentState?.openBookmarkView();
                    },
                    child: Text("Bookmark"),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () async {
                        addBookmark();
                      },
                      icon: Icon(Icons.bookmark),
                    ),
                  ),
                ],
              )
            : const SizedBox(height: 0.0, width: 0.0),
      ),
    );
  }
}
