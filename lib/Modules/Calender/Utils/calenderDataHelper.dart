// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:http/http.dart' as http;

Future<List<Document>?> getDocumentByMonth(String month, String year) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl +
            'Client/GetDocumentByMonth?month=' +
            month +
            '&year=' +
            year),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        _list = data["result"];
        return _list.map<Document>((json) => Document.fromJson(json)).toList();
      }
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    // EasyLoading.dismiss();
    return null;
  }
}
