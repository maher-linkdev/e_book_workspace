import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const userPdfDocumentsMetaSharedPreferencesKey = "user_pdf_documents_meta";

  static Future<void> saveUserPdfDocumentsMeta(Map<String, Map<String, dynamic>> pdfDocumentMeta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(pdfDocumentMeta);
    await prefs.setString(userPdfDocumentsMetaSharedPreferencesKey, jsonString);
  }

  static Future<Map<String, Map<String, dynamic>>?> getUserPdfDocumentsMeta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(userPdfDocumentsMetaSharedPreferencesKey);
    if (jsonString == null) return null;
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    Map<String, Map<String, dynamic>> pdfDocumentMeta =
        decodedMap.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
    return pdfDocumentMeta;
  }
}
