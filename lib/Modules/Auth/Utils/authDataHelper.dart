// ignore_for_file: import_of_legacy_library_into_null_safe,file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Auth/UI/login.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:http/http.dart' as http;
import 'package:Xpiree/Shared/Utils/encryption.dart';

Future<UserInfo?> login(String userNameController, String passwordController,
    bool rememberMe) async {
  try {
    SignIn modal = SignIn();
    modal.userName = userNameController;
    modal.password = EncryptionAndDecryption.encryptAES(passwordController);
    modal.rememberMe = rememberMe;
    modal.loginSource = 2;

    SessionMangement _sm = SessionMangement();

    final response = await http.post(
      Uri.parse(baseUrl + 'Account/signIn'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(modal),
    );
    print('response:${response.statusCode}');
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "-1") {
        UserInfo obj = UserInfo();
        obj.responseApi = "-1";
        return obj;
      }
      if (modal.rememberMe == true) {
        _sm.setPassword(passwordController);
        _sm.setRememberMe(modal.rememberMe);
      } else {
        _sm.removePassword();
        _sm.removeRememberMe();
      }
      Map userMap = jsonDecode(response.body);
      var _data = UserInfo.fromJson(userMap);

      _sm.setToken(_data.accessToken);
      _sm.setEmail(_data.email);
      _sm.setUserName(_data.userName);
      _sm.setProfilePic(_data.userPic);
      _sm.setNoOfFolders(_data.noOfFolders);
      _sm.setNoOfDocuments(_data.noOfDocuments);
      _sm.setUserId(_data.userId);
      return _data;
    } else if (response.statusCode == 401) {
      UserInfo obj = UserInfo();
      obj.responseApi = "-2";
      return obj;
    }
    return null;
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String> signUp(SignUp obj) async {
  try {
    final response = await http.post(Uri.parse(baseUrl + 'Account/signUp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(obj));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<UserInfo> externalLogin(ExternalAuthDto obj) async {
  SessionMangement _sm = SessionMangement();
  try {
    final response = await http.post(
        Uri.parse(baseUrl + 'Account/ExternalLogin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(obj));
    if (response.statusCode == 200) {
      Map userMap = jsonDecode(response.body);
      var _data = UserInfo.fromJson(userMap);

      _sm.setToken(_data.accessToken);
      _sm.setEmail(_data.email);
      _sm.setUserName(_data.userName);
      _sm.setProfilePic(_data.userPic);
      _sm.setNoOfFolders(_data.noOfFolders);
      _sm.setNoOfDocuments(_data.noOfDocuments);
      _sm.setUserId(_data.userId);
      return _data;
    } else {
      throw Exception('Failed');
    }
  } catch (error) {
    EasyLoading.dismiss();
    throw Exception('Failed');
  }
}

Future<String?> forgetPassword(String email) async {
  try {
    final response = await http
        .get(Uri.parse(baseUrl + 'Account/forgetPassword?email=' + email));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Something is Wrong');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<void> logout(BuildContext context) async {
  SessionMangement obj = SessionMangement();

  obj.removeToken();
  obj.removeUserName();
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false);
}

Future<String> verifyEmailAddress(String email, String verifyCode) async {
  try {
    final response = await http.get(
      Uri.parse(baseUrl +
          'Account/verifyEmailCode?email=' +
          email +
          '&verifyCode=' +
          verifyCode),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return "null";
  } catch (error) {
    throw Exception('Failed');
  }
}
/*
Future<String> getUserToken(String email, String password) async {
  try {
    SessionMangement obj = SessionMangement();
    obj.setEmail(EncryptionAndDecryption.encryptAES(email));
    obj.setPassword(EncryptionAndDecryption.encryptAES(password));

    String logindata =
        "grant_type=password&username=" + email + "&password=" + password;
    var response = await http.post(webUrl + 'token',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: logindata);
    if (response.statusCode == 200) {
      TokenData objToken = TokenData.fromJson(jsonDecode(response.body));

      final response2 = await http.get(baseUrl + 'm_GetUserID', headers: {
        'Authorization': 'Bearer ' + objToken.accessToken,
      });

      if (response2.statusCode == 200) {
        obj.setAlumniId(jsonDecode(response2.body).toString());
      } else {
        throw Exception('Failed to load Alumni Major Role');
      }

      return objToken.accessToken;
    } else {
      throw Exception('Failed to load school');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

Future<String> getRefreshUserToken() async {
  try {
    SessionMangement obj = SessionMangement();
    String encrptEmail = await obj.getEmail();
    String encrptPassword = await obj.getPassword();
    if (encrptEmail != null && encrptPassword != null) {
      String email = EncryptionAndDecryption.decryptAES(encrptEmail);
      String password = EncryptionAndDecryption.decryptAES(encrptPassword);

      String logindata =
          "grant_type=password&username=" + email + "&password=" + password;
      var response = await http.post(webUrl + 'token',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: logindata);
      if (response.statusCode == 200) {
        TokenData obj = TokenData.fromJson(jsonDecode(response.body));
        return obj.accessToken;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      return null;
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}
 */


/* Future<String> getLoginUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("Token");
} */

/* Future<String> getAlumniId() async {
  SessionMangement obj = SessionMangement();
  String alumniId = await obj.getAlumniId();
  return alumniId;
}



Future<String> addTearmCondition(bool term) async {
  try {
    String token = await getRefreshUserToken();

    final response = await http
        .get(baseUrl + "m_AddTerms?term=" + term.toString(), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    });
    String _list;
    if (response.statusCode == 200) {
      _list = response.body;
      return _list;
    } else {
      throw Exception('Failed to load school');
    }
  } catch (error) {
    EasyLoading.dismiss();
    return null;
  }
}

 */