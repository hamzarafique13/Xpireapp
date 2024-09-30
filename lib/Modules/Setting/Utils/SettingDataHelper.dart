// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

Future<String> addFeedBack(FeedBackVm modal) async {
  modal.userId = "";
  modal.isMarked = false;
  modal.isRead = false;
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addFeedBack'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
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

Future<String?> addSharer(String email, String name) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addSharer?email=' + email + '&name=' + name),
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

Future<String?> editSharer(EditUserSharer modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/updateSharer'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> deleteSharer(String id, bool isInvitedEmail) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    if (isInvitedEmail == false) {
      final response = await http.get(
        Uri.parse(baseUrl + 'Client/deleteSharer?id=' + id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } 
    else {
       final response2 = await http.get(
      Uri.parse(baseUrl + 'Client/deleteInvitation?id=' + id),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response2.statusCode == 200) {
      return jsonDecode(response2.body);
    }

    }

   

    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<UserInfo?> findSharerByEmail(String email) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Client/findSharerByEmail?email=' + email),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      return UserInfo.fromJson(data);
    }
    return null;
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<SharerListVM?> getSharerDataTable(String usernameSearch) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
        Uri.parse(
            baseUrl + 'Client/getSharerDataTable?username=' + usernameSearch),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        return SharerListVM.fromJson(data["result"]);
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

Future<NotificationSettingVM?> getNotifySettingDataTable() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http
        .get(Uri.parse(baseUrl + 'Client/getNotifySettingDataTable'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });

    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        return NotificationSettingVM.fromJson(data);
      }
      return null;
    }
    return null;
  } catch (error) {
    // EasyLoading.dismiss();
    return null;
  }
}

Future<void> addNotificationSetting(NotificationSettingVM modal) async {
  modal.userId = "";
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Client/addNotificationSetting'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      getNotifySettingDataTable();
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String?> editPhoneNumber(String phoneCode, String phoneNumber) async {
  try {
    String phoneNo = phoneCode + phoneNumber;
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Account/SendSMS?phoneNo' + phoneNo),
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

Future<String> verifyPhoneNumber(String verifyCode) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + 'Account/VerifyPhoneNumber?verifyCode' + verifyCode),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed');
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<String> setExpiringCriteria(int defaultCreteria) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.get(
      Uri.parse(baseUrl +
          'Account/setExpiringCriteria?expiryCriteria=' +
          defaultCreteria.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed');
  } catch (error) {
    throw Exception('Failed');
  }
}

Future<UserInfo?> getUserInfo() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response =
        await http.get(Uri.parse(baseUrl + 'Account/getUserInfo'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });

    if (response.statusCode == 200) {
      if (response.body != "null") {
        Map data = jsonDecode(response.body);
        return UserInfo.fromJson(data);
      }
      return null;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<List<TblNotificationEnable>?> getUserNotifySettingDDL() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http
        .get(Uri.parse(baseUrl + 'DDL/getUserNotifySettingDDL'), headers: {
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
            .map<TblNotificationEnable>(
                (json) => TblNotificationEnable.fromJson(json))
            .toList();
      }
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<List<TblPackage>?> getPackageList() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response =
        await http.get(Uri.parse(baseUrl + 'DDL/GetPackageList'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token!,
    });
    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        _list = jsonDecode(response.body);
        return _list
            .map<TblPackage>((json) => TblPackage.fromJson(json))
            .toList();
      }
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String> upgradeUserPackage(int packageId) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.get(
      Uri.parse(baseUrl +
          'Client/UpgradeUserPackage?packageId=' +
          packageId.toString()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
    );

    if (response.statusCode == 200) {
      if (response.body != "null") {
        return jsonDecode(response.body);
      }
    }
    return "-1";
  } catch (error) {
    EasyLoading.dismiss();
    return "-1";
  }
}

Future<List<PushNotificationVm>?> getPushNotifyList() async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    String? userId = await _sm.getUserId();

    final response = await http.get(
        Uri.parse(baseUrl + 'Client/getPushNotificationList?userId=' + userId!),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });
    List _list;
    if (response.statusCode == 200) {
      if (response.body != "null") {
        _list = jsonDecode(response.body);
        return _list
            .map<PushNotificationVm>(
                (json) => PushNotificationVm.fromJson(json))
            .toList();
      }
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String?> turnAllOFFnotify(int sourceCatgry) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.post(
        Uri.parse(baseUrl +
            'Client/turnAllOFFnotify?SourceCatgry=' +
            sourceCatgry.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token!,
        });

    if (response.statusCode == 200) {
      if (response.body != "null") {
        return jsonDecode(response.body);
      }
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    return "-1";
  }
}

Future<String> updateNotifySetting(List<TblNotificationEnable> dataList) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();

    final response = await http.post(
      Uri.parse(baseUrl + 'Client/updateNotifySetting'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(dataList),
    );

    if (response.statusCode == 200) {
      if (response.body != "null") {
        return jsonDecode(response.body);
      }
    }
    return "-1";
  } catch (error) {
    EasyLoading.dismiss();
    return "-1";
  }
}

Future<String?> editProfile(UserInfo obj) async {
  SessionMangement _sm = SessionMangement();
  String? token = await _sm.getToken();
  try {
    FormData formData = FormData();
    if (obj.uploadPic != null) {
      formData = FormData.fromMap({
        "Name": obj.name,
        /* "DOB": obj.dob,
        "Gender": obj.gender,
        "Address": obj.address, */
        "CountryId": obj.countryId,
        "CountryCode": obj.countryCode,
        "PhoneNumber": obj.phoneNumber,
        "file": await MultipartFile.fromFile(obj.uploadPic!.path)
      });
    } else {
      formData = FormData.fromMap({
        "Name": obj.name,
        /*  "DOB": obj.dob,
        "Gender": obj.gender,
        "Address": obj.address, */
        "CountryId": obj.countryId,
        "CountryCode": obj.countryCode,
        "PhoneNumber": obj.phoneNumber,
      });
    }

    Dio dio = Dio();
    dio.options.headers["Authorization"] = 'Bearer ' + token!;
    var response =
        await dio.post(baseUrl + "Account/EditProfile", data: formData);

    String _data;
    if (response.statusCode == 200) {
      _data = response.data;
      return _data;
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String?> addStripeCustomerData(AddStripeCustomer modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Stripe/AddStripeCustomer'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      Map _map = jsonDecode(response.body);
      var _modal = StripeResponse.fromJson(_map);

      return _modal.customerId;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> addStripePayment(AddStripePayment modal) async {
  try {
    SessionMangement _sm = SessionMangement();
    String? token = await _sm.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + 'Stripe/AddStripePayment'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token!,
      },
      body: json.encode(modal),
    );
    if (response.statusCode == 200) {
      Map _map = jsonDecode(response.body);
      var _modal = StripePaymentResponse.fromJson(_map);
      return _modal.paymentId;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}
