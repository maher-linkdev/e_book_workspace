// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_pdf_text/flutter_pdf_text.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
//
// class PdfViewer2 extends StatefulWidget {
//   final File file;
//
//   const PdfViewer2({super.key, required this.file});
//
//   @override
//   State<PdfViewer2> createState() => _PdfViewer2State();
// }
//
// class _PdfViewer2State extends State<PdfViewer2> {
//   int pages = 0;
//   Completer<PDFViewController> pdfControllerCompleter = Completer<PDFViewController>();
//
//   List<Rect> highlightRects = [];
//
//   Size? pageSize;
//
// // Use the HighlightedPdfView
//
//   // Assuming you have found the index of the keyword
//   Rect calculateRect(int keywordIndex, String pageText, Size pdfPageSize) {
//     // Approximate the position of the keyword based on the index and layout
//     // You can adjust these values based on your font size, line height, etc.
//     double top = (keywordIndex / pageText.length) * pdfPageSize.height;
//     double left = 10.0; // Approximate or calculate the left position
//     double width = 100.0; // Width of the highlighted text (approximation)
//     double height = 20.0; // Height based on font size (approximation)
//
//     return Rect.fromLTWH(left, top, width, height);
//   }
//
//   getTextOfDoc() async {
//     PDFDoc doc = await PDFDoc.fromFile(widget.file);
//     String docText = await doc.text;
//     print('pdf doc text $docText');
//     print('pdf doc pages ${doc.pages}');
//
//     PDFPage page = doc.pageAt(2);
//     String pageText = await page.text;
//     print('pdf page text ${page.text}, ${page.toString()}');
//
//     searchText(pageText);
//     PDFDocInfo info = doc.info;
//     print('pdf indo ${info.toString()}');
//   }
//
//   searchText(String pageText) {
//     final keywordIndex = pageText.indexOf("Grow");
//     print("keywordIndex $keywordIndex");
//     setState(() {
//       highlightRects.add(
//         calculateRect(
//           keywordIndex,
//           pageText,
//           MediaQuery.sizeOf(context),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             LayoutBuilder(builder: (context, constraints) {
//               pageSize = Size(constraints.maxWidth, constraints.maxHeight);
//               return SizedBox(
//                 height: constraints.maxHeight,
//                 width: constraints.maxWidth,
//                 child: PDFView(
//                   filePath: widget.file.path,
//                   enableSwipe: true,
//                   swipeHorizontal: true,
//                   autoSpacing: false,
//                   pageFling: false,
//                   onRender: (_pages) {
//                     print('onRender ${_pages}');
//                     if (_pages != null) {
//                       getTextOfDoc();
//                       setState(() {
//                         pages = _pages;
//                       });
//                     }
//                   },
//                   onError: (error) {
//                     print(error.toString());
//                   },
//                   onPageError: (page, error) {
//                     print('$page: ${error.toString()}');
//                   },
//                   onViewCreated: (PDFViewController pdfViewController) {
//                     pdfControllerCompleter.complete(pdfViewController);
//                   },
//                   fitEachPage: true,
//                   onPageChanged: (int? page, int? total) {
//                     print('page change: $page/$total');
//                   },
//                 ),
//               );
//             }),
//             ...highlightRects.map((rect) => Positioned(
//                   left: rect.left,
//                   top: rect.top,
//                   width: rect.width,
//                   height: rect.height,
//                   child: Container(
//                     color: Colors.yellow.withOpacity(0.5),
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
