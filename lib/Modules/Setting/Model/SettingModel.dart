// ignore_for_file: file_names

import 'dart:core';

import 'package:image_picker/image_picker.dart';

class FeedBackVm {
  String id;
  String subject;
  String detail;
  String createdOn;
  String userId;
  bool isRead;
  bool isMarked;

  FeedBackVm({
    this.id = "",
    this.subject = "",
    this.detail = "",
    this.createdOn = "",
    this.userId = "",
    this.isRead = false,
    this.isMarked = false,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Subject': subject.toString(),
      'Detail': detail.toString(),
      'UserId': userId,
      'IsRead': isRead,
      'IsMarked': isMarked,
    };
    return map;
  }
}

class Sharer {
  String id;
  String name;
  String email;
  String profilePic;
  String accessTypeTitle;
  String accessTypeId;
  String createdOn;
  String userId;
  int requestStatus;
  bool isInvitedEmail;

  Sharer(
    this.id,
    this.name,
    this.email,
    this.profilePic,
    this.accessTypeTitle,
    this.accessTypeId,
    this.createdOn,
    this.userId,
    this.requestStatus,
    this.isInvitedEmail,
  );
  factory Sharer.fromJson(dynamic json) {
    return Sharer(
      json['Id'] ?? "",
      json['Name'] ?? "",
      json['Email'] ?? "",
      json['ProfilePic'] ?? "",
      json['AccessTypeTitle'] ?? "",
      json['AccessTypeId'] ?? "",
      json['CreatedOn'] ?? "",
      json['UserId'] ?? "",
      json['RequestStatus'] ?? 0,
      json['isInvitedEmail'] ?? false,
    );
  }
}

class NotificationSettingVM {
  bool docExpiry;
  bool docShared;
  bool inAppReminder;
  String userId;

  NotificationSettingVM(
      {this.docExpiry = false,
      this.docShared = false,
      this.inAppReminder = false,
      this.userId = ""});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'DocExpiry': docExpiry,
      'DocShared': docShared,
      'InAppReminder': inAppReminder,
      'UserId': userId,
    };
    return map;
  }

  factory NotificationSettingVM.fromJson(Map<dynamic, dynamic> json) {
    return NotificationSettingVM(
      docExpiry: json['DocExpiry'],
      docShared: json['DocShared'],
      inAppReminder: json['InAppReminder'],
    );
  }
}

class TblUserSharer {
  String id;
  String sharerId;
  String toEmail;
  String userId;
  String accessTypeId;

  TblUserSharer({
    this.id = "",
    this.sharerId = "",
    this.toEmail = "",
    this.userId = "",
    this.accessTypeId = "",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'SharerId': sharerId,
      'UserId': userId,
      'toEmail': toEmail,
      'AccessTypeId': accessTypeId,
    };
    return map;
  }
}

class EditUserSharer {
  String id;
  String sharerId;
  String userId;
  String accessTypeId;
  String userName;
  String userEmail;

  EditUserSharer({
    this.id = "",
    this.sharerId = "",
    this.userId = "",
    this.accessTypeId = "",
    this.userName = "",
    this.userEmail = "",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Id': id,
      'SharerId': sharerId,
      'UserId': userId,
      'AccessTypeId': accessTypeId,
    };
    return map;
  }
}

class UserInfo {
  String id;
  String name;
  String userName;
  String email;
  String phoneNumber;
  String profilePic;
  int docExpiringCriteria;
  XFile? uploadPic;
  String? countryId;
  String? countryCode;
  String? stateId;
  String? gender;
  String? dob;
  String? address;

  UserInfo({
    this.id = "",
    this.name = "",
    this.userName = "",
    this.email = "",
    this.phoneNumber = "",
    this.profilePic = "",
    this.docExpiringCriteria = 0,
    this.uploadPic,
    this.countryId,
    this.countryCode,
    this.stateId,
    this.gender,
    this.dob,
    this.address,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Id': id.toString(),
      'Name': name.toString(),
      'UserName': userName.toString(),
      'Email': email.toString(),
      'PhoneNumber': phoneNumber.toString(),
      'ProfilePic': profilePic.toString(),
      'DocExpiringCriteria': docExpiringCriteria.toString(),
      'CountryId': countryId.toString(),
      'CountryCode': countryCode.toString(),
      'StateId': stateId.toString(),
      'Gender': gender.toString(),
      'Dob': dob.toString(),
      'Address': address.toString(),
    };
    return map;
  }

