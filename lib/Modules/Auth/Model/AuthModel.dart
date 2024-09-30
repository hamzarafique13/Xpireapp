// ignore_for_file: file_names

class SignUp {
  String name;
  String email;
  String password;

  SignUp({
    this.name = "",
    this.email = "",
    this.password = "",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Name': name.toString(),
      'Email': email.toString(),
      'Password': password.toString(),
    };
    return map;
  }
}

class ExternalAuthDto {
  String provider;
  String id;
  String name;
  String email;

  ExternalAuthDto({
    this.provider = "",
    this.id = "",
    this.name = "",
    this.email = "",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Provider': provider.toString(),
      'Id': id.toString(),
      'Name': name.toString(),
      'Email': email.toString(),
    };
    return map;
  }
}

class SignIn {
  String userName;
  String password;
  bool rememberMe;
  int loginSource;

  SignIn(
      {this.userName = "",
      this.password = "",
      this.rememberMe = false,
      this.loginSource = 2});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'UserName': userName.toString(),
      'Password': password.toString(),
      'RememberMe': rememberMe.toString(),
      'LoginSource': loginSource.toString(),
    };
    return map;
  }
}

class UserInfo {
  String accessToken;
  String userName;
  String userPic;
  String email;
  bool confirmedEmail;
  int noOfFolders;
  int noOfDocuments;
  String responseApi;
  String userId;

  UserInfo({
    this.accessToken = "",
    this.userName = "",
    this.userPic = "",
    this.email = "",
    this.confirmedEmail = false,
    this.noOfFolders = 0,
    this.noOfDocuments = 0,
    this.responseApi = "",
    this.userId = "",
  });

  factory UserInfo.fromJson(Map<dynamic, dynamic> json) {
    return UserInfo(
      accessToken: json['accessToken'] ?? "",
      userName: json['userName'] ?? "",
      userPic: json['userPic'] ?? "",
      email: json['email'] ?? "",
      confirmedEmail: json['confirmedEmail'] ?? false,
      noOfFolders: json['noOfFolders'] ?? 0,
      noOfDocuments: json['noOfDocuments'] ?? 0,
      userId: json['userId'] ?? "",
    );
  }
}
