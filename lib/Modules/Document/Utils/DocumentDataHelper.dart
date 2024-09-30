// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Document/Model/DocumentModel.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';

Future<String?> addDocument(
    TblDocument obj,
    List<TblDocSendOn> sendOnList,
    List<TblDocReminder> reminderList,
    List<XFile> imageList,
    List<PlatformFile> fileList,
    List<customReminderArray> custmReminderArry,
    bool isCustomReminderShow) async {
  SessionMangement _sm = SessionMangement();
  String? token = await _sm.getToken();

  if (isCustomReminderShow) {
    for (int i = 0; i < custmReminderArry.length; i++) {
      if ((custmReminderArry[i].customRemindValue == 2 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 4 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 8 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 24 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 1 &&
              custmReminderArry[i].customRemindPeriod == "Months") ||
          (custmReminderArry[i].customRemindValue == 2 &&
              custmReminderArry[i].customRemindPeriod == "Months") ||
          (custmReminderArry[i].customRemindValue == 6 &&
              custmReminderArry[i].customRemindPeriod == "Months")) {
      } else {
        TblDocReminder _modal = TblDocReminder();
        _modal.remindValue = 5;
        _modal.customRemindPeriod = custmReminderArry[i].customRemindPeriod;
        _modal.customRemindValue = custmReminderArry[i].customRemindValue;

        reminderList.add(_modal);
      }
    }
  }
  if (obj.validForPeriod == null) {
    obj.validFor = "0";
  }

  String sendOn = json.encode(sendOnList);
  String reminder = json.encode(reminderList);
  try {
    FormData formData = FormData();
    formData = FormData.fromMap({
      "DocName": obj.docName,
      "ValidFor": obj.validFor,
      "ValidForPeriod": obj.validForPeriod,
      "DocOwnerName": obj.docOwnerName,
      "DocNumber": obj.docNumber,
      "DocTypeId": obj.docTypeId,
      "ExpiryDate": obj.expiryDate,
      "IssueDate": obj.issueDate,
      "FolderId": obj.folderId,
      "CountryId": obj.countryId,
      "StateId": obj.stateId,
      "RemindMe": obj.remindMe,
      "sendOn": sendOn,
      "remindOn": reminder,
    });

    if (imageList.isNotEmpty) {
      for (int i = 0; i < imageList.length; i++) {
        formData.files.addAll([
          MapEntry("file", await MultipartFile.fromFile(imageList[i].path)),
        ]);
      }
    }
    if (fileList.isNotEmpty) {
      for (int i = 0; i < fileList.length; i++) {
        formData.files.addAll([
          MapEntry("file", await MultipartFile.fromFile(fileList[i].path!)),
        ]);
      }
    }
    Dio dio = Dio();
    dio.options.headers["Authorization"] = 'Bearer ' + token!;
    var response =
        await dio.post(baseUrl + "Client/addDocument", data: formData);

    if (response.statusCode == 200) {
      String data = response.data;
      return data;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String?> updateDocument(
    TblDocument obj,
    List<TblDocSendOn> sendOnList,
    List<TblDocReminder> reminderList,
    List<XFile> imageList,
    List<PlatformFile> fileList,
    List<customReminderArray> custmReminderArry,
    bool isCustomReminderShow) async {
  SessionMangement _sm = SessionMangement();
  String? token = await _sm.getToken();

  if (isCustomReminderShow) {
    for (int i = 0; i < custmReminderArry.length; i++) {
      if ((custmReminderArry[i].customRemindValue == 2 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 4 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 8 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 24 &&
              custmReminderArry[i].customRemindPeriod == "Weeks") ||
          (custmReminderArry[i].customRemindValue == 1 &&
              custmReminderArry[i].customRemindPeriod == "Months") ||
          (custmReminderArry[i].customRemindValue == 2 &&
              custmReminderArry[i].customRemindPeriod == "Months") ||
          (custmReminderArry[i].customRemindValue == 6 &&
              custmReminderArry[i].customRemindPeriod == "Months")) {
      } else {
        TblDocReminder _modal = TblDocReminder();
        _modal.remindValue = 5;
        _modal.customRemindPeriod = custmReminderArry[i].customRemindPeriod;
        _modal.customRemindValue = custmReminderArry[i].customRemindValue;

        reminderList.add(_modal);
      }
    }
  }

  String sendOn = json.encode(sendOnList);
  String reminder = json.encode(reminderList);
  try {
    FormData formData = FormData();
    formData = FormData.fromMap({
      "Id": obj.id,
      "DocName": obj.docName,
      "ValidFor": obj.validFor,
      "ValidForPeriod": obj.validForPeriod,
      "DocOwnerName": obj.docOwnerName,
      "DocNumber": obj.docNumber,
      "DocTypeId": obj.docTypeId,
      "ExpiryDate": obj.expiryDate,
      "IssueDate": obj.issueDate,
      "FolderId": obj.folderId,
      "CountryId": obj.countryId,
      "StateId": obj.stateId,
      "RemindMe": obj.remindMe,
      "sendOn": sendOn,
      "remindOn": reminder,
    });

    if (imageList.isNotEmpty) {
      for (int i = 0; i < imageList.length; i++) {
        formData.files.addAll([
          MapEntry("file", await MultipartFile.fromFile(imageList[i].path)),
        ]);
      }
    }
    if (fileList.isNotEmpty) {
      for (int i = 0; i < fileList.length; i++) {
        formData.files.addAll([
          MapEntry("file", await MultipartFile.fromFile(fileList[i].path!)),
        ]);
      }
    }
    Dio dio = Dio();
    dio.options.headers["Authorization"] = 'Bearer ' + token!;
    var response =
        await dio.post(baseUrl + "Client/updateDocument", data: formData);

    if (response.statusCode == 200) {
      String data = response.data;
      return data;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String?> saveNote(String notes, String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/SaveNote?docId=' + docId + '&notes=' + notes),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<List<Document>?> getSavedDocumentDataTable(int orderby) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl +
            'Client/GetSavedDocumentDataTable?orderby=' +
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
        return _list.map<Document>((json) => Document.fromJson(json)).toList();
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

Future<DocumentVM?> getBookedMarkActiveDocList() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetBookedMarkActiveDocList'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getBookedMarkExpiringDocList() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetBookedMarkExpiringDocList'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<DocumentVM?> getBookedMarkExpiredDocList() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetBookedMarkExpiredDocList'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        var _data = DocumentVM.fromJson(data["result"]);
        return _data;
      }
      return null;
    } else {
      throw Exception('Failed to load');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<List<Document>?> getDocumentByFolderId(String folderId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(
            baseUrl + 'Client/GetDocumentByFolderId?folderId=' + folderId),
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

Future<DocumentDetail?> getDocumentById(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetDocumentById?DocId=' + docId),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        if (data["result"] == null) {
          return null;
        }
        return DocumentDetail.fromJson(data["result"]);
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

Future<List<DocShareringVm>?> getDocSharingDataTable(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetDocSharingDataTable?DocId=' + docId),
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
        return _list
            .map<DocShareringVm>((json) => DocShareringVm.fromJson(json))
            .toList();
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

Future<String?> deleteDocSharing(String id) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/deleteDocSharing?id=' + id),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> deleteAttachment(String id) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/deleteAttachment?attachmentId=' + id),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> deleteDocument(String id) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/deleteDocument?docId=' + id),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["response"];
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> updateUserDocStatus(String id, int docStatus) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl +
          'Client/updateUserDocStatus?docId=' +
          id +
          '&docStatus=' +
          docStatus.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> addDocType(TblDocType modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addDocType'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> addDocSharing(AddDocSharing modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addDocSharing'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> updateDocSharing(UpdateDocSharing modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/updateDocSharing'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> addTask(TblTask modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addTask'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> updateTask(UpdateTblTask modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/updateTask'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> deleteTask(String taskId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/deleteTask?taskId=' + taskId),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return data["result"];
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> updateTaskIscompleted(String taskId, bool isCompleted) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    if (isCompleted) {
      final response = await http.get(
        Uri.parse(baseUrl +
            'Client/updateTaskIscompleted?taskId=' +
            taskId +
            '&isCompleted=' +
            isCompleted.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        },
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        return data["response"];
      }
    }

    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

/* Future<List<TaskVm>?> getTaskDataTable(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetAssignToMeTaskByDocId?DocId=' + docId),
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
        return _list.map<TaskVm>((json) => TaskVm.fromJson(json)).toList();
      }
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    // EasyLoading.dismiss();
    return null;
  }
} */

Future<List<TaskVm>?> getAssignToMeTaskByDocId(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/GetAssignToMeTaskByDocId?DocId=' + docId),
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
        return _list.map<TaskVm>((json) => TaskVm.fromJson(json)).toList();
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

Future<List<TaskVm>?> getAssignToOthersTaskByDocId(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(
            baseUrl + 'Client/GetAssignToOthersTaskByDocId?DocId=' + docId),
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
        return _list.map<TaskVm>((json) => TaskVm.fromJson(json)).toList();
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

Future<List<TaskVm>?> getCompletedTaskByDocId(String docId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/getCompletedTaskByDocId?DocId=' + docId),
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
        return _list.map<TaskVm>((json) => TaskVm.fromJson(json)).toList();
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

Future<CheckPushNotificationVm?> checkPushNotificationEnable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/CheckPushNotificationEnable'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        return CheckPushNotificationVm.fromJson(data);
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

Future<List<Document>?> getFilterDocuments(
    FilterDocVm modal, List<String> strFolder, List<String> strDocType) async {
  modal.docFolderList = strFolder;
  modal.docTypeList = strDocType;
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/GetFilterDocuments'),
      body: json.encode(modal),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );

    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        if (data["result"] != null) {
          _list = data["result"];
          return _list
              .map<Document>((json) => Document.fromJson(json))
              .toList();
        }
      }
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<TblPackage> getUserPackage() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/GetUserPackage'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );

    if (response.statusCode == 200) {
      var _data = TblPackage.fromJson(jsonDecode(response.body));
      return _data;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}
