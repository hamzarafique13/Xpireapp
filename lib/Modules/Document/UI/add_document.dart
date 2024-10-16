import 'dart:io';

import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Xpiree/Modules/Document/Model/DocumentModel.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';
import 'package:Xpiree/Modules/FolderList/Utils/FolderDataHelper.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class AddDocument extends StatefulWidget {
  const AddDocument({Key? key}) : super(key: key);

  @override
  AddDocumentState createState() => AddDocumentState();
}

class AddDocumentState extends State<AddDocument> {
  TblDocument modal = TblDocument();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController validForController = TextEditingController();
  TextEditingController docOwnerController = TextEditingController();
  TextEditingController docNumberController = TextEditingController();
  TextEditingController customRemindValueController = TextEditingController();
  late TextEditingController docTypeController;
  late TextEditingController folderNameController;
  int groupValue = 1;
  int cstmRemderCount = 1;
  String? docId;
  String? newFolderValue;
  String? newDocTypeValue;
  List<customReminderArray> listCustomReminderArry = [];

  DateTime currentDate = DateTime.now();

  List<TblCountry> listofCountry = [];
  List<TblState> listofStates = [];
  List<TblDocType> listofDocType = [];
  List<TblFolder> listofFolders = [];
  List<TblDocSendOn> listofSendOn = [];
  List<TblDocReminder> listofRemindOn = [];

  bool isOptionalShow = false;
  bool isCustomReminderShow = true;
  bool isIssueDateShow = false;

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
  TblPackage userPackage = TblPackage();
  List<XFile> image = [];
  List<PlatformFile> selectedfiles = [];
  var myControllers = [];
/*  PlatformFile uploadedFile;*/

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

    listofRemindOn.add(TblDocReminder(remindValue: 1));
    listofRemindOn.add(TblDocReminder(remindValue: 2));
    listofRemindOn.add(TblDocReminder(remindValue: 3));
    listofRemindOn.add(TblDocReminder(remindValue: 4));
    nameController.text = "";
    expiryDateController.text = "";
    docTypeController = TextEditingController();
    folderNameController = TextEditingController();
    validForController.text = "1";

    addNewCustomReminder();

    setState(() {
      modal.remindMe = true;
      modal.validFor = "1";
      customRemindValueController.text = defaultCustomRemindValue.toString();
    });
    EasyLoading.addStatusCallback((status) {});
    EasyLoading.show(status: 'loading...');

