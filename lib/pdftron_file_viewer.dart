import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_book_workspace/helper/secure_screen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PdftronFileViewer extends StatefulWidget {
  final String url;

  const PdftronFileViewer({super.key, required this.url});

  @override
  State<PdftronFileViewer> createState() => _PdftronFileViewerState();
}

class _PdftronFileViewerState extends State<PdftronFileViewer> {
  @override
  void initState() {
    super.initState();
    SecureScreenHelper.secureScreenDataLeakageWithBlur();
    SecureScreenHelper.secureScreenshot();
    // If you are using local files delete the line above, change the _document field
    // appropriately and uncomment the section below.
    initPlatformState();
    if (Platform.isIOS) {
      // Open the document for iOS, no need for permission.
      openViewer();
    } else {
      // Request permission for Android before opening document.
      openViewerWithPermission();
    }
  }

  @override
  void dispose() {
    SecureScreenHelper.unsecureScreenDataLeakageWithBlur();
    SecureScreenHelper.unsecureScreenshot();
    super.dispose();
  }

  Future<void> openViewerWithPermission() async {
    PermissionStatus permission = await Permission.storage.request();
    print("permission $permission");
    if (permission.isGranted) {
      openViewer();
    }
  }

  void openViewer() async {
    final file = await _downloadAndDisplayPdf(widget.url);
    var config = Config();
    config.layoutMode = LayoutModes.single;
    config.openUrlPath = file.path;
    // How to disable functionality:
    //      config.disabledElements = [Buttons.shareButton, Buttons.searchButton];
    //      config.disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
    // Other viewer configurations:
    //      config.multiTabEnabled = true;
    //      config.customHeaders = {'headerName': 'headerValue'};

    // An event listener for document loading
    var documentLoadedCancel = startDocumentLoadedListener((filePath) {
      print("document loaded: $filePath");
    });
    await PdftronFlutter.openDocument(file.path, config: config);
    try {
      // The imported command is in XFDF format and tells whether to add, modify or delete annotations in the current document.
      PdftronFlutter.importAnnotationCommand("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
          "    <xfdf xmlns=\"http://ns.adobe.com/xfdf/\" xml:space=\"preserve\">\n" +
          "      <add>\n" +
          "        <square style=\"solid\" width=\"5\" color=\"#E44234\" opacity=\"1\" creationdate=\"D:20200619203211Z\" flags=\"print\" date=\"D:20200619203211Z\" name=\"c684da06-12d2-4ccd-9361-0a1bf2e089e3\" page=\"1\" rect=\"113.312,277.056,235.43,350.173\" title=\"\" />\n" +
          "      </add>\n" +
          "      <modify />\n" +
          "      <delete />\n" +
          "      <pdf-info import-version=\"3\" version=\"2\" xmlns=\"http://www.pdftron.com/pdfinfo\" />\n" +
          "    </xfdf>");
    } on PlatformException catch (e) {
      print("Failed to importAnnotationCommand '${e.message}'.");
    }

    try {
      // Adds a bookmark into the document.
      PdftronFlutter.importBookmarkJson('{"0":"Page 1"}');
    } on PlatformException catch (e) {
      print("Failed to importBookmarkJson '${e.message}'.");
    }

    // An event listener for when local annotation changes are committed to the document.
    // xfdfCommand is the XFDF Command of the annotation that was last changed.
    var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
      String command = xfdfCommand;
      print("flutter xfdfCommand:\n");
      // Dart limits how many characters are printed onto the console.
      // The code below ensures that all of the XFDF command is printed.
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

    // An event listener for when local bookmark changes are committed to the document.
    // bookmarkJson is JSON string containing all the bookmarks that exist when the change was made.
    var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
      print("flutter bookmark: $bookmarkJson");
    });

    var path = await PdftronFlutter.saveDocument();
    print("flutter save: $path");

    // To cancel event:
    // annotCancel();
    // bookmarkCancel();
    // documentLoadedCancel();
  }

  // Platform messages are asynchronous, so initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so use a try/catch PlatformException.
    try {
      // Initializes the PDFTron SDK, it must be called before you can use any functionality.
      PdftronFlutter.initialize("");

      final version = await PdftronFlutter.version;
      print("version $version");
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  Future<File> _downloadAndDisplayPdf(String url) async {
    final filename = url.split('/').last;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    print("file path ${dir.path}/$filename");

    if (!file.existsSync()) {
      // Downloading the file
      Dio dio = Dio();
      await dio.download(url, file.path);
    } else {
      print('already exists');
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 90,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      PdftronFlutter.startSearchMode("قوانين", true, true);
                    },
                    child: Text("search"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
