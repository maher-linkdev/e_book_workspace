// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
//
// class PdfxViewer extends StatefulWidget {
//   final String filePath;
//
//   const PdfxViewer({Key? key, required this.filePath}) : super(key: key);
//
//   @override
//   State<PdfxViewer> createState() => _PdfxViewerState();
// }
//
// class _PdfxViewerState extends State<PdfxViewer> {
//   static const int _initialPage = 1;
//   bool _isSampleDoc = true;
//   late PdfController _pdfController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pdfController = PdfController(
//       document: PdfDocument.openFile(widget.filePath),
//       initialPage: _initialPage,
//     );
//   }
//
//   @override
//   void dispose() {
//     _pdfController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: const Text('Pdfx example'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.navigate_before),
//             onPressed: () {
//               _pdfController.previousPage(
//                 curve: Curves.ease,
//                 duration: const Duration(milliseconds: 100),
//               );
//             },
//           ),
//           PdfPageNumber(
//             controller: _pdfController,
//             builder: (_, loadingState, page, pagesCount) => Container(
//               alignment: Alignment.center,
//               child: Text(
//                 '$page/${pagesCount ?? 0}',
//                 style: const TextStyle(fontSize: 22),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.navigate_next),
//             onPressed: () {
//               _pdfController.nextPage(
//                 curve: Curves.ease,
//                 duration: const Duration(milliseconds: 100),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               if (_isSampleDoc) {
//                 _pdfController.loadDocument(PdfDocument.openAsset('assets/flutter_tutorial.pdf'));
//               } else {
//                 _pdfController.loadDocument(PdfDocument.openAsset('assets/hello.pdf'));
//               }
//               _isSampleDoc = !_isSampleDoc;
//             },
//           ),
//         ],
//       ),
//       body: PdfView(
//         builders: PdfViewBuilders<DefaultBuilderOptions>(
//           options: const DefaultBuilderOptions(),
//           documentLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
//           pageLoaderBuilder: (_) => const Center(child: CircularProgressIndicator()),
//           pageBuilder: _pageBuilder,
//         ),
//         controller: _pdfController,
//         reverse: true,
//       ),
//     );
//   }
//
//   PhotoViewGalleryPageOptions _pageBuilder(
//     BuildContext context,
//     Future<PdfPageImage> pageImage,
//     int index,
//     PdfDocument document,
//   ) {
//     return PhotoViewGalleryPageOptions(
//       imageProvider: PdfPageImageProvider(
//         pageImage,
//         index,
//         document.id,
//       ),
//       minScale: PhotoViewComputedScale.contained * 1,
//       maxScale: PhotoViewComputedScale.contained * 2,
//       initialScale: PhotoViewComputedScale.contained * 1.0,
//       heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
//     );
//   }
// }
