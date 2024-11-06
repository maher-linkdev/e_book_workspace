import 'dart:async';
import 'dart:io';

import 'package:e_book_workspace/helper/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class PdftronViewer extends StatefulWidget {
  final String url;

  const PdftronViewer({super.key, required this.url});

  @override
  State<PdftronViewer> createState() => _PdftronViewerState();
}

class _PdftronViewerState extends State<PdftronViewer> {
  Map<String, dynamic>? _pdfDocumentMeta;

  final Completer<DocumentViewController> _controllerCompleter = Completer<DocumentViewController>();

  String? _getPdfDocumentAnnotation() => _pdfDocumentMeta?["annotations"];

  _onLoadPdfDocument(DocumentViewController docViewController) async {
    _controllerCompleter.complete(docViewController);
    final Map<String, dynamic>? pdfDocumentMeta = await getPdfDocumentMeta();
    _pdfDocumentMeta = pdfDocumentMeta;
    final String? annotationsXFDFString = _getPdfDocumentAnnotation();
    // if (annotationsXFDFString != null) {
    //   final documentViewController = await _controllerCompleter.future;
    //   documentViewController.importAnnotations(annotationsXFDFString);
    // }
  }

  _onAnnotationsExported(String? xfdfEncodedString) async {
    final controller = await _controllerCompleter.future;
    final String? exportedAnnotations = await controller.exportAnnotations(null);
    final annotations = exportedAnnotations;
    _pdfDocumentMeta = _updatePdfDocumentMetaAnnotations(_pdfDocumentMeta, annotations);
    _saveAndUpdatePdfDocumentMeta(_pdfDocumentMeta, widget.url);
  }

  _saveAndUpdatePdfDocumentMeta(Map<String, dynamic>? userPdfDocumentMeta, String pdfDocumentUrl) async {
    Map<String, Map<String, dynamic>>? userPdfDocumentsMeta = await SharedPreferencesHelper.getUserPdfDocumentsMeta();
    if (userPdfDocumentsMeta != null) {
      userPdfDocumentsMeta[pdfDocumentUrl] = userPdfDocumentMeta ?? {};
    } else {
      //NO PREVIOUS SAVED USER PDFs Documents Meta
      if (userPdfDocumentMeta != null) {
        userPdfDocumentsMeta = {};
        userPdfDocumentsMeta[pdfDocumentUrl] = userPdfDocumentMeta;
      }
    }

    if (userPdfDocumentsMeta != null) {
      await SharedPreferencesHelper.saveUserPdfDocumentsMeta(userPdfDocumentsMeta);
    }
  }

  Map<String, dynamic> _updatePdfDocumentMetaAnnotations(Map<String, dynamic>? pdfDocumentMeta, String? annotations) {
    if (pdfDocumentMeta != null) {
      pdfDocumentMeta["annotations"] = annotations ?? "";
    } else {
      pdfDocumentMeta = {"annotations": annotations ?? ""};
    }
    return pdfDocumentMeta;
  }

  Future<Map<String, dynamic>?> getPdfDocumentMeta() async {
    final Map<String, Map<String, dynamic>>? userPdfDocumentsMeta =
        await SharedPreferencesHelper.getUserPdfDocumentsMeta();
    final Map<String, dynamic>? userPdfDocumentMeta = _getPdfDocument(userPdfDocumentsMeta, widget.url);
    return userPdfDocumentMeta;
  }

