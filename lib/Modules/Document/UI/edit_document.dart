import 'dart:io';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:Xpiree/Modules/Dashboard/UI/NavigationBottom.dart';
import 'package:Xpiree/Modules/Document/Model/DocumentModel.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';
import 'package:Xpiree/Modules/FolderList/Utils/FolderDataHelper.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:Xpiree/Shared/Utils/notification_service.dart';

class EditDocument extends StatefulWidget {
  final DocumentDetail docDetail;
  const EditDocument({Key? key, required this.docDetail}) : super(key: key);

  @override
  EditDocumentState createState() => EditDocumentState();
}

class EditDocumentState extends State<EditDocument> {
  late DocumentDetail docDetail;
  TblDocument modal = TblDocument();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController validForController = TextEditingController();
  TextEditingController validForPeriodController = TextEditingController();
  TextEditingController docOwnerController = TextEditingController();
  TextEditingController docNumberController = TextEditingController();

  TextEditingController customRemindValueController = TextEditingController();
  TextEditingController docTypeController = TextEditingController();
  var myControllers = [];
  List<TblCountry> listofCountry = [];
  List<TblState> listofStates = [];
  List<TblDocType> listofDocType = [];
  List<TblFolder> listofFolders = [];
  List<TblDocSendOn> listofSendOn = [];
  List<TblDocReminder> listofRemindOn = [];
  List<customReminderArray> listCustomReminderArry = [];
  int cstmRemderCount = 1;
  bool isOptionalShow = false;
  bool isCustomReminderShow = false;
  bool isIssueDateShow = false;
  TblPackage userPackage = TblPackage();
  DateTime currentDate = DateTime.now();

  List<ReminderList> reminderList = ReminderList.getList();
  List<SendToList> sendToList = SendToList.getList();
  List<SingleCustomRemindList> singlecustomRemindList =
      SingleCustomRemindList.getList();
  List<DoubleCustomRemindList> doubleCustomRemindList =
      DoubleCustomRemindList.getList();

  List<SingleValidPeriodList> singleValidPeriodList =
      SingleValidPeriodList.getList();
  List<DoubleValidPeriodList> doubleValidPeriodList =
      DoubleValidPeriodList.getList();
  List<TripleValidPeriodList> tripleValidPeriodList =
      TripleValidPeriodList.getList();

  int defaultCustomRemindValue = 1;
  String defaultCustomRemindPeriod = "Weeks";
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  AddFolder folderModal = AddFolder();
  TblDocType docTypeModal = TblDocType();

  TextEditingController folderNameController = TextEditingController();
  int groupValue = 1;
  String? validForPeriodValue;
  String? countryIdValue;
  String? stateIdValue;
  late String previousFolder;
  var customFormat = DateFormat('MMM dd, yyyy');
  var selectionFormat = DateFormat('MM/dd/yyyy');
  List<XFile> image = [];
  List<PlatformFile> selectedfiles = [];

  int innerCounter = 0;
  bool isNewReminderAdded = false;
  void _uploadImage() async {
    Navigator.pop(context);

    final _picker = ImagePicker();

    var _pickedImage = await _picker.pickMultiImage();

    setState(() {
      if (_pickedImage != null) {
        for (int i = 0; i < _pickedImage.length; i++) {
          image.add(_pickedImage[i]);
        }
      }
    });
  }

