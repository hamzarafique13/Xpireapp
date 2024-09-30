class TblCountry {
  String name;

  TblCountry({
    this.name = "",
  });

  factory TblCountry.fromJson(dynamic json) {
    return TblCountry( name: json);
  }

  void compareTo(TblCountry b) {}
}

class TblState {
  String name;

  TblState({
    this.name = "",
  });

  factory TblState.fromJson(dynamic json) {
    return TblState(name: json);
  }
}

class TblAccessType {
  String id;
  String title;
  bool isActive;
  String createdOn;

  TblAccessType({
    this.id = "",
    this.title = "",
    this.isActive = false,
    this.createdOn = "",
  });

  factory TblAccessType.fromJson(Map<String, dynamic> json) {
    return TblAccessType(
      id: json['Id'],
      title: json['Title'],
      isActive: json['IsActive'],
      createdOn: json['CreatedOn'],
    );
  }
}

class TblDocType {
  String id;
  String title;
  bool isChecked;

  TblDocType({
    this.id = "",
    this.title = "",
    this.isChecked = false,
  });

  factory TblDocType.fromJson(Map<String, dynamic> json) {
    return TblDocType(
      id: json['Id'],
      title: json['Title'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Title': title,
    };
    return map;
  }
}

class UserSharerVm {
  String id;
  String userId;
  String name;
  String email;
  String profilePic;
  String accessTypeId;
  String accessTypeTitle;
  String createdOn;
  String docId;

  UserSharerVm({
    this.id = "",
    this.userId = "",
    this.name = "",
    this.email = "",
    this.profilePic = "",
    this.accessTypeId = "",
    this.accessTypeTitle = "",
    this.createdOn = "",
    this.docId = "",
  });

  factory UserSharerVm.fromJson(Map<String, dynamic> json) {
    return UserSharerVm(
      id: json['Id'] ?? "",
      userId: json['UserId'] ?? "",
      name: json['Name'] ?? "",
      email: json['Email'] ?? "",
      profilePic: json['ProfilePic'] ?? "",
      accessTypeId: json['AccessTypeId'] ?? "",
      accessTypeTitle: json['AccessTypeTitle'] ?? "",
      createdOn: json['CreatedOn'] ?? "",
      docId: json['DocId'] ?? "",
    );
  }
}

class TblNotifyChild {
  String id;
  String title;
  String parentId;
  int preference;
  int value;
  bool selected;

  TblNotifyChild({
    this.id = "",
    this.title = "",
    this.parentId = "",
    this.preference = 0,
    this.value = 0,
    this.selected = false,
  });

  factory TblNotifyChild.fromJson(Map<String, dynamic> json) {
    return TblNotifyChild(
      id: json['Id'] ?? "",
      title: json['Title'] ?? "",
      parentId: json['ParentId'] ?? "",
      preference: json['Preference'] ?? 0,
      value: json['Value'] ?? 0,
      selected: json['Selected'] ?? false,
    );
  }
}

class TblNotificationType {
  String id;
  String title;
  String parentId;
  int preference;
  int value;
  List<TblNotifyChild> childList;

  TblNotificationType(
    this.id,
    this.title,
    this.parentId,
    this.preference,
    this.value,
    this.childList,
  );

  factory TblNotificationType.fromJson(dynamic json) {
    var childList = json['childList'] as List;
    List<TblNotifyChild> _childList =
        childList.map((dataJson) => TblNotifyChild.fromJson(dataJson)).toList();

    return TblNotificationType(
      json['Id'] ?? "",
      json['Title'] ?? "",
      json['ParentId'] ?? "",
      json['Preference'] ?? 0,
      json['Value'] ?? 0,
      _childList,
    );
  }
}

class SliderList {
  String image;
  String textStr;

  SliderList({this.image = "", this.textStr = ""});

  static List<SliderList> getList() {
    return <SliderList>[
      SliderList(
        image: "",
        textStr:
            "It’s great to have you with us!\n To help us optimize your experience \n tell us how you plan to use Xpiree.",
      ),
      SliderList(
        image: "assets/Slider/2.png",
        textStr: "Use Xpiree to keep track of \n your critical paper-work.",
      ),
      SliderList(
        image: "assets/Slider/3.png",
        textStr: "Get timely reminders regarding \n expiration dates.",
      ),
      SliderList(
        image: "assets/Slider/6.jpeg",
        textStr: "Stay organized,\n stay connected.",
      ),
      SliderList(
        image: "assets/Slider/4.png",
        textStr: "Share and assign tasks to peer \n with a single tap.",
      ),
    ];
  }
}

class PushNotificationVm {
  String userName;
  String userPicUrl;
  String title;
  String description;

  PushNotificationVm(
      this.userName, this.userPicUrl, this.title, this.description);

  factory PushNotificationVm.fromJson(dynamic json) {
    return PushNotificationVm(
      json['userName'] ?? "",
      json['userPicUrl'] ?? "",
      json['Title'] ?? "",
      json['Description'] ?? "",
    );
  }
}