  Map<String, dynamic>? _getPdfDocument(
      Map<String, Map<String, dynamic>>? userPdfDocumentsMeta, String? pdfDocumentUrl) {
    return userPdfDocumentsMeta?[pdfDocumentUrl];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              DocumentView(
                onCreated: _onDocumentViewCreated,
              ),
              Positioned(
                bottom: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final documentViewController = await _controllerCompleter.future;
                        documentViewController.saveDocument();
                      },
                      child: Text("Save"),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final documentViewController = await _controllerCompleter.future;
                        String word = "سجلات الطالب";
                        if (_isArabic(word) && Platform.isIOS) {
                          final _reversedWord = _reverseArabicSentence(word);
                          documentViewController.startSearchMode(_reversedWord, true, true);
                        } else {
                          documentViewController.startSearchMode(word, true, true);
                          documentViewController.openSearch();
                        }

                        //CRASH ON IOS
                      },
                      child: Text("Search"),
                    ),
                    // OutlinedButton(
                    //   onPressed: () async {
                    //     final documentViewController = await _controllerCompleter.future;
                    //     //OPEN BOOKMARK, OUTLINE, NAVIGATION
                    //     documentViewController.openBookmarkList();
                    //     // documentViewController.openOutlineList();
                    //     // documentViewController.openNavigationLists();
                    //     // documentViewController.openAnnotationList();
                    //   },
                    //   child: Text("Open bookmark"),
                    // ),
                    // OutlinedButton(
                    //   onPressed: () async {
                    //     final documentViewController = await _controllerCompleter.future;
                    //     documentViewController.zoomWithCenter(4, (MediaQuery.sizeOf(context).width / 2).toInt(),
                    //         (MediaQuery.sizeOf(context).height / 2).toInt());
                    //   },
                    //   child: Text("zoom 40"),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isArabic(String input) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(input);
  }

  String _reverseArabicSentence(String input) {
    // Split the string into individual characters
    List<String> chars = input.split('');
    // Reverse the list of characters
    List<String> reversedChars = chars.reversed.toList();
    // Join the reversed list back into a string
    return reversedChars.join();
  }

  void _onDocumentViewCreated(DocumentViewController controller) async {
    Config config = new Config();
    config.layoutMode = LayoutModes.single;
    var disabledElements = [
      Buttons.printButton,
      Buttons.searchButton,
      Buttons.saveCopyButton,
      Buttons.editPagesButton,
      Buttons.shareButton,
    ];
    var disabledTools = [Tools.annotationCreateLine];
    var hideDefaultAnnotationToolbars = [
      DefaultToolbars.view,
      DefaultToolbars.draw,
    ];
    config.disabledElements = disabledElements;
    config.disabledTools = disabledTools;
    config.hideDefaultAnnotationToolbars = hideDefaultAnnotationToolbars;
    config.hideAnnotationToolbarSwitcher = true;
    config.continuousAnnotationEditing = true;
    //config.hideTopAppNavBar = true;
    config.hideBottomToolbar = true;
    config.hideScrollbars = true;
    config.userBookmarksListEditingEnabled = false;
    config.annotationsListEditingEnabled = false;
    config.autoSaveEnabled = true;
    config.showDocumentSavedToast = false;

    //config.hideAnnotationMenu = [AnnotationMenuItems.ungroup, ];
    var leadingNavCancel = startLeadingNavButtonPressedListener(() {
      _showMyDialog();
    });

    var onBehaviorActivated = startBehaviorActivatedListener((action, data) {
      print("from behavior activated action $action");
      print("from behavior activated data ${data}");
    });
    var onAnnotationMenuPressed = startAnnotationMenuPressedListener((annotationMenuItem, annotationsList) {
      print("from annotation menu item $annotationMenuItem");
      print("from long press text ${annotationsList}");
    });
    var onLongPressMenuPressed = startLongPressMenuPressedListener((longPressMenuItem, longPressText) {
      print("from long press menu item $longPressMenuItem");
      print("from long press text $longPressText");
    });
    var onAnnotationSelected = startAnnotationsSelectedListener((annotationWithRects) {
      print("from annotations selected");

      for (AnnotWithRect annotWithRect in annotationWithRects) {
        Annot annot = Annot(annotWithRect.id, annotWithRect.pageNumber);
        print(
            'annotation first point ${annotWithRect.rect?.x1},${annotWithRect.rect?.y1} second  point ${annotWithRect.rect?.x2},${annotWithRect.rect?.y2}');
        print('annotation has id: ${annotWithRect.id}');
        print('annotation is in page: ${annotWithRect.pageNumber}');
        print('annotation has size: ${annotWithRect.rect?.width},${annotWithRect.rect?.height}');
      }
    });

    var onAnnotationChanged = startAnnotationChangedListener((action, annotations) {
      print("from annotations changed");

      print('flutter annotation action: $action');
      for (Annot annot in annotations) {
        print('annotation has id: ${annot.id}');
        print('annotation is in page: ${annot.pageNumber}');
      }
    });

    var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
      print("export annotation command listeners");
      final String command = xfdfCommand;
      _onAnnotationsExported(command);

      //PRINT ALL COMMAND STRING
      print("flutter xfdfCommand\n");
      if (command.length > 1024) {
        int start = 0;
        int end = 1023;
        while (end < command.length) {
          print(command.substring(start, end) + "\n");
          start += 1024;
          end += 1024;
        }
        print(command.substring(start));
      } else {
        print("flutter xfdfCommand:\n $command");
      }
    });

    await controller.openDocument(widget.url, config: config);
    await _onLoadPdfDocument(controller);
  }

  Future<void> _showMyDialog() async {
    print('hello');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog'),
          content: SingleChildScrollView(
            child: Text('Leading navigation button has been pressed.'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
