import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_book_workspace/helper/secure_screen_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pspdfkit_flutter/pspdfkit.dart';

class PspdfkitViewer extends StatefulWidget {
  final String url;

  const PspdfkitViewer({super.key, required this.url});

  @override
  State<PspdfkitViewer> createState() => _PspdfkitViewerState();
}

class _PspdfkitViewerState extends State<PspdfkitViewer> with WidgetsBindingObserver {
  late PspdfkitWidgetController pspdfkitWidgetController;

  //String _frameworkVersion = '';

  String? pdfDocumentPath;
  PdfDocument? _pdfDocument;
  String? _exportedAnnotations;

  @override
  void initState() {
    super.initState();
    print("fired");
    WidgetsBinding.instance.addObserver(this);
    SecureScreenHelper.secureScreenDataLeakageWithBlur();
    SecureScreenHelper.secureScreenshot();
    //initPlatformState();
    loadDoc();
  }

  Future<File> _loadFile() async {
    final filename = widget.url.split('/').last;
    final tempDir = await Pspdfkit.getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$filename';
    if (File(tempDocumentPath).existsSync()) {
      File(tempDocumentPath).delete();
      print("already exists");
    }
    final file = await File(tempDocumentPath).create(recursive: true);
    Dio dio = Dio();
    await dio.download(widget.url, file.path);
    return file;
  }

  loadDoc() async {
    final doc = await _loadFile();
    setState(() {
      pdfDocumentPath = doc.path;
    });
    //await Pspdfkit.present(doc.path);
  }

  Future<File> _getAnnotationsFile() async {
    final filenameWithPdfExtension = widget.url.split('/').last;
    final filename = "${filenameWithPdfExtension.split('.').first}_annotations.json";
    final tempDir = await Pspdfkit.getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$filename';
    final file = File(tempDocumentPath);
    if (file.existsSync()) {
      print("file already exists");
    }
    return file;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SecureScreenHelper.unsecureScreenDataLeakageWithBlur();
    SecureScreenHelper.unsecureScreenshot();
    super.dispose();
  }

