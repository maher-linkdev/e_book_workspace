import 'package:e_book_workspace/helper/secure_screen_helper.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfUrlViewer extends StatefulWidget {
  final String url;

  const PdfUrlViewer({super.key, required this.url});

  @override
  State<PdfUrlViewer> createState() => _PdfUrlViewerState();
}

class _PdfUrlViewerState extends State<PdfUrlViewer> with SingleTickerProviderStateMixin {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResults = PdfTextSearchResult();

  // Uint8List? _swipeImagePngBytes;
  // Uint8List? _nextSwipeImagePngBytes;
  //
  // bool showSwipeImage = false;
  //
  // GlobalKey globalKey = GlobalKey();

  // Future<Uint8List> _capturePngImage() async {
  //   RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData!.buffer.asUint8List();
  //   print("_swipeImagePngBytes $pngBytes");
  //   return pngBytes;
  // }

  @override
  void dispose() {
    SecureScreenHelper.unsecureScreenDataLeakageWithBlur();
    SecureScreenHelper.unsecureScreenshot();
    super.dispose();
  }

  // Future<String> getFirstLineOfPage(int pageNumber) async {
  //   //PDFDOC From Flutter_pdf_text package
  //   PDFDoc pdfDoc = await PDFDoc.fromURL(widget.url);
  //   PDFPage page = pdfDoc.pageAt(pageNumber);
  //   String pageText = await page.text;
  //   print("Page text ${pageText}");
  //   List<String> lines = pageText.split('\n');
  //   String firstLine;
  //   firstLine = lines.firstWhere((line) => line.trim().length > 3, orElse: () => "No title");
  //   return firstLine;
  // }

  @override
  void initState() {
    super.initState();
    SecureScreenHelper.secureScreenDataLeakageWithBlur();
    SecureScreenHelper.secureScreenshot();

    _pdfViewerController.addListener(() {
      print("dx ${_pdfViewerController.scrollOffset.dx}, dy ${_pdfViewerController.scrollOffset.dy},");
    });
    _searchResults.addListener(() {
      print("search results has results? ${_searchResults.hasResult}");
      print("search results completed? ${_searchResults.isSearchCompleted}");
      print("search results total instance ${_searchResults.totalInstanceCount}");
    });
    //init();
  }

  // init() async {
  //   final page3Title = await getFirstLineOfPage(1);
  //   print("page3Title ${page3Title}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: SfPdfViewer.network(
                  widget.url,
                  key: _pdfViewerKey,
                  onPageChanged: (pdfChangedDetails) async {
                    final newNumber = pdfChangedDetails.newPageNumber;
                    print("newNumber $newNumber");
                  },
                  pageLayoutMode: PdfPageLayoutMode.single,
                  controller: _pdfViewerController,
                  canShowScrollHead: false,
                  scrollDirection: PdfScrollDirection.horizontal,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
                    print("pages ${details.document.pages.count}");
                  },
                  onTap: (pdfGesturesDetails) {
                    print("pdfGesturesDetails ${pdfGesturesDetails.position}");
                  },
                ),
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
                      _searchResults = _pdfViewerController.searchText('صنعتها');
                    },
                    child: Text("Search"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      _searchResults.nextInstance();
                    },
                    child: Text("next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