  factory UserInfo.fromJson(Map<dynamic, dynamic> json) {
    return UserInfo(
      id: json['Id'] ?? "",
      name: json['Name'] ?? "",
      userName: json['UserName'] ?? "",
      email: json['Email'] ?? "",
      phoneNumber: json['PhoneNumber'] ?? "",
      profilePic: json['ProfilePic'] ?? "",
      docExpiringCriteria: json['DocExpiringCriteria'] ?? 0,
      countryId: json['CountryId'] ?? "",
      countryCode: json['CountryCode'],
      stateId: json['StateId'] ?? "",
      gender: json['Gender'] ?? "",
      dob: json['DOB'] ?? "",
      address: json['Address'] ?? "",
    );
  }
}

class SharerListVM {
  List<Sharer> item1;
  int item2;

  SharerListVM(this.item1, this.item2);

  factory SharerListVM.fromJson(dynamic json) {
    var item1 = json['Item1'] as List;
    List<Sharer> _item1 =
        item1.map((dataJson) => Sharer.fromJson(dataJson)).toList();

    return SharerListVM(
      _item1,
      json['Item2'] ?? 0,
    );
  }
}

class GenderList {
  String value;
  String title;

  GenderList({this.value = "", this.title = ""});

  static List<GenderList> getList() {
    return <GenderList>[
      GenderList(
        value: "M",
        title: "Male",
      ),
      GenderList(
        value: "F",
        title: "Female",
      ),
    ];
  }
}

class TblNotificationEnable {
  String id;
  bool? onXpiree;
  bool? onEmail;
  bool? onPhone;
  String userId;
  String notifyTypeId;
  String createdOn;

  TblNotificationEnable({
    this.id = "",
    this.onXpiree,
    this.onEmail,
    this.onPhone,
    this.userId = "",
    this.notifyTypeId = "",
    this.createdOn = "",
  });

  factory TblNotificationEnable.fromJson(Map<String, dynamic> json) {
    return TblNotificationEnable(
      id: json['id'] ?? "",
      onXpiree: json['onXpiree'],
      onEmail: json['onEmail'],
      onPhone: json['onPhone'],
      userId: json['userId'] ?? "",
      notifyTypeId: json['notifyTypeId'] ?? "",
      createdOn: json['createdOn'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Id': id,
      'OnXpiree': onXpiree,
      'OnEmail': onEmail,
      'OnPhone': onPhone,
      'UserId': userId,
      'NotifyTypeId': notifyTypeId,
      'CreatedOn': createdOn,
    };
    return map;
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
   String? createdOn;
   String? createdBy;

  TblPackage(
    this.id,
    this.title,
    this.preference,
    this.price,
    this.noOfDocument,
    this.attachPerDoc,
    this.perAttachSize,
    this.totalStorage,
    this.noOfDocShare,
    this.docShareWithShare,
    this.noOfFolderAllow,
    this.noOfSharerAllow,
    this.ads,
    this.support,
    this.allowToShareTask,
    this.noOfTaskPerDoc,
    this.isUnlimitedDocument,
    this.isUnlimitedFolder,
    this.isUnlimitedSharers,
    this.isActive,
    this.createdOn,
    this.createdBy,
  );

  factory TblPackage.fromJson(dynamic json) {
    return TblPackage(
      json['Id'] ?? 0,
      json['Title'] ?? "",
      json['Preference'] ?? 0,
      json['Price'] ?? 0,
      json['NoOfDocument'] ?? 0,
      json['AttachPerDoc'] ?? 0,
      json['PerAttachSize'] ?? 0,
      json['TotalStorage'] ?? 0,
      json['NoOfDocShare'] ?? 0,
      json['DocShareWithShare'] ?? 0,
      json['NoOfFolderAllow'] ?? 0,
      json['NoOfSharerAllow'] ?? 0,
      json['Ads'] ?? false,
      json['Support'] ?? false,
      json['AllowToShareTask'] ?? false,
      json['NoOfTaskPerDoc'] ?? 0,
      json['IsUnlimitedDocument'] ?? false,
      json['IsUnlimitedFolder'] ?? false,
      json['IsUnlimitedSharers'] ?? false,
      json['IsActive'] ?? false,
      json['CreatedOn'] ?? "",
      json['CreatedBy'] ?? "",
    );
        
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      
       'Id': id,
      'Title': title,
      'Preference': preference,
      'Price': price,
      'NoOfDocument': noOfDocument,
      'AttachPerDoc': attachPerDoc,
      'PerAttachSize': perAttachSize,
      'TotalStorage': totalStorage,
      'NoOfDocShare': noOfDocShare,
      'DocShareWithShare': docShareWithShare,
      'NoOfFolderAllow': noOfFolderAllow,
      'NoOfSharerAllow': noOfSharerAllow,
      'Ads': ads,
      'Support': support,
      'AllowToShareTask': allowToShareTask,
      'NoOfTaskPerDoc': noOfTaskPerDoc,
      'IsUnlimitedDocument': isUnlimitedDocument,
      'IsUnlimitedFolder': isUnlimitedFolder,
      'IsUnlimitedSharers': isUnlimitedSharers,
      'IsActive': isActive,
      'CreatedOn': createdOn,
      'CreatedBy': createdBy,
    };
    return map;
  }
}

class AddStripeCustomer {
  String email;
  String name;
  AddStripeCard? creditCard;

