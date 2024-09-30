// ignore_for_file: file_names

import 'package:image_picker/image_picker.dart';

class DocumentDetail {
  String id;
  String docName;
  String expiryDate;
  String issueDate;
  String docTypeId;
  String docTypeTitle;
  String folderId;
  String folderName;
  String docNumber;
  String countryId;
  String countryName;
  String stateId;
  String stateName;
  bool remindMe;
  String notes;
  bool isbookmark;
  String createdOn;
  String createdBy;
  int status;
  String sharedOn;
  String sharedBy;
  int diffTotalDays;
  String userId;
  String accessTypeId;
  String accessTypeTitle;
  int docUserStatusId;
  bool docSharingEditAccess;
  bool isDocCreated;
  List<TblDocReminder>? reminderList;
  List<TblDocAttachment>? attachmentList;

  DocumentDetail(
      {this.id = "",
      this.docName = "",
      this.expiryDate = "",
      this.issueDate = "",
      this.docTypeId = "",
      this.docTypeTitle = "",
      this.folderId = "",
      this.folderName = "",
      this.docNumber = "",
      this.countryId = "",
      this.countryName = "",
      this.stateId = "",
      this.stateName = "",
      this.remindMe = false,
      this.notes = "",
      this.isbookmark = false,
      this.createdOn = "",
      this.createdBy = "",
      this.status = 0,
      this.sharedOn = "",
      this.sharedBy = "",
      this.diffTotalDays = 0,
      this.userId = "",
      this.accessTypeId = "",
      this.accessTypeTitle = "",
      this.docUserStatusId = 1,
      this.docSharingEditAccess = false,
      this.isDocCreated = false,
      this.reminderList,
      this.attachmentList});

  factory DocumentDetail.fromJson(dynamic json) {
    var reminderObjsJson = json['reminderList'] as List;
    List<TblDocReminder> _reminderList =
        reminderObjsJson.map((json) => TblDocReminder.fromJson(json)).toList();
    var attachmentListJson = json['attachmentList'] as List;
    List<TblDocAttachment> _attachmentList = attachmentListJson
        .map((json) => TblDocAttachment.fromJson(json))
        .toList();

    return DocumentDetail(
      id: json['Id'] ?? "",
      docName: json['DocName'] ?? "",
      expiryDate: json['ExpiryDate'] ?? "",
      issueDate: json['IssueDate'] ?? "",
      docTypeId: json['DocTypeId'] ?? "",
      docTypeTitle: json['DocTypeTitle'] ?? "",
      folderId: json['FolderId'] ?? "",
      folderName: json['FolderName'] ?? "",
      docNumber: json['DocNumber'] ?? "",
      countryId: json['CountryId'] ?? "",
      countryName: json['CountryName'] ?? "",
      stateId: json['StateId'] ?? "",
      stateName: json['StateName'] ?? "",
      remindMe: json['RemindMe'] ?? false,
      notes: json['Notes'] ?? "",
      isbookmark: json['Isbookmark'] ?? false,
      createdOn: json['CreatedOn'] ?? "",
      createdBy: json['CreatedBy'] ?? "",
      status: json['Status'] ?? 0,
      sharedOn: json['SharedOn'] ?? "",
      sharedBy: json['SharedBy'] ?? "",
      diffTotalDays: json['DiffTotalDays'] ?? 0,
      userId: json['UserId'] ?? "",
      accessTypeId: json['AccessTypeId'] ?? "",
      accessTypeTitle: json['AccessTypeTitle'] ?? "",
      docUserStatusId: json['DocUserStatusId'] ?? 1,
      docSharingEditAccess: json['DocSharingEditAccess'] ?? false,
      isDocCreated: json['isDocCreated'] ?? false,
      reminderList: _reminderList,
      attachmentList: _attachmentList,
    );
  }
}

class CheckPushNotificationVm {
  bool shared;
  bool statusChange;
  bool moveFodler;
  bool delete;
  bool completeTask;

  CheckPushNotificationVm({
    this.shared = false,
    this.statusChange = false,
    this.moveFodler = false,
    this.delete = false,
    this.completeTask = false,
  });

  factory CheckPushNotificationVm.fromJson(dynamic json) {
    return CheckPushNotificationVm(
      shared: json['shared'] ?? false,
      statusChange: json['statusChange'] ?? false,
      moveFodler: json['moveFodler'] ?? false,
      delete: json['delete'] ?? false,
      completeTask: json['completeTask'] ?? false,
    );
  }
}

class TblDocAttachment {
  String id;
  String attachmentUrl;
  String docId;
  String fileName;
  int size;
  String fileExtention;

  TblDocAttachment(
      {this.id = "",
      this.attachmentUrl = "",
      this.docId = "",
      this.fileName = "",
      this.size = 0,
      this.fileExtention = ""});

  factory TblDocAttachment.fromJson(dynamic json) {
    return TblDocAttachment(
      id: json['Id'],
      attachmentUrl: json['AttachmentUrl'],
      docId: json['DocId'],
      fileName: json['FileName'],
      size: json['Size'],
      fileExtention: json['FileExtention'],
    );
  }
}

