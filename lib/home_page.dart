import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_book_workspace/pdftron_file_viewer.dart';
import 'package:e_book_workspace/pdftron_viewer.dart';
import 'package:e_book_workspace/pspdfkit_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController(text: '');

  //https://www.shelterprojects.org/translations/ar/A.31_Syria2018-AR.pdf

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextField(
            //   controller: controller,
            //   decoration: InputDecoration(hintText: 'enter pdf link'),
            // ),
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => SyncfusionPdf(
            //             url:
            //                 "https://marjankogelnik.wordpress.com/wp-content/uploads/2016/02/napoleon-hill-think-and-grow-rich.pdf"),
            //       ),
            //     );
            //   },
            //   child: Text("Load syncfusion pdf"),
            // ),
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PdfUrlViewer(
            //             url:
            //                 "https://marjankogelnik.wordpress.com/wp-content/uploads/2016/02/napoleon-hill-think-and-grow-rich.pdf"),
            //       ),
            //     );
            //   },
            //   child: Text("Load syncfusion pdf"),
            // ),
            //
            // const SizedBox(height: 30),
            // OutlinedButton(
            //   onPressed: () async {
            //     final file = await downloadAndDisplayPdf(controller.text);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PdfrxPage(file: file),
            //       ),
            //     );
            //   },
            //   child: Text("Download pdfrx"),
            // ),
            // const SizedBox(height: 30),
            //
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             PdfUrlViewer(url: "https://www.shelterprojects.org/translations/ar/A.31_Syria2018-AR.pdf"),
            //       ),
            //     );
            //   },
            //   child: Text("Load Url syncfusion viewer arabic"),
            // ),
            // const SizedBox(height: 30),
            //
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PdfUrlViewer(
            //             url:
            //                 "https://marjankogelnik.wordpress.com/wp-content/uploads/2016/02/napoleon-hill-think-and-grow-rich.pdf"),
            //       ),
            //     );
            //   },
            //   child: Text("Load Url syncfusion viewer english"),
            // ),
            //String _document = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
            //String _document = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
            //String _document = ;

            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PspdfkitViewer(
                        url: "https://www.ed.gov/sites/ed/files/about/offices/list/ocr/docs/qa-201405-arabic.pdf"),
                  ),
                );
              },
              child: Text("pspdfkit arabic 1"),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdftronViewer(
                      url: "https://www.ed.gov/sites/ed/files/about/offices/list/ocr/docs/qa-201405-arabic.pdf",
                    ),
                  ),
                );
              },
              child: Text("pdftron arabic 2"),
            ),
            const SizedBox(height: 30),

            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdftronFileViewer(
                      url: "https://www.ed.gov/sites/ed/files/about/offices/list/ocr/docs/qa-201405-arabic.pdf",
                    ),
                  ),
                );
              },
              child: Text("pdftron file arabic 1"),
            ),

            // const SizedBox(height: 30),
            // OutlinedButton(
            //   onPressed: () async {
            //     final result = await downloadAndDisplayPdf(controller.text);
            //     if (pdfFile != null) {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => PdfViewer2(file: pdfFile!),
            //         ),
            //       );
            //     }
            //   },
            //   child: Text("Download And Open PDF VIEW"),
            // ),
            // const SizedBox(height: 30),
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PageFlipCustom(),
            //       ),
            //     );
            //   },
            //   child: Text("Page custom flipping"),
            // ),
            //
            // const SizedBox(height: 30),
            // OutlinedButton(
            //   onPressed: () async {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PageFlipping(),
            //       ),
            //     );
            //   },
            //   child: Text("Page flipping"),
            // ),
          ],
        ),
      ),
    );
  }

  Future<File> downloadAndDisplayPdf(String url) async {
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
}
