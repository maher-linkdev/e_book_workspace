import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfFileViewer extends StatefulWidget {
  final Uint8List bytes;

  PdfFileViewer({super.key, required this.bytes});

  @override
  State<PdfFileViewer> createState() => _PdfFileViewerState();
}

class _PdfFileViewerState extends State<PdfFileViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResults = PdfTextSearchResult();
  PdfDocument? document;

  @override
  void initState() {
    super.initState();
    _pdfViewerController.addListener(() {
      print("dx ${_pdfViewerController.scrollOffset.dx}, dy ${_pdfViewerController.scrollOffset.dy},");
    });
    _searchResults.addListener(() {
      print("search results has results? ${_searchResults.hasResult}");
      print("search results completed? ${_searchResults.isSearchCompleted}");
      print("search results total instance ${_searchResults.totalInstanceCount}");
    });
  }

  // void _getPDFBytes() async {
  //   document = PdfDocument(inputBytes: _file.readAsBytesSync());
  //   //Gets all the pages
  //   for (int i = 0; i < document!.pages.count; i++) {
  //     //Loads the existing PDF page
  //     PdfPage page = document!.pages[i];
  //     //Gets the annotation collection from the page
  //     PdfAnnotationCollection collection = page.annotations;
  //     print('collection annotation ${collection.count}');
  //     //Gets all the annotations in the page
  //     for (int j = 0; j < collection.count; j++) {
  //       //Gets the annotation from the annotation collection
  //       //Ignored the supported DocumentLinkAnnotation from flattening.
  //       final annotation = collection[j];
  //       //å _pdfViewerController.addAnnotation(annotation);
  //       if (annotation != PdfDocumentLinkAnnotation) {
  //         //Flattens the annotation
  //         annotation.flatten();
  //       }
  //     }
  //   }
  //
  //   //Flattens the PDF form field annotation
  //   document!.form.flattenAllFields();
  //   documentBytes = Uint8List.fromList(document!.saveSync());
  //
  //   setState(() {});
  // }

  // void exportAnnotations() async {
  //   //Load an existing PDF document.
  //   PdfDocument document = PdfDocument(inputBytes: _file.readAsBytesSync());
  //   //Export the annotations to JSON file format.
  //   List<int> bytes = document.exportAnnotation(PdfAnnotationDataFormat.json);
  //   //Save the FDF file.
  //   final dir = await getApplicationDocumentsDirectory();
  //   final File file = File('${dir.path}annotations.json');
  //   file.writeAsBytesSync(bytes);
  //   print('file path ${file.path}');
  //   //Dispose the document.
  //   document.dispose();
  // }
  //
  // void loadAnnotations() async {
  //   //Load an existing PDF document.
  //   PdfDocument document = PdfDocument(inputBytes: _file.readAsBytesSync());
  //   final dir = await getApplicationDocumentsDirectory();
  //
  //   //Import the annotations to JSON file format.
  //   File file = File('${dir.path}annotations.json');
  //   if (file.existsSync()) {
  //     print('file exists');
  //     document.importAnnotation(file.readAsBytesSync(), PdfAnnotationDataFormat.json);
  //     //Save the PDF document.
  //     await document.save();
  //   }
  // }

  getAnnotations() {
    final List<Annotation> annotations = _pdfViewerController.getAnnotations();
    print("annotations length ${annotations.length}");
  }

  // Future<void> saveDocAndFile() async {
  //   List<int> bytes = await _pdfViewerController.saveDocument();
  //   if (widget.file.existsSync()) {
  //     print("widget.file exists");
  //   }
  //   if (_file.existsSync()) {
  //     print("_file exists");
  //   }
  //   if (_file.existsSync()) {
  //     await _file.delete();
  //   }
  //   await _file.writeAsBytes(bytes);
  //   print('file saved');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SfPdfViewer.memory(
              widget.bytes,
              key: _pdfViewerKey,
              onTap: (PdfGestureDetails details) {
                print('pageNumber ${details.pageNumber}');
                print('pagePosition ${details.pagePosition}');
                print('position ${details.position.dx},${details.position.dy}');
              },
              pageLayoutMode: PdfPageLayoutMode.single,
              scrollDirection: PdfScrollDirection.horizontal,
              controller: _pdfViewerController,
              canShowScrollHead: false,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                print("pages ${details.document.pages.count}");
                print("bookmarks ${details.document.bookmarks.count}");
                getAnnotations();
              },
              onAnnotationAdded: (annotation) {
                print("annotation added ${annotation.name}");
              },
              onAnnotationSelected: (annotation) {
                print("annotation selected ${annotation.toString()}");
              },
              onAnnotationRemoved: (annotation) {
                print("annotation removed ${annotation.toString()}");
              },
              onPageChanged: (pageDetails) {},
              canShowTextSelectionMenu: false,
              onTextSelectionChanged: (textSelectionChanged) {
                print("selectedText ${textSelectionChanged.selectedText}");
                print("selectedText ${textSelectionChanged.globalSelectedRegion}");
                if (textSelectionChanged.selectedText != null && textSelectionChanged.globalSelectedRegion != null) {
                  final textLines = [
                    PdfTextLine(textSelectionChanged.globalSelectedRegion!, textSelectionChanged.selectedText!, 1)
                  ];
                  final HighlightAnnotation highlightAnnotation = HighlightAnnotation(
                    textBoundsCollection: textLines,
                  );
                  _pdfViewerController.addAnnotation(highlightAnnotation);
                  _pdfViewerController.saveDocument();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    _pdfViewerKey.currentState?.openBookmarkView();
                  },
                  child: Text("Bookmark"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    _searchResults = _pdfViewerController.searchText('napoleon');
                  },
                  child: Text("Search"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final annotations = _pdfViewerController.getAnnotations();
                    Annotation firstAnnotation = annotations.first;

                    _pdfViewerController.removeAnnotation(firstAnnotation);
                  },
                  child: Text("next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
