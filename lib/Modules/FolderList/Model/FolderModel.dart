
// ignore_for_file: file_names

class FolderVM {
String id;
String userId;
String name;
int docCount;
String createdOn;
String updatedOn;
String color;

  FolderVM(
    this.id,
    this.userId,
    this.name,
    this.docCount,
    this.createdOn,
     this.updatedOn,
    this.color,
);
  factory FolderVM.fromJson(dynamic json) {
   
     return FolderVM(
      json['Id'] ?? "",
      json['UserId'] ?? "",
      json['Name'] ?? "",
      json['docCount'] ?? 0,
      json['CreatedOn'] ?? "",
      json['UpdatedOn'] ?? "",
      json['Color'] ?? "",
    );
  }
}
class TblFolder {
  String id;
  String userId;
  String name;
  String createdOn;
  String color;
  bool isChecked;

  TblFolder({
    this.id="",
    this.userId="",
    this.name="",
    this.createdOn="",
    this.color="",
    this.isChecked=false,
  });

  factory TblFolder.fromJson(Map<String, dynamic> json) {
    return TblFolder(
      id: json['Id'],
      userId: json['UserId'],
      name: json['Name'],
      createdOn: json['CreatedOn'],
      color: json['Color'],
    );
  }
} 


class AddFolder {
String id;
String userId;
String name;
String createdOn;
String color;

  AddFolder({
    this.id="",
    this.userId="",
    this.name="",
    this.createdOn="",
    this.color="",}
);
 
   Map<String, dynamic> toJson() {
        Map<String, dynamic> map = {
          'Name': name,
          'Color': color,
        };
        return map;
      }
}


class UpdateFolder {
String id;
String userId;
String name;
String createdOn;
String color;

  UpdateFolder({
    this.id="",
    this.userId="",
    this.name="",
    this.createdOn="",
    this.color="",
    }
);
 
   Map<String, dynamic> toJson() {
        Map<String, dynamic> map = {
          'Id': id,
          'Name': name,
          'Color': color,
        };
        return map;
      }
}