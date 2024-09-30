// ignore_for_file: file_names

class Document {
  String id;
  String docName;
  String expiryDate;
  int status;
  bool isbookmark;
  String createdOn;
  String createdBy;
  int diffTotalDays;
  int sharerCount;
  int attachmentCount;
  bool remindMe;
  String docSharingUserId;
  bool docSharingEditAccess;
  int docUserStatusId;
  bool isDocCreated;
  List<UserSharerVm>? sharerList;
  UserSharerVm? sharerByList;

  Document(
    this.id,
    this.docName,
    this.expiryDate,
    this.status,
    this.isbookmark,
    this.createdOn,
    this.createdBy,
    this.diffTotalDays,
    this.sharerCount,
    this.attachmentCount,
    this.remindMe,
    this.docSharingUserId,
    this.docSharingEditAccess,
    this.docUserStatusId,
    this.isDocCreated,
    this.sharerList,
    this.sharerByList,
  );

  factory Document.fromJson(dynamic json) {
    var item1 = json['sharerList'];
    var item2 = json['sharerByList'];
    List<UserSharerVm>? _item1;
    if (item1 != null) {
      var item2 = json['sharerList'] as List;
      _item1 =
          item2.map((dataJson) => UserSharerVm.fromJson(dataJson)).toList();
    }
    UserSharerVm? _item2;
    if (item2 != null) {
      var item2 = json['sharerByList'];
      _item2 = UserSharerVm.fromJson(item2);
    }

    return Document(
      json['Id'] ?? "",
      json['DocName'] ?? "",
      json['ExpiryDate'] ?? "",
      json['Status'] ?? 0,
      json['Isbookmark'] ?? false,
      json['CreatedOn'] ?? "",
      json['CreatedBy'] ?? "",
      json['DiffTotalDays'] ?? 0,
      json['sharerCount'] ?? 0,
      json['attachmentCount'] ?? 0,
      json['remindMe'] ?? false,
      json['DocSharingUserId'] ?? "",
      json['DocSharingEditAccess'] ?? false,
      json['DocUserStatusId'] ?? 1,
      json['isDocCreated'] ?? false,
      _item1,
      _item2,
    );
  }
}

class DocumentVM {
  List<Document>? item1;
  int item2;

  DocumentVM(this.item1, this.item2);

  factory DocumentVM.fromJson(dynamic json) {
    var item1 = json['Item1'] as List;
    List<Document> _item1 =
        item1.map((dataJson) => Document.fromJson(dataJson)).toList();

    return DocumentVM(
      _item1,
      json['Item2'] ?? 0,
    );
  }
}

class TblPackage {
  int id;
  String title;
  int preference;
  int price;
  int noOfDocument;
  int attachPerDoc;
  int perAttachSize;
  int totalStorage;
  int noOfDocShare;
  int docShareWithShare;
  int noOfFolderAllow;
  int noOfSharerAllow;
  bool ads;
  bool support;
  bool allowToShareTask;
  int noOfTaskPerDoc;
  bool isUnlimitedDocument;
  bool isUnlimitedFolder;
  bool isUnlimitedSharers;
  bool isActive;

  TblPackage({
    this.id = 0,
    this.title = "",
    this.preference = 0,
    this.price = 0,
    this.noOfDocument = 0,
    this.attachPerDoc = 0,
    this.perAttachSize = 0,
    this.totalStorage = 0,
    this.noOfDocShare = 0,
    this.docShareWithShare = 0,
    this.noOfFolderAllow = 0,
    this.noOfSharerAllow = 0,
    this.ads = false,
    this.support = false,
    this.allowToShareTask = false,
    this.noOfTaskPerDoc = 0,
    this.isUnlimitedDocument = false,
    this.isUnlimitedFolder = false,
    this.isUnlimitedSharers = false,
    this.isActive = false,
  });


    factory TblPackage.fromJson(Map<String, dynamic> json) {
    return TblPackage(
      id: json['Id'] ?? 0,
      title: json['Title'] ?? '',
      preference: json['Preference'] ?? 0,
      price: json['Price'] ?? 0,
      noOfDocument: json['NoOfDocument'] ?? 0,
      attachPerDoc: json['AttachPerDoc'] ?? 0,
      perAttachSize: json['PerAttachSize'] ?? 0,
      totalStorage: json['TotalStorage'] ?? 0,
      noOfDocShare: json['NoOfDocShare'] ?? 0,
      docShareWithShare: json['DocShareWithShare'] ?? 0,
      noOfFolderAllow: json['NoOfFolderAllow'] ?? 0,
      noOfSharerAllow: json['NoOfSharerAllow'] ?? 0,
      ads: json['Ads'] ?? false,
      support: json['Support'] ?? false,
      allowToShareTask: json['AllowToShareTask'] ?? false,
      noOfTaskPerDoc: json['NoOfTaskPerDoc'] ?? 0,
      isUnlimitedDocument: json['IsUnlimitedDocument'] ?? false,
      isUnlimitedFolder: json['IsUnlimitedFolder'] ?? false,
      isUnlimitedSharers: json['IsUnlimitedSharers'] ?? false,
      isActive: json['IsActive'] ?? false,
    );
  }
 
}

class DashboardCountVm {
  int activeDoc;
  int expiringDoc;
  int expiredDoc;
  int taskCount;
  int sharerCount;
  int reminderOffCount;
  bool isVisited;

  DashboardCountVm({
    this.activeDoc = 0,
    this.expiringDoc = 0,
    this.expiredDoc = 0,
    this.taskCount = 0,
    this.sharerCount = 0,
    this.reminderOffCount = 0,
    this.isVisited = false,
  });

  factory DashboardCountVm.fromJson(dynamic json) {
    return DashboardCountVm(
        activeDoc: json['ActiveDoc'],
        expiringDoc: json['ExpiringDoc'],
        expiredDoc: json['ExpiredDoc'],
        taskCount: json['TaskCount'],
        sharerCount: json['SharerCount'],
        reminderOffCount: json['ReminderOffCount'],
        isVisited: json['IsVisited']);
  }
}

class NotificationVm {
  String id;
  String toUserId;
  String toUserName;
  String message;
  String fromUserId;
  String fromUserName;
  String createdOn;
  bool isRead;
  bool isTaskRelated;
  bool? isSharerRequest;
  String docId;

  NotificationVm({
    this.id = "",
    this.toUserId = "",
    this.toUserName = "",
    this.message = "",
    this.fromUserId = "",
    this.fromUserName = "",
    this.createdOn = "",
    this.isRead = false,
    this.isTaskRelated = false,
    this.isSharerRequest = false,
    this.docId = "",
  });

  factory NotificationVm.fromJson(dynamic json) {
    return NotificationVm(
      id: json['Id'],
      toUserId: json['ToUserId'],
      toUserName: json['ToUserName'],
      message: json['Message'],
      fromUserId: json['FromUserId'],
      fromUserName: json['FromUserName'],
      createdOn: json['CreatedOn'],
      isRead: json['IsRead'],
      isTaskRelated: json['IsTaskRelated'],
      isSharerRequest: json['IsSharerRequest'],
      docId: json['DocId'] ?? "",
    );
  }
}

class UserSharerVm {
  String docId;
  String name;
  String? profilePic;

  UserSharerVm({
    this.docId = "",
    this.name = "",
    this.profilePic = "",
  });

  factory UserSharerVm.fromJson(dynamic json) {
    return UserSharerVm(
      docId: json['DocId'],
      name: json['Name'],
      profilePic: json['ProfilePic'],
    );
  }
}
