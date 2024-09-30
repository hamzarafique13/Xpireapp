// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
/* 
Future<List<TblCountry>?> fetchCountry() async {
  try {
    final response = await http.get(
        Uri.parse('https://api.countrystatecity.in/v1/countries'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSCAPI-KEY':
              'cHFrTzJ6ZkNybWVtc2xOVmVOb0MxUmpGRkgzZmtNaENwMEduTllmeQ=='
        });
    List _list;
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      var _listData =_list .map<TblCountry>((json) => TblCountry.fromJson(json)).toList();
      _listData.sort((a, b) => a.name.compareTo(b.name));
      return _listData;
    } else {
      throw Exception('Failed to load Country');
    }
  } catch (error) {
    return null;
  }
} */
Future<List<TblCountry>?> fetchCountry() async {
  try {
     SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response =
        await http.get(Uri.parse(baseUrl + 'ddl/getCountryDDL'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      var _listData =_list .map<TblCountry>((json) => TblCountry.fromJson(json)).toList();
      _listData.sort((a, b) => a.name.compareTo(b.name));
      return _listData;
    } else {
      throw Exception('Failed to load Country');
    }
  } catch (error) {
    return null;
  }
}
Future<TblCountry?> fetchCountryDetail(String countryId) async {
  try {
    final response = await http.get(
        Uri.parse('https://api.countrystatecity.in/v1/countries/$countryId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSCAPI-KEY':
              'cHFrTzJ6ZkNybWVtc2xOVmVOb0MxUmpGRkgzZmtNaENwMEduTllmeQ=='
        });
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return TblCountry.fromJson(data);
    } else {
      throw Exception('Failed to load Country');
    }
  } catch (error) {
    return null;
  }
}
Future<List<TblState>?> fetchState(String? countryId) async {
  try {
      SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response =
        await http.get(Uri.parse(baseUrl + 'ddl/getStateDDL?countryId='+countryId.toString()), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      var _listData =
          _list.map<TblState>((json) => TblState.fromJson(json)).toList();
          _listData.sort((a, b) => a.name.compareTo(b.name));
      return _listData;
    } else {
      throw Exception('Failed to load states');
    }
  } catch (error) {
    return null;
  }
}

/* Future<List<TblState>?> fetchState(String? countryId) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://api.countrystatecity.in/v1/countries/$countryId/states'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSCAPI-KEY':
              'cHFrTzJ6ZkNybWVtc2xOVmVOb0MxUmpGRkgzZmtNaENwMEduTllmeQ=='
        });
    List _list;
    if (response.statusCode == 200) {
      _list = jsonDecode(response.body);
      var _listData =
          _list.map<TblState>((json) => TblState.fromJson(json)).toList();
          _listData.sort((a, b) => a.name.compareTo(b.name));
      return _listData;
    } else {
      throw Exception('Failed to load states');
    }
  } catch (error) {
    return null;
  }
}
 */
Future<TblState?> fetchStateDetail(String countryId, String stateId) async {
  try {
    final response = await http.get(
        Uri.parse(
            'https://api.countrystatecity.in/v1/countries/$countryId/states/$stateId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSCAPI-KEY':
              'cHFrTzJ6ZkNybWVtc2xOVmVOb0MxUmpGRkgzZmtNaENwMEduTllmeQ=='
        });
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return TblState.fromJson(data);
    } else {
      throw Exception('Failed to load states');
    }
  } catch (error) {
    return null;
  }
}

Future<List<TblAccessType>?> fetchAccessType() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response =
        await http.get(Uri.parse(baseUrl + 'ddl/getAccessTypeDDL'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
      return _list
          .map<TblAccessType>((json) => TblAccessType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load access type');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<List<UserSharerVm>?> getSharerByUserDDL() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response =
        await http.get(Uri.parse(baseUrl + 'ddl/getSharerByUserDDL'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
      return _list
          .map<UserSharerVm>((json) => UserSharerVm.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    return null;
  }
}

Future<List<TblNotificationType>?> getNotifyTypeDDL(int sourceCatgry) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
        Uri.parse(baseUrl +
            'ddl/getNotifyTypeDDL?SourceCatgry=' +
            sourceCatgry.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
      return _list
          .map<TblNotificationType>(
              (json) => TblNotificationType.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    return null;
  }
}

Future<List<UserSharerVm>?> getAssignTaskUserByDocIdDLL(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
        Uri.parse(baseUrl + 'ddl/GetAssignTaskUserByDocIdDLL?docId=' + docId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
      return _list
          .map<UserSharerVm>((json) => UserSharerVm.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    return null;
  }
}

Future<List<TblDocType>?> fetchDocType(String? docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    String apiCall = "";
    if (docId == null) {
      apiCall = 'ddl/getDocTypeDDL';
    } else {
      apiCall = 'ddl/getDocTypeDDL?docId=' + docId;
    }
    final response = await http.get(Uri.parse(baseUrl + apiCall), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
        var _listData =_list
          .map<TblDocType>((json) => TblDocType.fromJson(json))
          .toList();
      _listData.sort((a, b) => a.title.compareTo(b.title));
      return _listData;
    } else {
      throw Exception('Failed to load doc type');
    }
  } catch (error) {
    return null;
  }
}

Future<List<TblFolder>?> fetchUserFolders(String? docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    String apiCall = "";
    if (docId == null) {
      apiCall = 'ddl/getUserFoldersDLL';
    } else {
      apiCall = 'ddl/getUserFoldersDLL?docId=' + docId;
    }

    final response = await http.get(Uri.parse(baseUrl + apiCall), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      _list = data["result"];
        var _listData =_list.map<TblFolder>((json) => TblFolder.fromJson(json)).toList();
      _listData.sort((a, b) => a.name.compareTo(b.name));
      return _listData;
    } else {
      throw Exception('Failed to load doc type');
    }
  } catch (error) {
    return null;
  }
}