class TblDocument {
  String id;
  String docName;
  String expiryDate;
  String? issueDate;
  String? validFor;
  String docTypeId;
  String folderId;
  String? docOwnerName;
  String? docNumber;
  String? countryId;
  String? stateId;
  bool remindMe;
  String? validForPeriod;
  List<TblDocSendOn>? sendOn;
  List<TblDocReminder>? remindOn;
  XFile? image;

  TblDocument({
    this.id = "",
    this.docName = "",
    this.expiryDate = "",
    this.issueDate,
    this.validFor,
    this.docTypeId = "",
    this.folderId = "",
    this.docOwnerName,
    this.docNumber,
    this.countryId,
    this.stateId,
    this.remindMe = false,
    this.validForPeriod,
    this.sendOn,
    this.remindOn,
    this.image,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'DocName': docName,
      'ValidFor': validFor,
      'ValidForPeriod': validForPeriod,
      'DocOwnerName': docOwnerName,
      'DocNumber': docNumber,
      'DocTypeId': docTypeId,
      'ExpiryDate': expiryDate,
      'IssueDate': issueDate,
      'FolderId': folderId,
      'CountryId': countryId,
      'StateId': stateId,
      'RemindMe': remindMe,
      'sendOn': sendOn,
      'remindOn': remindOn
    };
    return map;
  }
}

class TblDocSendOn {
  int sendOn;

  TblDocSendOn({
    this.sendOn = 0,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'SendOn': sendOn,
    };
    return map;
  }

  factory TblDocSendOn.fromJson(dynamic json) {
    return TblDocSendOn(
      sendOn: json['SendOn'],
    );
  }
}

class TblDocReminder {
  int remindValue;
  String customRemindPeriod;
  int customRemindValue;

  TblDocReminder({
    this.remindValue = 0,
    this.customRemindPeriod = "",
    this.customRemindValue = 0,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'RemindValue': remindValue,
      'CustomRemindPeriod': customRemindPeriod,
      'CustomRemindValue': customRemindValue,
    };
    return map;
  }

  factory TblDocReminder.fromJson(dynamic json) {
    return TblDocReminder(
      remindValue: json['RemindValue'] ?? 0,
      customRemindPeriod: json['CustomRemindPeriod'] ?? "",
      customRemindValue: json['CustomRemindValue'] ?? 0,
    );
  }
}

class DocShareringVm {
  String id;
  String docId;
  String docName;
  String userId;
  String userName;
  String accessTypeId;
  String accessTitle;
  String userEmail;
  String createdOn;
  String profilePic;

  DocShareringVm(
    this.id,
    this.docId,
    this.docName,
    this.userId,
    this.userName,
    this.accessTypeId,
    this.accessTitle,
    this.userEmail,
    this.createdOn,
    this.profilePic,
  );
  factory DocShareringVm.fromJson(dynamic json) {
    return DocShareringVm(
      json['Id'] ?? "",
      json['DocId'] ?? "",
      json['DocName'] ?? "",
      json['UserId'] ?? 0,
      json['UserName'] ?? false,
      json['AccessTypeId'] ?? "",
      json['AccessTitle'] ?? "",
      json['userEmail'] ?? "",
      json['CreatedOn'] ?? "",
      json['ProfilePic'] ?? "",
    );
  }
}

class UpdateDocSharing {
  String id;
  String docId;
  String userId;
  String accessTypeId;

  UpdateDocSharing({
    this.id = "",
    this.docId = "",
    this.userId = "",
    this.accessTypeId = "",
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Id': id,
      'DocId': docId,
      'UserId': userId,
      'AccessTypeId': accessTypeId,
    };
    return map;
  }
}

class AddDocSharing {
  String docId;
  String userId;
  String accessTypeId;

  AddDocSharing({
    this.docId = "",
    this.userId = "",
    this.accessTypeId = "",
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'DocId': docId,
      'UserId': userId,
      'AccessTypeId': accessTypeId,
    };
    return map;
  }
}

class UpdateTblTask {
  String id;
  String taskName;
  String? assignTo;
  String dueDate;
  String description;
  String docId;
  bool isCompleted;

  UpdateTblTask({
    this.id = "",
    this.taskName = "",
    this.assignTo,
    this.dueDate = "",
    this.description = "",
    this.docId = "",
    this.isCompleted = false,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Id': id,
      'TaskName': taskName,
      'AssignTo': assignTo,
      'DueDate': dueDate,
      'Description': description,
      'DocId': docId,
      'isCompleted': isCompleted,
    };
    return map;
  }
}

class TblTask {
  String taskName;
  String? assignTo;
  String dueDate;
  String description;
  String docId;
  bool isCompleted;

  TblTask({
    this.taskName = "",
    this.assignTo,
    this.dueDate = "",
    this.description = "",
    this.docId = "",
    this.isCompleted = false,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'TaskName': taskName,
      'AssignTo': assignTo,
      'DueDate': dueDate,
      'Description': description,
      'DocId': docId,
      'isCompleted': isCompleted,
    };
    return map;
  }
}