  void _takeCameraImage() async {
    Navigator.pop(context);
    final _picker = ImagePicker();

    var _pickedImage = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (_pickedImage != null) {
        image.add(_pickedImage);
      }
    });
  }

  void _chooseFile() async {
    Navigator.pop(context);
    FilePickerResult? chooseFile = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    setState(() {
      if (chooseFile != null) {
        for (int i = 0; i < chooseFile.files.length; i++) {
          selectedfiles.add(chooseFile.files[i]);
        }
      }
    });
  }

  DateTime startDate = DateTime(2000);
  DateTime enddate = DateTime(2050);
  @override
  void initState() {
    super.initState();
    docDetail = widget.docDetail;

    setState(() {
      DateTime expiryDate = DateTime.parse(docDetail.expiryDate);
      expiryDateController.text = customFormat.format(expiryDate);
      modal.validFor = '0';

      if (docDetail.issueDate.isNotEmpty) {
        DateTime issueDate = DateTime.parse(docDetail.issueDate);
        issueDateController.text = customFormat.format(issueDate);
        modal.issueDate = docDetail.issueDate;
      }

      nameController.text = docDetail.docName;
      docNumberController.text = docDetail.docNumber;

      if (docDetail.issueDate.isNotEmpty) {
        isIssueDateShow = true;
      }

      modal.id = docDetail.id;
      modal.expiryDate = docDetail.expiryDate;
      modal.docName = docDetail.docName;
      modal.docNumber = docDetail.docNumber;

      modal.remindMe = docDetail.remindMe;

      modal.docTypeId = docDetail.docTypeId;
      modal.folderId = docDetail.folderId;
      previousFolder = modal.folderId;

      EasyLoading.addStatusCallback((status) {});
      EasyLoading.show(status: 'loading...');
      if (docDetail.countryId.isNotEmpty && docDetail.countryId != "null") {
        modal.countryId = docDetail.countryId;
        countryIdValue = docDetail.countryId;

        fetchState(modal.countryId).then((response) {
          if (docDetail.stateId.isNotEmpty) {
            modal.stateId = docDetail.stateId;
            stateIdValue = docDetail.stateId;
          }
          setState(() {
            listofStates = response!;
          });
          EasyLoading.dismiss();
        });
      }
      for (int i = 0; i < reminderList.length; i++) {
        for (int j = 0; j < docDetail.reminderList!.length; j++) {
          if (reminderList[i].remindValue ==
              docDetail.reminderList![j].remindValue) {
            reminderList[i].isCheck = true;
            if (docDetail.reminderList![j].remindValue == 5) {
              setState(() {
                isCustomReminderShow = true;
                isNewReminderAdded = true;

                addNewCustomReminder();

                listCustomReminderArry[innerCounter].customRemindValue =
                    docDetail.reminderList![j].customRemindValue;
                listCustomReminderArry[innerCounter].customRemindPeriod =
                    docDetail.reminderList![j].customRemindPeriod;
                myControllers[innerCounter].text =
                    docDetail.reminderList![j].customRemindValue.toString();

                innerCounter++;
              });
            } else {
              listofRemindOn.add(
                  TblDocReminder(remindValue: reminderList[i].remindValue));
            }
          }
        }
      }
      if (!isNewReminderAdded) {
        addNewCustomReminder();
        isNewReminderAdded = true;
      }
    });
    getUserPackage().then((response) {
      setState(() {
        userPackage = response;
      });
      EasyLoading.dismiss();
    });
    fetchCountry().then((response) {
      setState(() {
        listofCountry = response!;
      });
      EasyLoading.dismiss();
    });
    fetchDocType(docDetail.id).then((response) {
      setState(() {
        listofDocType = response!;
      });
      EasyLoading.dismiss();
    });

    getfolderlist();
  }

  List<TblFolder> getfolderlist() {
    fetchUserFolders(docDetail.id).then((response) {
      setState(() {
        listofFolders = response!;
      });
      EasyLoading.dismiss();
    });
    return listofFolders;
  }

  void addNewCustomReminder() {
    if (listCustomReminderArry.length < 3) {
      customReminderArray modl = customReminderArray();
      modl.customRemindPeriod = defaultCustomRemindPeriod.toString();
      modl.customRemindValue = defaultCustomRemindValue;
      listCustomReminderArry.add(modl);
      myControllers.add(TextEditingController());
      if (listCustomReminderArry.length > 1) {
        myControllers[listCustomReminderArry.length - 1].text = "1";
      } else {
        myControllers[0].text = "1";
      }
    }
  }

  @override
  void dispose() {
    docTypeController.dispose();
    folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.whiteColor,
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: Theme.of(context).colorScheme.whiteColor,
        centerTitle: true,
        title: Text("Update New Xpiree",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xffA7A8BB)
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
          child: Container(
              color: Theme.of(context).colorScheme.whiteColor,
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Text("Document Name",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: CustomTextStyle.textBoxStyle,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                  RegExp("[a-zA-Z0-9 *']"),
                                  allow: true)
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Document Name is required';
                              } else if (value.length > 35) {
                                return 'Maximum up 35 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                modal.docName = value;
                              });
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .textfiledColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Add document name here',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 20),
                            child: Text("Expiration Date",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          TextFormField(
                            controller: expiryDateController,
                            keyboardType: TextInputType.datetime,
                            style: CustomTextStyle.textBoxStyle,
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Expiration Date is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon:
                                    const Icon(Icons.calendar_month, size: 20),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .textfiledColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Enter expiration date here',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              //   FocusScope.of(context).requestFocus(FocusNode());
                              FocusScope.of(context).unfocus();

                              date = (await showDatePicker(
                                  context: context,
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  initialDate: modal.issueDate == null
                                      ? DateTime.now()
                                      : DateTime.parse(modal.issueDate!),
                                  firstDate: modal.issueDate == null
                                      ? startDate
                                      : DateTime.parse(modal.issueDate!),
                                  lastDate: enddate));

                              if (date != null) {
                                expiryDateController.text =
                                    customFormat.format(date);
                                modal.expiryDate = date.toString();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text("Issue Date",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          TextFormField(
                            controller: issueDateController,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            style: CustomTextStyle.textBoxStyle,
                            decoration: InputDecoration(
                                suffixIcon:
                                    const Icon(Icons.calendar_month, size: 20),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .textfiledColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Issue Date',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              // FocusScope.of(context).requestFocus(FocusNode());
                              FocusScope.of(context).unfocus();

                              date = (await showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: modal.expiryDate.isEmpty
                                    ? DateTime.now()
                                    : DateTime.parse(modal.expiryDate),
                                firstDate: startDate,
                                lastDate: modal.expiryDate.isEmpty
                                    ? enddate
                                    : DateTime.parse(modal.expiryDate),
                              ));

                              if (date != null) {
                                issueDateController.text =
                                    customFormat.format(date);
                                modal.issueDate = date.toString();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 20),
                            child: Text("Document Type",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: DropdownButtonFormField(
                                      isExpanded: true,
                                      style: CustomTextStyle.textBoxStyle,
                                      iconEnabledColor:
                                          Theme.of(context).iconTheme.color,
                                      value: modal.docTypeId,
                                      hint: Text(
                                          "Choose from the list or add one",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fadeGrayColor)),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Doc Type is required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .textfiledColor,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                      ),
                                      items:
                                          listofDocType.map((TblDocType item) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            item.title,
                                          ),
                                          value: item.id,
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          modal.docTypeId = value as String;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  child: IconButton(
                                    // padding: const EdgeInsets.only(left: 6),
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.add,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .whiteColor,
                                    ),
                                    onPressed: () async {
                                      final response2 =
                                          await newDocType(context);
                                      fetchDocType(docDetail.id)
                                          .then((response) {
                                        setState(() {
                                          listofDocType = response!;
                                          if (response2 != null) {
                                            modal.docTypeId = response2;
                                          }
                                        });
                                        EasyLoading.dismiss();
                                      });
                                    },
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: Text("Add to Folder",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  // width: MediaQuery.of(context).size.width / 1.2,
                                  child: DropdownButtonFormField(
                                      isExpanded: true,
                                      style: CustomTextStyle.textBoxStyle,
                                      iconEnabledColor:
                                          Theme.of(context).iconTheme.color,
                                      value: modal.folderId,
                                      hint: Text(
                                          "Choose from the list or add one",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .fadeGrayColor)),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .textfiledColor,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Folder is required';
                                        }
                                        return null;
                                      },
                                      items:
                                          listofFolders.map((TblFolder item) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            item.name,
                                          ),
                                          value: item.id,
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          modal.folderId = value as String;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                child: IconButton(
                                  // padding: const EdgeInsets.only(left: 6),
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .whiteColor,
                                  ),
                                  onPressed: () async {
                                    final response2 = await newFolder(context);
                                    fetchUserFolders(docDetail.id)
                                        .then((response) {
                                      setState(() {
                                        listofFolders = response!;
                                        if (response2 != null) {
                                          modal.folderId = response2;
                                        }
                                      });
                                      EasyLoading.dismiss();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Text("Additional Information",
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 10),
                            child: Text("Document Number",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          TextFormField(
                            controller: docNumberController,
                            keyboardType: TextInputType.text,
                            style: CustomTextStyle.textBoxStyle,
                            onChanged: (value) {
                              setState(() {
                                modal.docNumber = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length > 15) {
                                return 'Maximum up 15 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .textfiledColor,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Add the document number',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 10),
                                        child: Text("Issued Country",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      DropdownButtonFormField(
                                          isExpanded: true,
                                          style: CustomTextStyle.textBoxStyle,
                                          iconEnabledColor:
                                              Theme.of(context).iconTheme.color,
                                          value: modal.countryId,
                                          hint: Text("Select One",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fadeGrayColor)),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(16),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .textfiledColor,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(6.0)),
                                          ),
                                          items: listofCountry
                                              .map((TblCountry item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                item.name,
                                              ),
                                              value: item.name,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            EasyLoading.addStatusCallback(
                                                (status) {});
                                            EasyLoading.show(
                                                status: 'loading...');
                                            setState(() {
                                              modal.countryId = value as String;
                                              fetchState(modal.countryId)
                                                  .then((response) {
                                                setState(() {
                                                  listofStates = response!;
                                                });
                                                EasyLoading.dismiss();
                                              });
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 10),
                                        child: Text("Issued State",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                      DropdownButtonFormField(
                                          isExpanded: true,
                                          style: CustomTextStyle.textBoxStyle,
                                          iconEnabledColor:
                                              Theme.of(context).iconTheme.color,
                                          value: modal.stateId,
                                          hint: Text("Select One",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fadeGrayColor)),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(16),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .textfiledColor,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(6.0)),
                                          ),
                                          items:
                                              listofStates.map((TblState item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                item.name,
                                              ),
                                              value: item.name,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              modal.stateId = value as String;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                            margin: const EdgeInsets.only(top: 20, bottom: 8),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text(
                                      "Default Reminders Before Expiration ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFA4A3A3),
                                          fontWeight: FontWeight.w500)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    String _msg =
                                        "The following Reminders are set by default and system will notify you as per below specified intervals. You can add any additional custom reminders below.";
                                    String title = "About Reminders";
                                    var response =
                                        showAlertDialog(title, _msg, context);
                                  },
                                  child: Image.asset(
                                      "assets/Icons/QuestionIcon.png"),
                                )
                              ],
                            ),
                          ),
                          ListView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 5, 4),
                                  child: Row(
                                    children: reminderList
                                        .map(
                                          (list) => list.remindValue != 5
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                    // color: Theme.of(context)
                                                    //     .colorScheme
                                                    //     .textfiledColor,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Text(
                                                    list.title,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                )
                                              : Container(),
                                        )
                                        .toList(),
                                  ),
                                ),
                                Container(
                                  // width: 300,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: reminderList
                                        .map(
                                          (list) => list.remindValue == 5
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Custom Reminders",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                    const SizedBox(width: 30
                                                        // MediaQuery.of(context)
                                                        //         .size
                                                        //         .width *
                                                        //     0.40,
                                                        ),
                                                    Switch(
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          isCustomReminderShow =
                                                              value;
                                                          list.isCheck = value;
                                                        });
                                                      },
                                                      value: list.isCheck,
                                                      activeColor: Colors.white,
                                                      activeTrackColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      inactiveThumbColor:
                                                          Colors.white,
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        )
                                        .toList(),
                                  ),
                                ),
                                isCustomReminderShow == true
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListView.builder(
                                              itemCount:
                                                  listCustomReminderArry.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment
                                                  //         .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                      alignment:
                                                          Alignment.center,
                                                      child: TextFormField(
                                                        controller:
                                                            myControllers[
                                                                index],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: CustomTextStyle
                                                            .textBoxStyle,
                                                        textAlign:
                                                            TextAlign.center,
                                                        validator: (value) {
                                                          if (int.parse(
                                                                  value!) >
                                                              52) {
                                                            return '1-52';
                                                          }
                                                          return null;
                                                        },
                                                        onChanged: (value) {
                                                          if (value
                                                              .isNotEmpty) {
                                                            if (int.parse(
                                                                    value) >
                                                                52) {
                                                              setState(() {
                                                                defaultCustomRemindValue =
                                                                    0;
                                                                customRemindValueController
                                                                        .text =
                                                                    defaultCustomRemindValue
                                                                        .toString();
                                                              });
                                                            } else {
                                                              setState(() {
                                                                defaultCustomRemindValue =
                                                                    int.parse(
                                                                        value);
                                                              });
                                                            }
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .textfiledColor,
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          prefixIcon:
                                                              IconButton(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                  icon:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .center, // Aligns the icon to the center of the container
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color),
                                                                    child:
                                                                        const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              30),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .minimize_outlined,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (listCustomReminderArry[index]
                                                                              .customRemindValue >
                                                                          1) {
                                                                        listCustomReminderArry[index]
                                                                            .customRemindValue = listCustomReminderArry[index]
                                                                                .customRemindValue -
                                                                            1;
                                                                        myControllers[index]
                                                                            .text = listCustomReminderArry[
                                                                                index]
                                                                            .customRemindValue
                                                                            .toString();
                                                                      }
                                                                    });
                                                                  }),
                                                          prefixIconConstraints:
                                                              const BoxConstraints(),
                                                          suffixIcon:
                                                              IconButton(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          15,
                                                                          0),
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                  icon:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .center, // Aligns the icon to the center of the container
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        color: Theme.of(context)
                                                                            .iconTheme
                                                                            .color),
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      size: 15,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (listCustomReminderArry[index]
                                                                              .customRemindValue <
                                                                          52) {
                                                                        listCustomReminderArry[index]
                                                                            .customRemindValue = listCustomReminderArry[index]
                                                                                .customRemindValue +
                                                                            1;
                                                                        myControllers[index]
                                                                            .text = listCustomReminderArry[
                                                                                index]
                                                                            .customRemindValue
                                                                            .toString();
                                                                      }
                                                                    });
                                                                  }),
                                                          suffixIconConstraints:
                                                              const BoxConstraints(),
                                                        ),
                                                      ),
                                                    ),
                                                    defaultCustomRemindValue >
                                                            12
                                                        ? Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.60,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child:
                                                                DropdownButtonFormField(
                                                                    isExpanded:
                                                                        true,
                                                                    style: CustomTextStyle
                                                                        .textBoxStyle,
                                                                    iconEnabledColor: Theme
                                                                            .of(
                                                                                context)
                                                                        .iconTheme
                                                                        .color,
                                                                    value: listCustomReminderArry[
                                                                            index]
                                                                        .customRemindPeriod,
                                                                    hint: Text(
                                                                        "Pick one",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .colorScheme
                                                                                .fadeGrayColor)),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding:
                                                                          const EdgeInsets.all(
                                                                              17),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .textfiledColor,
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25)),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.0)),
                                                                    ),
                                                                    items: singlecustomRemindList.map(
                                                                        (SingleCustomRemindList
                                                                            obj) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: obj
                                                                            .value,
                                                                        child: Text(
                                                                            obj.title),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        listCustomReminderArry[index].customRemindPeriod =
                                                                            value
                                                                                as String;
                                                                      });
                                                                    }),
                                                          )
                                                        : Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.50,
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    5, 5, 0, 5),
                                                            child:
                                                                DropdownButtonFormField(
                                                                    isExpanded:
                                                                        true,
                                                                    style: CustomTextStyle
                                                                        .textBoxStyle,
                                                                    iconEnabledColor: Theme
                                                                            .of(
                                                                                context)
                                                                        .iconTheme
                                                                        .color,
                                                                    value: listCustomReminderArry[
                                                                            index]
                                                                        .customRemindPeriod,
                                                                    hint: Text(
                                                                        "Pick one",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .colorScheme
                                                                                .fadeGrayColor)),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding:
                                                                          const EdgeInsets.all(
                                                                              17),
                                                                      filled:
                                                                          true,
                                                                      fillColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .textfiledColor,
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(6)),
                                                                    ),
                                                                    items: doubleCustomRemindList.map(
                                                                        (DoubleCustomRemindList
                                                                            obj) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: obj
                                                                            .value,
                                                                        child: Text(
                                                                            obj.title),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        listCustomReminderArry[index].customRemindPeriod =
                                                                            value
                                                                                as String;
                                                                      });
                                                                    }),
                                                          ),
                                                  ],
                                                );
                                              }),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 5, 5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    cstmRemderCount =
                                                        cstmRemderCount + 1;
                                                    addNewCustomReminder();
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // const Icon(Icons.add),
                                                    Container(
                                                      width: 190,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: const Text(
                                                          "Add a custom reminder",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .white)),
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      )
                                    : Container(),
                              ]),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                      "Attachments (" +
                                          (image.length + selectedfiles.length)
                                              .toString() +
                                          "/" +
                                          userPackage.attachPerDoc.toString() +
                                          ")",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                                image.isNotEmpty || selectedfiles.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          showAttachemnts(context);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.add_circle_sharp,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .linkTextColor,
                                                size: 18),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 2),
                                              child: Text("Add more",
                                                  style:
                                                      CustomTextStyle.blueText),
                                            ),
                                          ],
                                        ))
                                    : Container(),
                              ],
                            ),
                          ),
                          image.isEmpty &&
                                  selectedfiles.isEmpty &&
                                  docDetail.attachmentList!.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    showAttachemnts(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textfiledColor),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .iconBackColor,
                                            child: Image.asset(
                                                "assets/Icons/uploadAttach.png",
                                                width: 35,
                                                height: 35),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              "Tap to upload",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Text(
                                              "SVG, PNG, JPG or GIF (max. 3 MB)",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          docDetail.attachmentList!.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: docDetail.attachmentList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          docDetail.attachmentList![index]
                                                      .fileExtention ==
                                                  ".pdf"
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 250, 152, 4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Text(
                                                    docDetail
                                                        .attachmentList![index]
                                                        .fileExtention,
                                                    style: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ))
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Container(
                                                    height: 100,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Image.network(
                                                      imageUrl +
                                                          docDetail
                                                              .attachmentList![
                                                                  index]
                                                              .attachmentUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                          Positioned(
                                            right: -4,
                                            top: -4,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    EasyLoading.show(
                                                        status: 'Deleting...');
                                                    deleteAttachment(docDetail
                                                            .attachmentList![
                                                                index]
                                                            .id)
                                                        .then((reponse) {
                                                      getDocumentById(
                                                              docDetail.id)
                                                          .then((response) {
                                                        setState(() {
                                                          docDetail = response!;
                                                          EasyLoading.dismiss();
                                                        });
                                                      });
                                                    });
                                                  });
                                                },
                                                icon: Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .profileEditColor,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 15,
                                                  ),
                                                ),
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          image.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: image.isEmpty ? 0 : image.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.file(
                                                File(image[index].path),
                                                fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                            right: -4,
                                            top: -4,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    image.removeAt(index);
                                                  });
                                                },
                                                icon: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .profileEditColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 15,
                                                    )),
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          selectedfiles.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemCount: selectedfiles.isEmpty
                                      ? 0
                                      : selectedfiles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 250, 152, 4),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Text(
                                                "." +
                                                    selectedfiles[index]
                                                        .extension!,
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )),
                                          Positioned(
                                            right: -4,
                                            top: -4,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedfiles
                                                        .removeAt(index);
                                                  });
                                                },
                                                icon: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .profileEditColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 15,
                                                    )),
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            // padding: const EdgeInsets.only(top: 30),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // padding: const EdgeInsets.all(6),
                                  elevation: 0,
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Text(
                                  'Update',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      String _msg = "";
                                      if (modal.expiryDate != modal.issueDate) {
                                        EasyLoading.show(status: 'Updating...');

                                        updateDocument(
                                                modal,
                                                listofSendOn,
                                                listofRemindOn,
                                                image,
                                                selectedfiles,
                                                listCustomReminderArry,
                                                isCustomReminderShow)
                                            .then((response) {
                                          setState(() {
                                            EasyLoading.dismiss();
                                            if (response == "-3") {
                                              _msg =
                                                  "This document name is already in use.";
                                              EasyLoading.dismiss();
                                              String title = "";
                                              String _icon =
                                                  "assets/images/alert.json";
                                              var response = showInfoAlert(
                                                  title, _msg, _icon, context);
                                            } else if (response == "1") {
                                              _msg = "The document " +
                                                  modal.docName +
                                                  " has been updated.";
                                              EasyLoading.dismiss();
                                              String title = "Document updated";
                                              String _icon =
                                                  "assets/images/Success.json";
                                              var resStatus = showInfoAlert(
                                                  title, _msg, _icon, context);
                                              if (resStatus == "1") {
                                                Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () {
                                                  late int tabIndex;
                                                  final Duration durdef =
                                                      (DateTime.parse(
                                                              modal.expiryDate))
                                                          .difference(
                                                              currentDate);
                                                  if (currentDate.isAfter(
                                                      DateTime.parse(
                                                          modal.expiryDate))) {
                                                    tabIndex = 0;
                                                  } else if (currentDate.isBefore(
                                                          DateTime.parse(modal
                                                              .expiryDate)) &&
                                                      durdef.inDays < 60) {
                                                    tabIndex = 1;
                                                  } else {
                                                    tabIndex = 2;
                                                  }
                                                  Navigator.pop(context, true);
                                                  Navigator.pop(context, true);
                                                  if (previousFolder !=
                                                      modal.folderId) {
                                                    checkPushNotificationEnable()
                                                        .then((rsp) {
                                                      if (rsp!.moveFodler =
                                                          true) {
                                                        final NotificationService
                                                            _notificationService =
                                                            NotificationService();
                                                        _notificationService
                                                            .initialiseNotifications();
                                                        _notificationService
                                                            .sendNotifications(
                                                                "Document Moved",
                                                                modal.docName +
                                                                    " has been moved to the folder.");
                                                      }
                                                    });
                                                  }

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Dashboard(
                                                                indexTab: 1,
                                                              )));
                                                });
                                              }
                                            } else if (response == "-2") {
                                              _msg =
                                                  "You have limited No. of resources for uploading attachments!\n \n Please upgrade your plan.";
                                              EasyLoading.dismiss();
                                              String title = "";
                                              String _icon =
                                                  "assets/images/alert.json";
                                              var response =
                                                  showUpgradePackageAlert(title,
                                                      _msg, _icon, context);
                                            } else if (response == "-4") {
                                              _msg =
                                                  "Your total storage exceeds the allocated limit.\n \n Please upgrade your plan.";
                                              EasyLoading.dismiss();
                                              String title = "";
                                              String _icon =
                                                  "assets/images/alert.json";
                                              var response =
                                                  showUpgradePackageAlert(title,
                                                      _msg, _icon, context);
                                            } else if (response == "-6") {
                                              _msg =
                                                  "Your file size exceeds the allocated limit.\n \n Please upgrade your plan.";
                                              EasyLoading.dismiss();
                                              String title = "";
                                              String _icon =
                                                  "assets/images/alert.json";
                                              var response =
                                                  showUpgradePackageAlert(title,
                                                      _msg, _icon, context);
                                            } else if (response == "-5") {
                                              _msg =
                                                  "You have limited No. of resources for adding documents.\n \n Please upgrade your plan.";
                                              EasyLoading.dismiss();
                                              String title = "";
                                              String _icon =
                                                  "assets/images/alert.json";
                                              var response =
                                                  showUpgradePackageAlert(title,
                                                      _msg, _icon, context);
                                            }
                                          });
                                        });
                                      } else {
                                        _msg =
                                            "Oops! Issued date and expiration date must be different.";
                                        EasyLoading.dismiss();
                                        String title = "Alert";
                                        String _icon =
                                            "assets/images/alert.json";
                                        var response = showInfoAlert(
                                            title, _msg, _icon, context);
                                      }
                                    }
                                  }
                                }),
                          ),
                        ]),
                  )))),
    );
  }

  Future<String?> newDocType(BuildContext context) {
    String tempDocTypeId = "";
    docTypeController.text = "";
    return showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("New Document Type"),
              content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.20,
                  child: Form(
                      key: _formKey3,
                      child: TextFormField(
                        controller: docTypeController,
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        style: CustomTextStyle.textBoxStyle,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                              allow: true)
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Document Type is required';
                          } else if (value.length > 30) {
                            return 'Maximum up 30 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            docTypeModal.title = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.textfiledColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(6)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(6.0)),
                            hintText: 'Document Type here',
                            hintStyle: Theme.of(context).textTheme.headline6),
                      ))),
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Theme.of(context).colorScheme.textfiledColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.whiteColor),
                      ),
                      onPressed: () {
                        if (_formKey3.currentState!.validate()) {
                          _formKey3.currentState!.save();

                          EasyLoading.show(status: 'Saving...');
                          addDocType(docTypeModal).then((response) {
                            docTypeController.clear();

                            EasyLoading.dismiss();
                            String _msg = "";
                            if (response == "-3") {
                              _msg = "Oops! Already document type exist.";
                              EasyLoading.dismiss();
                              String title = "";
                              String _icon = "assets/images/alert.json";
                              var response =
                                  showInfoAlert(title, _msg, _icon, context);
                            } else {
                              Navigator.pop(context);
                              _msg =
                                  "Document Type has been added successfully!";
                              EasyLoading.dismiss();
                              String title = "Document Type";
                              String _icon = "assets/images/Success.json";
                              var resStatus =
                                  showInfoAlert(title, _msg, _icon, context);
                              if (resStatus == "1") {
                                getfolderlist();
                                setState(() {
                                  tempDocTypeId = response!;
                                });
                              }
                            }
                          });
                        }
                      }),
                )
              ],
            )).then((value) {
      if (tempDocTypeId == "") {
        return null;
      } else {
        return tempDocTypeId;
      }
    });
  }

  Future<String?> newFolder(BuildContext context) {
    String newFolderId = "";
    folderNameController.text = "";
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topRight: const Radius.circular(20),
                      topLeft: Radius.circular(20),
                    )),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Text("Folder Name",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: folderNameController,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[a-zA-Z0-9 ]"),
                                allow: true)
                          ],
                          style: CustomTextStyle.textBoxStyle,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Folder Name is required';
                            } else if (value.length > 20) {
                              return 'Maximum up 20 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              folderModal.name = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.textfiledColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6.0)),
                              hintText: 'New Folder e.g. Work Docs',
                              hintStyle: Theme.of(context).textTheme.headline6),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Choose color",
                                style: Theme.of(context).textTheme.headline6),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D98DA),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 1,
                                      groupValue: groupValue,
                                      activeColor: Colors.black,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#2D98DA';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA65EEA),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 2,
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#A65EEA';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF747D0),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 3,
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#F747D0';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF948D61)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 4,
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#948D61';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF99A4B2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 5,
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#99A4B2';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3D5E8C),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Radio(
                                      value: 6,
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          groupValue = value as int;
                                          folderModal.color = '#3D5E8C';
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0.0),
                                    elevation: 0,
                                    primary: Theme.of(context)
                                        .colorScheme
                                        .textfiledColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text("Cancel",
                                      style: CustomTextStyle.heading44),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0.0),
                                    elevation: 0,
                                    primary: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  child: const Text(
                                    "Create",
                                    style: CustomTextStyle.headingWhite,
                                  ),
                                  onPressed: () {
                                    if (_formKey2.currentState!.validate()) {
                                      _formKey2.currentState!.save();
                                      EasyLoading.show(status: 'Saving...');
                                      addDllFolder(folderModal)
                                          .then((response) {
                                        if (response == "-3") {
                                          String _msg =
                                              "Oops! Already folder name exist.";
                                          String title = "";
                                          String _icon =
                                              "assets/images/alert.json";
                                          var response = showInfoAlert(
                                              title, _msg, _icon, context);
                                        } else if (response == "-5") {
                                          String _msg =
                                              "You have limited No. of resources for creating folders! \n \n Please upgrade package.";
                                          EasyLoading.dismiss();
                                          String title = "";
                                          String _icon =
                                              "assets/images/alert.json";
                                          var response =
                                              showUpgradePackageAlert(
                                                  title, _msg, _icon, context);
                                        } else {
                                          SessionMangement _sm =
                                              SessionMangement();
                                          _sm.getNoOfFolders().then((response) {
                                            int sum = int.parse(response!) + 1;
                                            setState(() {
                                              _sm.setNoOfFolders(sum);
                                            });
                                          });
                                          Navigator.pop(context);

                                          String _msg =
                                              "Folder has been successfully Created!";
                                          EasyLoading.dismiss();
                                          String title = "Folder created";
                                          String _icon =
                                              "assets/images/Success.json";
                                          String resStatus = showInfoAlert(
                                              title, _msg, _icon, context);
                                          if (resStatus == "1") {
                                            setState(() {
                                              newFolderId = response;
                                            });
                                          }
                                        }
                                      });
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }).then((value) {
      if (newFolderId == "") {
        return null;
      } else {
        return newFolderId;
      }
    });
  }

  Future<dynamic> showAttachemnts(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      barrierColor: Theme.of(context).colorScheme.whiteColor.withOpacity(0.1),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).colorScheme.profileEditColor,
          height: 200,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _chooseFile,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).colorScheme.whiteColor,
                    child: Image.asset("assets/Icons/insert_drive_file.png",
                        width: 25, height: 25),
                  ),
                ),
                Text("Document",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontSize: 16)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _takeCameraImage,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).colorScheme.whiteColor,
                    child: Image.asset("assets/Icons/camera.png",
                        width: 25, height: 25),
                  ),
                ),
                Text("Camera",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontSize: 16)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _uploadImage,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).colorScheme.whiteColor,
                    child: Image.asset("assets/Icons/collections.png",
                        width: 25, height: 25),
                  ),
                ),
                Text("Gallery",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontSize: 16)),
              ],
            ),
          ]),
        );
      },
    );
  }
}
