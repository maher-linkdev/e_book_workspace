// import 'dart:io';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:pdfrx/pdfrx.dart';
//
// class PdfrxPage extends StatefulWidget {
//   final File file;
//
//   const PdfrxPage({super.key, required this.file});
//
//   @override
//   State<PdfrxPage> createState() => _PdfrxPageState();
// }
//
// class _PdfrxPageState extends State<PdfrxPage> {
//   PdfViewerController pdfViewerController = PdfViewerController();
//   List<Rect> pagesRects = [];
//
//   late PdfViewerParams params;
//
//   @override
//   void initState() {
//     super.initState();
//     params = PdfViewerParams(
//         layoutPages: (pages, params) {
//           final height = pages.fold(0.0, (prev, page) => max(prev, page.height)) + params.margin * 2;
//           final pageLayouts = <Rect>[];
//           double x = params.margin;
//           for (var page in pages) {
//             //612.0, 792.0,
//             //print("page size ${page.size.width}, ${page.size.height}, page ${page.pageNumber}");
//             final rect = Rect.fromLTWH(
//               x,
//               (height - page.height) / 2, // center vertically
//               page.width,
//               page.height,
//             );
//             pageLayouts.add(rect);
//
//             pagesRects.add(rect);
//
//             x += page.width + params.margin;
//           }
//           return PdfPageLayout(
//             pageLayouts: pageLayouts,
//             documentSize: Size(x, height),
//           );
//         },
//         onPageChanged: (page) {
//           print('page changed ${page}');
//         },
//         onInteractionUpdate: (scaleStartDetails) {
//           print("onInteractionUpdate focalPoint   ${scaleStartDetails.focalPoint}");
//         },
//         panAxis: PanAxis.horizontal,
//         panEnabled: true);
//     pdfViewerController.addListener(() {
//       // print("matrix ${pdfViewerController.value}");
//       // print("document size ${pdfViewerController.documentSize}");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pdfrx example'),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Stack(
//           children: [
//             PdfViewer.file(
//               widget.file.path,
//               params: params,
//               controller: pdfViewerController,
//             ),
//             TextButton(
//               onPressed: () {
//                 pdfViewerController.goToArea(rect: pagesRects[1]);
//               },
//               child: Text("Do Action"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