class TaskVm {
  String id;
  String taskName;
  String assignTo;
  String assignToName;
  String dueDate;
  String createdOn;
  String createdBy;
  String docId;
  String docName;
  bool isCompleted;
  String assignToPic;
  String description;

  TaskVm(
      this.id,
      this.taskName,
      this.assignTo,
      this.assignToName,
      this.dueDate,
      this.createdOn,
      this.createdBy,
      this.docId,
      this.docName,
      this.isCompleted,
      this.assignToPic,
      this.description);
  factory TaskVm.fromJson(dynamic json) {
    return TaskVm(
        json['Id'] ?? "",
        json['TaskName'] ?? "",
        json['AssignTo'] ?? "",
        json['AssignToName'] ?? "",
        json['DueDate'] ?? "",
        json['CreatedOn'] ?? "",
        json['CreatedBy'] ?? "",
        json['DocId'] ?? "",
        json['DocName'] ?? "",
        json['IsCompleted'] ?? false,
        json['assignToPic'] ?? "",
        json['Description'] ?? "");
  }
}

class SingleCustomRemindList {
  String value;
  String title;

  SingleCustomRemindList({this.value = "", this.title = ""});

  static List<SingleCustomRemindList> getList() {
    return <SingleCustomRemindList>[
      SingleCustomRemindList(
        value: "Week",
        title: "Weeks Before",
      ),
    ];
  }
}

class SingleValidPeriodList {
  String value;
  String title;

  SingleValidPeriodList({this.value = "", this.title = ""});

  static List<SingleValidPeriodList> getList() {
    return <SingleValidPeriodList>[
      SingleValidPeriodList(
        value: "Week",
        title: "Week/s",
      ),
    ];
  }
}

class DoubleValidPeriodList {
  String value;
  String title;

  DoubleValidPeriodList({this.value = "", this.title = ""});

  static List<DoubleValidPeriodList> getList() {
    return <DoubleValidPeriodList>[
      DoubleValidPeriodList(
        value: "Month",
        title: "Month/s",
      ),
      DoubleValidPeriodList(
        value: "Week",
        title: "Week/s",
      ),
    ];
  }
}

class TripleValidPeriodList {
  String value;
  String title;

  TripleValidPeriodList({this.value = "", this.title = ""});

  static List<TripleValidPeriodList> getList() {
    return <TripleValidPeriodList>[
      TripleValidPeriodList(
        value: "Year",
        title: "Year/s",
      ),
      TripleValidPeriodList(
        value: "Month",
        title: "Month/s",
      ),
      TripleValidPeriodList(
        value: "Week",
        title: "Week/s",
      ),
    ];
  }
}

class DoubleCustomRemindList {
  String value;
  String title;

  DoubleCustomRemindList({this.value = "", this.title = ""});

  static List<DoubleCustomRemindList> getList() {
    return <DoubleCustomRemindList>[
      DoubleCustomRemindList(
        value: "Weeks",
        title: "Weeks Before",
      ),
      DoubleCustomRemindList(
        value: "Months",
        title: "Months Before",
      ),
    ];
  }
}

class SendToList {
  int sendOn;
  String title;
  bool isCheck;

  SendToList({this.sendOn = 0, this.title = "", this.isCheck = false});

  static List<SendToList> getList() {
    return <SendToList>[
      SendToList(sendOn: 11, title: "Email", isCheck: false),
      SendToList(sendOn: 22, title: "Phone", isCheck: false),
    ];
  }
}

class customReminderArray {
  int customRemindValue;
  String customRemindPeriod;

  customReminderArray(
      {this.customRemindValue = 0, this.customRemindPeriod = ""});
}

class ReminderList {
  int remindValue;
  String title;
  bool isCheck;

  ReminderList({this.remindValue = 0, this.title = "", this.isCheck = false});

  static List<ReminderList> getList() {
    return <ReminderList>[
      ReminderList(remindValue: 1, title: "02 Weeks before", isCheck: true),
      ReminderList(remindValue: 2, title: "04 Weeks before", isCheck: true),
      ReminderList(remindValue: 3, title: "02 Months before", isCheck: true),
      ReminderList(remindValue: 4, title: "06 Months before", isCheck: true),
      ReminderList(remindValue: 5, title: "Custom", isCheck: false),
    ];
  }
}

class FilterDocVm {
  int docOrdering;
  bool? reminder;
  bool? taskAssociated;
  List<String>? docFolderList;
  List<String>? docTypeList;

  FilterDocVm({
    this.docOrdering = 1,
    this.reminder,
    this.taskAssociated,
    this.docFolderList,
    this.docTypeList,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'DocOrdering': docOrdering,
      'Reminder': reminder,
      'TaskAssociated': taskAssociated,
      'DocFolderList': docFolderList,
      'DocTypeList': docTypeList,
    };
    return map;
  }
}
