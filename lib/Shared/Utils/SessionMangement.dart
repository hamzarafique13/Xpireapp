
// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SessionMangement {
 late SharedPreferences prefs;
  
  setEmail(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("email", text);
  }
  setPassword(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("password", text);
  } 
  setRememberMe(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setBool("rememberMe", text);
  }
  setProfilePic(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("profilePic", text);
  }
  setUserName(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("userName", text);
  }
  setToken(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", text);
  }
  setNoOfFolders(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("noOfFolders", text.toString());
  }
  setNoOfDocuments(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("noOfDocuments", text.toString());
  }
   setNewNotify(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setBool("newNotify", text);
  }
 setUserId(text) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.setString("userId", text.toString());
  }

 Future<bool?> getRememberMe() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    bool? returnText = obj.getBool("rememberMe");
    return returnText;
  }
 Future<String?> getEmail() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("email");
    return returnText;
  }
   Future<String?> getPassword() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("password");
    return returnText;
  }
 Future<String?> getProfilePic() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("profilePic");
    return returnText;
  }
 Future<String?> getUserName() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("userName");
    return returnText;
  }
 Future<String?> getToken() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
     String? returnText = obj.getString("token");
    return returnText;
  }
 Future<String?> getNoOfFolders() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("noOfFolders");
    return returnText;
  }
Future<String?> getNoOfDocuments() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("noOfDocuments");
    return returnText;
  }
  Future<bool?> getNewNotify() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    bool? returnText = obj.getBool("newNotify");
    return returnText;
  }
 Future<String?> getUserId() async {
    SharedPreferences obj = await SharedPreferences.getInstance();
    String? returnText = obj.getString("userId");
    return returnText;
  }
 
 
  removeRememberMe() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("rememberMe");
  }
  removePassword() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("password");
  }
  removeEmail() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("email");
  }
  removeProfilePic() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("profilePic");
  }
  removeUserName() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("userName");
  }
  removeToken() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }
removeNoOfFolders() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("noOfFolders");
  }
removeNoOfDocuments() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("noOfDocuments");
  }
  removeNewNotify() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("newNotify");
  }
removeUserId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.remove("UserId");
  }

}