  AddStripeCustomer({
    this.email = "",
    this.name = "",
    this.creditCard,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Email': email,
      'Name': name,
      'CreditCard': creditCard,
    };
    return map;
  }
}

class AddStripeCard {
  String name;
  String cardNumber;
  String expirationYear;
  String expirationMonth;
  String cvc;

  AddStripeCard({
    this.name = "",
    this.cardNumber = "",
    this.expirationYear = "",
    this.expirationMonth = "",
    this.cvc = "",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Name': name,
      'CardNumber': cardNumber,
      'ExpirationYear': expirationYear,
      'ExpirationMonth': expirationMonth,
      'Cvc': cvc,
    };
    return map;
  }
}

class AddStripePayment {
  String customerId;
  String receiptEmail;
  String description;
  String currency;
  int amount;
  int packageId;

  AddStripePayment({
    this.customerId = "",
    this.receiptEmail = "",
    this.description = "",
    this.currency = "",
    this.amount = 0,
    this.packageId = 0,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'CustomerId': customerId,
      'ReceiptEmail': receiptEmail,
      'Description': description,
      'Currency': currency,
      'Amount': amount,
      'PackageId': packageId,
    };
    return map;
  }
}

class StripeResponse {
  String customerId;
  String name;
  String email;

  StripeResponse({
    this.customerId = "",
    this.name = "",
    this.email = "",
  });

  factory StripeResponse.fromJson(Map<dynamic, dynamic> json) {
    return StripeResponse(
      customerId: json['CustomerId'] ?? "",
      name: json['Name'] ?? "",
      email: json['Email'] ?? "",
    );
  }
}
class StripePaymentResponse {
    String customerId;
    String receiptEmail;
    String description;
    String currency;
    int amount;
    String paymentId;
  StripePaymentResponse({
    this.customerId = "",
    this.receiptEmail = "",
    this.description = "",
    this.currency = "",
    this.amount = 0,
    this.paymentId = "",
  });

  factory StripePaymentResponse.fromJson(Map<dynamic, dynamic> json) {
    return StripePaymentResponse(
      customerId: json['CustomerId'] ?? "",
      receiptEmail: json['ReceiptEmail'] ?? "",
      description: json['Description'] ?? "",
      currency: json['Currency'] ?? "",
      amount: json['Amount'] ?? 0,
      paymentId: json['PaymentId'] ?? "",
    );
  }
}