  // String frameworkVersion() {
  //   return 'frameworkVersion $_frameworkVersion\n';
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // void initPlatformState() async {
  //   String? frameworkVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     frameworkVersion = await Pspdfkit.frameworkVersion;
  //   } on PlatformException {
  //     frameworkVersion = 'Failed to get platform version. ';
  //   }
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _frameworkVersion = frameworkVersion ?? '';
  //   });
  //   Pspdfkit.flutterPdfActivityOnPause = () => flutterPdfActivityOnPauseHandler();
  //   Pspdfkit.pdfViewControllerWillDismiss = () => pdfViewControllerWillDismissHandler();
  //   Pspdfkit.pdfViewControllerDidDismiss = () => pdfViewControllerDidDismissHandler();
  //   Pspdfkit.flutterPdfFragmentAdded = () => flutterPdfFragmentAdded();
  //   Pspdfkit.pspdfkitDocumentLoaded = (documentId) => pspdfkitDocumentLoaded(documentId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfDocumentPath != null
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PspdfkitWidget(
                  documentPath: pdfDocumentPath!,
                  configuration: PdfConfiguration(
                    //scrollDirection: PspdfkitScrollDirection.horizontal,
                    pageTransition: PspdfkitPageTransition.curl,
                    spreadFitting: PspdfkitSpreadFitting.fit,
                    userInterfaceViewMode: PspdfkitUserInterfaceViewMode.automatic,
                    androidShowSearchAction: true,
                    // inlineSearch: false,
                    showThumbnailBar: PspdfkitThumbnailBarMode.none,
                    androidShowThumbnailGridAction: true,
                    androidShowOutlineAction: true,
                    androidShowAnnotationListAction: true,
                    showPageLabels: false,
                    documentLabelEnabled: true,
                    invertColors: false,
                    androidGrayScale: false,
                    //startPage: 1,
                    enableAnnotationEditing: true,
                    enableTextSelection: true,
                    androidShowBookmarksAction: true,
                    androidEnableDocumentEditor: true,
                    androidShowShareAction: false,
                    androidShowPrintAction: false,
                    androidShowDocumentInfoView: true,
                    appearanceMode: PspdfkitAppearanceMode.defaultMode,
                    androidDefaultThemeResource: 'PSPDFKit.Theme.Example',
                    iOSRightBarButtonItems: [
                      'bookmarkButtonItem',
                      'outlineButtonItem',
                      'searchButtonItem',
                      'annotationButtonItem'
                    ],
                    iOSLeftBarButtonItems: ['settingsButtonItem', 'bookmarkButtonItem'],
                    iOSAllowToolbarTitleChange: false,
                    toolbarTitle: 'E-Book',
                    settingsMenuItems: [
                      'pageTransition',
                      'scrollDirection',
                      'androidTheme',
                      'iOSAppearance',
                      'androidPageLayout',
                      'iOSPageMode',
                      'iOSSpreadFitting',
                      'androidScreenAwake',
                      'iOSBrightness',
                      'pageLayout'
                    ],

                    showActionNavigationButtons: true,
                    pageLayoutMode: PspdfkitPageLayoutMode.single,
                    firstPageAlwaysSingle: false,
                    measurementSnappingEnabled: false,
                    immersiveMode: false,
                    disableAutosave: true,
                    toolbarMenuItems: [
                      PspdfkitToolbarMenuItems.documentEditorButtonItem,
                      PspdfkitToolbarMenuItems.emailButtonItem,
                      PspdfkitToolbarMenuItems.searchButtonItem
                    ],
                    enableMeasurementTools: true,
                    enableInstantComments: true,
                    enableMagnifier: false,

                    //  restoreLastViewedPage: false,
                    // webConfiguration: PdfWebConfiguration(
                    //     toolbarPlacement: PspdfKitToolbarPlacement.bottom,
                    //     enableHistory: true,
                    //     disableTextSelection: false,
                    //     sideBarMode: PspdfkitSidebarMode.bookmarks,
                    //     interactionMode: PspdfkitWebInteractionMode.pan,
                    //     locale: 'de-DE',
                    //     zoom: PspdfkitZoomMode.fitToViewPort,
                    //     allowPrinting: false),
                  ),
                  onPspdfkitWidgetCreated: (controller) {
                    pspdfkitWidgetController = controller;
                  },
                  onPdfDocumentLoaded: (PdfDocument document) async {
                    _pdfDocument = document;
                    print("pdf document loaded");
                  },
                  onPageChanged: (page) {
                    print("page changed $page");
                  },
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 70),
                  child: Row(
                    children: [
                      ///BOOKMARKS
                      OutlinedButton(
                        onPressed: () async {
                          pspdfkitWidgetController.changeToRtl();
                          //  pspdfkitWidgetController.addBookmark(2);

                          // final file = await _getAnnotationsFile();
                          // final filePath = file.path;
                          //
                          // final bookmarkAnnotation = {
                          //   'v': 1,
                          //   'type': 'pspdfkit/bookmark',
                          //   'action': {"type": "goTo"},
                          //   "pageIndex": 1,
                          //   "bbox": [395.37933349609375, 519.9959716796875, 53.105377197265625, 15.76800537109375],
                          //   // Adjust position as needed
                          //   'name': 'Bookmark page 1',
                          //   'opacity': 1.0
                          // };
                          // final annotations = await pspdfkitWidgetController.addAnnotation(bookmarkAnnotation);
                        },
                        child: Text("add bookmark"),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          //  pspdfkitWidgetController.jumpToPage(2);
                          // final bookmarks = await pspdfkitWidgetController.getBookmarks();
                          // debugPrint("bookmarks $bookmarks");
                        },
                        child: Text("bookmarks"),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          //bookmark object iOS {page: 0, sortKey: null, name: null, uuid: null}, {page: 1, sortKey: null, name: 2, uuid: null}
                          //bookmark object android {uuid: f2532132-d672-4d8d-a6f3-4696a5f7b326, page: 0, name: null, sortKey: null}
                          //     pspdfkitWidgetController.removeBookmark(2);
                        },
                        child: Text("remove bookmark"),
                      ),

                      ///ANNOTATIONS
                      // OutlinedButton(
                      //   onPressed: () async {
                      //
                      //     if (_exportedAnnotations != null) {
                      //       final bool? exportedAnnotations =
                      //           await pspdfkitWidgetController.applyInstantJson(_exportedAnnotations!);
                      //       print("importedAnnotations $_exportedAnnotations");
                      //     }
                      //   },
                      //   child: Text("import annotations"),
                      // ),
                      // OutlinedButton(
                      //   onPressed: () async {
                      //     final String? exportedAnnotations = await pspdfkitWidgetController.exportInstantJson();
                      //     _exportedAnnotations = exportedAnnotations;
                      //     debugPrint("exportedAnnotations $_exportedAnnotations");
                      //     // pspdfkitWidgetController.addEventListener(1, "type");
                      //   },
                      //   child: Text("export annotations"),
                      // ),
                      // OutlinedButton(
                      //   onPressed: () async {
                      //   },
                      //   child: Text("go to page"),
                      // ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  void flutterPdfActivityOnPauseHandler() {
    if (kDebugMode) {
      print('sspspdfkit flutterPdfActivityOnPauseHandler');
    }
  }

  void pdfViewControllerWillDismissHandler() {
    if (kDebugMode) {
      print('sspspdfkit pdfViewControllerWillDismissHandler');
    }
  }

  void pdfViewControllerDidDismissHandler() {
    if (kDebugMode) {
      print('sspspdfkit pdfViewControllerDidDismissHandler');
    }
  }

  void flutterPdfFragmentAdded() {
    if (kDebugMode) {
      print('sspspdfkit flutterPdfFragmentAdded');
    }
  }

  void pspdfkitDocumentLoaded(String? documentId) {
    if (kDebugMode) {
      print('sspspdfkit pspdfkitDocumentLoaded: $documentId');
    }
  }
}