    fetchCountry().then((response) {
      setState(() {
        listofCountry = response!;
      });
      EasyLoading.dismiss();
    });
    fetchDocType(docId).then((response) {
      setState(() {
        listofDocType = response!;
      });
      EasyLoading.dismiss();
    });
    getfolderlist();
    getUserPackage().then((response) {
      setState(() {
        userPackage = response;
      });
      EasyLoading.dismiss();
    });
  }

  List<TblFolder> getfolderlist() {
    fetchUserFolders(docId).then((response) {
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

  var customFormat = DateFormat('MMM dd, yyyy');
  var selectionFormat = DateFormat('MM/dd/yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xff4FC2F8).withOpacity(0.1),
          backgroundColor: Theme.of(context).colorScheme.whiteColor,
          centerTitle: true,
          title: Text("Add New Document",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20)),
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  size: 20,
                  // FontAwesomeIcons.arrowLeft,
                  color: Color(0xffA7A8BB)),
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Dashboard(
                              indexTab: 0,
                            )));
              }),
        ),
        body: SafeArea(
          child: Container(
              // color: const Color(0xff4FC2F8).withOpacity(0.1),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text("Document Name",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      fontSize: 14,
                                    )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter(
                                  RegExp("[a-zA-Z0-9 *']"),
                                  allow: true)
                            ],
                            style: CustomTextStyle.textBoxStyle,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Expiration Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 14,
                                  )),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: expiryDateController,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Expiration Date is required';
                              }
                              return null;
                            },
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
                                // enabledBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .textBoxBorderColor),
                                //     borderRadius: BorderRadius.circular(25.0)),
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context).primaryColor),
                                //     borderRadius: BorderRadius.circular(25.0)),
                                hintText: 'Enter expiration date here',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              FocusScope.of(context).unfocus();

                              date = (await showDatePicker(
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  context: context,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Issue Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 14,
                                  )),
                          const SizedBox(
                            height: 10,
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
                              DateTime curentDate = DateTime.now();
                              DateTime dateOnly = DateTime(curentDate.year,
                                  curentDate.month, curentDate.day);
                              if (date != null) {
                                if (date.isBefore(dateOnly)) {
                                  issueDateController.text =
                                      customFormat.format(date);
                                  modal.issueDate = date.toString();
                                }
                              }
                            },
                          ),
                          /* Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 10),
                                      child: Text("Valid for",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                    TextFormField(
                                      controller: validForController,
                                      keyboardType: TextInputType.number,
                                      readOnly: true,
                                      style: CustomTextStyle.textBoxStyle,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .textBoxBorderColor),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        hintText: 'Valid For',
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fadeGrayColor),
                                        suffixIcon: Column(
                                          children: [
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                icon: const Icon(
                                                  FontAwesomeIcons.angleUp,
                                                  size: 15,
                                                ),
                                                onPressed: modal
                                                        .expiryDate.isEmpty
                                                    ? () {
                                                        setState(() {
                                                          int value = int.parse(
                                                                  validForController
                                                                      .text) +
                                                              1;
                                                          validForController
                                                                  .text =
                                                              value.toString();
                                                          setState(() {
                                                            modal.validFor =
                                                                value
                                                                    .toString();
                                                          });
                                                          if (value > 260) {
                                                            modal.validFor =
                                                                '0';
                                                            setState(() {
                                                              validForController
                                                                  .text = "0";
                                                            });
                                                          }

                                                          if (modal.issueDate!
                                                                  .isNotEmpty &&
                                                              modal.validForPeriod ==
                                                                  "Month") {
                                                            setState(() {
                                                              int calculateDays =
                                                                  (value) *
                                                                      (30);
                                                              DateTime?
                                                                  issueDate =
                                                                  DateTime.tryParse(
                                                                      modal
                                                                          .issueDate!);
                                                              DateTime newDate =
                                                                  issueDate!.add(
                                                                      Duration(
                                                                          days:
                                                                              calculateDays));
                                                              expiryDateController
                                                                      .text =
                                                                  customFormat
                                                                      .format(
                                                                          newDate);
                                                              modal.expiryDate =
                                                                  newDate
                                                                      .toString();
                                                            });
                                                          } else if (modal
                                                                  .issueDate!
                                                                  .isNotEmpty &&
                                                              modal.validForPeriod ==
                                                                  "Week") {
                                                            setState(() {
                                                              int calculateDays =
                                                                  (value) * (7);
                                                              DateTime?
                                                                  issueDate =
                                                                  DateTime.tryParse(
                                                                      modal
                                                                          .issueDate!);
                                                              DateTime newDate =
                                                                  issueDate!.add(
                                                                      Duration(
                                                                          days:
                                                                              calculateDays));
                                                              expiryDateController
                                                                      .text =
                                                                  customFormat
                                                                      .format(
                                                                          newDate);
                                                              modal.expiryDate =
                                                                  newDate
                                                                      .toString();
                                                            });
                                                          } else if (modal
                                                                  .issueDate!
                                                                  .isNotEmpty &&
                                                              modal.validForPeriod ==
                                                                  "Year") {
                                                            setState(() {
                                                              int calculateDays =
                                                                  (value) *
                                                                      (365);
                                                              DateTime?
                                                                  issueDate =
                                                                  DateTime.tryParse(
                                                                      modal
                                                                          .issueDate!);
                                                              DateTime newDate =
                                                                  issueDate!.add(
                                                                      Duration(
                                                                          days:
                                                                              calculateDays));
                                                              expiryDateController
                                                                      .text =
                                                                  customFormat
                                                                      .format(
                                                                          newDate);
                                                              modal.expiryDate =
                                                                  newDate
                                                                      .toString();
                                                            });
                                                          }
                                                          if (value > 5 &&
                                                              value < 61) {
                                                            setState(() {
                                                              modal.validForPeriod =
                                                                  "Month";
                                                            });
                                                          }
                                                          if (value > 61) {
                                                            setState(() {
                                                              modal.validForPeriod =
                                                                  "Week";
                                                            });
                                                          }
                                                        });
                                                      }
                                                    : null),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              icon: const Icon(
                                                FontAwesomeIcons.angleDown,
                                                size: 15,
                                              ),
                                              onPressed: modal
                                                      .expiryDate.isEmpty
                                                  ? () {
                                                      setState(() {
                                                        int value = int.parse(
                                                                validForController
                                                                    .text) -
                                                            1;
                                                        if (value > 1) {
                                                          validForController
                                                                  .text =
                                                              value.toString();
                                                        }
                                                        setState(() {
                                                          modal.validFor =
                                                              value.toString();
                                                        });
                                                        if (value > 260) {
                                                          modal.validFor = '0';
                                                          setState(() {
                                                            validForController
                                                                .text = "0";
                                                          });
                                                        }
                                                        if (modal.issueDate!
                                                                .isNotEmpty &&
                                                            modal.validForPeriod ==
                                                                "Month") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (value) * (30);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            modal.validForPeriod ==
                                                                "Week") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (value) * (7);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            modal.validForPeriod ==
                                                                "Year") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (value) * (365);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        }
                                                        if (value > 5 &&
                                                            value < 61) {
                                                          setState(() {
                                                            modal.validForPeriod =
                                                                "Month";
                                                          });
                                                        }
                                                        if (value > 61) {
                                                          setState(() {
                                                            modal.validForPeriod =
                                                                "Week";
                                                          });
                                                        }
                                                      });
                                                    }
                                                  : null,
                                            ),
                                          ],
                                        ),
                                        suffixIconConstraints:
                                            const BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              int.parse(modal.validFor!) < 6
                                  ? Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Text("",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            iconEnabledColor: Theme.of(context)
                                                .iconTheme
                                                .color,

                                            // value: modal.validForPeriod,
                                            style: CustomTextStyle.textBoxStyle,

                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(16),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .textBoxBorderColor),
                                                    borderRadius: BorderRadius.circular(
                                                        5.0)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                hintText: 'Month/s',
                                                hintStyle: TextStyle(
                                                    color: Theme.of(context).colorScheme.fadeGrayColor)),
                                            items: tripleValidPeriodList.map(
                                                (TripleValidPeriodList obj) {
                                              return DropdownMenuItem<String>(
                                                value: obj.value,
                                                child: Text(obj.title),
                                              );
                                            }).toList(),
                                            onChanged: modal.expiryDate.isEmpty
                                                ? (value) async {
                                                    setState(() {
                                                      modal.validForPeriod =
                                                          value as String;
                                                    });

                                                    if (modal.validFor!
                                                            .isNotEmpty &&
                                                        value == "Month") {
                                                      setState(() {
                                                        int calculateDays =
                                                            (int.parse(modal
                                                                    .validFor!)) *
                                                                (30);
                                                        DateTime? issueDate =
                                                            DateTime.tryParse(
                                                                modal
                                                                    .issueDate!);
                                                        DateTime newDate =
                                                            issueDate!.add(Duration(
                                                                days:
                                                                    calculateDays));
                                                        expiryDateController
                                                                .text =
                                                            customFormat.format(
                                                                newDate);
                                                        modal.expiryDate =
                                                            newDate.toString();
                                                      });
                                                    } else if (modal.validFor!
                                                            .isNotEmpty &&
                                                        value == "Week") {
                                                      setState(() {
                                                        int calculateDays =
                                                            (int.parse(modal
                                                                    .validFor!)) *
                                                                (7);
                                                        DateTime? issueDate =
                                                            DateTime.tryParse(
                                                                modal
                                                                    .issueDate!);
                                                        DateTime newDate =
                                                            issueDate!.add(Duration(
                                                                days:
                                                                    calculateDays));
                                                        expiryDateController
                                                                .text =
                                                            customFormat.format(
                                                                newDate);
                                                        modal.expiryDate =
                                                            newDate.toString();
                                                      });
                                                    } else if (modal.validFor!
                                                            .isNotEmpty &&
                                                        value == "Year") {
                                                      setState(() {
                                                        int calculateDays =
                                                            (int.parse(modal
                                                                    .validFor!)) *
                                                                (365);
                                                        DateTime? issueDate =
                                                            DateTime.tryParse(
                                                                modal
                                                                    .issueDate!);
                                                        DateTime newDate =
                                                            issueDate!.add(Duration(
                                                                days:
                                                                    calculateDays));
                                                        expiryDateController
                                                                .text =
                                                            customFormat.format(
                                                                newDate);
                                                        modal.expiryDate =
                                                            newDate.toString();
                                                      });
                                                    }
                                                  }
                                                : null,
                                          ),
                                        ],
                                      ),
                                    )
                                  : int.parse(modal.validFor!) < 61
                                      ? Container(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child: Text("",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                              ),
                                              DropdownButtonFormField(
                                                isExpanded: true,
                                                iconEnabledColor:
                                                    Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                style: CustomTextStyle
                                                    .textBoxStyle,
                                                value: modal.validForPeriod,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5,
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .textBoxBorderColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5,
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius.circular(5.0)),
                                                    hintText: 'Month/s',
                                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                items: doubleValidPeriodList
                                                    .map((DoubleValidPeriodList
                                                        obj) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: obj.value,
                                                    child: Text(obj.title),
                                                  );
                                                }).toList(),
                                                onChanged: modal
                                                        .expiryDate.isEmpty
                                                    ? (value) async {
                                                        setState(() {
                                                          modal.validForPeriod =
                                                              value as String;
                                                        });

                                                        if (modal.issueDate!
                                                                .isNotEmpty &&
                                                            value == "Month") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (30);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            value == "Week") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (7);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            value == "Year") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (365);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        }
                                                      }
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child: Text("",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                              ),
                                              DropdownButtonFormField(
                                                isExpanded: true,
                                                style: CustomTextStyle
                                                    .textBoxStyle,
                                                iconEnabledColor:
                                                    Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                value: modal.validForPeriod,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5,
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .textBoxBorderColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1.5,
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            BorderRadius.circular(5.0)),
                                                    hintText: 'Month/s',
                                                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                items: singleValidPeriodList
                                                    .map((SingleValidPeriodList
                                                        obj) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: obj.value,
                                                    child: Text(obj.title),
                                                  );
                                                }).toList(),
                                                onChanged: modal
                                                        .expiryDate.isEmpty
                                                    ? (value) async {
                                                        setState(() {
                                                          modal.validForPeriod =
                                                              value as String;
                                                        });

                                                        if (modal.validFor!
                                                                .isNotEmpty &&
                                                            value == "Month") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (30);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            value == "Week") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (7);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        } else if (modal
                                                                .issueDate!
                                                                .isNotEmpty &&
                                                            value == "Year") {
                                                          setState(() {
                                                            int calculateDays =
                                                                (int.parse(modal
                                                                        .validFor!)) *
                                                                    (365);
                                                            DateTime?
                                                                issueDate =
                                                                DateTime.tryParse(
                                                                    modal
                                                                        .issueDate!);
                                                            DateTime newDate =
                                                                issueDate!.add(
                                                                    Duration(
                                                                        days:
                                                                            calculateDays));
                                                            expiryDateController
                                                                    .text =
                                                                customFormat
                                                                    .format(
                                                                        newDate);
                                                            modal.expiryDate =
                                                                newDate
                                                                    .toString();
                                                          });
                                                        }
                                                      }
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          ),
                          */
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Document Type",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 14,
                                  )),
                          const SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       // width: MediaQuery.of(context).size.width / 1.2,
                          //       child:
                          DropdownButtonFormField(
                              isExpanded: true,
                              value: newDocTypeValue,
                              style: CustomTextStyle.textBoxStyle,
                              iconEnabledColor:
                                  Theme.of(context).iconTheme.color,
                              hint: Text("Choose from the list or add one",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fadeGrayColor)),
                              validator: (value) {
                                if (value == null) {
                                  return 'Document Type is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 17, 10, 17),

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
                                // enabledBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .textBoxBorderColor),
                                //     borderRadius:
                                //         BorderRadius.circular(25.0)),
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context)
                                //             .primaryColor),
                                //     borderRadius:
                                //         BorderRadius.circular(25.0)),
                              ),
                              items: listofDocType.map((TblDocType item) {
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
                          // ),
                          //     const SizedBox(
                          //       width: 8,
                          //     ),
                          //     Container(
                          //       height: 45,
                          //       width: 45,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(6),
                          //         color: Theme.of(context).iconTheme.color,
                          //       ),
                          //       child: IconButton(
                          //         // padding: const EdgeInsets.only(left: 6),
                          //         constraints: const BoxConstraints(),
                          //         icon: Icon(
                          //           Icons.add,
                          //           color: Theme.of(context)
                          //               .colorScheme
                          //               .whiteColor,
                          //         ),
                          //         onPressed: () async {
                          //           final response2 = await newDocType(context);
                          //           fetchDocType(null).then((response) {
                          //             setState(() {
                          //               listofDocType = response!;
                          //               if (response2 != null) {
                          //                 modal.docTypeId = response2;
                          //                 newDocTypeValue = response2;
                          //               }
                          //             });
                          //             EasyLoading.dismiss();
                          //           });
                          //         },
                          //       ),
                          //     )
                          //   ],
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Add to Folder",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 14,
                                  )),
                          const SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       // width: MediaQuery.of(context).size.width / 1.2,
                          //       child:
                          DropdownButtonFormField(
                              isExpanded: true,
                              iconEnabledColor:
                                  Theme.of(context).iconTheme.color,
                              value: newFolderValue,
                              style: CustomTextStyle.textBoxStyle,
                              hint: Text("Choose from the list or add one",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fadeGrayColor)),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(10, 17, 10, 17),
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
                                //   enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color: Theme.of(context)
                                //               .colorScheme
                                //               .textBoxBorderColor),
                                //       borderRadius:
                                //           BorderRadius.circular(25.0)),
                                //   focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color: Theme.of(context)
                                //               .primaryColor),
                                //       borderRadius:
                                //           BorderRadius.circular(5.0)),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Folder is required';
                                }
                                return null;
                              },
                              items: listofFolders.map((TblFolder item) {
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
                          //     ),
                          //     const SizedBox(
                          //       width: 8,
                          //     ),
                          //     Container(
                          //       height: 45,
                          //       width: 45,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(6),
                          //         color: Theme.of(context).iconTheme.color,
                          //       ),
                          //       child: IconButton(
                          //         // padding: const EdgeInsets.only(left: 6),
                          //         constraints: const BoxConstraints(),
                          //         icon: Icon(
                          //           Icons.add,
                          //           color: Theme.of(context)
                          //               .colorScheme
                          //               .whiteColor,
                          //         ),
                          //         onPressed: () async {
                          //           final response2 = await newFolder(context);
                          //           fetchUserFolders(null).then((response) {
                          //             setState(() {
                          //               listofFolders = response!;
                          //               if (response2 != null) {
                          //                 modal.folderId = response2;
                          //                 newFolderValue = response2;
                          //               }
                          //             });
                          //             EasyLoading.dismiss();
                          //           });
                          //         },
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.only(top: 20, bottom: 20),
                          //   child: Divider(
                          //     color: Theme.of(context).iconTheme.color,
                          //     thickness: 3,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Additional Information",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("Document Number",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 14,
                                  )),
                          const SizedBox(
                            height: 10,
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
                                // enabledBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .textBoxBorderColor),
                                //     borderRadius: BorderRadius.circular(25.0)),
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1.5,
                                //         color: Theme.of(context).primaryColor),
                                //     borderRadius: BorderRadius.circular(25.0)),
                                hintText: 'Add the document number',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            bottom: 5, top: 5),
                                        child: Text("Issued Country",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  fontSize: 14,
                                                )),
                                      ),
                                      DropdownButtonFormField(
                                          isExpanded: true,
                                          iconEnabledColor:
                                              Theme.of(context).iconTheme.color,
                                          style: CustomTextStyle.textBoxStyle,
                                          hint: Text("Select One",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fadeGrayColor)),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(17),
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
                                            // enabledBorder: OutlineInputBorder(
                                            //     borderSide: BorderSide(
                                            //         width: 1.5,
                                            //         color: Theme.of(context)
                                            //             .colorScheme
                                            //             .textBoxBorderColor),
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             25.0)),
                                            // focusedBorder: OutlineInputBorder(
                                            //     borderSide: BorderSide(
                                            //         width: 1.5,
                                            //         color: Theme.of(context)
                                            //             .primaryColor),
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             25.0)),
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
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: Text("Issued State",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                  fontSize: 14,
                                                )),
                                      ),
                                      DropdownButtonFormField(
                                          isExpanded: true,
                                          style: CustomTextStyle.textBoxStyle,
                                          iconEnabledColor:
                                              Theme.of(context).iconTheme.color,
                                          hint: Text("Select One",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fadeGrayColor)),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(17),
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
                                            // enabledBorder: OutlineInputBorder(
                                            //     borderSide: BorderSide(
                                            //         width: 1.5,
                                            //         color: Theme.of(context)
                                            //             .colorScheme
                                            //             .textBoxBorderColor),
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             25.0)),
                                            // focusedBorder: OutlineInputBorder(
                                            //     borderSide: BorderSide(
                                            //         width: 1.5,
                                            //         color: Theme.of(context)
                                            //             .primaryColor),
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             25.0)),
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
                            margin: const EdgeInsets.only(top: 10, bottom: 4),
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
                                padding: const EdgeInsets.all(0),
                                child: Wrap(
                                  spacing:
                                      8.0, // optional: add space between widgets
                                  runSpacing:
                                      8.0, // optional: add space between lines
                                  children: reminderList.map((list) {
                                    return list.remindValue != 5
                                        ? Container(
                                            width: 155,
                                            padding: const EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                              list.title,
                                              style: CustomTextStyle.heading5
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }).toList(),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
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
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  const SizedBox(width: 30
                                                      // MediaQuery.of(context)
                                                      //         .size
                                                      //         .width *
                                                      //     0.30,
                                                      ),
                                                  Switch(
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        isCustomReminderShow =
                                                            value;
                                                        list.isCheck = value;
                                                      });
                                                    },
                                                    value: isCustomReminderShow,
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                            itemCount:
                                                listCustomReminderArry.length,
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      // width:
                                                      //     MediaQuery.of(context)
                                                      //             .size
                                                      //             .width *
                                                      //         0.40,
                                                      // alignment: Alignment.center,
                                                      child: TextFormField(
                                                        controller:
                                                            myControllers[
                                                                index],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
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
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0)),

                                                          prefixIcon:
                                                              IconButton(
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                  icon:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    alignment:
                                                                        Alignment
                                                                            .center, // Aligns the icon to the center of the container
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
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
                                                          // ),
                                                          prefixIconConstraints:
                                                              const BoxConstraints(),
                                                          suffixIcon:
                                                              IconButton(
                                                                  constraints:
                                                                      const BoxConstraints(),
                                                                  icon:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                    child:
                                                                        const Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
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
                                                  ),
                                                  defaultCustomRemindValue > 12
                                                      ? Expanded(
                                                          child: Container(
                                                            // width: MediaQuery.of(
                                                            //             context)
                                                            //         .size
                                                            //         .width *
                                                            //     0.60,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            child:
                                                                DropdownButtonFormField(
                                                                    isExpanded:
                                                                        true,
                                                                    iconEnabledColor: Theme
                                                                            .of(
                                                                                context)
                                                                        .iconTheme
                                                                        .color,
                                                                    style: CustomTextStyle
                                                                        .textBoxStyle,
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
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none,
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.0)),
                                                                      // enabledBorder: OutlineInputBorder(
                                                                      //     borderSide: BorderSide(
                                                                      //         width:
                                                                      //             1.5,
                                                                      //         color: Theme.of(context)
                                                                      //             .colorScheme
                                                                      //             .textBoxBorderColor),
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(25.0)),
                                                                      // focusedBorder: OutlineInputBorder(
                                                                      //     borderSide: BorderSide(
                                                                      //         width:
                                                                      //             1.5,
                                                                      //         color: Theme.of(context)
                                                                      //             .primaryColor),
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(25.0)),
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
                                                          ),
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
                                                                  iconEnabledColor:
                                                                      Theme.of(context)
                                                                          .iconTheme
                                                                          .color,
                                                                  style: CustomTextStyle
                                                                      .textBoxStyle,
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
                                                                        borderSide:
                                                                            BorderSide
                                                                                .none,
                                                                        borderRadius:
                                                                            BorderRadius.circular(6)),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide
                                                                                .none,
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.0)),
                                                                    // enabledBorder: OutlineInputBorder(
                                                                    //     borderSide: BorderSide(
                                                                    //         width:
                                                                    //             1.5,
                                                                    //         color: Theme.of(context)
                                                                    //             .colorScheme
                                                                    //             .textBoxBorderColor),
                                                                    //     borderRadius:
                                                                    //         BorderRadius.circular(25.0)),
                                                                    // focusedBorder: OutlineInputBorder(
                                                                    //     borderSide: BorderSide(
                                                                    //         width:
                                                                    //             1.5,
                                                                    //         color: Theme.of(context)
                                                                    //             .primaryColor),
                                                                    //     borderRadius:
                                                                    //         BorderRadius.circular(25.0)),
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
                                                                      listCustomReminderArry[index]
                                                                              .customRemindPeriod =
                                                                          value
                                                                              as String;
                                                                    });
                                                                  }),
                                                        ),
                                                ],
                                              );
                                            }),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 15, 5, 5),
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
                                                    height: 40,
                                                    width: 190,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: const Text(
                                                        "Add a custom reminder",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white)),
                                                  )
                                                ],
                                              ),
                                            ))
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
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
                          image.isEmpty && selectedfiles.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    showAttachemnts(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textfiledColor,
                                      // border: Border.all(
                                      //   width: 1.5,
                                      //   color: Theme.of(context)
                                      //       .colorScheme
                                      //       .textBoxBorderColor,
                                      // ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
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
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .profileEditColor,
                                                  ),
                                                  child: const Icon(
                                                      Icons.close_rounded),
                                                ),
                                                iconSize: 15,
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
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .profileEditColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: const Icon(
                                                        Icons.close)),
                                                iconSize: 15,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          Container(
                            padding: const EdgeInsets.only(top: 30),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  primary: Color(0xff00A3FF),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Text('Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    String _msg = "";

                                    if (modal.expiryDate != modal.issueDate) {
                                      EasyLoading.show(status: 'Saving...');
                                      addDocument(
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
                                            _msg =
                                                "Start assigning tasks, add notes or share documents with your friends.";
                                            EasyLoading.dismiss();
                                            String title =
                                                "Document added successfully";
                                            String _icon =
                                                "assets/images/addDoc.png";
                                            var resStatus = showGeneralAlert(
                                                title, _msg, _icon, context);
                                            if (resStatus == "1") {
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                SessionMangement _sm =
                                                    SessionMangement();
                                                _sm
                                                    .getNoOfDocuments()
                                                    .then((response) {
                                                  setState(() {
                                                    _sm.setNoOfDocuments(
                                                        int.parse(response!) +
                                                            1);
                                                  });
                                                });
                                                late int _indexTab;
                                                final Duration durdef =
                                                    (DateTime.parse(
                                                            modal.expiryDate))
                                                        .difference(
                                                            currentDate);
                                                if (currentDate.isAfter(
                                                    DateTime.parse(
                                                        modal.expiryDate))) {
                                                  _indexTab = 0;
                                                } else if (currentDate.isBefore(
                                                        DateTime.parse(modal
                                                            .expiryDate)) &&
                                                    durdef.inDays < 60) {
                                                  _indexTab = 1;
                                                } else {
                                                  _indexTab = 2;
                                                }

                                                Navigator.pop(context, true);
                                                Navigator.pop(context, true);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Dashboard(
                                                              indexTab:
                                                                  _indexTab,
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
                                      String _icon = "assets/images/alert.json";
                                      var response = showInfoAlert(
                                          title, _msg, _icon, context);
                                    }
                                  }
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  primary: Theme.of(context)
                                      .colorScheme
                                      .textfiledColor,
                                  // Theme.of(context).colorScheme.whiteColor,
                                  elevation: 0,
                                  // side: BorderSide(
                                  //   width: 1,
                                  //   color: Theme.of(context)
                                  //       .colorScheme
                                  //       .darkGrayColor,
                                  // ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .blackColor)),
                                onPressed: () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            content: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                "Are you sure you want to cancel adding this document?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .warmGreyColor),
                                              ),
                                            ),
                                            actions: [
                                              Container(
                                                height: 36,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .textfiledColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                // padding:
                                                //     const EdgeInsets.all(10),
                                                child: TextButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    // elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),

                                                      // side: BorderSide(
                                                      //     color:
                                                      // Theme.of(
                                                      //         context)
                                                      //     .colorScheme
                                                      //     .warmGreyColor
                                                      // )
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Return",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .blackColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    docTypeController.clear();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                height: 36,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                // padding:
                                                //     const EdgeInsets.all(10),
                                                child: TextButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      // side: BorderSide(
                                                      //     color: Theme.of(
                                                      //             context)
                                                      //         .primaryColor)
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .whiteColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Dashboard(
                                                                  indexTab: 0,
                                                                )));
                                                  },
                                                ),
                                              )
                                            ],
                                          ));
                                }),
                          ),
                        ]),
                  ))),
        ));
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
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.textfiledColor,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(6)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(6.0)),
                            // enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         width: 1.5,
                            //         color: Theme.of(context)
                            //             .colorScheme
                            //             .textBoxBorderColor),
                            //     borderRadius: BorderRadius.circular(5.0)),
                            // focusedBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //         width: 1.5,
                            //         color: Theme.of(context).primaryColor),
                            //     borderRadius: BorderRadius.circular(5.0)),
                            hintText: 'Document Type here',
                            hintStyle: Theme.of(context).textTheme.headline6),
                      ))),
              /*    actions: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              elevation: 0,
                              primary: Theme.of(context).colorScheme.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textBoxBorderColor),
                              ),
                            ),
                            child: const Text("Cancel",
                                style: CustomTextStyle.heading44),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              elevation: 0,
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: const Text(
                              "Create",
                              style: CustomTextStyle.headingWhite,
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
                                    var response = showInfoAlert(
                                        title, _msg, _icon, context);
                                  } else  {
                                    Navigator.pop(context);
                                    _msg =
                                        "Document Type has been added successfully!";
                                    EasyLoading.dismiss();
                                    String title = "Document Type";
                                    String _icon = "assets/images/Success.json";
                                    var resStatus = showInfoAlert(
                                        title, _msg, _icon, context);
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
                  ),
                ),
              ], */
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
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
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
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Folder Name",
                            style: Theme.of(context).textTheme.headline4),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
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
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.textfiledColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6.0)),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         width: 1.5,
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .textBoxBorderColor),
                              //     borderRadius: BorderRadius.circular(5.0)),
                              // focusedBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         width: 1.5,
                              //         color: Theme.of(context).primaryColor),
                              //     borderRadius: BorderRadius.circular(5.0)),
                              hintText: 'New Folder e.g. Work Docs',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(fontSize: 12)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Choose color",
                                  style: Theme.of(context).textTheme.headline4),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).colorScheme.whiteColor,
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // width: MediaQuery.of(context).size.width * 0.40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(0.0),
                                      elevation: 0,
                                      primary: Theme.of(context)
                                          .colorScheme
                                          .textfiledColor,
                                      //  Theme.of(context)
                                      //     .colorScheme
                                      //     .whiteColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        // side: BorderSide(
                                        //     color: Theme.of(context)
                                        //         .colorScheme
                                        //         .textBoxBorderColor),
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
                                          borderRadius:
                                              BorderRadius.circular(6)),
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
                                                showUpgradePackageAlert(title,
                                                    _msg, _icon, context);
                                          } else {
                                            SessionMangement _sm =
                                                SessionMangement();
                                            _sm
                                                .getNoOfFolders()
                                                .then((response) {
                                              int sum =
                                                  int.parse(response!) + 1;
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
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
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          ]),
        );
      },
    );
  }
}
