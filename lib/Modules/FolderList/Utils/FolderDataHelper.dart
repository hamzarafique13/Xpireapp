// ignore_for_file: import_of_legacy_library_into_null_safe,file_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:http/http.dart' as http;

Future<List<FolderVM>?> getFolderDataTable(int orderby) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl +
            'Client/getFolderDataTable?orderby=' +
            orderby.toString()),
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
        return _list.map<FolderVM>((json) => FolderVM.fromJson(json)).toList();
      }
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String> addFolder(AddFolder modal) async {
  try {
    SessionMangement _sm = SessionMangement();

    if (modal.color == null || modal.color == "") {
      modal.color = '#BEEAFF';
    }
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addFolder'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    throw Exception('Failed');
  }
}
Future<String> addDllFolder(AddFolder modal) async {
  try {
    SessionMangement _sm = SessionMangement();

    if (modal.color == null || modal.color == "") {
      modal.color = '#BEEAFF';
    }
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addDllFolder'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String> updateFolder(UpdateFolder modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/updateFolder'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String> deleteFolder(String folderId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/deleteFolder?Id=' + folderId),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    throw Exception('Failed');
  }
}
