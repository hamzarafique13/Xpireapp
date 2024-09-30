// ignore_for_file: unnecessary_const

import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Document/Model/DocumentModel.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:Xpiree/Shared/Utils/notification_service.dart';

import '../../Dashboard/Model/DashboardModel.dart' as dashboard;

class DocumentData extends StatefulWidget {
  final String docId;
  final int indexTab;
  const DocumentData({Key? key, required this.docId, required this.indexTab})
      : super(key: key);

  @override
  DocumentDataState createState() => DocumentDataState();
}

class DocumentDataState extends State<DocumentData> {
  List<XFile> image = [];
  dashboard.TblPackage userPackage = dashboard.TblPackage();
  List<PlatformFile> selectedfiles = [];
  void _uploadImage() async {
    Navigator.pop(context);

    final _picker = ImagePicker();

    var _pickedImage = await _picker.pickMultiImage();

    setState(() {
      if (_pickedImage != null) {
        for (int i = 0; i < _pickedImage.length; i++) {
          // modal.attachmentList.add(_pickedImage)
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

  late String docId;
  late int indexTab;
  int innerIndexTab = 0;
  bool checkBoxValue = false;
  bool _isChecked = false;

  DocumentDetail modal = DocumentDetail();
  TextEditingController notesController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String statesMessage = "";
  bool showNotesBox = true;
  List<DocShareringVm> docSharingList = [];
  List<TblAccessType> listAccessType = [];
  List<UserSharerVm> listSharerUser = [];
  List<TaskVm> listOfTasks = [];
  List<TaskVm> listOfOthersTasks = [];
  List<TaskVm> listOfCompletedTasks = [];
  final _formKey = GlobalKey<FormState>();
  List<ReminderList> reminderList = ReminderList.getList();

  TblTask taskModal = TblTask();
  UpdateTblTask updateTaskModal = UpdateTblTask();

  bool isOptionalShow = false;
  UpdateDocSharing updateDocShare = UpdateDocSharing();
  AddDocSharing addDocShare = AddDocSharing();
  int color = 0;
  int docStatus = 1;
  int accessStatus = 1;
  String? assignToValue;
  bool iscustomeReminderExist = false;
  final List _option3 = [
    'Edit',
    'Remove',
  ];

  get index => null;
  @override
  void initState() {
    super.initState();

    docId = widget.docId;
    indexTab = widget.indexTab;
    EasyLoading.show(status: 'loading...');
    getDocumentById(docId).then((response) {
      setState(() {
        modal = response!;
        docStatus = modal.docUserStatusId;
        if (modal != null) {
          if (modal.status == 3) {
            statesMessage = modal.diffTotalDays.toString() + " days/s";
          } else if (modal.status == 2) {
            statesMessage = modal.diffTotalDays.toString() + " days/s";
          } else {
            statesMessage = "Active";
          }
          if (modal.notes.isNotEmpty) {
            showNotesBox = false;
          }

          notesController.text = modal.notes;
        }
        for (int i = 0; i < modal.reminderList!.length; i++) {
          if (modal.reminderList![i].remindValue == 5) {
            iscustomeReminderExist = true;
          }
        }

        EasyLoading.dismiss();
      });
    });
    getDocSharingDataTable(docId).then((response) {
      setState(() {
        docSharingList = response!;
      });
      EasyLoading.dismiss();
    });
    fetchAccessType().then((response) {
      setState(() {
        listAccessType = response!;
      });
      EasyLoading.dismiss();
    });

    getSharerByUserDDL().then((response) {
      setState(() {
        listSharerUser = response!;
      });
      EasyLoading.dismiss();
    });
    getAssignToMeTaskByDocId(docId).then((response) {
      setState(() {
        listOfTasks = response!;
      });
      EasyLoading.dismiss();
    });
    getAssignToOthersTaskByDocId(docId).then((response) {
      setState(() {
        listOfOthersTasks = response!;
      });
      EasyLoading.dismiss();
    });
    getCompletedTaskByDocId(docId).then((response) {
      setState(() {
        listOfCompletedTasks = response!;
      });
      EasyLoading.dismiss();
    });
  }

  var myFormat = DateFormat('MMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final lightgreycolor = Theme.of(context).colorScheme.lightgrey;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
        body: modal == null
            ? Container()
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 4, top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            late int tabIndex;
                            if (modal.status == 3) {
                              tabIndex = 0;
                            }
                            if (modal.status == 1) {
                              tabIndex = 2;
                            } else {
                              tabIndex = 1;
                            }
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard(
                                          indexTab: tabIndex,
                                        )));
                          },
                          child: const Icon(Icons.arrow_back,
                              size: 20, color: Color(0xffA7A8BB)
                              // color: lightgreycolor,
                              ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: modal.status == 3
                                        ? const Color(0xffF1416C)
                                        : modal.status == 2
                                            ? const Color(0xffFFA621)
                                            : modal.status == 1
                                                ? const Color(0xff0BB783)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .whiteColor,
                                  ),
                                  child: modal.status == 3
                                      ? Image.asset(
                                          "assets/images/d.png",
                                          scale: 4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .whiteColor,
                                        )
                                      : const Icon(
                                          Icons.access_time_outlined,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        modal.docName.isEmpty
                                            ? ""
                                            : modal.docName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .blackColor,
                                                fontSize: 22)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 20,
                                          color: lightgreycolor,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                            modal.folderName == ""
                                                ? "---"
                                                : modal.folderName,
                                            style: CustomTextStyle.heading5
                                                .copyWith(
                                                    color: lightgreycolor)),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 30.0,
                                  ),
                                  child: Container(
                                    height: 26,
                                    width: 64,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: modal.status == 3
                                            ? const Color(0xffFFF5F8)
                                            : modal.status == 2
                                                ? const Color(0xffFFF8DD)
                                                : const Color(0xffE8FFF3)),
                                    child: Text(
                                      modal.status == 3
                                          ? 'Expired'
                                          : modal.status == 2
                                              ? 'Expiring'
                                              : modal.status == 1
                                                  ? 'Active'
                                                  : '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: modal.status == 3
                                            ? const Color(0xffF1416C)
                                            : modal.status == 2
                                                ? const Color(0xffFFA621)
                                                : modal.status == 1
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .activeColor
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .whiteColor,
                                      ),
                                      // textAlign: Alignment.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 30.0,
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: lightgreycolor,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              // height: 53,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        modal.expiryDate == ""
                                            ? "---"
                                            : getDateFormate(modal.expiryDate),
                                        style:
                                            CustomTextStyle.heading5.copyWith(
                                          color: modal.status == 3
                                              ? const Color(0xffF1416C)
                                              : modal.status == 2
                                                  ? const Color(0xffFFA621)
                                                  : modal.status == 1
                                                      ? const Color(0xff0BB783)
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .whiteColor,
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Expiry Date',
                                      style: TextStyle(
                                          color: lightgreycolor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            modal.status == 1
                                ? const SizedBox()
                                : Container(
                                    // height: 53,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            statesMessage.replaceAll(
                                                RegExp('-'), ''),
                                            style: CustomTextStyle.heading5
                                                .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .blackColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            modal.status == 3
                                                ? 'Renewal Overdue'
                                                : modal.status == 2
                                                    ? 'Remaining'
                                                    : '',
                                            style: TextStyle(
                                                color: lightgreycolor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            modal.status == 3
                                ? const SizedBox(
                                    width: 14,
                                  )
                                : const SizedBox(),
                            modal.status == 3
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 33,
                                        width: 33,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: const Text(
                                          'S',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Positioned(
                                        right: -20,
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                              'assets/images/sharar.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -40,
                                        child: Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                              'assets/images/s.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  DefaultTabController(
                    length: 4,
                    initialIndex: indexTab,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TabBar(
                          labelColor: Theme.of(context).colorScheme.blackColor,
                          unselectedLabelColor: lightgreycolor,
                          labelPadding: const EdgeInsets.all(5),
                          indicatorColor:
                              Theme.of(context).colorScheme.blackColor,
                          indicatorWeight: 2,
                          labelStyle: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          onTap: (index) {
                            setState(() {
                              indexTab = index;
                            });
                          },
                          tabs: const [
                            Tab(text: 'Details'),
                            Tab(text: 'Attachments'),
                            Tab(text: 'Tasks'),
                            Tab(
                              text: 'Sharing',
                            ),
                            // Tab(text: 'Sharing'),
                            // Tab(text: 'Notes'),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .dashboardbackGround,
                          ),
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     20, 20, 20, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 24, 20, 20),
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              children: [
                                                const Text(
                                                  'Document Details',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 30.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Document Type',
                                                              style: TextStyle(
                                                                  color:
                                                                      lightgreycolor,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              modal.docTypeTitle
                                                                      .isNotEmpty
                                                                  ? modal
                                                                      .docTypeTitle
                                                                  : '',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ]),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Document Number',
                                                              style: TextStyle(
                                                                  color:
                                                                      lightgreycolor,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              modal.docNumber
                                                                      .isNotEmpty
                                                                  ? modal
                                                                      .docNumber
                                                                  : '',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 30.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Issued Country',
                                                              style: TextStyle(
                                                                  color:
                                                                      lightgreycolor,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                modal.countryId
                                                                        .isEmpty
                                                                    ? "---"
                                                                    : modal
                                                                        .countryId,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: CustomTextStyle
                                                                    .heading5),
                                                          ]),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        width: 130,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 17),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Issued State',
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightgreycolor,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                    modal.stateId
                                                                            .isEmpty
                                                                        ? "---"
                                                                        : modal
                                                                            .stateId,
                                                                    style: CustomTextStyle
                                                                        .heading5),
                                                              ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20, top: 30),
                                                  child: Text("Reminder",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                              color:
                                                                  lightgreycolor)),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Wrap(
                                                    spacing:
                                                        8.0, // optional: add space between widgets
                                                    runSpacing:
                                                        8.0, // optional: add space between lines
                                                    children: reminderList
                                                        .map((list) {
                                                      return list.remindValue !=
                                                              5
                                                          ? Container(
                                                              width: 135,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              child: Text(
                                                                list.title,
                                                                style: CustomTextStyle
                                                                    .heading5
                                                                    .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            )
                                                          : Container();
                                                    }).toList(),
                                                  ),
                                                )
                                              ])
                                        ]),
                                      )),
                                  //  extra brackets
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     20, 20, 20, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 24, 20, 20),
                                    child: modal.attachmentList == null ||
                                            modal.attachmentList!.isEmpty
                                        ? SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 50,
                                                ),
                                                Image.asset(
                                                  'assets/images/attached.png',
                                                  height: 117,
                                                  width: 177,
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                Text(
                                                  'No attachment available ',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: lightgreycolor),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showAttachemnts(context);
                                                  },
                                                  child: Container(
                                                    height: 34,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: const Color(
                                                            0xffebf8ff)),
                                                    child: const Center(
                                                      child: Text(
                                                        'Add Attachment',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff00A3FF),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Attachments',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          modal.attachmentList!
                                                                  .isEmpty
                                                              ? ''
                                                              : '${modal.attachmentList!.length.toString()} total',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffA7A8BB),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showAttachemnts(
                                                            context);
                                                      },
                                                      child: Container(
                                                        height: 34,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffebf8ff)),
                                                        child: const Center(
                                                          child: Text(
                                                            'Add Attachment',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff00A3FF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 31,
                                                ),
                                                SizedBox(
                                                  child: GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                      crossAxisCount: 2,
                                                      childAspectRatio: .9,
                                                    ),
                                                    itemCount:
                                                        modal.attachmentList ==
                                                                null
                                                            ? 0
                                                            : modal
                                                                .attachmentList!
                                                                .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            // boxShadow: const [
                                                            //   BoxShadow(
                                                            //     color: Color(
                                                            //         0xffcfd5db),
                                                            //     spreadRadius:
                                                            //         3,
                                                            //     blurRadius:
                                                            //         5,
                                                            //     offset: Offset(
                                                            //         1,
                                                            //         1), // changes position of shadow
                                                            //   ),
                                                            // ],
                                                            border: Border.all(
                                                                width: .5,
                                                                color: const Color(
                                                                    0xffcfd5db)),
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                modal.attachmentList![index]
                                                                            .fileExtention ==
                                                                        ".pdf"
                                                                    ? 'assets/images/pdf.png'
                                                                    : 'assets/images/jpg.png',
                                                                height: 48,
                                                                width: 48,
                                                              ),
                                                              // Image.network(
                                                              //   imageUrl +
                                                              //       modal
                                                              //           .attachmentList![
                                                              //               index]
                                                              //           .attachmentUrl,
                                                              //   fit: BoxFit
                                                              //       .cover,
                                                              // ),
                                                              const SizedBox(
                                                                height: 13,
                                                              ),
                                                              const Text(
                                                                'Insurance Card',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xff475467)),
                                                              ),
                                                              const Text(
                                                                '1.4 MB',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xffA7A8BB)),
                                                              ),
                                                            ],
                                                          ));
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                  ),

                                  //  extra brackets
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     20, 20, 20, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 24, 20, 20),
                                    child: listOfTasks.isEmpty
                                        // ||
                                        // listOfCompletedTasks.isEmpty
                                        ? SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 50,
                                                ),
                                                Image.asset(
                                                  'assets/images/tasks.png',
                                                  height: 117,
                                                  width: 177,
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                Text(
                                                  'Assign tasks to yourself and other',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: lightgreycolor),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,

                                                      // set this to true
                                                      builder: (_) {
                                                        return SingleChildScrollView(
                                                          child: StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return Container(
                                                              color: const Color(
                                                                  0xffFFFFFF),
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                              ),
                                                              child: Form(
                                                                  key: _formKey,
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                            alignment: Alignment
                                                                                .centerRight,
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                5,
                                                                                15,
                                                                                5,
                                                                                5),
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  taskNameController.text = "";
                                                                                  taskModal.taskName = "";
                                                                                  taskModal.assignTo = "";
                                                                                  dueDateController.text = "";
                                                                                  taskModal.dueDate = "";
                                                                                  descController.text = "";
                                                                                  taskModal.description = "";
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.close,
                                                                                  color: Theme.of(context).colorScheme.blackColor,
                                                                                ))),
                                                                        Container(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                15,
                                                                                5,
                                                                                15,
                                                                                0),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text(
                                                                              "Add a New Task",
                                                                              style: CustomTextStyle.topHeading.copyWith(color: Theme.of(context).primaryColor),
                                                                            )),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text("Task Title", style: Theme.of(context).textTheme.headline6),
                                                                              // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                taskNameController,
                                                                            style:
                                                                                CustomTextStyle.textBoxStyle,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            textCapitalization:
                                                                                TextCapitalization.sentences,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Task Title is required';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                taskModal.taskName = value;
                                                                              });
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(17),
                                                                                filled: true,
                                                                                fillColor: Theme.of(context).colorScheme.textfiledColor,
                                                                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)),
                                                                                hintText: 'Add your task title here',
                                                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                            // decoration: InputDecoration(
                                                                            //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     hintText: 'Add your task title here',
                                                                            //     hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text("Description", style: Theme.of(context).textTheme.headline6),
                                                                              // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                descController,
                                                                            style:
                                                                                CustomTextStyle.textBoxStyle,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            textCapitalization:
                                                                                TextCapitalization.sentences,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Description is required';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                taskModal.description = value;
                                                                              });
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(17),
                                                                                filled: true,
                                                                                fillColor: Theme.of(context).colorScheme.textfiledColor,
                                                                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)),
                                                                                hintText: 'Add description here',
                                                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                            // decoration: InputDecoration(
                                                                            //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     // hintText: 'Add description here',
                                                                            //     // hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)

                                                                            //     ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                15,
                                                                                5,
                                                                                15,
                                                                                0),
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child: Text(
                                                                              "Assign to",
                                                                              style: Theme.of(context).textTheme.headline6,
                                                                            )),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child: DropdownButtonFormField(
                                                                              // isExpanded: true,
                                                                              hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                              alignment: Alignment.bottomCenter,
                                                                              iconEnabledColor: Theme.of(context).iconTheme.color,
                                                                              //  value: taskModal.assignTo,
                                                                              style: CustomTextStyle.textBoxStyle,
                                                                              decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(17),
                                                                                filled: true,
                                                                                fillColor: Theme.of(context).colorScheme.textfiledColor,
                                                                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)),
                                                                              ),
                                                                              // hintText: 'Add description here',
                                                                              //     // hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)
                                                                              // decoration: InputDecoration(
                                                                              //   contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17),
                                                                              //   enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                              //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                              // ),
                                                                              items: listSharerUser.map((UserSharerVm item) {
                                                                                return DropdownMenuItem(
                                                                                  child: Text(
                                                                                    item.name,
                                                                                  ),
                                                                                  value: item.userId,
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  taskModal.assignTo = value as String;
                                                                                });
                                                                              }),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text("Assign Due Date", style: Theme.of(context).textTheme.headline6),
                                                                              // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              5,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                dueDateController,
                                                                            style:
                                                                                CustomTextStyle.textBoxStyle,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            readOnly:
                                                                                true,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return 'Due Date is required';
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration: InputDecoration(
                                                                                contentPadding: const EdgeInsets.all(17),
                                                                                filled: true,
                                                                                fillColor: Theme.of(context).colorScheme.textfiledColor,
                                                                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)),
                                                                                hintText: 'Add a due date to the task',
                                                                                suffixIcon: const Icon(Icons.calendar_month, size: 20),
                                                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                            // decoration: InputDecoration(
                                                                            //     contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19),
                                                                            //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                            //     suffixIcon: const Icon(Icons.calendar_today),
                                                                            //     hintText: 'Add a due date to the task',
                                                                            //     hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                            onTap:
                                                                                () async {
                                                                              DateTime? date = DateTime(1900);
                                                                              //FocusScope.of(context).requestFocus(FocusNode());
                                                                              FocusScope.of(context).unfocus();

                                                                              date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100)));
                                                                              if (date != null) {
                                                                                dueDateController.text = myFormat.format(date);
                                                                                taskModal.dueDate = date.toString();
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              25,
                                                                              15,
                                                                              15),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              padding: const EdgeInsets.all(15),
                                                                              primary: const Color(0xff00A3FF),
                                                                              elevation: 0,
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Done',
                                                                              style: Theme.of(context).textTheme.headline3,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              if (_formKey.currentState!.validate()) {
                                                                                _formKey.currentState!.save();
                                                                                setState(() {
                                                                                  taskModal.docId = docId;
                                                                                });
                                                                                EasyLoading.addStatusCallback((status) {});
                                                                                EasyLoading.show(status: 'Saving...');
                                                                                addTask(taskModal).then((response) {
                                                                                  taskNameController.text = "";
                                                                                  descController.text = "";
                                                                                  taskModal.taskName = "";
                                                                                  taskModal.assignTo = "";
                                                                                  dueDateController.text = "";
                                                                                  taskModal.dueDate = "";
                                                                                  String _msg = "";
                                                                                  if (response == "-3") {
                                                                                    _msg = "This task has already been assigned to this user.";
                                                                                    EasyLoading.dismiss();
                                                                                    String title = "";
                                                                                    String _icon = "assets/images/alert.json";
                                                                                    var respStatus = showInfoAlert(title, _msg, _icon, context);
                                                                                    Future.delayed(const Duration(seconds: 3), () {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  } else if (response == "1") {
                                                                                    _msg = "The task has been created.";
                                                                                    EasyLoading.dismiss();
                                                                                    String title = "";
                                                                                    String _icon = "assets/images/Success.json";
                                                                                    var respStatus = showInfoAlert(title, _msg, _icon, context);
                                                                                    if (respStatus == "1") {
                                                                                      Future.delayed(const Duration(seconds: 3), () {
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    }
                                                                                  } else if (response == "-5") {
                                                                                    String _msg = "You have limited No. of resources for creating more tasks! Please upgrade your plan!";
                                                                                    EasyLoading.dismiss();
                                                                                    String title = "";
                                                                                    String _icon = "assets/images/alert.json";
                                                                                    var response = showUpgradePackageAlert(title, _msg, _icon, context);
                                                                                  } else if (response == "-6") {
                                                                                    String _msg = "You cannot assign tasks! Please upgrade your plan!";
                                                                                    EasyLoading.dismiss();
                                                                                    String title = "";
                                                                                    String _icon = "assets/images/alert.json";
                                                                                    var response = showUpgradePackageAlert(title, _msg, _icon, context);
                                                                                  }
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ])),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                    ).whenComplete(() {
                                                      getAssignToMeTaskByDocId(
                                                              docId)
                                                          .then((response) {
                                                        setState(() {
                                                          listOfTasks =
                                                              response!;
                                                        });
                                                        EasyLoading.dismiss();
                                                      });
                                                      getAssignToOthersTaskByDocId(
                                                              docId)
                                                          .then((response) {
                                                        setState(() {
                                                          listOfOthersTasks =
                                                              response!;
                                                        });
                                                        EasyLoading.dismiss();
                                                      });
                                                      getCompletedTaskByDocId(
                                                              docId)
                                                          .then((response) {
                                                        setState(() {
                                                          listOfCompletedTasks =
                                                              response!;
                                                        });
                                                        EasyLoading.dismiss();
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 34,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: const Color(
                                                            0xffebf8ff)),
                                                    child: const Center(
                                                      child: Text(
                                                        'Create Task',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff00A3FF),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'My Tasks ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          listOfTasks.length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffA7A8BB),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,

                                                          // set this to true
                                                          builder: (_) {
                                                            return SingleChildScrollView(
                                                              child: StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return Container(
                                                                  color: const Color(
                                                                      0xffFFFFFF),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom,
                                                                  ),
                                                                  child: Form(
                                                                      key:
                                                                          _formKey,
                                                                      child: Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      taskNameController.text = "";
                                                                                      taskModal.taskName = "";
                                                                                      taskModal.assignTo = "";
                                                                                      dueDateController.text = "";
                                                                                      taskModal.dueDate = "";
                                                                                      descController.text = "";
                                                                                      taskModal.description = "";
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.close,
                                                                                      color: Theme.of(context).colorScheme.blackColor,
                                                                                    ))),
                                                                            Container(
                                                                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "Add a New Task",
                                                                                  style: CustomTextStyle.topHeading.copyWith(color: Theme.of(context).primaryColor),
                                                                                )),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Text("Task Title", style: Theme.of(context).textTheme.headline6),
                                                                                  // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: TextFormField(
                                                                                controller: taskNameController,
                                                                                style: CustomTextStyle.textBoxStyle,
                                                                                keyboardType: TextInputType.text,
                                                                                textCapitalization: TextCapitalization.sentences,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Task Title is required';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    taskModal.taskName = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(contentPadding: const EdgeInsets.all(17), filled: true, fillColor: Theme.of(context).colorScheme.textfiledColor, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)), focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                                // decoration: InputDecoration(
                                                                                //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     hintText: 'Add your task title here',
                                                                                //     hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Text("Description", style: Theme.of(context).textTheme.headline6),
                                                                                  // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: TextFormField(
                                                                                controller: descController,
                                                                                style: CustomTextStyle.textBoxStyle,
                                                                                keyboardType: TextInputType.text,
                                                                                textCapitalization: TextCapitalization.sentences,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Description is required';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    taskModal.description = value;
                                                                                  });
                                                                                },
                                                                                decoration: InputDecoration(contentPadding: const EdgeInsets.all(17), filled: true, fillColor: Theme.of(context).colorScheme.textfiledColor, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)), focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                                // decoration: InputDecoration(
                                                                                //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     // hintText: 'Add description here',
                                                                                //     // hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)

                                                                                //     ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "Assign to",
                                                                                  style: Theme.of(context).textTheme.headline6,
                                                                                )),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: DropdownButtonFormField(
                                                                                  // isExpanded: true,
                                                                                  hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  iconEnabledColor: Theme.of(context).iconTheme.color,
                                                                                  //  value: taskModal.assignTo,
                                                                                  style: CustomTextStyle.textBoxStyle,
                                                                                  decoration: InputDecoration(
                                                                                    contentPadding: const EdgeInsets.all(17),
                                                                                    filled: true,
                                                                                    fillColor: Theme.of(context).colorScheme.textfiledColor,
                                                                                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                                                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)),
                                                                                  ),
                                                                                  // hintText: 'Add description here',
                                                                                  //     // hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)
                                                                                  // decoration: InputDecoration(
                                                                                  //   contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17),
                                                                                  //   enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                  //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                  // ),
                                                                                  items: listSharerUser.map((UserSharerVm item) {
                                                                                    return DropdownMenuItem(
                                                                                      child: Text(
                                                                                        item.name,
                                                                                      ),
                                                                                      value: item.userId,
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      taskModal.assignTo = value as String;
                                                                                    });
                                                                                  }),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Text("Assign Due Date", style: Theme.of(context).textTheme.headline6),
                                                                                  // Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                                              child: TextFormField(
                                                                                controller: dueDateController,
                                                                                style: CustomTextStyle.textBoxStyle,
                                                                                keyboardType: TextInputType.number,
                                                                                readOnly: true,
                                                                                validator: (value) {
                                                                                  if (value!.isEmpty) {
                                                                                    return 'Due Date is required';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                decoration: InputDecoration(contentPadding: const EdgeInsets.all(17), filled: true, fillColor: Theme.of(context).colorScheme.textfiledColor, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)), focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6.0)), hintText: 'Add a due date to the task', suffixIcon: const Icon(Icons.calendar_month, size: 20), hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                                // decoration: InputDecoration(
                                                                                //     contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19),
                                                                                //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                                                                                //     suffixIcon: const Icon(Icons.calendar_today),
                                                                                //     hintText: 'Add a due date to the task',
                                                                                //     hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                                                                                onTap: () async {
                                                                                  DateTime? date = DateTime(1900);
                                                                                  //FocusScope.of(context).requestFocus(FocusNode());
                                                                                  FocusScope.of(context).unfocus();

                                                                                  date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100)));
                                                                                  if (date != null) {
                                                                                    dueDateController.text = myFormat.format(date);
                                                                                    taskModal.dueDate = date.toString();
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  padding: const EdgeInsets.all(15),
                                                                                  primary: const Color(0xff00A3FF),
                                                                                  elevation: 0,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                                ),
                                                                                child: Text(
                                                                                  'Done',
                                                                                  style: Theme.of(context).textTheme.headline3,
                                                                                ),
                                                                                onPressed: () {
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    _formKey.currentState!.save();
                                                                                    setState(() {
                                                                                      taskModal.docId = docId;
                                                                                    });
                                                                                    EasyLoading.addStatusCallback((status) {});
                                                                                    EasyLoading.show(status: 'Saving...');
                                                                                    addTask(taskModal).then((response) {
                                                                                      taskNameController.text = "";
                                                                                      descController.text = "";
                                                                                      taskModal.taskName = "";
                                                                                      taskModal.assignTo = "";
                                                                                      dueDateController.text = "";
                                                                                      taskModal.dueDate = "";
                                                                                      String _msg = "";
                                                                                      if (response == "-3") {
                                                                                        _msg = "This task has already been assigned to this user.";
                                                                                        EasyLoading.dismiss();
                                                                                        String title = "";
                                                                                        String _icon = "assets/images/alert.json";
                                                                                        var respStatus = showInfoAlert(title, _msg, _icon, context);
                                                                                        Future.delayed(const Duration(seconds: 3), () {
                                                                                          Navigator.pop(context);
                                                                                        });
                                                                                      } else if (response == "1") {
                                                                                        _msg = "The task has been created.";
                                                                                        EasyLoading.dismiss();
                                                                                        String title = "";
                                                                                        String _icon = "assets/images/Success.json";
                                                                                        var respStatus = showInfoAlert(title, _msg, _icon, context);
                                                                                        if (respStatus == "1") {
                                                                                          Future.delayed(const Duration(seconds: 3), () {
                                                                                            Navigator.pop(context);
                                                                                          });
                                                                                        }
                                                                                      } else if (response == "-5") {
                                                                                        String _msg = "You have limited No. of resources for creating more tasks! Please upgrade your plan!";
                                                                                        EasyLoading.dismiss();
                                                                                        String title = "";
                                                                                        String _icon = "assets/images/alert.json";
                                                                                        var response = showUpgradePackageAlert(title, _msg, _icon, context);
                                                                                      } else if (response == "-6") {
                                                                                        String _msg = "You cannot assign tasks! Please upgrade your plan!";
                                                                                        EasyLoading.dismiss();
                                                                                        String title = "";
                                                                                        String _icon = "assets/images/alert.json";
                                                                                        var response = showUpgradePackageAlert(title, _msg, _icon, context);
                                                                                      }
                                                                                    });
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ])),
                                                                );
                                                              }),
                                                            );
                                                          },
                                                        ).whenComplete(() {
                                                          getAssignToMeTaskByDocId(
                                                                  docId)
                                                              .then((response) {
                                                            setState(() {
                                                              listOfTasks =
                                                                  response!;
                                                            });
                                                            EasyLoading
                                                                .dismiss();
                                                          });
                                                          getAssignToOthersTaskByDocId(
                                                                  docId)
                                                              .then((response) {
                                                            setState(() {
                                                              listOfOthersTasks =
                                                                  response!;
                                                            });
                                                            EasyLoading
                                                                .dismiss();
                                                          });
                                                          getCompletedTaskByDocId(
                                                                  docId)
                                                              .then((response) {
                                                            setState(() {
                                                              listOfCompletedTasks =
                                                                  response!;
                                                            });
                                                            EasyLoading
                                                                .dismiss();
                                                          });
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 34,
                                                        width: 120,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: const Color(
                                                                0xffebf8ff)),
                                                        child: const Center(
                                                          child: Text(
                                                            'Create Task',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff00A3FF),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                listOfCompletedTasks.isEmpty
                                                    ? const SizedBox()
                                                    : const SizedBox(
                                                        height: 20,
                                                      ),
                                                listOfCompletedTasks.isEmpty
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        height: (listOfCompletedTasks
                                                                        .length *
                                                                    60 +
                                                                (listOfCompletedTasks
                                                                            .length -
                                                                        1) *
                                                                    8)
                                                            .toDouble(),
                                                        child: ListView.builder(
                                                          itemCount:
                                                              listOfCompletedTasks
                                                                  .length,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        listOfCompletedTasks[index]
                                                                            .taskName,
                                                                        style: const TextStyle(
                                                                            color: const Color(
                                                                                0xffA7A8BB),
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Row(
                                                                        children: const [
                                                                          Text(
                                                                            'Completed',
                                                                            style: TextStyle(
                                                                                color: Color(0xff0BB783),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          Text(
                                                                            '@Myself',
                                                                            style: TextStyle(
                                                                                color: Color(0xffA7A8BB),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            14.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/checkboxes.png',
                                                                      height:
                                                                          18,
                                                                      width: 18,
                                                                    ),
                                                                  )
                                                                  // Checkbox(
                                                                  //   shape:
                                                                  //       RoundedRectangleBorder(
                                                                  //     side:
                                                                  //         BorderSide.none,
                                                                  //     borderRadius:
                                                                  //         BorderRadius.circular(5.0),
                                                                  //   ),
                                                                  //   checkColor:
                                                                  //       const Color(0xff00A3FF),
                                                                  //   value:
                                                                  //       checkBoxValue,
                                                                  //   activeColor:
                                                                  //       Theme.of(context).primaryColor,
                                                                  //   onChanged:
                                                                  //       (bool?
                                                                  //           newValue) {
                                                                  //     setState(
                                                                  //         () {
                                                                  //       checkBoxValue =
                                                                  //           newValue!;
                                                                  //     });
                                                                  //   },
                                                                  // ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                listOfTasks.isEmpty
                                                    ? const SizedBox()
                                                    : const SizedBox(
                                                        height: 0,
                                                      ),
                                                listOfTasks.isEmpty
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        height: (listOfTasks
                                                                        .length *
                                                                    60 +
                                                                (listOfTasks.length -
                                                                        1) *
                                                                    8)
                                                            .toDouble(),
                                                        child: ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemCount: listOfTasks
                                                              .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        listOfTasks[index]
                                                                            .taskName,
                                                                        style: const TextStyle(
                                                                            color: Color(
                                                                                0xff475467),
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            getDateFormate(listOfTasks[index].createdOn),
                                                                            style: const TextStyle(
                                                                                color: const Color(0xff00A3FF),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                30,
                                                                          ),
                                                                          const Text(
                                                                            '@Myself',
                                                                            style: const TextStyle(
                                                                                color: const Color(0xffA7A8BB),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Checkbox(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5)),
                                                                      value:
                                                                          false,
                                                                      // listOfTasks[index]
                                                                      //     .isCompleted,
                                                                      activeColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .profileEditColor,
                                                                      onChanged:
                                                                          (value) {
                                                                        EasyLoading.show(
                                                                            status:
                                                                                'Processing...');
                                                                        updateTaskIscompleted(listOfTasks[index].id,
                                                                                value!)
                                                                            .then((value) {
                                                                          checkPushNotificationEnable()
                                                                              .then((rsp) {
                                                                            if (rsp!.completeTask =
                                                                                true) {
                                                                              final NotificationService _notificationService = NotificationService();
                                                                              _notificationService.initialiseNotifications();
                                                                              _notificationService.sendNotifications("Task completed", "The task " + listOfCompletedTasks[index].taskName + " has been completed.");
                                                                            }
                                                                          });
                                                                          getAssignToMeTaskByDocId(docId)
                                                                              .then((response) {
                                                                            setState(() {
                                                                              listOfTasks = response!;
                                                                            });
                                                                          });
                                                                          EasyLoading
                                                                              .dismiss();
                                                                        });
                                                                        showDialog<
                                                                                String>(
                                                                            context:
                                                                                context,
                                                                            builder: (_) =>
                                                                                AlertDialog(
                                                                                  content: Container(
                                                                                    height: 410,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                                                                                    padding: const EdgeInsets.only(top: 20),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Image.asset(
                                                                                          'assets/images/happy_music.png',
                                                                                          scale: 3,
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 16,
                                                                                        ),
                                                                                        const Text(
                                                                                          "Are you sure?",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 16,
                                                                                        ),
                                                                                        Text(
                                                                                          "Tasks are critical for document renewalso we’d like you to be sure",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(color: Theme.of(context).colorScheme.warmGreyColor, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          height: 16,
                                                                                        ),
                                                                                        Container(
                                                                                            alignment: Alignment.bottomCenter,
                                                                                            padding: const EdgeInsets.only(bottom: 20),
                                                                                            child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                                  elevation: 0,
                                                                                                  primary: Theme.of(context).primaryColor,
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                                                                ),
                                                                                                child: Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  height: 50,
                                                                                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(6))),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      'Mark as Completed',
                                                                                                      style: Theme.of(context).textTheme.headline3,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                })),
                                                                                        Container(
                                                                                            alignment: Alignment.bottomCenter,
                                                                                            padding: const EdgeInsets.only(bottom: 25),
                                                                                            child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                                  elevation: 0,
                                                                                                  primary: Colors.white,
                                                                                                  // primary: Theme.of(context)
                                                                                                  //     .primaryColor,
                                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                                                                ),
                                                                                                child: Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  height: 50,
                                                                                                  decoration: const BoxDecoration(
                                                                                                      color: Colors.white,
                                                                                                      // color:
                                                                                                      //     Theme.of(context)
                                                                                                      //         .primaryColor,
                                                                                                      borderRadius: BorderRadius.all(Radius.circular(6))),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      'Not yet, take me back',
                                                                                                      style: Theme.of(context).textTheme.headline3!.copyWith(color: lightgreycolor),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                }))
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                      })
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  // padding: const EdgeInsets.fromLTRB(
                                  //     20, 20, 20, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 24, 20, 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          docSharingList.isNotEmpty
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'My Sharers',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                              docSharingList
                                                                      .isEmpty
                                                                  ? '0 total'
                                                                  : '${docSharingList.length.toString()} total',
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffA7A8BB),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            addSharing(context);
                                                          },
                                                          child: Container(
                                                            height: 34,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffebf8ff)),
                                                            child: const Center(
                                                              child: Text(
                                                                'Invite a Sharer',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff00A3FF),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 31,
                                                    ),
                                                    Wrap(
                                                        runSpacing: 8,
                                                        spacing: 8,
                                                        children: docSharingList
                                                            .map((list) {
                                                          return Row(
                                                            children: [
                                                              Container(
                                                                  width: 171,
                                                                  height: 34,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      border: Border
                                                                          .all()),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            16,
                                                                        child: docSharingList.isNotEmpty
                                                                            ? Image.network(docSharingList[index].profilePic)
                                                                            : Image.asset('assets/Icons/person.png'),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Text(docSharingList
                                                                              .isNotEmpty
                                                                          ? docSharingList[index]
                                                                              .userName
                                                                          : ''),
                                                                      const SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color:
                                                                            lightgreycolor,
                                                                      )
                                                                    ],
                                                                  ))
                                                            ],
                                                          );
                                                        }).toList())
                                                  ],
                                                )
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 50,
                                                      ),
                                                      Image.asset(
                                                        'assets/images/sharar.png',
                                                        height: 117,
                                                        width: 177,
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Text(
                                                        'Document has not been shared yet',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                lightgreycolor),
                                                      ),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          addSharing(context);
                                                        },
                                                        child: Container(
                                                          height: 34,
                                                          width: 120,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              color: const Color(
                                                                  0xffebf8ff)),
                                                          child: const Center(
                                                            child: Text(
                                                              'Invite a Sharer',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff00A3FF),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(
                              //           top: 20.0,left:24,right: 24,
                              //           bottom: 20),
                              //   child: Container(

                              //     decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius:
                              //             BorderRadius
                              //                 .circular(6)),
                              //   ),
                              // )
                              // Container(
                              //   padding: const EdgeInsets
                              //       .fromLTRB(0, 0, 8, 8),
                              //   child: Text(
                              //       "Expiration Date",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // Container(
                              //   height: 50,
                              //   alignment:
                              //       Alignment.centerLeft,
                              //   padding: const EdgeInsets
                              //           .fromLTRB(
                              //       16, 10, 10, 10),
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context)
                              //         .colorScheme
                              //         .textfiledColor,
                              //     borderRadius:
                              //         BorderRadius.circular(
                              //             6),
                              //   ),
                              //   child: Text(
                              //       modal.expiryDate == ""
                              //           ? "---"
                              //           : getDateFormate(
                              //               modal
                              //                   .expiryDate),
                              //       style: CustomTextStyle
                              //           .heading5),
                              // ),
                              // modal.issueDate == ""
                              //     ? Container()
                              //     : Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment
                              //                 .start,
                              //         children: [
                              //             Container(
                              //               padding:
                              //                   const EdgeInsets
                              //                           .fromLTRB(
                              //                       0,
                              //                       5,
                              //                       8,
                              //                       8),
                              //               child: Text(
                              //                   "Issue Date",
                              //                   style: Theme.of(
                              //                           context)
                              //                       .textTheme
                              //                       .headline6),
                              //             ),
                              //             Container(
                              //               height: 50,
                              //               alignment: Alignment
                              //                   .centerLeft,
                              //               padding:
                              //                   const EdgeInsets
                              //                           .fromLTRB(
                              //                       16,
                              //                       10,
                              //                       10,
                              //                       10),
                              //               decoration:
                              //                   BoxDecoration(
                              //                 color: Theme.of(
                              //                         context)
                              //                     .colorScheme
                              //                     .textfiledColor,
                              //                 borderRadius:
                              //                     BorderRadius
                              //                         .circular(
                              //                             6),
                              //               ),
                              //               child: Text(
                              //                   modal.issueDate ==
                              //                           ""
                              //                       ? "---"
                              //                       : getDateFormate(modal
                              //                           .issueDate),
                              //                   style: CustomTextStyle
                              //                       .heading5),
                              //             ),
                              //           ]),
                              // Container(
                              //   padding: const EdgeInsets
                              //       .fromLTRB(0, 5, 8, 8),
                              //   child: Text("Document Type",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // Container(
                              //   height: 50,
                              //   alignment:
                              //       Alignment.centerLeft,
                              //   padding: const EdgeInsets
                              //           .fromLTRB(
                              //       16, 10, 10, 10),
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context)
                              //         .colorScheme
                              //         .textfiledColor,
                              //     borderRadius:
                              //         BorderRadius.circular(
                              //             6),
                              //   ),
                              //   child: Text(
                              //       modal.docTypeTitle == ""
                              //           ? "---"
                              //           : modal
                              //               .docTypeTitle,
                              //       style: CustomTextStyle
                              //           .heading5),
                              // ),
                              // Container(
                              //   padding: const EdgeInsets
                              //       .fromLTRB(0, 5, 8, 8),
                              //   child: Text("Folder",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // Container(
                              //   height: 50,
                              //   alignment:
                              //       Alignment.centerLeft,
                              //   padding: const EdgeInsets
                              //           .fromLTRB(
                              //       16, 10, 10, 10),
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context)
                              //         .colorScheme
                              //         .textfiledColor,
                              //     borderRadius:
                              //         BorderRadius.circular(
                              //             6),
                              //   ),
                              //   child: Text(
                              //       modal.folderName == ""
                              //           ? "---"
                              //           : modal.folderName,
                              //       style: CustomTextStyle
                              //           .heading5),
                              // ),
                              // Container(
                              //   padding:
                              //       const EdgeInsets.only(
                              //           top: 15,
                              //           bottom: 15),
                              //   child: const Text(
                              //       "Additional Information",
                              //       style: TextStyle(
                              //           fontSize: 20)),
                              // ),
                              // Container(
                              //   padding: const EdgeInsets
                              //       .fromLTRB(0, 5, 8, 8),
                              //   child: Text(
                              //       "Document Number",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // Container(
                              //   height: 50,
                              //   alignment:
                              //       Alignment.centerLeft,
                              //   padding: const EdgeInsets
                              //           .fromLTRB(
                              //       16, 10, 10, 10),
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context)
                              //         .colorScheme
                              //         .textfiledColor,
                              //     borderRadius:
                              //         BorderRadius.circular(
                              //             6),
                              //   ),
                              //   child: Text(
                              //       modal.docNumber
                              //                   .isEmpty ||
                              //               modal.docNumber ==
                              //                   "null"
                              //           ? "---"
                              //           : modal.docNumber
                              //                       .length >
                              //                   15
                              //               ? modal.docNumber
                              //                       .substring(
                              //                           0,
                              //                           15) +
                              //                   "..."
                              //               : modal
                              //                   .docNumber,
                              //       style: CustomTextStyle
                              //           .heading5),
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //   children: [
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment
                              //                 .start,
                              //         children: [
                              //           Container(
                              //             padding:
                              //                 const EdgeInsets
                              //                         .fromLTRB(
                              //                     0,
                              //                     5,
                              //                     8,
                              //                     8),
                              //             child: Text(
                              //                 "Issue Country",
                              //                 style: Theme.of(
                              //                         context)
                              //                     .textTheme
                              //                     .headline6),
                              //           ),
                              //           Container(
                              //             height: 50,
                              //             alignment: Alignment
                              //                 .centerLeft,
                              //             padding:
                              //                 const EdgeInsets
                              //                         .fromLTRB(
                              //                     16,
                              //                     10,
                              //                     10,
                              //                     10),
                              //             decoration:
                              //                 BoxDecoration(
                              //               color: Theme.of(
                              //                       context)
                              //                   .colorScheme
                              //                   .textfiledColor,
                              //               borderRadius:
                              //                   BorderRadius
                              //                       .circular(
                              //                           6),
                              //             ),
                              // child: Text(
                              //     modal.countryId
                              //             .isEmpty
                              //         ? "---"
                              //         : modal
                              //             .countryId,
                              //     style: CustomTextStyle
                              //         .heading5),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment
                              //                 .start,
                              //         children: [
                              //           Container(
                              //             padding:
                              //                 const EdgeInsets
                              //                         .fromLTRB(
                              //                     0,
                              //                     5,
                              //                     8,
                              //                     8),
                              //             child: Text(
                              //                 "Issue State",
                              //                 style: Theme.of(
                              //                         context)
                              //                     .textTheme
                              //                     .headline6),
                              //           ),
                              //           Container(
                              //             height: 50,
                              //             alignment: Alignment
                              //                 .centerLeft,
                              //             padding:
                              //                 const EdgeInsets
                              //                         .fromLTRB(
                              //                     16,
                              //                     10,
                              //                     10,
                              //                     10),
                              //             decoration:
                              //                 BoxDecoration(
                              //               color: Theme.of(
                              //                       context)
                              //                   .colorScheme
                              //                   .textfiledColor,
                              //               borderRadius:
                              //                   BorderRadius
                              //                       .circular(
                              //                           6),
                              //             ),
                              //   child: Text(
                              //       modal.stateId
                              //               .isEmpty
                              //           ? "---"
                              //           : modal
                              //               .stateId,
                              //       style: CustomTextStyle
                              //           .heading5),
                              // ),
                              //         ],
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // Container(
                              //   padding:
                              //       const EdgeInsets.only(
                              //           bottom: 10,
                              //           top: 15),
                              //   child: Text(
                              //       "Default Reminders",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // Container(
                              //   padding:
                              //       const EdgeInsets.all(0),
                              //   child: Row(
                              //     children: reminderList
                              //         .map(
                              //           (list) =>
                              //               list.remindValue !=
                              //                       5
                              //                   ? Container(
                              //                       padding:
                              //                           const EdgeInsets.all(5),
                              //                       margin: const EdgeInsets.only(
                              //                           right:
                              //                               7),
                              //                       alignment:
                              //                           Alignment.centerLeft,
                              //                       decoration:
                              //                           BoxDecoration(
                              //                         border:
                              //                             Border.all(color: Theme.of(context).primaryColor),
                              //                         // color: Theme.of(context)
                              //                         //     .colorScheme
                              //                         //     .textfiledColor,
                              //                         borderRadius:
                              //                             BorderRadius.circular(25),
                              //                       ),
                              //                       child: Text(
                              //                           list
                              //                               .title,
                              //                           style:
                              //                               CustomTextStyle.heading5.copyWith(color: Theme.of(context).primaryColor, fontSize: 10)),
                              //                     )
                              //                   : Container(),
                              //         )
                              //         .toList(),
                              //   ),
                              // ),
                              // iscustomeReminderExist == true
                              //     ? Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment
                              //                 .start,
                              //         children: [
                              //           Padding(
                              //             padding:
                              //                 const EdgeInsets
                              //                         .only(
                              //                     bottom:
                              //                         10,
                              //                     top: 15),
                              //             child: Text(
                              //               "Custom Reminders",
                              //               style: Theme.of(
                              //                       context)
                              //                   .textTheme
                              //                   .headline6,
                              //             ),
                              //           ),
                              //           Row(
                              //             children: modal
                              //                 .reminderList!
                              //                 .map(
                              //                   (list) => list.remindValue ==
                              //                           5
                              //                       ? Container(
                              //                           padding:
                              //                               const EdgeInsets.all(5),
                              //                           margin:
                              //                               const EdgeInsets.only(right: 5),
                              //                           alignment:
                              //                               Alignment.centerLeft,
                              //                           decoration:
                              //                               BoxDecoration(
                              //                             border: Border.all(color: Theme.of(context).primaryColor),
                              //                             borderRadius: BorderRadius.circular(25),
                              //                           ),
                              //                           child:
                              //                               Text(
                              //                             list.customRemindValue.toString() + " " + list.customRemindPeriod,
                              //                             style: CustomTextStyle.heading6WithBlue.copyWith(fontSize: 12),
                              //                           ),
                              //                         )
                              //                       : Container(),
                              //                 )
                              //                 .toList(),
                              //           ),
                              //         ],
                              //       )
                              //     : Container(),
                              // Container(
                              //   padding: const EdgeInsets
                              //       .fromLTRB(5, 15, 5, 5),
                              //   child: Text("Attachments",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .headline6),
                              // ),
                              // modal.attachmentList != null
                              // ? modal.attachmentList!
                              //         .isNotEmpty
                              //         ? GridView.builder(
                              //             shrinkWrap: true,
                              //             physics:
                              //                 const ClampingScrollPhysics(),
                              //             gridDelegate:
                              //                 const SliverGridDelegateWithFixedCrossAxisCount(
                              //               crossAxisCount:
                              //                   3,
                              //             ),
                              // itemCount: modal
                              //             .attachmentList ==
                              //         null
                              //     ? 0
                              //     : modal
                              //         .attachmentList!
                              //         .length,
                              //             itemBuilder:
                              //                 (BuildContext
                              //                         context,
                              //                     int index) {
                              // return modal
                              //             .attachmentList![
                              //                 index]
                              //             .fileExtention ==
                              //         ".pdf"
                              //                   ? Container(
                              //                       alignment:
                              //                           Alignment
                              //                               .center,
                              //                       width: double
                              //                           .infinity,
                              //                       decoration: BoxDecoration(
                              //                           color: const Color.fromARGB(
                              //                               255,
                              //                               250,
                              //                               152,
                              //                               4),
                              //                           borderRadius: BorderRadius.circular(
                              //                               12)),
                              //                       child:
                              //                           Text(
                              //                         modal
                              //                             .attachmentList![index]
                              //                             .fileExtention,
                              //                         style:
                              //                             const TextStyle(
                              //                           fontSize:
                              //                               28,
                              //                           fontWeight:
                              //                               FontWeight.bold,
                              //                           color:
                              //                               Colors.white,
                              //                         ),
                              //                       ))
                              //                   : Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(2.0),
                              //                       child:
                              //                           ClipRRect(
                              //                         borderRadius:
                              //                             BorderRadius.circular(6),
                              //                         child:
                              //                             Image.network(imageUrl + modal.attachmentList![index].attachmentUrl),
                              //                       ),
                              //                     );
                              //             },
                              //           )
                              //         : Container(
                              //             padding:
                              //                 const EdgeInsets
                              //                     .all(8),
                              //             alignment:
                              //                 Alignment
                              //                     .center,
                              //             child: Text(
                              //                 "No attachments available",
                              //                 style: Theme.of(
                              //                         context)
                              //                     .textTheme
                              //                     .headline6),
                              //           )
                              //     : Container(
                              //         padding:
                              //             const EdgeInsets
                              //                 .all(8),
                              //         alignment:
                              //             Alignment.center,
                              //         child: Text(
                              //             "No attachments available",
                              //             style: Theme.of(
                              //                     context)
                              //                 .textTheme
                              //                 .headline6),
                              //       ),

                              // modal.isDocCreated == true
                              //     ? Expanded(
                              //         flex: 0,
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment
                              //                   .spaceBetween,
                              //           children: [
                              //             Container(
                              //               padding: const EdgeInsets
                              //                       .only(
                              //                   left: 8),
                              //               width: MediaQuery.of(
                              //                           context)
                              //                       .size
                              //                       .width *
                              //                   0.4,
                              //               child: ElevatedButton(
                              //                   style: ElevatedButton.styleFrom(
                              //                     padding:
                              //                         const EdgeInsets.all(0.0),
                              //                     primary: Theme.of(context)
                              //                         .colorScheme
                              //                         .textfiledColor,
                              //                     elevation:
                              //                         0,
                              //                     // side:
                              //                     //     const BorderSide(
                              //                     //         color: Colors
                              //                     //             .red),
                              //                     shape: RoundedRectangleBorder(
                              //                         borderRadius:
                              //                             BorderRadius.circular(6)),
                              //                   ),
                              //                   child: const Text(
                              //                     'Delete',
                              //                     style: TextStyle(
                              //                         color:
                              //                             Colors.black),
                              //                   ),
                              //                   onPressed: () {
                              //                     Widget
                              //                         deletebutton =
                              //                         Container(
                              //                       padding:
                              //                           const EdgeInsets.all(5),
                              //                       alignment:
                              //                           Alignment.center,
                              //                       child:
                              //                           Row(
                              //                         mainAxisAlignment:
                              //                             MainAxisAlignment.spaceBetween,
                              //                         children: [
                              //                           SizedBox(
                              //                             width: MediaQuery.of(context).size.width / 3,
                              //                             child: ElevatedButton(
                              //                                 style: ElevatedButton.styleFrom(
                              //                                   padding: const EdgeInsets.all(0.0),
                              //                                   elevation: 0,
                              //                                   primary: Theme.of(context).primaryColor,
                              //                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              //                                 ),
                              //                                 child: const Text(
                              //                                   "Remove",
                              //                                   style: CustomTextStyle.headingWhite,
                              //                                 ),
                              //                                 onPressed: () {
                              //                                   Navigator.pop(context);
                              //                                   EasyLoading.show(status: 'loading...');
                              //                                   deleteDocument(docId).then((response) {
                              //                                     EasyLoading.dismiss();
                              //                                     String _msg = "Document has been deleted successfully!";
                              //                                     String title = "Delete document";
                              //                                     String _icon = "assets/images/Success.json";
                              //                                     var resStatus = showInfoAlert(title, _msg, _icon, context);
                              //                                     if (resStatus == "1") {
                              //                                       Future.delayed(const Duration(seconds: 3), () {
                              //                                         SessionMangement _sm = SessionMangement();
                              //                                         _sm.getNoOfDocuments().then((res) {
                              //                                           int sum = int.parse(res!) - 1;
                              //                                           _sm.setNoOfDocuments(sum);
                              //                                         });
                              //                                         late int tabIndex;
                              //                                         if (modal.status == 3) {
                              //                                           tabIndex = 0;
                              //                                         }
                              //                                         if (modal.status == 1) {
                              //                                           tabIndex = 2;
                              //                                         } else {
                              //                                           tabIndex = 1;
                              //                                         }
                              //                                         Navigator.pop(context, true);
                              //                                         Navigator.pop(context, true);
                              //                                         checkPushNotificationEnable().then((rsp) {
                              //                                           if (rsp!.delete == true) {
                              //                                             final NotificationService _notificationService = NotificationService();
                              //                                             _notificationService.initialiseNotifications();
                              //                                             _notificationService.sendNotifications("Document delete", "Your document <b>" + modal.docName + " </b> has been successfully deleted.");
                              //                                           }
                              //                                         });
                              //                                         Navigator.push(
                              //                                             context,
                              //                                             MaterialPageRoute(
                              //                                                 builder: (context) => Dashboard(
                              //                                                       indexTab: tabIndex,
                              //                                                     )));
                              //                                       });
                              //                                     }
                              //                                   });
                              //                                 }),
                              //                           ),
                              //                           SizedBox(
                              //                               width: MediaQuery.of(context).size.width / 3,
                              //                               child: ElevatedButton(
                              //                                   style: ElevatedButton.styleFrom(
                              //                                     padding: const EdgeInsets.all(0.0),
                              //                                     elevation: 0,
                              //                                     primary: Theme.of(context).colorScheme.textfiledColor,
                              //                                     shape: RoundedRectangleBorder(
                              //                                       borderRadius: BorderRadius.circular(6),
                              //                                       // side: BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                              //                                     ),
                              //                                   ),
                              //                                   child: const Text("Cancel", style: CustomTextStyle.heading44),
                              //                                   onPressed: () {
                              //                                     Navigator.pop(context);
                              //                                   }))
                              //                         ],
                              //                       ),
                              //                     );

                              //                     AlertDialog
                              //                         alert =
                              //                         AlertDialog(
                              //                       alignment:
                              //                           Alignment.center,
                              //                       title: const Text(
                              //                           "Are you sure?",
                              //                           style: CustomTextStyle.heading2NOunderLIne,
                              //                           textAlign: TextAlign.center),
                              //                       content: Text(
                              //                           "Once removed, document & tasks shared with the Sharer will be removed from their account.",
                              //                           style: Theme.of(context).textTheme.headline6,
                              //                           textAlign: TextAlign.center),
                              //                       actions: [
                              //                         deletebutton
                              //                       ],
                              //                     );
                              //                     showDialog(
                              //                       context:
                              //                           context,
                              //                       builder:
                              //                           (BuildContext context) {
                              //                         return alert;
                              //                       },
                              //                     );
                              //                   }),
                              //             ),
                              //             Container(
                              //               padding: const EdgeInsets
                              //                       .only(
                              //                   right: 8),
                              //               width: MediaQuery.of(
                              //                           context)
                              //                       .size
                              //                       .width *
                              //                   0.4,
                              //               child: ElevatedButton(
                              //                   style: ElevatedButton.styleFrom(
                              //                     padding:
                              //                         const EdgeInsets.all(0.0),
                              //                     elevation:
                              //                         0,
                              //                     primary:
                              //                         Theme.of(context).primaryColor,
                              //                     shape: RoundedRectangleBorder(
                              //                         borderRadius:
                              //                             BorderRadius.circular(6)),
                              //                   ),
                              //                   child: Text(
                              //                     'Edit',
                              //                     style: Theme.of(context)
                              //                         .textTheme
                              //                         .headline3,
                              //                   ),
                              //                   onPressed: () {
                              //                     Navigator
                              //                         .push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                           builder: (context) => EditDocument(docDetail: modal)),
                              //                     );
                              //                   }),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                              //     : Container(),
                              // //                                             modal.docSharingEditAccess == true
                              // //                                                 ? Expanded(
                              // //                                                     flex: 0,
                              // //                                                     child: Container(
                              // //                                                       width: MediaQuery.of(
                              // //                                                               context)
                              // //                                                           .size
                              // //                                                           .width,
                              // //                                                       child: ElevatedButton(
                              // //                                                           style:
                              // //                                                               ElevatedButton
                              // //                                                                   .styleFrom(
                              // //                                                             padding:
                              // //                                                                 const EdgeInsets
                              // //                                                                     .all(0.0),
                              // //                                                             elevation: 0,
                              // //                                                             primary: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .primaryColor,
                              // //                                                             shape: RoundedRectangleBorder(
                              // //                                                                 borderRadius:
                              // //                                                                     BorderRadius
                              // //                                                                         .circular(
                              // //                                                                             5)),
                              // //                                                           ),
                              // //                                                           child: Text(
                              // //                                                             'Edit',
                              // //                                                             style: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .textTheme
                              // //                                                                 .headline3,
                              // //                                                           ),
                              // //                                                           onPressed: () {
                              // //                                                             Navigator.push(
                              // //                                                               context,
                              // //                                                               MaterialPageRoute(
                              // //                                                                   builder: (context) =>
                              // //                                                                       EditDocument(
                              // //                                                                           docDetail:
                              // //                                                                               modal)),
                              // //                                                             );
                              // //                                                           }),
                              // //                                                     ),
                              // //                                                   )
                              // //                                                 : Container()
                              // //                                           ]),
                              // //                                         )),
                              // //                                   ),
                              // //                                   Container(
                              // //                                     padding: const EdgeInsets.fromLTRB(
                              // //                                         5, 15, 5, 5),
                              // //                                     child: Column(
                              // //                                       children: [
                              // //                                         listOfTasks.isNotEmpty ||
                              // //                                                 listOfOthersTasks
                              // //                                                     .isNotEmpty ||
                              // //                                                 listOfCompletedTasks
                              // //                                                     .isNotEmpty
                              // //                                             ? DefaultTabController(
                              // //                                                 length: 3,
                              // //                                                 initialIndex: innerIndexTab,
                              // //                                                 child: Column(
                              // //                                                   crossAxisAlignment:
                              // //                                                       CrossAxisAlignment
                              // //                                                           .stretch,
                              // //                                                   children: [
                              // //                                                     Container(
                              // //                                                       height: 50,
                              // //                                                       decoration: BoxDecoration(
                              // //                                                           color: Theme.of(
                              // //                                                                   context)
                              // //                                                               .colorScheme
                              // //                                                               .textfiledColor,
                              // //                                                           borderRadius:
                              // //                                                               BorderRadius
                              // //                                                                   .circular(
                              // //                                                                       6)),
                              // //                                                       child: TabBar(
                              // //                                                         // indicator:,
                              // //                                                         padding:
                              // //                                                             EdgeInsets.zero,
                              // //                                                         labelPadding:
                              // //                                                             const EdgeInsets
                              // //                                                                 .all(0),
                              // //                                                         labelColor:
                              // //                                                             Theme.of(context)
                              // //                                                                 .colorScheme
                              // //                                                                 .blackColor,
                              // //                                                         unselectedLabelColor:
                              // //                                                             Theme.of(context)
                              // //                                                                 .colorScheme
                              // //                                                                 .blackColor,
                              // //                                                         indicatorColor:
                              // //                                                             Theme.of(context)
                              // //                                                                 .colorScheme
                              // //                                                                 .blackColor,
                              // //                                                         indicatorWeight: 3,
                              // //                                                         onTap: (index) {
                              // //                                                           setState(() {
                              // //                                                             innerIndexTab =
                              // //                                                                 index;
                              // //                                                           });
                              // //                                                           if (innerIndexTab ==
                              // //                                                               1) {
                              // //                                                             getAssignToOthersTaskByDocId(
                              // //                                                                     docId)
                              // //                                                                 .then(
                              // //                                                                     (response) {
                              // //                                                               setState(() {
                              // //                                                                 listOfOthersTasks =
                              // //                                                                     response!;
                              // //                                                               });
                              // //                                                               EasyLoading
                              // //                                                                   .dismiss();
                              // //                                                             });
                              // //                                                           } else if (innerIndexTab ==
                              // //                                                               2) {
                              // //                                                             getCompletedTaskByDocId(
                              // //                                                                     docId)
                              // //                                                                 .then(
                              // //                                                                     (response) {
                              // //                                                               setState(() {
                              // //                                                                 listOfCompletedTasks =
                              // //                                                                     response!;
                              // //                                                               });
                              // //                                                               EasyLoading
                              // //                                                                   .dismiss();
                              // //                                                             });
                              // //                                                           }
                              // //                                                         },
                              // //                                                         tabs: [
                              // //                                                           Tab(
                              // //                                                             child: Container(
                              // //                                                                 // width: MediaQuery.of(
                              // //                                                                 //             context)
                              // //                                                                 //         .size
                              // //                                                                 //         .width *
                              // //                                                                 //     0.45,
                              // //                                                                 padding: const EdgeInsets
                              // //                                                                         .fromLTRB(
                              // //                                                                     20,
                              // //                                                                     10,
                              // //                                                                     0,
                              // //                                                                     10),
                              // //                                                                 margin:
                              // //                                                                     EdgeInsets
                              // //                                                                         .zero,
                              // //                                                                 decoration:
                              // //                                                                     BoxDecoration(
                              // //                                                                   borderRadius:
                              // //                                                                       BorderRadius
                              // //                                                                           .circular(6),
                              // //                                                                   //     .only(
                              // //                                                                   // topLeft:
                              // //                                                                   //     Radius.circular(
                              // //                                                                   //         10.0),
                              // //                                                                   // bottomLeft:
                              // //                                                                   //     Radius.circular(10.0)),
                              // //                                                                   // border:
                              // //                                                                   //     Border
                              // //                                                                   //         .all(
                              // //                                                                   //   color: Theme.of(
                              // //                                                                   //           context)
                              // //                                                                   //       .colorScheme
                              // //                                                                   //       .iconThemeGray,
                              // //                                                                   // ),
                              // //                                                                   color: innerIndexTab ==
                              // //                                                                           0
                              // //                                                                       ? Theme.of(context)
                              // //                                                                           .primaryColor
                              // //                                                                       : Colors
                              // //                                                                           .transparent,
                              // //                                                                 ),
                              // //                                                                 child:
                              // //                                                                     Padding(
                              // //                                                                   padding: const EdgeInsets
                              // //                                                                           .symmetric(
                              // //                                                                       horizontal:
                              // //                                                                           7.0),
                              // //                                                                   child: Text(
                              // //                                                                       "Assigned to me",
                              // //                                                                       style: TextStyle(
                              // //                                                                           color: innerIndexTab == 0
                              // //                                                                               ? Colors.white
                              // //                                                                               : Colors.black,
                              // //                                                                           fontSize: 12,
                              // //                                                                           fontWeight: FontWeight.w600),
                              // //                                                                       textAlign: TextAlign.center),
                              // //                                                                 )),
                              // //                                                           ),
                              // //                                                           Tab(
                              // //                                                             child: Container(
                              // //                                                                 width: MediaQuery.of(context)
                              // //                                                                         .size
                              // //                                                                         .width *
                              // //                                                                     0.60,
                              // //                                                                 padding:
                              // //                                                                     const EdgeInsets.fromLTRB(
                              // //                                                                         0,
                              // //                                                                         10,
                              // //                                                                         2,
                              // //                                                                         10),
                              // //                                                                 margin:
                              // //                                                                     EdgeInsets
                              // //                                                                         .zero,
                              // //                                                                 decoration:
                              // //                                                                     BoxDecoration(
                              // //                                                                         borderRadius: BorderRadius.circular(
                              // //                                                                             6),
                              // //                                                                         // border:
                              // //                                                                         //     Border
                              // //                                                                         //         .all(
                              // //                                                                         //   color: Theme.of(
                              // //                                                                         //           context)
                              // //                                                                         //       .colorScheme
                              // //                                                                         //       .iconThemeGray,
                              // //                                                                         // ),
                              // //                                                                         color: innerIndexTab == 1
                              // //                                                                             ? Theme.of(context)
                              // //                                                                                 .primaryColor
                              // //                                                                             : Colors
                              // //                                                                                 .transparent),
                              // //                                                                 child: Text(
                              // //                                                                     "Assigned to others",
                              // //                                                                     style: TextStyle(
                              // //                                                                         color: innerIndexTab == 1 ? Colors.white : Colors.black,
                              // //                                                                         fontSize: 12,
                              // //                                                                         fontWeight: FontWeight.w600),
                              // //                                                                     textAlign: TextAlign.center)),
                              // //                                                           ),
                              // //                                                           Padding(
                              // //                                                             padding:
                              // //                                                                 const EdgeInsets
                              // //                                                                         .only(
                              // //                                                                     right:
                              // //                                                                         8.0),
                              // //                                                             child: Tab(
                              // //                                                               child: Container(
                              // //                                                                   width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                   padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              // //                                                                   margin: EdgeInsets.zero,
                              // //                                                                   decoration: BoxDecoration(
                              // //                                                                       borderRadius: BorderRadius.circular(6),
                              // //                                                                       // border:
                              // //                                                                       //     Border
                              // //                                                                       //         .all(
                              // //                                                                       //   color: Theme.of(
                              // //                                                                       //           context)
                              // //                                                                       //       .colorScheme
                              // //                                                                       //       .iconThemeGray,
                              // //                                                                       // ),
                              // //                                                                       color: innerIndexTab == 2 ? Theme.of(context).primaryColor : Colors.transparent),
                              // //                                                                   child: Text(
                              // //                                                                     "Completed",
                              // //                                                                     style:
                              // //                                                                         TextStyle(
                              // //                                                                       color: innerIndexTab ==
                              // //                                                                               2
                              // //                                                                           ? Colors.white
                              // //                                                                           : Colors.black,
                              // //                                                                       fontSize:
                              // //                                                                           12,
                              // //                                                                       fontWeight:
                              // //                                                                           FontWeight.w600,
                              // //                                                                     ),
                              // //                                                                     textAlign:
                              // //                                                                         TextAlign
                              // //                                                                             .center,
                              // //                                                                   )),
                              // //                                                             ),
                              // //                                                           ),
                              // //                                                         ],
                              // //                                                       ),
                              // //                                                     ),
                              // //                                                     SizedBox(
                              // //                                                         height: MediaQuery.of(
                              // //                                                                     context)
                              // //                                                                 .size
                              // //                                                                 .height *
                              // //                                                             0.50,
                              // //                                                         child: TabBarView(
                              // //                                                             physics:
                              // //                                                                 const NeverScrollableScrollPhysics(),
                              // //                                                             children: <
                              // //                                                                 Widget>[
                              // //                                                               ListView(
                              // //                                                                 shrinkWrap:
                              // //                                                                     true,
                              // //                                                                 physics:
                              // //                                                                     const ClampingScrollPhysics(),
                              // //                                                                 children: [
                              // //                                                                   ListView.builder(
                              // //                                                                       shrinkWrap: true,
                              // //                                                                       physics: const ClampingScrollPhysics(),
                              // //                                                                       itemCount: listOfTasks.length,
                              // //                                                                       itemBuilder: (context, index) {
                              // //                                                                         return SizedBox(
                              // //                                                                           width:
                              // //                                                                               MediaQuery.of(context).size.width,
                              // //                                                                           child:
                              // //                                                                               Row(
                              // //                                                                             crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                             children: [
                              // //                                                                               Checkbox(
                              // //                                                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                   value: listOfTasks[index].isCompleted,
                              // //                                                                                   activeColor: Theme.of(context).colorScheme.profileEditColor,
                              // //                                                                                   onChanged: (value) {
                              // //                                                                                     EasyLoading.show(status: 'Processing...');
                              // //                                                                                     updateTaskIscompleted(listOfTasks[index].id, value!).then((value) {
                              // //                                                                                       checkPushNotificationEnable().then((rsp) {
                              // //                                                                                         if (rsp!.completeTask = true) {
                              // //                                                                                           final NotificationService _notificationService = NotificationService();
                              // //                                                                                           _notificationService.initialiseNotifications();
                              // //                                                                                           _notificationService.sendNotifications("Task completed", "The task " + listOfCompletedTasks[index].taskName + " has been completed.");
                              // //                                                                                         }
                              // //                                                                                       });
                              // //                                                                                       getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                         setState(() {
                              // //                                                                                           listOfTasks = response!;
                              // //                                                                                         });
                              // //                                                                                       });
                              // //                                                                                       EasyLoading.dismiss();
                              // //                                                                                     });
                              // //                                                                                   }),
                              // //                                                                               listOfTasks[index].isCompleted == false
                              // //                                                                                   ? Expanded(
                              // //                                                                                       child: Column(
                              // //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                       children: [
                              // //                                                                                         Row(
                              // //                                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                           children: [
                              // //                                                                                             Text(listOfTasks.isEmpty ? "" : listOfTasks[index].taskName, style: Theme.of(context).textTheme.headline5),
                              // //                                                                                             PopupMenuButton(
                              // //                                                                                               icon: Icon(
                              // //                                                                                                 Icons.more_vert,
                              // //                                                                                                 color: Theme.of(context).colorScheme.warmGreyColor,
                              // //                                                                                               ),
                              // //                                                                                               itemBuilder: (BuildContext bc) {
                              // //                                                                                                 return _option3
                              // //                                                                                                     .map((obj) => PopupMenuItem(
                              // //                                                                                                           height: 40,
                              // //                                                                                                           child: obj == "Remove"
                              // //                                                                                                               ? Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.delete,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 )
                              // //                                                                                                               : Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.edit,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                           value: obj,
                              // //                                                                                                         ))
                              // //                                                                                                     .toList();
                              // //                                                                                               },
                              // //                                                                                               onSelected: modal.isDocCreated == true
                              // //                                                                                                   ? (value) {
                              // //                                                                                                       if (value == "Remove") {
                              // //                                                                                                         Widget deletebutton = Container(
                              // //                                                                                                           padding: const EdgeInsets.all(5),
                              // //                                                                                                           alignment: Alignment.center,
                              // //                                                                                                           child: Row(
                              // //                                                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                                             children: [
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                 width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                 child: ElevatedButton(
                              // //                                                                                                                     style: ElevatedButton.styleFrom(
                              // //                                                                                                                       padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                       elevation: 0,
                              // //                                                                                                                       primary: Theme.of(context).primaryColor,
                              // //                                                                                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              // //                                                                                                                     ),
                              // //                                                                                                                     child: const Text(
                              // //                                                                                                                       "Remove",
                              // //                                                                                                                       style: CustomTextStyle.headingWhite,
                              // //                                                                                                                     ),
                              // //                                                                                                                     onPressed: () {
                              // //                                                                                                                       deleteTask(listOfTasks[index].id).then((response) {
                              // //                                                                                                                         if (response == "1") {
                              // //                                                                                                                           String _msg = "The task has been deleted.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/Success.json";
                              // //                                                                                                                           Navigator.pop(context);
                              // //                                                                                                                           var response = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                         }
                              // //                                                                                                                         EasyLoading.dismiss();
                              // //                                                                                                                         getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             listOfTasks = response!;
                              // //                                                                                                                           });
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                         });
                              // //                                                                                                                       });
                              // //                                                                                                                     }),
                              // //                                                                                                               ),
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                   width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                   child: ElevatedButton(
                              // //                                                                                                                       style: ElevatedButton.styleFrom(
                              // //                                                                                                                         padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                         elevation: 0,
                              // //                                                                                                                         primary: Theme.of(context).colorScheme.textfiledColor,
                              // //                                                                                                                         shape: RoundedRectangleBorder(
                              // //                                                                                                                           borderRadius: BorderRadius.circular(6),
                              // //                                                                                                                         ),
                              // //                                                                                                                       ),
                              // //                                                                                                                       child: const Text("Cancel", style: CustomTextStyle.heading44),
                              // //                                                                                                                       onPressed: () {
                              // //                                                                                                                         Navigator.pop(context);
                              // //                                                                                                                       }))
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                         );
                              // //                                                                                                         AlertDialog alert = AlertDialog(
                              // //                                                                                                           title: const Text("Confirmation", style: CustomTextStyle.heading2NOunderLIne, textAlign: TextAlign.center),
                              // //                                                                                                           content: Text("Are you sure you want to delete this?", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                              // //                                                                                                           actions: [deletebutton],
                              // //                                                                                                         );
                              // //                                                                                                         // show the dialog
                              // //                                                                                                         showDialog(
                              // //                                                                                                           context: context,
                              // //                                                                                                           builder: (BuildContext context) {
                              // //                                                                                                             return alert;
                              // //                                                                                                           },
                              // //                                                                                                         );
                              // //                                                                                                       } else if (value == "Edit") {
                              // //                                                                                                         taskNameController.text = listOfTasks[index].taskName;
                              // //                                                                                                         descController.text = listOfTasks[index].description;
                              // //                                                                                                         dueDateController.text = getDateFormate(listOfTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.taskName = listOfTasks[index].taskName;
                              // //                                                                                                         updateTaskModal.dueDate = getDateFormate(listOfTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.description = listOfTasks[index].description;
                              // //                                                                                                         if (listOfTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           updateTaskModal.assignTo = listOfTasks[index].assignTo;
                              // //                                                                                                         }

                              // //                                                                                                         updateTaskModal.id = listOfTasks[index].id;
                              // //                                                                                                         if (listOfTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           assignToValue = listOfTasks[index].assignTo;
                              // //                                                                                                         } else {
                              // //                                                                                                           assignToValue = null;
                              // //                                                                                                         }

                              // //                                                                                                         showModalBottomSheet(
                              // //                                                                                                           isScrollControlled: true,
                              // //                                                                                                           context: context,
                              // //                                                                                                           shape: const RoundedRectangleBorder(
                              // //                                                                                                             borderRadius: BorderRadius.only(
                              // //                                                                                                               topRight: Radius.circular(20),
                              // //                                                                                                               topLeft: Radius.circular(20),
                              // //                                                                                                             ),
                              // //                                                                                                           ), // set this to true
                              // //                                                                                                           builder: (_) {
                              // //                                                                                                             return Container(
                              // //                                                                                                               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //                                                                                                               height: MediaQuery.of(context).size.height * 0.75,
                              // //                                                                                                               child: Form(
                              // //                                                                                                                   key: _formKey,
                              // //                                                                                                                   child: ListView(children: [
                              // //                                                                                                                     Container(
                              // //                                                                                                                         alignment: Alignment.centerRight,
                              // //                                                                                                                         child: IconButton(
                              // //                                                                                                                             onPressed: () {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.description = "";
                              // //                                                                                                                               Navigator.pop(context);
                              // //                                                                                                                             },
                              // //                                                                                                                             icon: Icon(
                              // //                                                                                                                               Icons.close,
                              // //                                                                                                                               color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                             ))),
                              // //                                                                                                                     Container(padding: const EdgeInsets.all(5), alignment: Alignment.center, child: const Text("Update Task")),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: taskNameController,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Task Title is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.taskName = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Description", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: descController,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Description is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.description = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           "Assign task to",
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline6,
                              // //                                                                                                                         )),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       width: MediaQuery.of(context).size.width / 3,
                              // //                                                                                                                       child: DropdownButtonFormField(
                              // //                                                                                                                           alignment: Alignment.bottomCenter,
                              // //                                                                                                                           iconEnabledColor: Theme.of(context).iconTheme.color,
                              // //                                                                                                                           value: assignToValue,
                              // //                                                                                                                           style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                           hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                           decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0))),
                              // //                                                                                                                           items: listSharerUser.map((UserSharerVm item) {
                              // //                                                                                                                             return DropdownMenuItem(
                              // //                                                                                                                               child: Text(
                              // //                                                                                                                                 item.name,
                              // //                                                                                                                               ),
                              // //                                                                                                                               value: item.userId,
                              // //                                                                                                                             );
                              // //                                                                                                                           }).toList(),
                              // //                                                                                                                           onChanged: (value) {
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.assignTo = value as String;
                              // //                                                                                                                             });
                              // //                                                                                                                           }),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Due Date", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: dueDateController,
                              // //                                                                                                                         keyboardType: TextInputType.number,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         readOnly: true,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Due Date is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), suffixIcon: const Icon(Icons.calendar_today), hintText: 'Add a due date to the task', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                         onTap: () async {
                              // //                                                                                                                           DateTime? date = DateTime(1900);
                              // //                                                                                                                           //FocusScope.of(context).requestFocus(FocusNode());
                              // //                                                                                                                           FocusScope.of(context).unfocus();

                              // //                                                                                                                           date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));
                              // //                                                                                                                           if (date == null) {
                              // //                                                                                                                             dueDateController.text = myFormat.format(date!);
                              // //                                                                                                                             updateTaskModal.dueDate = date.toString();
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                              // //                                                                                                                       child: ElevatedButton(
                              // //                                                                                                                         style: ElevatedButton.styleFrom(
                              // //                                                                                                                           padding: const EdgeInsets.all(15),
                              // //                                                                                                                           primary: Theme.of(context).primaryColor,
                              // //                                                                                                                           elevation: 0,
                              // //                                                                                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                         ),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           'Update',
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                                         ),
                              // //                                                                                                                         onPressed: () {
                              // //                                                                                                                           if (_formKey.currentState!.validate()) {
                              // //                                                                                                                             _formKey.currentState!.save();
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.docId = docId;
                              // //                                                                                                                             });
                              // //                                                                                                                             EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                                             EasyLoading.show(status: 'Saving...');
                              // //                                                                                                                             updateTask(updateTaskModal).then((response) {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               String _msg = "";
                              // //                                                                                                                               if (response == "-3") {
                              // //                                                                                                                                 _msg = "This task has already been assigned to this user.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/alert.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                                                   Navigator.pop(context);
                              // //                                                                                                                                 });
                              // //                                                                                                                               } else if (response == "1") {
                              // //                                                                                                                                 _msg = "The task has been updated.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/Success.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 if (respStatus == "1") {
                              // //                                                                                                                                   Future.delayed(const Duration(seconds: 2), () {
                              // //                                                                                                                                     Navigator.pop(context);
                              // //                                                                                                                                   });
                              // //                                                                                                                                 }
                              // //                                                                                                                               }
                              // //                                                                                                                             });
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                   ])),
                              // //                                                                                                             );
                              // //                                                                                                           },
                              // //                                                                                                         ).whenComplete(() {
                              // //                                                                                                           getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getAssignToOthersTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfOthersTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfCompletedTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                         });
                              // //                                                                                                       }
                              // //                                                                                                     }
                              // //                                                                                                   : null,
                              // //                                                                                             ),
                              // //                                                                                           ],
                              // //                                                                                         ),
                              // //                                                                                         Text(listOfTasks[index].docName, style: Theme.of(context).textTheme.headline6),
                              // //                                                                                         Padding(
                              // //                                                                                           padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              // //                                                                                           child: Row(
                              // //                                                                                             children: [
                              // //                                                                                               Container(
                              // //                                                                                                 padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                              // //                                                                                                 decoration: BoxDecoration(
                              // //                                                                                                   color: Theme.of(context).colorScheme.activeColor.withOpacity(0.2),
                              // //                                                                                                   borderRadius: BorderRadius.circular(6),
                              // //                                                                                                 ),
                              // //                                                                                                 child: Row(
                              // //                                                                                                   children: [
                              // //                                                                                                     Icon(
                              // //                                                                                                       Icons.calendar_month,
                              // //                                                                                                       color: Theme.of(context).colorScheme.activeColor,
                              // //                                                                                                       size: 12,
                              // //                                                                                                     ),
                              // //                                                                                                     Text(
                              // //                                                                                                       getDateFormate(listOfTasks[index].dueDate),
                              // //                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.activeColor, fontSize: 14, fontWeight: FontWeight.normal),
                              // //                                                                                                     ),
                              // //                                                                                                   ],
                              // //                                                                                                 ),
                              // //                                                                                               )
                              // //                                                                                             ],
                              // //                                                                                           ),
                              // //                                                                                         ),
                              // //                                                                                         Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: Divider(thickness: 1, color: Theme.of(context).colorScheme.textBoxBorderColor)),
                              // //                                                                                       ],
                              // //                                                                                     ))
                              // //                                                                                   : Expanded(
                              // //                                                                                       child: Column(
                              // //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                       children: [
                              // //                                                                                         Row(
                              // //                                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                           children: [
                              // //                                                                                             Text(
                              // //                                                                                               listOfTasks.isEmpty ? "" : listOfTasks[index].taskName,
                              // //                                                                                               style: CustomTextStyle.headline5,
                              // //                                                                                             ),
                              // //                                                                                             PopupMenuButton(
                              // //                                                                                               icon: Icon(
                              // //                                                                                                 Icons.more_vert,
                              // //                                                                                                 color: Theme.of(context).colorScheme.warmGreyColor,
                              // //                                                                                               ),
                              // //                                                                                               itemBuilder: (BuildContext bc) {
                              // //                                                                                                 return _option3
                              // //                                                                                                     .map((obj) => PopupMenuItem(
                              // //                                                                                                           height: 40,
                              // //                                                                                                           child: obj == "Remove"
                              // //                                                                                                               ? Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.delete,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 )
                              // //                                                                                                               : Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.edit,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                           value: obj,
                              // //                                                                                                         ))
                              // //                                                                                                     .toList();
                              // //                                                                                               },
                              // //                                                                                               onSelected: modal.isDocCreated == true
                              // //                                                                                                   ? (value) {
                              // //                                                                                                       if (value == "Remove") {
                              // //                                                                                                         Widget deletebutton = Container(
                              // //                                                                                                           padding: const EdgeInsets.all(5),
                              // //                                                                                                           alignment: Alignment.center,
                              // //                                                                                                           child: Row(
                              // //                                                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                                             children: [
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                 width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                 child: ElevatedButton(
                              // //                                                                                                                     style: ElevatedButton.styleFrom(
                              // //                                                                                                                       padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                       elevation: 0,
                              // //                                                                                                                       primary: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                     ),
                              // //                                                                                                                     child: const Text(
                              // //                                                                                                                       "Yes, Remove",
                              // //                                                                                                                       style: CustomTextStyle.headingWhite,
                              // //                                                                                                                     ),
                              // //                                                                                                                     onPressed: () {
                              // //                                                                                                                       deleteTask(listOfTasks[index].id).then((response) {
                              // //                                                                                                                         if (response == "1") {
                              // //                                                                                                                           String _msg = "The task has been deleted.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/Success.json";
                              // //                                                                                                                           Navigator.pop(context);
                              // //                                                                                                                           var response = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                         }
                              // //                                                                                                                         EasyLoading.dismiss();
                              // //                                                                                                                         getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             listOfTasks = response!;
                              // //                                                                                                                           });
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                         });
                              // //                                                                                                                       });
                              // //                                                                                                                     }),
                              // //                                                                                                               ),
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                   width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                   child: ElevatedButton(
                              // //                                                                                                                       style: ElevatedButton.styleFrom(
                              // //                                                                                                                         padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                         elevation: 0,
                              // //                                                                                                                         primary: Theme.of(context).colorScheme.whiteColor,
                              // //                                                                                                                         shape: RoundedRectangleBorder(
                              // //                                                                                                                           borderRadius: BorderRadius.circular(5),
                              // //                                                                                                                           side: BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                              // //                                                                                                                         ),
                              // //                                                                                                                       ),
                              // //                                                                                                                       child: const Text("Cancel", style: CustomTextStyle.heading44),
                              // //                                                                                                                       onPressed: () {
                              // //                                                                                                                         Navigator.pop(context);
                              // //                                                                                                                       }))
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                         );
                              // //                                                                                                         AlertDialog alert = AlertDialog(
                              // //                                                                                                           title: const Text("Confirmation", style: CustomTextStyle.heading2NOunderLIne, textAlign: TextAlign.center),
                              // //                                                                                                           content: Text("Are you sure you want to delete this?", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                              // //                                                                                                           actions: [deletebutton],
                              // //                                                                                                         );
                              // //                                                                                                         // show the dialog
                              // //                                                                                                         showDialog(
                              // //                                                                                                           context: context,
                              // //                                                                                                           builder: (BuildContext context) {
                              // //                                                                                                             return alert;
                              // //                                                                                                           },
                              // //                                                                                                         );
                              // //                                                                                                       } else if (value == "Edit") {
                              // //                                                                                                         taskNameController.text = listOfTasks[index].taskName;
                              // //                                                                                                         descController.text = listOfTasks[index].description;
                              // //                                                                                                         dueDateController.text = getDateFormate(listOfTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.taskName = listOfTasks[index].taskName;
                              // //                                                                                                         updateTaskModal.dueDate = getDateFormate(listOfTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.description = listOfTasks[index].description;
                              // //                                                                                                         if (listOfTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           updateTaskModal.assignTo = listOfTasks[index].assignTo;
                              // //                                                                                                         }

                              // //                                                                                                         updateTaskModal.id = listOfTasks[index].id;
                              // //                                                                                                         if (listOfTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           assignToValue = listOfTasks[index].assignTo;
                              // //                                                                                                         } else {
                              // //                                                                                                           assignToValue = null;
                              // //                                                                                                         }

                              // //                                                                                                         showModalBottomSheet(
                              // //                                                                                                           isScrollControlled: true,
                              // //                                                                                                           context: context,
                              // //                                                                                                           shape: const RoundedRectangleBorder(
                              // //                                                                                                             borderRadius: BorderRadius.only(
                              // //                                                                                                               topRight: Radius.circular(20),
                              // //                                                                                                               topLeft: Radius.circular(20),
                              // //                                                                                                             ),
                              // //                                                                                                           ), // set this to true
                              // //                                                                                                           builder: (_) {
                              // //                                                                                                             return Container(
                              // //                                                                                                               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //                                                                                                               height: MediaQuery.of(context).size.height * 0.75,
                              // //                                                                                                               child: Form(
                              // //                                                                                                                   key: _formKey,
                              // //                                                                                                                   child: ListView(children: [
                              // //                                                                                                                     Container(
                              // //                                                                                                                         alignment: Alignment.centerRight,
                              // //                                                                                                                         child: IconButton(
                              // //                                                                                                                             onPressed: () {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.description = "";
                              // //                                                                                                                               Navigator.pop(context);
                              // //                                                                                                                             },
                              // //                                                                                                                             icon: Icon(
                              // //                                                                                                                               Icons.close,
                              // //                                                                                                                               color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                             ))),
                              // //                                                                                                                     Container(padding: const EdgeInsets.all(5), alignment: Alignment.center, child: const Text("Update Task")),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: taskNameController,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Task Title is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.taskName = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Description", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: descController,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Description is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.description = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           "Assign task to",
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline6,
                              // //                                                                                                                         )),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       width: MediaQuery.of(context).size.width / 3,
                              // //                                                                                                                       child: DropdownButtonFormField(
                              // //                                                                                                                           alignment: Alignment.bottomCenter,
                              // //                                                                                                                           iconEnabledColor: Theme.of(context).iconTheme.color,
                              // //                                                                                                                           value: assignToValue,
                              // //                                                                                                                           hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                           style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                           decoration: InputDecoration(
                              // //                                                                                                                             contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17),
                              // //                                                                                                                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)),
                              // //                                                                                                                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)),
                              // //                                                                                                                           ),
                              // //                                                                                                                           items: listSharerUser.map((UserSharerVm item) {
                              // //                                                                                                                             return DropdownMenuItem(
                              // //                                                                                                                               child: Text(
                              // //                                                                                                                                 item.name,
                              // //                                                                                                                               ),
                              // //                                                                                                                               value: item.userId,
                              // //                                                                                                                             );
                              // //                                                                                                                           }).toList(),
                              // //                                                                                                                           onChanged: (value) {
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.assignTo = value as String;
                              // //                                                                                                                             });
                              // //                                                                                                                           }),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Due Date", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: dueDateController,
                              // //                                                                                                                         keyboardType: TextInputType.number,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         readOnly: true,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Due Date is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), suffixIcon: const Icon(Icons.calendar_today), hintText: 'Add a due date to the task', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                         onTap: () async {
                              // //                                                                                                                           DateTime? date = DateTime(1900);
                              // //                                                                                                                           //FocusScope.of(context).requestFocus(FocusNode());
                              // //                                                                                                                           FocusScope.of(context).unfocus();

                              // //                                                                                                                           date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));
                              // //                                                                                                                           if (date == null) {
                              // //                                                                                                                             dueDateController.text = myFormat.format(date!);
                              // //                                                                                                                             updateTaskModal.dueDate = date.toString();
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                              // //                                                                                                                       child: ElevatedButton(
                              // //                                                                                                                         style: ElevatedButton.styleFrom(
                              // //                                                                                                                           padding: const EdgeInsets.all(15),
                              // //                                                                                                                           primary: Theme.of(context).primaryColor,
                              // //                                                                                                                           elevation: 0,
                              // //                                                                                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                         ),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           'Update',
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                                         ),
                              // //                                                                                                                         onPressed: () {
                              // //                                                                                                                           if (_formKey.currentState!.validate()) {
                              // //                                                                                                                             _formKey.currentState!.save();
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.docId = docId;
                              // //                                                                                                                             });
                              // //                                                                                                                             EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                                             EasyLoading.show(status: 'Saving...');
                              // //                                                                                                                             updateTask(updateTaskModal).then((response) {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               String _msg = "";
                              // //                                                                                                                               if (response == "-3") {
                              // //                                                                                                                                 _msg = "This task has already been assigned to this user.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/alert.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                                                   Navigator.pop(context);
                              // //                                                                                                                                 });
                              // //                                                                                                                               } else if (response == "1") {
                              // //                                                                                                                                 _msg = "The task has been updated.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/Success.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 if (respStatus == "1") {
                              // //                                                                                                                                   Future.delayed(const Duration(seconds: 2), () {
                              // //                                                                                                                                     Navigator.pop(context);
                              // //                                                                                                                                   });
                              // //                                                                                                                                 }
                              // //                                                                                                                               }
                              // //                                                                                                                             });
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                   ])),
                              // //                                                                                                             );
                              // //                                                                                                             ;
                              // //                                                                                                           },
                              // //                                                                                                         ).whenComplete(() {
                              // //                                                                                                           getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getAssignToOthersTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfOthersTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfCompletedTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                         });
                              // //                                                                                                       }
                              // //                                                                                                     }
                              // //                                                                                                   : null,
                              // //                                                                                             ),
                              // //                                                                                           ],
                              // //                                                                                         ),
                              // //                                                                                         Text(listOfTasks[index].docName, style: Theme.of(context).textTheme.headline6),
                              // //                                                                                         Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: Divider(thickness: 1, color: Theme.of(context).colorScheme.textBoxBorderColor)),
                              // //                                                                                       ],
                              // //                                                                                     )),
                              // //                                                                             ],
                              // //                                                                           ),
                              // //                                                                         );
                              // //                                                                       }),
                              // //                                                                 ],
                              // //                                                               ),
                              // //                                                               ListView(
                              // //                                                                 shrinkWrap:
                              // //                                                                     true,
                              // //                                                                 physics:
                              // //                                                                     const ClampingScrollPhysics(),
                              // //                                                                 children: [
                              // //                                                                   ListView.builder(
                              // //                                                                       shrinkWrap: true,
                              // //                                                                       physics: const ClampingScrollPhysics(),
                              // //                                                                       itemCount: listOfOthersTasks.length,
                              // //                                                                       itemBuilder: (context, index) {
                              // //                                                                         return Container(
                              // //                                                                           width:
                              // //                                                                               MediaQuery.of(context).size.width,
                              // //                                                                           padding:
                              // //                                                                               const EdgeInsets.all(0),
                              // //                                                                           child:
                              // //                                                                               Row(
                              // //                                                                             crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                             children: [
                              // //                                                                               Checkbox(
                              // //                                                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                   value: listOfOthersTasks[index].isCompleted,
                              // //                                                                                   activeColor: Theme.of(context).colorScheme.profileEditColor,
                              // //                                                                                   onChanged: (value) {
                              // //                                                                                     EasyLoading.show(status: 'Processing...');
                              // //                                                                                     updateTaskIscompleted(listOfOthersTasks[index].id, value!).then((value) {
                              // //                                                                                       checkPushNotificationEnable().then((rsp) {
                              // //                                                                                         if (rsp!.completeTask = true) {
                              // //                                                                                           final NotificationService _notificationService = NotificationService();
                              // //                                                                                           _notificationService.initialiseNotifications();
                              // //                                                                                           _notificationService.sendNotifications("Task completed", "The task " + listOfCompletedTasks[index].taskName + " has been completed.");
                              // //                                                                                         }
                              // //                                                                                       });
                              // //                                                                                       getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                         setState(() {
                              // //                                                                                           listOfOthersTasks = response!;
                              // //                                                                                         });
                              // //                                                                                       });
                              // //                                                                                       EasyLoading.dismiss();
                              // //                                                                                     });
                              // //                                                                                   }),
                              // //                                                                               listOfOthersTasks[index].isCompleted == false
                              // //                                                                                   ? Expanded(
                              // //                                                                                       child: Column(
                              // //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                       children: [
                              // //                                                                                         Row(
                              // //                                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                           children: [
                              // //                                                                                             Text(listOfOthersTasks.isEmpty ? "" : listOfOthersTasks[index].taskName, style: Theme.of(context).textTheme.headline5),
                              // //                                                                                             PopupMenuButton(
                              // //                                                                                               icon: Icon(
                              // //                                                                                                 Icons.more_vert,
                              // //                                                                                                 color: Theme.of(context).colorScheme.warmGreyColor,
                              // //                                                                                               ),
                              // //                                                                                               itemBuilder: (BuildContext bc) {
                              // //                                                                                                 return _option3
                              // //                                                                                                     .map((obj) => PopupMenuItem(
                              // //                                                                                                           height: 40,
                              // //                                                                                                           child: obj == "Remove"
                              // //                                                                                                               ? Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.delete,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 )
                              // //                                                                                                               : Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.edit,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                           value: obj,
                              // //                                                                                                         ))
                              // //                                                                                                     .toList();
                              // //                                                                                               },
                              // //                                                                                               onSelected: modal.isDocCreated == true
                              // //                                                                                                   ? (value) {
                              // //                                                                                                       if (value == "Remove") {
                              // //                                                                                                         Widget deletebutton = Container(
                              // //                                                                                                           padding: const EdgeInsets.all(5),
                              // //                                                                                                           alignment: Alignment.center,
                              // //                                                                                                           child: Row(
                              // //                                                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                                             children: [
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                 width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                 child: ElevatedButton(
                              // //                                                                                                                     style: ElevatedButton.styleFrom(
                              // //                                                                                                                       padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                       elevation: 0,
                              // //                                                                                                                       primary: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                     ),
                              // //                                                                                                                     child: const Text(
                              // //                                                                                                                       "Yes, Remove",
                              // //                                                                                                                       style: CustomTextStyle.headingWhite,
                              // //                                                                                                                     ),
                              // //                                                                                                                     onPressed: () {
                              // //                                                                                                                       deleteTask(listOfOthersTasks[index].id).then((response) {
                              // //                                                                                                                         if (response == "1") {
                              // //                                                                                                                           String _msg = "The task has been deleted.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/Success.json";
                              // //                                                                                                                           Navigator.pop(context);
                              // //                                                                                                                           var response = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                         }
                              // //                                                                                                                         EasyLoading.dismiss();
                              // //                                                                                                                         getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             listOfOthersTasks = response!;
                              // //                                                                                                                           });
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                         });
                              // //                                                                                                                       });
                              // //                                                                                                                     }),
                              // //                                                                                                               ),
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                   width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                   child: ElevatedButton(
                              // //                                                                                                                       style: ElevatedButton.styleFrom(
                              // //                                                                                                                         padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                         elevation: 0,
                              // //                                                                                                                         primary: Theme.of(context).colorScheme.whiteColor,
                              // //                                                                                                                         shape: RoundedRectangleBorder(
                              // //                                                                                                                           borderRadius: BorderRadius.circular(5),
                              // //                                                                                                                           side: BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                              // //                                                                                                                         ),
                              // //                                                                                                                       ),
                              // //                                                                                                                       child: const Text("Cancel", style: CustomTextStyle.heading44),
                              // //                                                                                                                       onPressed: () {
                              // //                                                                                                                         Navigator.pop(context);
                              // //                                                                                                                       }))
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                         );
                              // //                                                                                                         AlertDialog alert = AlertDialog(
                              // //                                                                                                           title: const Text("Confirmation", style: CustomTextStyle.heading2NOunderLIne, textAlign: TextAlign.center),
                              // //                                                                                                           content: Text("Are you sure you want to delete this?", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                              // //                                                                                                           actions: [deletebutton],
                              // //                                                                                                         );
                              // //                                                                                                         // show the dialog
                              // //                                                                                                         showDialog(
                              // //                                                                                                           context: context,
                              // //                                                                                                           builder: (BuildContext context) {
                              // //                                                                                                             return alert;
                              // //                                                                                                           },
                              // //                                                                                                         );
                              // //                                                                                                       } else if (value == "Edit") {
                              // //                                                                                                         taskNameController.text = listOfOthersTasks[index].taskName;
                              // //                                                                                                         descController.text = listOfOthersTasks[index].description;
                              // //                                                                                                         dueDateController.text = getDateFormate(listOfOthersTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.taskName = listOfOthersTasks[index].taskName;
                              // //                                                                                                         updateTaskModal.dueDate = getDateFormate(listOfOthersTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.description = listOfOthersTasks[index].description;
                              // //                                                                                                         updateTaskModal.assignTo = listOfOthersTasks[index].assignTo;

                              // //                                                                                                         updateTaskModal.id = listOfOthersTasks[index].id;
                              // //                                                                                                         if (listOfOthersTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           assignToValue = listOfOthersTasks[index].assignTo;
                              // //                                                                                                         } else {
                              // //                                                                                                           assignToValue = null;
                              // //                                                                                                         }

                              // //                                                                                                         showModalBottomSheet(
                              // //                                                                                                           isScrollControlled: true,
                              // //                                                                                                           context: context,
                              // //                                                                                                           shape: const RoundedRectangleBorder(
                              // //                                                                                                             borderRadius: BorderRadius.only(
                              // //                                                                                                               topRight: Radius.circular(20),
                              // //                                                                                                               topLeft: Radius.circular(20),
                              // //                                                                                                             ),
                              // //                                                                                                           ), // set this to true
                              // //                                                                                                           builder: (_) {
                              // //                                                                                                             return Container(
                              // //                                                                                                               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //                                                                                                               height: MediaQuery.of(context).size.height * 0.75,
                              // //                                                                                                               child: Form(
                              // //                                                                                                                   key: _formKey,
                              // //                                                                                                                   child: ListView(children: [
                              // //                                                                                                                     Container(
                              // //                                                                                                                         alignment: Alignment.centerRight,
                              // //                                                                                                                         child: IconButton(
                              // //                                                                                                                             onPressed: () {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.description = "";
                              // //                                                                                                                               Navigator.pop(context);
                              // //                                                                                                                             },
                              // //                                                                                                                             icon: Icon(
                              // //                                                                                                                               Icons.close,
                              // //                                                                                                                               color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                             ))),
                              // //                                                                                                                     Container(padding: const EdgeInsets.all(5), alignment: Alignment.center, child: const Text("Update Task")),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: taskNameController,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Task Title is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.taskName = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Description", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: descController,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Description is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.description = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           "Assign task to",
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline6,
                              // //                                                                                                                         )),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       width: MediaQuery.of(context).size.width / 3,
                              // //                                                                                                                       child: DropdownButtonFormField(
                              // //                                                                                                                           // isExpanded: true,
                              // //                                                                                                                           alignment: Alignment.bottomCenter,
                              // //                                                                                                                           iconEnabledColor: Theme.of(context).iconTheme.color,
                              // //                                                                                                                           value: assignToValue,
                              // //                                                                                                                           hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                           style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                           decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0))),
                              // //                                                                                                                           items: listSharerUser.map((UserSharerVm item) {
                              // //                                                                                                                             return DropdownMenuItem(
                              // //                                                                                                                               child: Text(
                              // //                                                                                                                                 item.name,
                              // //                                                                                                                               ),
                              // //                                                                                                                               value: item.userId,
                              // //                                                                                                                             );
                              // //                                                                                                                           }).toList(),
                              // //                                                                                                                           onChanged: (value) {
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.assignTo = value as String;
                              // //                                                                                                                             });
                              // //                                                                                                                           }),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Due Date", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: dueDateController,
                              // //                                                                                                                         keyboardType: TextInputType.number,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         readOnly: true,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Due Date is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), suffixIcon: const Icon(Icons.calendar_today), hintText: 'Add a due date to the task', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                         onTap: () async {
                              // //                                                                                                                           DateTime? date = DateTime(1900);
                              // //                                                                                                                           //FocusScope.of(context).requestFocus(FocusNode());
                              // //                                                                                                                           FocusScope.of(context).unfocus();

                              // //                                                                                                                           date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));
                              // //                                                                                                                           if (date == null) {
                              // //                                                                                                                             dueDateController.text = myFormat.format(date!);
                              // //                                                                                                                             updateTaskModal.dueDate = date.toString();
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                              // //                                                                                                                       child: ElevatedButton(
                              // //                                                                                                                         style: ElevatedButton.styleFrom(
                              // //                                                                                                                           padding: const EdgeInsets.all(15),
                              // //                                                                                                                           primary: Theme.of(context).primaryColor,
                              // //                                                                                                                           elevation: 0,
                              // //                                                                                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                         ),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           'Update',
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                                         ),
                              // //                                                                                                                         onPressed: () {
                              // //                                                                                                                           if (_formKey.currentState!.validate()) {
                              // //                                                                                                                             _formKey.currentState!.save();
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.docId = docId;
                              // //                                                                                                                             });
                              // //                                                                                                                             EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                                             EasyLoading.show(status: 'Saving...');
                              // //                                                                                                                             updateTask(updateTaskModal).then((response) {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               String _msg = "";
                              // //                                                                                                                               if (response == "-3") {
                              // //                                                                                                                                 _msg = "This task has already been assigned to this user.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/alert.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                                                   Navigator.pop(context);
                              // //                                                                                                                                 });
                              // //                                                                                                                               } else if (response == "1") {
                              // //                                                                                                                                 _msg = "The task has been updated.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/Success.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 if (respStatus == "1") {
                              // //                                                                                                                                   Future.delayed(const Duration(seconds: 2), () {
                              // //                                                                                                                                     Navigator.pop(context);
                              // //                                                                                                                                   });
                              // //                                                                                                                                 }
                              // //                                                                                                                               }
                              // //                                                                                                                             });
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                   ])),
                              // //                                                                                                             );
                              // //                                                                                                           },
                              // //                                                                                                         ).whenComplete(() {
                              // //                                                                                                           getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getAssignToOthersTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfOthersTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfCompletedTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                         });
                              // //                                                                                                       }
                              // //                                                                                                     }
                              // //                                                                                                   : null,
                              // //                                                                                             ),
                              // //                                                                                           ],
                              // //                                                                                         ),
                              // //                                                                                         Text(listOfOthersTasks[index].docName, style: Theme.of(context).textTheme.headline6),
                              // //                                                                                         Padding(
                              // //                                                                                           padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              // //                                                                                           child: Row(
                              // //                                                                                             children: [
                              // //                                                                                               Container(
                              // //                                                                                                 padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                              // //                                                                                                 decoration: BoxDecoration(
                              // //                                                                                                   color: Theme.of(context).colorScheme.activeColor.withOpacity(0.2),
                              // //                                                                                                   borderRadius: BorderRadius.circular(6),
                              // //                                                                                                 ),
                              // //                                                                                                 child: Row(
                              // //                                                                                                   children: [
                              // //                                                                                                     Icon(
                              // //                                                                                                       Icons.calendar_month,
                              // //                                                                                                       color: Theme.of(context).colorScheme.activeColor,
                              // //                                                                                                       size: 12,
                              // //                                                                                                     ),
                              // //                                                                                                     Text(
                              // //                                                                                                       getDateFormate(listOfOthersTasks[index].dueDate),
                              // //                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.activeColor, fontSize: 14, fontWeight: FontWeight.normal),
                              // //                                                                                                     ),
                              // //                                                                                                   ],
                              // //                                                                                                 ),
                              // //                                                                                               )
                              // //                                                                                             ],
                              // //                                                                                           ),
                              // //                                                                                         ),
                              // //                                                                                         Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: Divider(thickness: 1, color: Theme.of(context).colorScheme.textBoxBorderColor)),
                              // //                                                                                       ],
                              // //                                                                                     ))
                              // //                                                                                   : Expanded(
                              // //                                                                                       child: Column(
                              // //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                       children: [
                              // //                                                                                         Row(
                              // //                                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                           children: [
                              // //                                                                                             Text(
                              // //                                                                                               listOfOthersTasks.isEmpty ? "" : listOfOthersTasks[index].taskName,
                              // //                                                                                               style: CustomTextStyle.headline5,
                              // //                                                                                             ),
                              // //                                                                                             PopupMenuButton(
                              // //                                                                                               icon: Icon(
                              // //                                                                                                 Icons.more_vert,
                              // //                                                                                                 color: Theme.of(context).colorScheme.warmGreyColor,
                              // //                                                                                               ),
                              // //                                                                                               itemBuilder: (BuildContext bc) {
                              // //                                                                                                 return _option3
                              // //                                                                                                     .map((obj) => PopupMenuItem(
                              // //                                                                                                           height: 40,
                              // //                                                                                                           child: obj == "Remove"
                              // //                                                                                                               ? Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.delete,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 )
                              // //                                                                                                               : Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Icon(
                              // //                                                                                                                       Icons.edit,
                              // //                                                                                                                       color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                       size: 18,
                              // //                                                                                                                     ),
                              // //                                                                                                                     Text(
                              // //                                                                                                                       obj,
                              // //                                                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                                                     )
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                           value: obj,
                              // //                                                                                                         ))
                              // //                                                                                                     .toList();
                              // //                                                                                               },
                              // //                                                                                               onSelected: modal.isDocCreated == true
                              // //                                                                                                   ? (value) {
                              // //                                                                                                       if (value == "Remove") {
                              // //                                                                                                         Widget deletebutton = Container(
                              // //                                                                                                           padding: const EdgeInsets.all(5),
                              // //                                                                                                           alignment: Alignment.center,
                              // //                                                                                                           child: Row(
                              // //                                                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                                             children: [
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                 width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                 child: ElevatedButton(
                              // //                                                                                                                     style: ElevatedButton.styleFrom(
                              // //                                                                                                                       padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                       elevation: 0,
                              // //                                                                                                                       primary: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                     ),
                              // //                                                                                                                     child: const Text(
                              // //                                                                                                                       "Yes, Remove",
                              // //                                                                                                                       style: CustomTextStyle.headingWhite,
                              // //                                                                                                                     ),
                              // //                                                                                                                     onPressed: () {
                              // //                                                                                                                       deleteTask(listOfOthersTasks[index].id).then((response) {
                              // //                                                                                                                         if (response == "1") {
                              // //                                                                                                                           String _msg = "The task has been deleted.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/Success.json";
                              // //                                                                                                                           Navigator.pop(context);
                              // //                                                                                                                           var response = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                         }
                              // //                                                                                                                         EasyLoading.dismiss();
                              // //                                                                                                                         getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             listOfOthersTasks = response!;
                              // //                                                                                                                           });
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                         });
                              // //                                                                                                                       });
                              // //                                                                                                                     }),
                              // //                                                                                                               ),
                              // //                                                                                                               SizedBox(
                              // //                                                                                                                   width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                                   child: ElevatedButton(
                              // //                                                                                                                       style: ElevatedButton.styleFrom(
                              // //                                                                                                                         padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                         elevation: 0,
                              // //                                                                                                                         primary: Theme.of(context).colorScheme.whiteColor,
                              // //                                                                                                                         shape: RoundedRectangleBorder(
                              // //                                                                                                                           borderRadius: BorderRadius.circular(5),
                              // //                                                                                                                           side: BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                              // //                                                                                                                         ),
                              // //                                                                                                                       ),
                              // //                                                                                                                       child: const Text("Cancel", style: CustomTextStyle.heading44),
                              // //                                                                                                                       onPressed: () {
                              // //                                                                                                                         Navigator.pop(context);
                              // //                                                                                                                       }))
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                         );
                              // //                                                                                                         AlertDialog alert = AlertDialog(
                              // //                                                                                                           title: const Text("Confirmation", style: CustomTextStyle.heading2NOunderLIne, textAlign: TextAlign.center),
                              // //                                                                                                           content: Text("Are you sure you want to delete this?", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                              // //                                                                                                           actions: [deletebutton],
                              // //                                                                                                         );
                              // //                                                                                                         // show the dialog
                              // //                                                                                                         showDialog(
                              // //                                                                                                           context: context,
                              // //                                                                                                           builder: (BuildContext context) {
                              // //                                                                                                             return alert;
                              // //                                                                                                           },
                              // //                                                                                                         );
                              // //                                                                                                       } else if (value == "Edit") {
                              // //                                                                                                         taskNameController.text = listOfOthersTasks[index].taskName;
                              // //                                                                                                         descController.text = listOfOthersTasks[index].description;
                              // //                                                                                                         dueDateController.text = getDateFormate(listOfOthersTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.taskName = listOfOthersTasks[index].taskName;
                              // //                                                                                                         updateTaskModal.dueDate = getDateFormate(listOfOthersTasks[index].dueDate);
                              // //                                                                                                         updateTaskModal.description = listOfOthersTasks[index].description;
                              // //                                                                                                         updateTaskModal.assignTo = listOfOthersTasks[index].assignTo;

                              // //                                                                                                         updateTaskModal.id = listOfOthersTasks[index].id;
                              // //                                                                                                         if (listOfOthersTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                           assignToValue = listOfOthersTasks[index].assignTo;
                              // //                                                                                                         } else {
                              // //                                                                                                           assignToValue = null;
                              // //                                                                                                         }

                              // //                                                                                                         showModalBottomSheet(
                              // //                                                                                                           isScrollControlled: true,
                              // //                                                                                                           context: context,
                              // //                                                                                                           shape: const RoundedRectangleBorder(
                              // //                                                                                                             borderRadius: BorderRadius.only(
                              // //                                                                                                               topRight: Radius.circular(20),
                              // //                                                                                                               topLeft: Radius.circular(20),
                              // //                                                                                                             ),
                              // //                                                                                                           ), // set this to true
                              // //                                                                                                           builder: (_) {
                              // //                                                                                                             return Container(
                              // //                                                                                                               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //                                                                                                               height: MediaQuery.of(context).size.height * 0.75,
                              // //                                                                                                               child: Form(
                              // //                                                                                                                   key: _formKey,
                              // //                                                                                                                   child: ListView(children: [
                              // //                                                                                                                     Container(
                              // //                                                                                                                         alignment: Alignment.centerRight,
                              // //                                                                                                                         child: IconButton(
                              // //                                                                                                                             onPressed: () {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.description = "";
                              // //                                                                                                                               Navigator.pop(context);
                              // //                                                                                                                             },
                              // //                                                                                                                             icon: Icon(
                              // //                                                                                                                               Icons.close,
                              // //                                                                                                                               color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                             ))),
                              // //                                                                                                                     Container(padding: const EdgeInsets.all(5), alignment: Alignment.center, child: const Text("Update Task")),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: taskNameController,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Task Title is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.taskName = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Description", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: descController,
                              // //                                                                                                                         keyboardType: TextInputType.text,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Description is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         onChanged: (value) {
                              // //                                                                                                                           setState(() {
                              // //                                                                                                                             updateTaskModal.description = value;
                              // //                                                                                                                           });
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                         padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           "Assign task to",
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline6,
                              // //                                                                                                                         )),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       width: MediaQuery.of(context).size.width / 3,
                              // //                                                                                                                       child: DropdownButtonFormField(
                              // //                                                                                                                           // isExpanded: true,
                              // //                                                                                                                           hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                           alignment: Alignment.bottomCenter,
                              // //                                                                                                                           iconEnabledColor: Theme.of(context).iconTheme.color,
                              // //                                                                                                                           value: assignToValue,
                              // //                                                                                                                           style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                           decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0))),
                              // //                                                                                                                           items: listSharerUser.map((UserSharerVm item) {
                              // //                                                                                                                             return DropdownMenuItem(
                              // //                                                                                                                               child: Text(
                              // //                                                                                                                                 item.name,
                              // //                                                                                                                               ),
                              // //                                                                                                                               value: item.userId,
                              // //                                                                                                                             );
                              // //                                                                                                                           }).toList(),
                              // //                                                                                                                           onChanged: (value) {
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.assignTo = value as String;
                              // //                                                                                                                             });
                              // //                                                                                                                           }),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: Row(
                              // //                                                                                                                         children: [
                              // //                                                                                                                           Text("Due Date", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                           Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                         ],
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                       child: TextFormField(
                              // //                                                                                                                         controller: dueDateController,
                              // //                                                                                                                         keyboardType: TextInputType.number,
                              // //                                                                                                                         style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                         readOnly: true,
                              // //                                                                                                                         validator: (value) {
                              // //                                                                                                                           if (value!.isEmpty) {
                              // //                                                                                                                             return 'Due Date is required';
                              // //                                                                                                                           }
                              // //                                                                                                                           return null;
                              // //                                                                                                                         },
                              // //                                                                                                                         decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), suffixIcon: const Icon(Icons.calendar_today), hintText: 'Add a due date to the task', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                         onTap: () async {
                              // //                                                                                                                           DateTime? date = DateTime(1900);
                              // //                                                                                                                           //FocusScope.of(context).requestFocus(FocusNode());
                              // //                                                                                                                           FocusScope.of(context).unfocus();

                              // //                                                                                                                           date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));
                              // //                                                                                                                           if (date == null) {
                              // //                                                                                                                             dueDateController.text = myFormat.format(date!);
                              // //                                                                                                                             updateTaskModal.dueDate = date.toString();
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                     Container(
                              // //                                                                                                                       padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                              // //                                                                                                                       child: ElevatedButton(
                              // //                                                                                                                         style: ElevatedButton.styleFrom(
                              // //                                                                                                                           padding: const EdgeInsets.all(15),
                              // //                                                                                                                           primary: Theme.of(context).primaryColor,
                              // //                                                                                                                           elevation: 0,
                              // //                                                                                                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                         ),
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           'Update',
                              // //                                                                                                                           style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                                         ),
                              // //                                                                                                                         onPressed: () {
                              // //                                                                                                                           if (_formKey.currentState!.validate()) {
                              // //                                                                                                                             _formKey.currentState!.save();
                              // //                                                                                                                             setState(() {
                              // //                                                                                                                               updateTaskModal.docId = docId;
                              // //                                                                                                                             });
                              // //                                                                                                                             EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                                             EasyLoading.show(status: 'Saving...');
                              // //                                                                                                                             updateTask(updateTaskModal).then((response) {
                              // //                                                                                                                               taskNameController.text = "";
                              // //                                                                                                                               descController.text = "";
                              // //                                                                                                                               updateTaskModal.taskName = "";
                              // //                                                                                                                               updateTaskModal.assignTo = "";
                              // //                                                                                                                               dueDateController.text = "";
                              // //                                                                                                                               updateTaskModal.dueDate = "";
                              // //                                                                                                                               String _msg = "";
                              // //                                                                                                                               if (response == "-3") {
                              // //                                                                                                                                 _msg = "This task has already been assigned to this user.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/alert.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                                                   Navigator.pop(context);
                              // //                                                                                                                                 });
                              // //                                                                                                                               } else if (response == "1") {
                              // //                                                                                                                                 _msg = "The task has been updated.";
                              // //                                                                                                                                 EasyLoading.dismiss();
                              // //                                                                                                                                 String title = "";
                              // //                                                                                                                                 String _icon = "assets/images/Success.json";
                              // //                                                                                                                                 var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                                 if (respStatus == "1") {
                              // //                                                                                                                                   Future.delayed(const Duration(seconds: 2), () {
                              // //                                                                                                                                     Navigator.pop(context);
                              // //                                                                                                                                   });
                              // //                                                                                                                                 }
                              // //                                                                                                                               }
                              // //                                                                                                                             });
                              // //                                                                                                                           }
                              // //                                                                                                                         },
                              // //                                                                                                                       ),
                              // //                                                                                                                     ),
                              // //                                                                                                                   ])),
                              // //                                                                                                             );
                              // //                                                                                                           },
                              // //                                                                                                         ).whenComplete(() {
                              // //                                                                                                           getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getAssignToOthersTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfOthersTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                           getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                             setState(() {
                              // //                                                                                                               listOfCompletedTasks = response!;
                              // //                                                                                                             });
                              // //                                                                                                             EasyLoading.dismiss();
                              // //                                                                                                           });
                              // //                                                                                                         });
                              // //                                                                                                       }
                              // //                                                                                                     }
                              // //                                                                                                   : null,
                              // //                                                                                             ),
                              // //                                                                                           ],
                              // //                                                                                         ),
                              // //                                                                                         Text(listOfOthersTasks[index].docName, style: Theme.of(context).textTheme.headline6),
                              // //                                                                                         Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: Divider(thickness: 1, color: Theme.of(context).colorScheme.textBoxBorderColor)),
                              // //                                                                                       ],
                              // //                                                                                     )),
                              // //                                                                             ],
                              // //                                                                           ),
                              // //                                                                         );
                              // //                                                                       }),
                              // //                                                                 ],
                              // //                                                               ),
                              // //                                                               ListView(
                              // //                                                                 shrinkWrap:
                              // //                                                                     true,
                              // //                                                                 physics:
                              // //                                                                     const ClampingScrollPhysics(),
                              // //                                                                 children: [
                              // //                                                                   ListView.builder(
                              // //                                                                       shrinkWrap: true,
                              // //                                                                       physics: const ClampingScrollPhysics(),
                              // //                                                                       itemCount: listOfCompletedTasks.length,
                              // //                                                                       itemBuilder: (context, index) {
                              // //                                                                         return Container(
                              // //                                                                           width:
                              // //                                                                               MediaQuery.of(context).size.width,
                              // //                                                                           padding: const EdgeInsets.fromLTRB(
                              // //                                                                               5,
                              // //                                                                               10,
                              // //                                                                               5,
                              // //                                                                               5),
                              // //                                                                           child:
                              // //                                                                               Row(
                              // //                                                                             crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                             children: [
                              // //                                                                               Checkbox(
                              // //                                                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                   value: listOfCompletedTasks[index].isCompleted,
                              // //                                                                                   activeColor: Theme.of(context).colorScheme.profileEditColor,
                              // //                                                                                   onChanged: (value) {
                              // //                                                                                     EasyLoading.show(status: 'Processing...');
                              // //                                                                                     updateTaskIscompleted(listOfCompletedTasks[index].id, value!).then((value) {
                              // //                                                                                       checkPushNotificationEnable().then((rsp) {
                              // //                                                                                         if (rsp!.completeTask = true) {
                              // //                                                                                           final NotificationService _notificationService = NotificationService();
                              // //                                                                                           _notificationService.initialiseNotifications();
                              // //                                                                                           _notificationService.sendNotifications("Task completed", "The task " + listOfCompletedTasks[index].taskName + " has been completed.");
                              // //                                                                                         }
                              // //                                                                                       });
                              // //                                                                                       getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                         setState(() {
                              // //                                                                                           listOfCompletedTasks = response!;
                              // //                                                                                         });
                              // //                                                                                       });
                              // //                                                                                       EasyLoading.dismiss();
                              // //                                                                                     });
                              // //                                                                                   }),
                              // //                                                                               Expanded(
                              // //                                                                                   child: Column(
                              // //                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                 children: [
                              // //                                                                                   Row(
                              // //                                                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                     children: [
                              // //                                                                                       Text(listOfCompletedTasks.isEmpty ? "" : listOfCompletedTasks[index].taskName, style: Theme.of(context).textTheme.headline5),
                              // //                                                                                       PopupMenuButton(
                              // //                                                                                         icon: Icon(
                              // //                                                                                           Icons.more_vert,
                              // //                                                                                           color: Theme.of(context).colorScheme.warmGreyColor,
                              // //                                                                                         ),
                              // //                                                                                         itemBuilder: (BuildContext bc) {
                              // //                                                                                           return _option3
                              // //                                                                                               .map((obj) => PopupMenuItem(
                              // //                                                                                                     height: 40,
                              // //                                                                                                     child: obj == "Remove"
                              // //                                                                                                         ? Row(
                              // //                                                                                                             children: [
                              // //                                                                                                               Icon(
                              // //                                                                                                                 Icons.delete,
                              // //                                                                                                                 color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                 size: 18,
                              // //                                                                                                               ),
                              // //                                                                                                               Text(
                              // //                                                                                                                 obj,
                              // //                                                                                                                 style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                                               )
                              // //                                                                                                             ],
                              // //                                                                                                           )
                              // //                                                                                                         : Row(
                              // //                                                                                                             children: [
                              // //                                                                                                               Icon(
                              // //                                                                                                                 Icons.edit,
                              // //                                                                                                                 color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                 size: 18,
                              // //                                                                                                               ),
                              // //                                                                                                               Text(
                              // //                                                                                                                 obj,
                              // //                                                                                                                 style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                                               )
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                     value: obj,
                              // //                                                                                                   ))
                              // //                                                                                               .toList();
                              // //                                                                                         },
                              // //                                                                                         onSelected: modal.isDocCreated == true
                              // //                                                                                             ? (value) {
                              // //                                                                                                 if (value == "Remove") {
                              // //                                                                                                   Widget deletebutton = Container(
                              // //                                                                                                     padding: const EdgeInsets.all(5),
                              // //                                                                                                     alignment: Alignment.center,
                              // //                                                                                                     child: Row(
                              // //                                                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                                                                                                       children: [
                              // //                                                                                                         SizedBox(
                              // //                                                                                                           width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                           child: ElevatedButton(
                              // //                                                                                                               style: ElevatedButton.styleFrom(
                              // //                                                                                                                 padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                 elevation: 0,
                              // //                                                                                                                 primary: Theme.of(context).colorScheme.redColor,
                              // //                                                                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                               ),
                              // //                                                                                                               child: const Text(
                              // //                                                                                                                 "Yes, Remove",
                              // //                                                                                                                 style: CustomTextStyle.headingWhite,
                              // //                                                                                                               ),
                              // //                                                                                                               onPressed: () {
                              // //                                                                                                                 deleteTask(listOfCompletedTasks[index].id).then((response) {
                              // //                                                                                                                   if (response == "1") {
                              // //                                                                                                                     String _msg = "The task has been deleted.";
                              // //                                                                                                                     EasyLoading.dismiss();
                              // //                                                                                                                     String title = "";
                              // //                                                                                                                     String _icon = "assets/images/Success.json";
                              // //                                                                                                                     Navigator.pop(context);
                              // //                                                                                                                     var response = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                   }
                              // //                                                                                                                   EasyLoading.dismiss();
                              // //                                                                                                                   getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                                     setState(() {
                              // //                                                                                                                       listOfCompletedTasks = response!;
                              // //                                                                                                                     });
                              // //                                                                                                                     EasyLoading.dismiss();
                              // //                                                                                                                   });
                              // //                                                                                                                 });
                              // //                                                                                                               }),
                              // //                                                                                                         ),
                              // //                                                                                                         SizedBox(
                              // //                                                                                                             width: MediaQuery.of(context).size.width * 0.30,
                              // //                                                                                                             child: ElevatedButton(
                              // //                                                                                                                 style: ElevatedButton.styleFrom(
                              // //                                                                                                                   padding: const EdgeInsets.all(0.0),
                              // //                                                                                                                   elevation: 0,
                              // //                                                                                                                   primary: Theme.of(context).colorScheme.whiteColor,
                              // //                                                                                                                   shape: RoundedRectangleBorder(
                              // //                                                                                                                     borderRadius: BorderRadius.circular(5),
                              // //                                                                                                                     side: BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                              // //                                                                                                                   ),
                              // //                                                                                                                 ),
                              // //                                                                                                                 child: const Text("Cancel", style: CustomTextStyle.heading44),
                              // //                                                                                                                 onPressed: () {
                              // //                                                                                                                   Navigator.pop(context);
                              // //                                                                                                                 }))
                              // //                                                                                                       ],
                              // //                                                                                                     ),
                              // //                                                                                                   );
                              // //                                                                                                   AlertDialog alert = AlertDialog(
                              // //                                                                                                     title: const Text("Confirmation", style: CustomTextStyle.heading2NOunderLIne, textAlign: TextAlign.center),
                              // //                                                                                                     content: Text("Are you sure you want to delete this?", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
                              // //                                                                                                     actions: [deletebutton],
                              // //                                                                                                   );
                              // //                                                                                                   // show the dialog
                              // //                                                                                                   showDialog(
                              // //                                                                                                     context: context,
                              // //                                                                                                     builder: (BuildContext context) {
                              // //                                                                                                       return alert;
                              // //                                                                                                     },
                              // //                                                                                                   );
                              // //                                                                                                 } else if (value == "Edit") {
                              // //                                                                                                   taskNameController.text = listOfCompletedTasks[index].taskName;
                              // //                                                                                                   descController.text = listOfCompletedTasks[index].description;
                              // //                                                                                                   dueDateController.text = getDateFormate(listOfCompletedTasks[index].dueDate);
                              // //                                                                                                   updateTaskModal.taskName = listOfCompletedTasks[index].taskName;
                              // //                                                                                                   updateTaskModal.dueDate = getDateFormate(listOfCompletedTasks[index].dueDate);
                              // //                                                                                                   updateTaskModal.description = listOfCompletedTasks[index].description;
                              // //                                                                                                   updateTaskModal.assignTo = listOfCompletedTasks[index].assignTo;

                              // //                                                                                                   updateTaskModal.id = listOfCompletedTasks[index].id;
                              // //                                                                                                   if (listOfCompletedTasks[index].assignTo.isNotEmpty) {
                              // //                                                                                                     assignToValue = listOfCompletedTasks[index].assignTo;
                              // //                                                                                                   } else {
                              // //                                                                                                     assignToValue = null;
                              // //                                                                                                   }

                              // //                                                                                                   showModalBottomSheet(
                              // //                                                                                                     isScrollControlled: true,
                              // //                                                                                                     context: context,
                              // //                                                                                                     shape: const RoundedRectangleBorder(
                              // //                                                                                                       borderRadius: BorderRadius.only(
                              // //                                                                                                         topRight: Radius.circular(20),
                              // //                                                                                                         topLeft: Radius.circular(20),
                              // //                                                                                                       ),
                              // //                                                                                                     ), // set this to true
                              // //                                                                                                     builder: (_) {
                              // //                                                                                                       return Container(
                              // //                                                                                                         padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //                                                                                                         height: MediaQuery.of(context).size.height * 0.75,
                              // //                                                                                                         child: Form(
                              // //                                                                                                             key: _formKey,
                              // //                                                                                                             child: ListView(children: [
                              // //                                                                                                               Container(
                              // //                                                                                                                   alignment: Alignment.centerRight,
                              // //                                                                                                                   child: IconButton(
                              // //                                                                                                                       onPressed: () {
                              // //                                                                                                                         taskNameController.text = "";
                              // //                                                                                                                         updateTaskModal.taskName = "";
                              // //                                                                                                                         updateTaskModal.assignTo = "";
                              // //                                                                                                                         dueDateController.text = "";
                              // //                                                                                                                         updateTaskModal.dueDate = "";
                              // //                                                                                                                         descController.text = "";
                              // //                                                                                                                         updateTaskModal.description = "";
                              // //                                                                                                                         Navigator.pop(context);
                              // //                                                                                                                       },
                              // //                                                                                                                       icon: Icon(
                              // //                                                                                                                         Icons.close,
                              // //                                                                                                                         color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                                       ))),
                              // //                                                                                                               Container(padding: const EdgeInsets.all(5), alignment: Alignment.center, child: const Text("Update Task")),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                     Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: TextFormField(
                              // //                                                                                                                   controller: taskNameController,
                              // //                                                                                                                   style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                   keyboardType: TextInputType.text,
                              // //                                                                                                                   textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                   validator: (value) {
                              // //                                                                                                                     if (value!.isEmpty) {
                              // //                                                                                                                       return 'Task Title is required';
                              // //                                                                                                                     }
                              // //                                                                                                                     return null;
                              // //                                                                                                                   },
                              // //                                                                                                                   onChanged: (value) {
                              // //                                                                                                                     setState(() {
                              // //                                                                                                                       updateTaskModal.taskName = value;
                              // //                                                                                                                     });
                              // //                                                                                                                   },
                              // //                                                                                                                   decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Text("Description", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                     Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: TextFormField(
                              // //                                                                                                                   controller: descController,
                              // //                                                                                                                   keyboardType: TextInputType.text,
                              // //                                                                                                                   style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                   textCapitalization: TextCapitalization.sentences,
                              // //                                                                                                                   validator: (value) {
                              // //                                                                                                                     if (value!.isEmpty) {
                              // //                                                                                                                       return 'Description is required';
                              // //                                                                                                                     }
                              // //                                                                                                                     return null;
                              // //                                                                                                                   },
                              // //                                                                                                                   onChanged: (value) {
                              // //                                                                                                                     setState(() {
                              // //                                                                                                                       updateTaskModal.description = value;
                              // //                                                                                                                     });
                              // //                                                                                                                   },
                              // //                                                                                                                   decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                   padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                   child: Text(
                              // //                                                                                                                     "Assign task to",
                              // //                                                                                                                     style: Theme.of(context).textTheme.headline6,
                              // //                                                                                                                   )),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 width: MediaQuery.of(context).size.width / 3,
                              // //                                                                                                                 child: DropdownButtonFormField(
                              // //                                                                                                                     hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                     alignment: Alignment.bottomCenter,
                              // //                                                                                                                     iconEnabledColor: Theme.of(context).iconTheme.color,
                              // //                                                                                                                     value: assignToValue,
                              // //                                                                                                                     style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                     decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0))),
                              // //                                                                                                                     items: listSharerUser.map((UserSharerVm item) {
                              // //                                                                                                                       return DropdownMenuItem(
                              // //                                                                                                                         child: Text(
                              // //                                                                                                                           item.name,
                              // //                                                                                                                         ),
                              // //                                                                                                                         value: item.userId,
                              // //                                                                                                                       );
                              // //                                                                                                                     }).toList(),
                              // //                                                                                                                     onChanged: (value) {
                              // //                                                                                                                       setState(() {
                              // //                                                                                                                         updateTaskModal.assignTo = value as String;
                              // //                                                                                                                       });
                              // //                                                                                                                     }),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: Row(
                              // //                                                                                                                   children: [
                              // //                                                                                                                     Text("Due Date", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                                     Text("*", style: TextStyle(color: Theme.of(context).colorScheme.redColor)),
                              // //                                                                                                                   ],
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                              // //                                                                                                                 child: TextFormField(
                              // //                                                                                                                   controller: dueDateController,
                              // //                                                                                                                   keyboardType: TextInputType.number,
                              // //                                                                                                                   style: CustomTextStyle.textBoxStyle,
                              // //                                                                                                                   readOnly: true,
                              // //                                                                                                                   validator: (value) {
                              // //                                                                                                                     if (value!.isEmpty) {
                              // //                                                                                                                       return 'Due Date is required';
                              // //                                                                                                                     }
                              // //                                                                                                                     return null;
                              // //                                                                                                                   },
                              // //                                                                                                                   decoration: InputDecoration(contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).colorScheme.textBoxBorderColor), borderRadius: BorderRadius.circular(5.0)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.5, color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5.0)), suffixIcon: const Icon(Icons.calendar_today), hintText: 'Add a due date to the task', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // //                                                                                                                   onTap: () async {
                              // //                                                                                                                     DateTime? date = DateTime(1900);
                              // //                                                                                                                     //FocusScope.of(context).requestFocus(FocusNode());
                              // //                                                                                                                     FocusScope.of(context).unfocus();

                              // //                                                                                                                     date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));
                              // //                                                                                                                     if (date == null) {
                              // //                                                                                                                       dueDateController.text = myFormat.format(date!);
                              // //                                                                                                                       updateTaskModal.dueDate = date.toString();
                              // //                                                                                                                     }
                              // //                                                                                                                   },
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                               Container(
                              // //                                                                                                                 padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                              // //                                                                                                                 child: ElevatedButton(
                              // //                                                                                                                   style: ElevatedButton.styleFrom(
                              // //                                                                                                                     padding: const EdgeInsets.all(15),
                              // //                                                                                                                     primary: Theme.of(context).primaryColor,
                              // //                                                                                                                     elevation: 0,
                              // //                                                                                                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                                                   ),
                              // //                                                                                                                   child: Text(
                              // //                                                                                                                     'Update',
                              // //                                                                                                                     style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                                   ),
                              // //                                                                                                                   onPressed: () {
                              // //                                                                                                                     if (_formKey.currentState!.validate()) {
                              // //                                                                                                                       _formKey.currentState!.save();
                              // //                                                                                                                       setState(() {
                              // //                                                                                                                         updateTaskModal.docId = docId;
                              // //                                                                                                                       });
                              // //                                                                                                                       EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                                       EasyLoading.show(status: 'Saving...');
                              // //                                                                                                                       updateTask(updateTaskModal).then((response) {
                              // //                                                                                                                         taskNameController.text = "";
                              // //                                                                                                                         descController.text = "";
                              // //                                                                                                                         updateTaskModal.taskName = "";
                              // //                                                                                                                         updateTaskModal.assignTo = "";
                              // //                                                                                                                         dueDateController.text = "";
                              // //                                                                                                                         updateTaskModal.dueDate = "";
                              // //                                                                                                                         String _msg = "";
                              // //                                                                                                                         if (response == "-3") {
                              // //                                                                                                                           _msg = "This task has already been assigned to this user.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/alert.json";
                              // //                                                                                                                           var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                           Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                                             Navigator.pop(context);
                              // //                                                                                                                           });
                              // //                                                                                                                         } else if (response == "1") {
                              // //                                                                                                                           _msg = "The task has been updated.";
                              // //                                                                                                                           EasyLoading.dismiss();
                              // //                                                                                                                           String title = "";
                              // //                                                                                                                           String _icon = "assets/images/Success.json";
                              // //                                                                                                                           var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                                           if (respStatus == "1") {
                              // //                                                                                                                             Future.delayed(const Duration(seconds: 2), () {
                              // //                                                                                                                               Navigator.pop(context);
                              // //                                                                                                                             });
                              // //                                                                                                                           }
                              // //                                                                                                                         }
                              // //                                                                                                                       });
                              // //                                                                                                                     }
                              // //                                                                                                                   },
                              // //                                                                                                                 ),
                              // //                                                                                                               ),
                              // //                                                                                                             ])),
                              // //                                                                                                       );
                              // //                                                                                                     },
                              // //                                                                                                   ).whenComplete(() {
                              // //                                                                                                     getAssignToMeTaskByDocId(docId).then((response) {
                              // //                                                                                                       setState(() {
                              // //                                                                                                         listOfTasks = response!;
                              // //                                                                                                       });
                              // //                                                                                                       EasyLoading.dismiss();
                              // //                                                                                                     });
                              // //                                                                                                     getAssignToOthersTaskByDocId(docId).then((response) {
                              // //                                                                                                       setState(() {
                              // //                                                                                                         listOfOthersTasks = response!;
                              // //                                                                                                       });
                              // //                                                                                                       EasyLoading.dismiss();
                              // //                                                                                                     });
                              // //                                                                                                     getCompletedTaskByDocId(docId).then((response) {
                              // //                                                                                                       setState(() {
                              // //                                                                                                         listOfCompletedTasks = response!;
                              // //                                                                                                       });
                              // //                                                                                                       EasyLoading.dismiss();
                              // //                                                                                                     });
                              // //                                                                                                   });
                              // //                                                                                                 }
                              // //                                                                                               }
                              // //                                                                                             : null,
                              // //                                                                                       ),
                              // //                                                                                     ],
                              // //                                                                                   ),
                              // //                                                                                   Text(listOfCompletedTasks[index].docName, style: Theme.of(context).textTheme.headline6),
                              // //                                                                                   Padding(
                              // //                                                                                     padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              // //                                                                                     child: Row(
                              // //                                                                                       children: [
                              // //                                                                                         Container(
                              // //                                                                                           padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                              // //                                                                                           decoration: BoxDecoration(
                              // //                                                                                             color: Theme.of(context).colorScheme.activeColor.withOpacity(0.2),
                              // //                                                                                             borderRadius: BorderRadius.circular(15),
                              // //                                                                                           ),
                              // //                                                                                           child: Row(
                              // //                                                                                             children: [
                              // //                                                                                               Icon(
                              // //                                                                                                 Icons.calendar_month,
                              // //                                                                                                 color: Theme.of(context).colorScheme.activeColor,
                              // //                                                                                                 size: 12,
                              // //                                                                                               ),
                              // //                                                                                               Text(
                              // //                                                                                                 getDateFormate(listOfCompletedTasks[index].dueDate),
                              // //                                                                                                 style: TextStyle(color: Theme.of(context).colorScheme.activeColor, fontSize: 14, fontWeight: FontWeight.normal),
                              // //                                                                                               ),
                              // //                                                                                             ],
                              // //                                                                                           ),
                              // //                                                                                         )
                              // //                                                                                       ],
                              // //                                                                                     ),
                              // //                                                                                   ),
                              // //                                                                                   Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: Divider(thickness: 1, color: Theme.of(context).colorScheme.textBoxBorderColor)),
                              // //                                                                                 ],
                              // //                                                                               ))
                              // //                                                                             ],
                              // //                                                                           ),
                              // //                                                                         );
                              // //                                                                       }),
                              // //                                                                 ],
                              // //                                                               ),
                              // //                                                             ]))
                              // //                                                   ],
                              // //                                                 ))
                              // //                                             : Expanded(
                              // //                                                 child: Container(
                              // //                                                 alignment: Alignment.center,
                              // //                                                 padding:
                              // //                                                     const EdgeInsets.all(5),
                              // //                                                 child: Column(
                              // //                                                   mainAxisAlignment:
                              // //                                                       MainAxisAlignment
                              // //                                                           .center,
                              // //                                                   children: [
                              // //                                                     Padding(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                               .all(5),
                              // //                                                       child: Image.asset(
                              // //                                                           "assets/Icons/image14.png"),
                              // //                                                     ),
                              // //                                                     Text(
                              // //                                                       "No Task Assigned",
                              // //                                                       style: Theme.of(context)
                              // //                                                           .textTheme
                              // //                                                           .headline6,
                              // //                                                     ),
                              // //                                                   ],
                              // //                                                 ),
                              // //                                               )),
                              // //                                         modal.isDocCreated == true
                              // // //                                             ? Container(
                              // // //                                                 padding:
                              // // //                                                     const EdgeInsets.all(10),
                              // // //                                                 child: ElevatedButton(
                              // // //                                                     style: ElevatedButton
                              // // //                                                         .styleFrom(
                              // // //                                                       padding:
                              // // //                                                           const EdgeInsets
                              // // //                                                               .all(15),
                              // // //                                                       elevation: 0,
                              // // //                                                       primary:
                              // // //                                                           Theme.of(context)
                              // // //                                                               .primaryColor,
                              // // //                                                       shape:
                              // // //                                                           RoundedRectangleBorder(
                              // // //                                                               borderRadius:
                              // // //                                                                   BorderRadius
                              // // //                                                                       .circular(
                              // // //                                                                           6)),
                              // // //                                                     ),
                              // // //                                                     child: Row(
                              // // //                                                       mainAxisAlignment:
                              // // //                                                           MainAxisAlignment
                              // // //                                                               .center,
                              // // //                                                       children: const [
                              // // //                                                         Padding(
                              // // //                                                           padding:
                              // // //                                                               EdgeInsets.only(
                              // // //                                                                   left: 5),
                              // // //                                                           child: Text(
                              // // //                                                               "Add New Task",
                              // // //                                                               style: TextStyle(
                              // // //                                                                   color: Colors
                              // // //                                                                       .white)),
                              // // //                                                         ),
                              // // //                                                       ],
                              // // //                                                     ),
                              // // //                                                     onPressed: () {
                              // // //                                                       showModalBottomSheet(
                              // // //                                                         backgroundColor:
                              // // //                                                             Theme.of(context)
                              // // //                                                                 .colorScheme
                              // // //                                                                 .whiteColor,
                              // // //                                                         isScrollControlled:
                              // // //                                                             true,
                              // // //                                                         context: context,
                              // // //                                                         shape:
                              // // //                                                             const RoundedRectangleBorder(
                              // // //                                                           borderRadius:
                              // // //                                                               BorderRadius
                              // // //                                                                   .only(
                              // // //                                                             topRight: Radius
                              // // //                                                                 .circular(20),
                              // // //                                                             topLeft: Radius
                              // // //                                                                 .circular(20),
                              // // //                                                           ),
                              // // //                                                         ), // set this to true
                              // // //                                                         builder: (_) {
                              // // //                                                           return SingleChildScrollView(
                              // // //                                                             child: StatefulBuilder(
                              // // //                                                                 builder: (context,
                              // // //                                                                     setState) {
                              // // //                                                               return Container(
                              // // //                                                                 padding:
                              // // //                                                                     EdgeInsets
                              // // //                                                                         .only(
                              // // //                                                                   bottom: MediaQuery.of(
                              // // //                                                                           context)
                              // // //                                                                       .viewInsets
                              // // //                                                                       .bottom,
                              // // //                                                                 ),
                              // // //                                                                 child: Form(
                              // // //                                                                     key:
                              // // //                                                                         _formKey,
                              // // //                                                                     child: Column(
                              // // //                                                                         mainAxisSize:
                              // // //                                                                             MainAxisSize.min,
                              // // //                                                                         children: [
                              // // //                                                                           Row(
                              // // //                                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // // //                                                                             children: [
                              // // //                                                                               Container(
                              // // //                                                                                   alignment: Alignment.centerLeft,
                              // // //                                                                                   padding: const EdgeInsets.fromLTRB(15, 15, 0, 5),
                              // // //                                                                                   child: Text(
                              // // //                                                                                     "Add a New Task",
                              // // //                                                                                     style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                              // // //                                                                                   )),
                              // // //                                                                               Container(
                              // // //                                                                                 padding: const EdgeInsets.fromLTRB(0, 15, 10, 5),
                              // // //                                                                                 alignment: Alignment.centerRight,
                              // // //                                                                                 child: GestureDetector(
                              // // //                                                                                   onTap: () {
                              // // //                                                                                     taskNameController.text = "";
                              // // //                                                                                     taskModal.taskName = "";
                              // // //                                                                                     taskModal.assignTo = "";
                              // // //                                                                                     dueDateController.text = "";
                              // // //                                                                                     taskModal.dueDate = "";
                              // // //                                                                                     descController.text = "";
                              // // //                                                                                     taskModal.description = "";
                              // // //                                                                                     Navigator.pop(context);
                              // // //                                                                                   },
                              // // //                                                                                   child: Container(
                              // // //                                                                                       height: 30,
                              // // //                                                                                       width: 65,
                              // // //                                                                                       alignment: Alignment.center,
                              // // //                                                                                       decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(25)),
                              // // //                                                                                       child: const Text('Reset',
                              // // //                                                                                           style: TextStyle(
                              // // //                                                                                             color: Colors.white,
                              // // //                                                                                           ))),
                              // // //                                                                                 ),
                              // // //                                                                               ),
                              // // //                                                                             ],
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              // // //                                                                             child: Row(
                              // // //                                                                               children: [
                              // // //                                                                                 Text("Task Title", style: Theme.of(context).textTheme.headline6),
                              // // //                                                                               ],
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              // // //                                                                             child: TextFormField(
                              // // //                                                                               controller: taskNameController,
                              // // //                                                                               style: CustomTextStyle.textBoxStyle,
                              // // //                                                                               keyboardType: TextInputType.text,
                              // // //                                                                               textCapitalization: TextCapitalization.sentences,
                              // // //                                                                               validator: (value) {
                              // // //                                                                                 if (value!.isEmpty) {
                              // // //                                                                                   return 'Task Title is required';
                              // // //                                                                                 }
                              // // //                                                                                 return null;
                              // // //                                                                               },
                              // // //                                                                               onChanged: (value) {
                              // // //                                                                                 setState(() {
                              // // //                                                                                   taskModal.taskName = value;
                              // // //                                                                                 });
                              // // //                                                                               },
                              // // //                                                                               decoration: InputDecoration(filled: true, fillColor: Theme.of(context).colorScheme.textfiledColor, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)), focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25.0)), hintText: 'Add your task title here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              // // //                                                                             child: Row(
                              // // //                                                                               children: [
                              // // //                                                                                 Text("Description", style: Theme.of(context).textTheme.headline6),
                              // // //                                                                               ],
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              // // //                                                                             child: TextFormField(
                              // // //                                                                               controller: descController,
                              // // //                                                                               style: CustomTextStyle.textBoxStyle,
                              // // //                                                                               keyboardType: TextInputType.text,
                              // // //                                                                               textCapitalization: TextCapitalization.sentences,
                              // // //                                                                               validator: (value) {
                              // // //                                                                                 if (value!.isEmpty) {
                              // // //                                                                                   return 'Description is required';
                              // // //                                                                                 }
                              // // //                                                                                 return null;
                              // // //                                                                               },
                              // // //                                                                               onChanged: (value) {
                              // // //                                                                                 setState(() {
                              // // //                                                                                   taskModal.description = value;
                              // // //                                                                                 });
                              // // //                                                                               },
                              // // //                                                                               decoration: InputDecoration(filled: true, fillColor: Theme.of(context).colorScheme.textfiledColor, border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)), focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25.0)), hintText: 'Add description here', hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                               padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              // // //                                                                               alignment: Alignment.centerLeft,
                              // // //                                                                               child: Text(
                              // // //                                                                                 "Assign to",
                              // // //                                                                                 style: Theme.of(context).textTheme.headline6,
                              // // //                                                                               )),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              // // //                                                                             child: DropdownButtonFormField(
                              // // //                                                                                 // isExpanded: true,
                              // // //                                                                                 hint: Text("Select an assignee", style: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor)),
                              // // //                                                                                 alignment: Alignment.bottomCenter,
                              // // //                                                                                 iconEnabledColor: Theme.of(context).iconTheme.color,
                              // // //                                                                                 //  value: taskModal.assignTo,
                              // // //                                                                                 style: CustomTextStyle.textBoxStyle,
                              // // //                                                                                 decoration: InputDecoration(
                              // // //                                                                                   contentPadding: const EdgeInsets.fromLTRB(5, 17, 5, 17),
                              // // //                                                                                   filled: true,
                              // // //                                                                                   fillColor: Theme.of(context).colorScheme.textfiledColor,
                              // // //                                                                                   border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                              // // //                                                                                   focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
                              // // //                                                                                 ),
                              // // //                                                                                 items: listSharerUser.map((UserSharerVm item) {
                              // // //                                                                                   return DropdownMenuItem(
                              // // //                                                                                     child: Text(
                              // // //                                                                                       item.name,
                              // // //                                                                                     ),
                              // // //                                                                                     value: item.userId,
                              // // //                                                                                   );
                              // // //                                                                                 }).toList(),
                              // // //                                                                                 onChanged: (value) {
                              // // //                                                                                   setState(() {
                              // // //                                                                                     taskModal.assignTo = value as String;
                              // // //                                                                                   });
                              // // //                                                                                 }),
                              //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              // // //                                                                             child: Row(
                              // // //                                                                               children: [
                              // // //                                                                                 Text("Assign Due Date", style: Theme.of(context).textTheme.headline6),
                              // // //                                                                               ],
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Padding(
                              // // //                                                                             padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                              // // //                                                                             child: Container(
                              // // //                                                                               color: Theme.of(context).colorScheme.textfiledColor,
                              // // //                                                                               padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                              // // //                                                                               child: TextFormField(
                              // // //                                                                                 controller: dueDateController,
                              // // //                                                                                 style: CustomTextStyle.textBoxStyle,
                              // // //                                                                                 keyboardType: TextInputType.number,
                              // // //                                                                                 readOnly: true,
                              // // //                                                                                 validator: (value) {
                              // // //                                                                                   if (value!.isEmpty) {
                              // // //                                                                                     return 'Due Date is required';
                              // // //                                                                                   }
                              // // //                                                                                   return null;
                              // // //                                                                                 },
                              // // //                                                                                 decoration: InputDecoration(
                              // // //                                                                                   contentPadding: const EdgeInsets.fromLTRB(5, 19, 5, 19),
                              // // //                                                                                   filled: true,
                              // // //                                                                                   fillColor: Theme.of(context).colorScheme.textfiledColor,
                              // // //                                                                                   border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                              // // //                                                                                   focusedBorder: OutlineInputBorder(
                              // // //                                                                                     borderSide: BorderSide.none,
                              // // //                                                                                     borderRadius: BorderRadius.circular(6.0),
                              // // //                                                                                   ),
                              // // //                                                                                   suffixIcon: const Icon(Icons.calendar_today),
                              // // //                                                                                   hintText: 'Add a due date to the task',
                              // // //                                                                                   hintStyle: TextStyle(color: Theme.of(context).colorScheme.fadeGrayColor),
                              // // //                                                                                 ),
                              // // //                                                                                 onTap: () async {
                              // // //                                                                                   DateTime? date = DateTime(1900);
                              // // //                                                                                   //FocusScope.of(context).requestFocus(FocusNode());
                              // // //                                                                                   FocusScope.of(context).unfocus();

                              // // //                                                                                   date = (await showDatePicker(context: context, initialEntryMode: DatePickerEntryMode.calendarOnly, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100)));
                              // // //                                                                                   if (date != null) {
                              // // //                                                                                     dueDateController.text = myFormat.format(date);
                              // // //                                                                                     taskModal.dueDate = date.toString();
                              // // //                                                                                   }
                              // // //                                                                                 },
                              // // //                                                                               ),
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                           Container(
                              // // //                                                                             padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
                              // // //                                                                             width: MediaQuery.of(context).size.width,
                              // // //                                                                             child: ElevatedButton(
                              // // //                                                                               style: ElevatedButton.styleFrom(
                              // // //                                                                                 padding: const EdgeInsets.all(15),
                              // // //                                                                                 primary: Theme.of(context).primaryColor,
                              // // //                                                                                 elevation: 0,
                              // // //                                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              // // //                                                                               ),
                              // // //                                                                               child: Text(
                              // // //                                                                                 'Add',
                              // // //                                                                                 style: Theme.of(context).textTheme.headline3,
                              // // //                                                                               ),
                              // // //                                                                               onPressed: () {
                              // // //                                                                                 if (_formKey.currentState!.validate()) {
                              // // //                                                                                   _formKey.currentState!.save();
                              // // //                                                                                   setState(() {
                              // // //                                                                                     taskModal.docId = docId;
                              // // //                                                                                   });
                              // // //                                                                                   EasyLoading.addStatusCallback((status) {});
                              // // //                                                                                   EasyLoading.show(status: 'Saving...');
                              // // //                                                                                   addTask(taskModal).then((response) {
                              // // //                                                                                     taskNameController.text = "";
                              // // //                                                                                     descController.text = "";
                              // // //                                                                                     taskModal.taskName = "";
                              // // //                                                                                     taskModal.assignTo = "";
                              // // //                                                                                     dueDateController.text = "";
                              // // //                                                                                     taskModal.dueDate = "";
                              // // //                                                                                     String _msg = "";
                              // // //                                                                                     if (response == "-3") {
                              // // //                                                                                       _msg = "This task has already been assigned to this user.";
                              // // //                                                                                       EasyLoading.dismiss();
                              // // //                                                                                       String title = "";
                              // // //                                                                                       String _icon = "assets/images/alert.json";
                              // // //                                                                                       var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // // //                                                                                       Future.delayed(const Duration(seconds: 3), () {
                              // // //                                                                                         Navigator.pop(context);
                              // // //                                                                                       });
                              // // //                                                                                     } else if (response == "1") {
                              // // //                                                                                       _msg = "The task has been created.";
                              // // //                                                                                       EasyLoading.dismiss();
                              // // //                                                                                       String title = "";
                              // // //                                                                                       String _icon = "assets/images/Success.json";
                              // // //                                                                                       var respStatus = showInfoAlert(title, _msg, _icon, context);
                              // // //                                                                                       if (respStatus == "1") {
                              // // //                                                                                         Future.delayed(const Duration(seconds: 3), () {
                              // // //                                                                                           Navigator.pop(context);
                              // // //                                                                                         });
                              // // //                                                                                       }
                              // // //                                                                                     } else if (response == "-5") {
                              // // //                                                                                       String _msg = "You have limited No. of resources for creating more tasks! Please upgrade your plan!";
                              // // //                                                                                       EasyLoading.dismiss();
                              // // //                                                                                       String title = "";
                              // // //                                                                                       String _icon = "assets/images/alert.json";
                              // // //                                                                                       var response = showUpgradePackageAlert(title, _msg, _icon, context);
                              // // //                                                                                     } else if (response == "-6") {
                              // // //                                                                                       String _msg = "You cannot assign tasks! Please upgrade your plan!";
                              // // //                                                                                       EasyLoading.dismiss();
                              // // //                                                                                       String title = "";
                              // // //                                                                                       String _icon = "assets/images/alert.json";
                              // // //                                                                                       var response = showUpgradePackageAlert(title, _msg, _icon, context);
                              // // //                                                                                     }
                              // // //                                                                                   });
                              // // //                                                                                 }
                              // // //                                                                               },
                              // // //                                                                             ),
                              // // //                                                                           ),
                              // // //                                                                         ])),
                              // // //                                                               );
                              // // //                                                             }),
                              // // //                                                           );
                              // // //                                                         },
                              // // //                                                       ).whenComplete(() {
                              // // //                                                         getAssignToMeTaskByDocId(
                              // // //                                                                 docId)
                              // // //                                                             .then((response) {
                              // // //                                                           setState(() {
                              // // //                                                             listOfTasks =
                              // // //                                                                 response!;
                              // // //                                                           });
                              // // //                                                           EasyLoading
                              // // //                                                               .dismiss();
                              // // //                                                         });
                              // // //                                                         getAssignToOthersTaskByDocId(
                              // // //                                                                 docId)
                              // // //                                                             .then((response) {
                              // // //                                                           setState(() {
                              // // //                                                             listOfOthersTasks =
                              // // //                                                                 response!;
                              // // //                                                           });
                              // // //                                                           EasyLoading
                              // // //                                                               .dismiss();
                              // // //                                                         });
                              // // //                                                         getCompletedTaskByDocId(
                              // // //                                                                 docId)
                              // // //                                                             .then((response) {
                              // // //                                                           setState(() {
                              // // //                                                             listOfCompletedTasks =
                              // // //                                                                 response!;
                              // // //                                                           });
                              // // //                                                           EasyLoading
                              // // //                                                               .dismiss();
                              // // //                                                         });
                              // // //                                                       });
                              // // //                                                     }),
                              // // //                                               )
                              // // //                                             : Container()
                              // // //                                       ],
                              // // //                                     ),
                              // // //                                   ),
                              // //                                   Container(
                              // //                                     padding: const EdgeInsets.all(10),
                              // //                                     child: Column(
                              // //                                       children: [
                              // //                                         docSharingList.isNotEmpty
                              // //                                             ? Expanded(
                              // //                                                 flex: 1,
                              // //                                                 child: ListView.builder(
                              // //                                                     shrinkWrap: true,
                              // //                                                     physics:
                              // //                                                         const ClampingScrollPhysics(),
                              // //                                                     itemCount:
                              // //                                                         docSharingList.length,
                              // //                                                     itemBuilder:
                              // //                                                         (context, index) {
                              // //                                                       return Container(
                              // //                                                         height: 60,
                              // //                                                         width: MediaQuery.of(
                              // //                                                                 context)
                              // //                                                             .size
                              // //                                                             .width,
                              // //                                                         padding:
                              // //                                                             const EdgeInsets
                              // //                                                                     .only(
                              // //                                                                 left: 15),
                              // //                                                         child: Row(
                              // //                                                           children: [
                              // //                                                             docSharingList[index]
                              // //                                                                         .profilePic
                              // //                                                                         .isEmpty ||
                              // //                                                                     docSharingList[index]
                              // //                                                                             .profilePic ==
                              // //                                                                         ""
                              // //                                                                 ? CircleAvatar(
                              // //                                                                     radius:
                              // //                                                                         25,
                              // //                                                                     backgroundColor: Theme.of(
                              // //                                                                             context)
                              // //                                                                         .colorScheme
                              // //                                                                         .profileEditColor,
                              // //                                                                     child: Text(
                              // //                                                                         getUserFirstLetetrs(docSharingList[index].userName)
                              // //                                                                             .toUpperCase(),
                              // //                                                                         style:
                              // //                                                                             TextStyle(color: Theme.of(context).primaryColor)),
                              // //                                                                   )
                              // //                                                                 : CircleAvatar(
                              // //                                                                     radius:
                              // //                                                                         25,
                              // //                                                                     backgroundImage:
                              // //                                                                         CachedNetworkImageProvider(imageUrl +
                              // //                                                                             docSharingList[index].profilePic),
                              // //                                                                   ),
                              // //                                                             Expanded(
                              // //                                                               child: Column(
                              // //                                                                 mainAxisAlignment:
                              // //                                                                     MainAxisAlignment
                              // //                                                                         .center,
                              // //                                                                 crossAxisAlignment:
                              // //                                                                     CrossAxisAlignment
                              // //                                                                         .start,
                              // //                                                                 children: [
                              // //                                                                   Container(
                              // //                                                                     alignment:
                              // //                                                                         Alignment
                              // //                                                                             .centerLeft,
                              // //                                                                     padding: const EdgeInsets
                              // //                                                                             .only(
                              // //                                                                         left:
                              // //                                                                             5),
                              // //                                                                     child:
                              // //                                                                         Row(
                              // //                                                                       mainAxisAlignment:
                              // //                                                                           MainAxisAlignment.spaceBetween,
                              // //                                                                       children: [
                              // //                                                                         Text(
                              // //                                                                           docSharingList.isEmpty
                              // //                                                                               ? ""
                              // //                                                                               : docSharingList[index].userName,
                              // //                                                                           style:
                              // //                                                                               CustomTextStyle.heading11,
                              // //                                                                         ),
                              // //                                                                         Container(
                              // //                                                                           padding:
                              // //                                                                               const EdgeInsets.all(5),
                              // //                                                                           decoration: BoxDecoration(
                              // //                                                                               color: Theme.of(context).colorScheme.whiteColor,
                              // //                                                                               borderRadius: const BorderRadius.all(Radius.circular(6)),
                              // //                                                                               border: Border.all(color: Theme.of(context).colorScheme.labelColor)),
                              // //                                                                           child:
                              // //                                                                               Text(docSharingList[index].accessTitle + " Access", style: CustomTextStyle.simple12Text),
                              // //                                                                         )
                              // //                                                                       ],
                              // //                                                                     ),
                              // //                                                                   ),
                              // //                                                                   Container(
                              // //                                                                     padding:
                              // //                                                                         const EdgeInsets.fromLTRB(
                              // //                                                                             5,
                              // //                                                                             0,
                              // //                                                                             5,
                              // //                                                                             0),
                              // //                                                                     child: Text(
                              // //                                                                         docSharingList[index]
                              // //                                                                             .userEmail,
                              // //                                                                         style:
                              // //                                                                             CustomTextStyle.simple12Text),
                              // //                                                                   )
                              // //                                                                 ],
                              // //                                                               ),
                              // //                                                             ),
                              // //                                                             PopupMenuButton(
                              // //                                                               icon: Icon(
                              // //                                                                 Icons
                              // //                                                                     .more_vert,
                              // //                                                                 color: Theme.of(
                              // //                                                                         context)
                              // //                                                                     .colorScheme
                              // //                                                                     .warmGreyColor,
                              // //                                                               ),
                              // //                                                               itemBuilder:
                              // //                                                                   (BuildContext
                              // //                                                                       bc) {
                              // //                                                                 return _option3
                              // //                                                                     .map((obj) =>
                              // //                                                                         PopupMenuItem(
                              // //                                                                           height:
                              // //                                                                               40,
                              // //                                                                           child: obj == "Remove"
                              // //                                                                               ? Row(
                              // //                                                                                   children: [
                              // //                                                                                     Icon(
                              // //                                                                                       Icons.delete,
                              // //                                                                                       color: Theme.of(context).colorScheme.redColor,
                              // //                                                                                       size: 18,
                              // //                                                                                     ),
                              // //                                                                                     Text(
                              // //                                                                                       obj,
                              // //                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.redColor, fontSize: 14),
                              // //                                                                                     )
                              // //                                                                                   ],
                              // //                                                                                 )
                              // //                                                                               : Row(
                              // //                                                                                   children: [
                              // //                                                                                     Icon(
                              // //                                                                                       Icons.edit,
                              // //                                                                                       color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                       size: 18,
                              // //                                                                                     ),
                              // //                                                                                     Text(
                              // //                                                                                       obj,
                              // //                                                                                       style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontSize: 14),
                              // //                                                                                     )
                              // //                                                                                   ],
                              // //                                                                                 ),
                              // //                                                                           value:
                              // //                                                                               obj,
                              // //                                                                         ))
                              // //                                                                     .toList();
                              // //                                                               },
                              // //                                                               onSelected:
                              // //                                                                   modal.isDocCreated ==
                              // //                                                                           true
                              // //                                                                       ? (value) {
                              // //                                                                           if (value ==
                              // //                                                                               "Remove") {
                              // //                                                                             var res = deleteSharing(context, docSharingList[index].id);
                              // //                                                                           } else if (value ==
                              // //                                                                               "Edit") {
                              // //                                                                             setState(() {
                              // //                                                                               updateDocShare.id = docSharingList[index].id;
                              // //                                                                               updateDocShare.docId = docSharingList[index].docId;

                              // //                                                                               updateDocShare.userId = docSharingList[index].userId;
                              // //                                                                             });
                              // //                                                                             setState(() {
                              // //                                                                               updateDocShare.accessTypeId = docSharingList[index].accessTypeId;
                              // //                                                                             });

                              // //                                                                             showModalBottomSheet(
                              // //                                                                               context: context,
                              // //                                                                               shape: const RoundedRectangleBorder(
                              // //                                                                                 borderRadius: BorderRadius.only(
                              // //                                                                                   topRight: Radius.circular(20),
                              // //                                                                                   topLeft: Radius.circular(20),
                              // //                                                                                 ),
                              // //                                                                               ),
                              // //                                                                               builder: (context) {
                              // //                                                                                 return StatefulBuilder(builder: (context, setState) {
                              // //                                                                                   return Container(
                              // //                                                                                       padding: const EdgeInsets.all(5),
                              // //                                                                                       height: MediaQuery.of(context).size.height * 0.40,
                              // //                                                                                       child: Column(children: [
                              // //                                                                                         Container(
                              // //                                                                                             alignment: Alignment.centerRight,
                              // //                                                                                             child: IconButton(
                              // //                                                                                                 onPressed: () {
                              // //                                                                                                   Navigator.pop(context);
                              // //                                                                                                 },
                              // //                                                                                                 icon: Icon(
                              // //                                                                                                   Icons.close,
                              // //                                                                                                   color: Theme.of(context).colorScheme.blackColor,
                              // //                                                                                                 ))),
                              // //                                                                                         Expanded(
                              // //                                                                                             child: Column(
                              // //                                                                                                 mainAxisAlignment: MainAxisAlignment.start,
                              // //                                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                                 children: listAccessType.map((TblAccessType item) {
                              // //                                                                                                   return Row(
                              // //                                                                                                     children: [
                              // //                                                                                                       Radio(
                              // //                                                                                                         value: item.id,
                              // //                                                                                                         groupValue: updateDocShare.accessTypeId,
                              // //                                                                                                         activeColor: Theme.of(context).primaryColor,
                              // //                                                                                                         onChanged: (val) {
                              // //                                                                                                           setState(() {
                              // //                                                                                                             updateDocShare.accessTypeId = val as String;
                              // //                                                                                                           });
                              // //                                                                                                         },
                              // //                                                                                                       ),
                              // //                                                                                                       Expanded(
                              // //                                                                                                         child: Container(
                              // //                                                                                                           padding: const EdgeInsets.all(5),
                              // //                                                                                                           child: Column(
                              // //                                                                                                             mainAxisAlignment: MainAxisAlignment.start,
                              // //                                                                                                             crossAxisAlignment: CrossAxisAlignment.start,
                              // //                                                                                                             children: [
                              // //                                                                                                               item.title == "View" ? const Text("View Only") : const Text("Can Edit"),
                              // //                                                                                                               item.title == "View" ? Text("Sharer can only view document details", style: Theme.of(context).textTheme.headline6) : Text("Sharer will be able to edit details of the shared document", style: Theme.of(context).textTheme.headline6),
                              // //                                                                                                             ],
                              // //                                                                                                           ),
                              // //                                                                                                         ),
                              // //                                                                                                       )
                              // //                                                                                                     ],
                              // //                                                                                                   );
                              // //                                                                                                 }).toList())),
                              // //                                                                                         Expanded(
                              // //                                                                                           child: Container(
                              // //                                                                                             padding: const EdgeInsets.all(15),
                              // //                                                                                             alignment: Alignment.bottomCenter,
                              // //                                                                                             child: ElevatedButton(
                              // //                                                                                               style: ElevatedButton.styleFrom(
                              // //                                                                                                 padding: const EdgeInsets.all(0.0),
                              // //                                                                                                 elevation: 0,
                              // //                                                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // //                                                                                               ),
                              // //                                                                                               child: Container(
                              // //                                                                                                 width: MediaQuery.of(context).size.width,
                              // //                                                                                                 height: MediaQuery.of(context).size.width * 0.10,
                              // //                                                                                                 decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(5))),
                              // //                                                                                                 child: Center(
                              // //                                                                                                   child: Text(
                              // //                                                                                                     'Update Access',
                              // //                                                                                                     style: Theme.of(context).textTheme.headline3,
                              // //                                                                                                   ),
                              // //                                                                                                 ),
                              // //                                                                                               ),
                              // //                                                                                               onPressed: () {
                              // //                                                                                                 setState(() {
                              // //                                                                                                   updateDocShare.docId = docId;
                              // //                                                                                                 });
                              // //                                                                                                 EasyLoading.addStatusCallback((status) {});
                              // //                                                                                                 EasyLoading.show(status: 'loading...');
                              // //                                                                                                 updateDocSharing(updateDocShare).then((response) {
                              // //                                                                                                   EasyLoading.dismiss();
                              // //                                                                                                   String _msg = "";
                              // //                                                                                                   if (response == "-3") {
                              // //                                                                                                     _msg = "The document is already shared with this user.";
                              // //                                                                                                   } else if (response == "1") {
                              // //                                                                                                     _msg = "Document access has been successfully updated.";
                              // //                                                                                                   }

                              // //                                                                                                   EasyLoading.dismiss();
                              // //                                                                                                   String title = "";
                              // //                                                                                                   String _icon = "assets/images/Success.json";
                              // //                                                                                                   var response2 = showInfoAlert(title, _msg, _icon, context);
                              // //                                                                                                   Future.delayed(const Duration(seconds: 3), () {
                              // //                                                                                                     Navigator.pop(context);
                              // //                                                                                                   });
                              // //                                                                                                 });
                              // //                                                                                               },
                              // //                                                                                             ),
                              // //                                                                                           ),
                              // //                                                                                         )
                              // //                                                                                       ]));
                              // //                                                                                 });
                              // //                                                                               },
                              // //                                                                             ).whenComplete(() {
                              // //                                                                               getDocSharingDataTable(docId).then((response) {
                              // //                                                                                 setState(() {
                              // //                                                                                   docSharingList = response!;
                              // //                                                                                 });
                              // //                                                                                 EasyLoading.dismiss();
                              // //                                                                               });
                              // //                                                                             });
                              // //                                                                           }
                              // //                                                                         }
                              // //                                                                       : null,
                              // //                                                             ),
                              // //                                                           ],
                              // //                                                         ),
                              // //                                                       );
                              // //                                                     }),
                              // //                                               )
                              // //                                             : Expanded(
                              // //                                                 child: Container(
                              // //                                                 alignment: Alignment.center,
                              // //                                                 padding:
                              // //                                                     const EdgeInsets.all(5),
                              // //                                                 child: Column(
                              // //                                                   mainAxisAlignment:
                              // //                                                       MainAxisAlignment
                              // //                                                           .center,
                              // //                                                   children: [
                              // //                                                     Text(
                              // //                                                       "Document not shared yet.",
                              // //                                                       style: Theme.of(context)
                              // //                                                           .textTheme
                              // //                                                           .headline6,
                              // //                                                     ),
                              // //                                                     modal.isDocCreated == true
                              // //                                                         ? Container(
                              // //                                                             padding:
                              // //                                                                 const EdgeInsets
                              // //                                                                     .all(10),
                              // //                                                             child:
                              // //                                                                 ElevatedButton(
                              // //                                                                     style: ElevatedButton
                              // //                                                                         .styleFrom(
                              // //                                                                       padding:
                              // //                                                                           const EdgeInsets.all(10),
                              // //                                                                       side:
                              // //                                                                           BorderSide(
                              // //                                                                         width:
                              // //                                                                             1,
                              // //                                                                         color:
                              // //                                                                             Theme.of(context).primaryColor,
                              // //                                                                       ),
                              // //                                                                       elevation:
                              // //                                                                           0,
                              // //                                                                       primary: Theme.of(context)
                              // //                                                                           .colorScheme
                              // //                                                                           .whiteColor,
                              // //                                                                       shape: RoundedRectangleBorder(
                              // //                                                                           borderRadius:
                              // //                                                                               BorderRadius.circular(5)),
                              // //                                                                     ),
                              // //                                                                     child: Text(
                              // //                                                                         "Share document",
                              // //                                                                         style: TextStyle(
                              // //                                                                             color: Theme.of(context)
                              // //                                                                                 .primaryColor)),
                              // //                                                                     onPressed:
                              // //                                                                         () {
                              // //                                                                       addSharing(
                              // //                                                                           context);
                              // //                                                                     }),
                              // //                                                           )
                              // //                                                         : Container()
                              // //                                                   ],
                              // //                                                 ),
                              // //                                               )),
                              // //                                         modal.isDocCreated == true &&
                              // //                                                 docSharingList.isNotEmpty
                              // //                                             ? Container(
                              // //                                                 padding:
                              // //                                                     const EdgeInsets.all(10),
                              // //                                                 child: ElevatedButton(
                              // //                                                     style: ElevatedButton
                              // //                                                         .styleFrom(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                               .all(0.0),
                              // //                                                       elevation: 0,
                              // //                                                       primary:
                              // //                                                           Theme.of(context)
                              // //                                                               .primaryColor,
                              // //                                                       shape:
                              // //                                                           RoundedRectangleBorder(
                              // //                                                               borderRadius:
                              // //                                                                   BorderRadius
                              // //                                                                       .circular(
                              // //                                                                           5)),
                              // //                                                     ),
                              // //                                                     child: Row(
                              // //                                                       mainAxisAlignment:
                              // //                                                           MainAxisAlignment
                              // //                                                               .center,
                              // //                                                       children: const [
                              // //                                                         /*  CircleAvatar(
                              // //                                                                       radius: 10,
                              // //                                                                       backgroundColor:
                              // //                                                                           Theme.of(context)
                              // //                                                                               .primaryColor,
                              // //                                                                       child: const Icon(
                              // //                                                                         FontAwesomeIcons.plus,
                              // //                                                                         size: 15,
                              // //                                                                         color: Colors.white,
                              // //                                                                       ),
                              // //                                                                     ), */
                              // //                                                         Padding(
                              // //                                                           padding:
                              // //                                                               EdgeInsets.only(
                              // //                                                                   left: 5),
                              // //                                                           child: Text(
                              // //                                                               "Share Document",
                              // //                                                               style: TextStyle(
                              // //                                                                   color: Colors
                              // //                                                                       .white)),
                              // //                                                         ),
                              // //                                                       ],
                              // //                                                     ),
                              // //                                                     onPressed: () {
                              // //                                                       addSharing(context);
                              // //                                                     }),
                              // //                                               )
                              // //                                             : Container()
                              // //                                       ],
                              // //                                     ),
                              // //                                   ),
                              // //                                   Container(
                              // //                                       padding: const EdgeInsets.all(10),
                              // //                                       child: showNotesBox == true
                              // //                                           ? Column(
                              // //                                               mainAxisAlignment:
                              // //                                                   MainAxisAlignment
                              // //                                                       .spaceBetween,
                              // //                                               children: [
                              // //                                                 Column(
                              // //                                                   crossAxisAlignment:
                              // //                                                       CrossAxisAlignment
                              // //                                                           .start,
                              // //                                                   children: [
                              // //                                                     Container(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                                   .fromLTRB(
                              // //                                                               15, 5, 15, 0),
                              // //                                                       child: Text(
                              // //                                                           "Add a Note",
                              // //                                                           style: Theme.of(
                              // //                                                                   context)
                              // //                                                               .textTheme
                              // //                                                               .headline6),
                              // //                                                     ),
                              // //                                                     Container(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                                   .fromLTRB(
                              // //                                                               15, 5, 15, 15),
                              // //                                                       child: TextFormField(
                              // //                                                         controller:
                              // //                                                             notesController,
                              // //                                                         keyboardType:
                              // //                                                             TextInputType
                              // //                                                                 .multiline,
                              // //                                                         textCapitalization:
                              // //                                                             TextCapitalization
                              // //                                                                 .sentences,
                              // //                                                         style: CustomTextStyle
                              // //                                                             .textBoxStyle,
                              // //                                                         maxLines: 5,
                              // //                                                         maxLength: 500,
                              // //                                                         validator: (value) {
                              // //                                                           if (value!
                              // //                                                               .isEmpty) {
                              // //                                                             return 'Notes is required';
                              // //                                                           }
                              // //                                                           return null;
                              // //                                                         },
                              // //                                                         onChanged: (value) {
                              // //                                                           setState(() {
                              // //                                                             modal.notes =
                              // //                                                                 value;
                              // //                                                           });
                              // //                                                         },
                              // //                                                         decoration: InputDecoration(
                              // //                                                             filled: true,
                              // //                                                             fillColor: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .colorScheme
                              // //                                                                 .textfiledColor,
                              // //                                                             border: OutlineInputBorder(
                              // //                                                                 borderSide:
                              // //                                                                     BorderSide
                              // //                                                                         .none,
                              // //                                                                 borderRadius:
                              // //                                                                     BorderRadius.circular(
                              // //                                                                         6)),
                              // //                                                             focusedBorder: OutlineInputBorder(
                              // //                                                                 borderSide:
                              // //                                                                     BorderSide
                              // //                                                                         .none,
                              // //                                                                 borderRadius:
                              // //                                                                     BorderRadius.circular(
                              // //                                                                         20.0)),
                              // //                                                             hintText:
                              // //                                                                 'Add notes here',
                              // //                                                             hintStyle: TextStyle(
                              // //                                                                 color: Theme.of(context)
                              // //                                                                     .colorScheme
                              // //                                                                     .fadeGrayColor)),
                              // //                                                       ),
                              // //                                                     ),
                              // //                                                   ],
                              // //                                                 ),
                              // //                                                 Container(
                              // //                                                   padding:
                              // //                                                       const EdgeInsets.all(
                              // //                                                           15),
                              // //                                                   width:
                              // //                                                       MediaQuery.of(context)
                              // //                                                           .size
                              // //                                                           .width,
                              // //                                                   child: ElevatedButton(
                              // //                                                     style: ElevatedButton
                              // //                                                         .styleFrom(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                               .all(15),
                              // //                                                       elevation: 0,
                              // //                                                       primary:
                              // //                                                           Theme.of(context)
                              // //                                                               .primaryColor,
                              // //                                                       shape:
                              // //                                                           RoundedRectangleBorder(
                              // //                                                               borderRadius:
                              // //                                                                   BorderRadius
                              // //                                                                       .circular(
                              // //                                                                           6)),
                              // //                                                     ),
                              // //                                                     child: Text(
                              // //                                                       'Save',
                              // //                                                       style: Theme.of(context)
                              // //                                                           .textTheme
                              // //                                                           .headline3,
                              // //                                                     ),
                              // //                                                     onPressed: () {
                              // //                                                       EasyLoading
                              // //                                                           .addStatusCallback(
                              // //                                                               (status) {});
                              // //                                                       EasyLoading.show(
                              // //                                                           status:
                              // //                                                               'loading...');
                              // //                                                       saveNote(modal.notes,
                              // //                                                               modal.id)
                              // //                                                           .then((response) {
                              // //                                                         if (response == "1") {
                              // //                                                           setState(() {
                              // //                                                             showNotesBox =
                              // //                                                                 false;
                              // //                                                           });
                              // //                                                         }
                              // //                                                         EasyLoading.dismiss();
                              // //                                                       });
                              // //                                                     },
                              // //                                                   ),
                              // //                                                 ),
                              // //                                               ],
                              // //                                             )
                              // //                                           : Column(
                              // //                                               mainAxisAlignment:
                              // //                                                   MainAxisAlignment
                              // //                                                       .spaceBetween,
                              // //                                               children: [
                              // //                                                 Column(
                              // //                                                   crossAxisAlignment:
                              // //                                                       CrossAxisAlignment
                              // //                                                           .start,
                              // //                                                   children: [
                              // //                                                     Container(
                              // //                                                       padding:
                              // //                                                           const EdgeInsets
                              // //                                                                   .fromLTRB(
                              // //                                                               15, 5, 15, 0),
                              // //                                                       child: Text("Notes",
                              // //                                                           style: Theme.of(
                              // //                                                                   context)
                              // //                                                               .textTheme
                              // //                                                               .headline6),
                              // //                                                     ),
                              // //                                                     Container(
                              // //                                                         decoration: BoxDecoration(
                              // //                                                             color: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .colorScheme
                              // //                                                                 .textfiledColor),
                              // //                                                         alignment: Alignment
                              // //                                                             .centerLeft,
                              // //                                                         padding:
                              // //                                                             const EdgeInsets
                              // //                                                                 .all(15),
                              // //                                                         child: Text(
                              // //                                                             modal == null
                              // //                                                                 ? ""
                              // //                                                                 : modal.notes,
                              // //                                                             style:
                              // //                                                                 CustomTextStyle
                              // //                                                                     .heading5)),
                              // //                                                   ],
                              // //                                                 ),
                              // //                                                 modal.docSharingEditAccess ==
                              // //                                                             true ||
                              // //                                                         modal.isDocCreated ==
                              // //                                                             true
                              // //                                                     ? Container(
                              // //                                                         height: 80,
                              // //                                                         padding:
                              // //                                                             const EdgeInsets
                              // //                                                                 .all(15),
                              // //                                                         width: MediaQuery.of(
                              // //                                                                 context)
                              // //                                                             .size
                              // //                                                             .width,
                              // //                                                         child: ElevatedButton(
                              // //                                                           style:
                              // //                                                               ElevatedButton
                              // //                                                                   .styleFrom(
                              // //                                                             padding:
                              // //                                                                 const EdgeInsets
                              // //                                                                     .all(0.0),
                              // //                                                             elevation: 0,
                              // //                                                             primary: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .primaryColor,
                              // //                                                             shape: RoundedRectangleBorder(
                              // //                                                                 borderRadius:
                              // //                                                                     BorderRadius
                              // //                                                                         .circular(
                              // //                                                                             6)),
                              // //                                                           ),
                              // //                                                           child: Text(
                              // //                                                             'Edit',
                              // //                                                             style: Theme.of(
                              // //                                                                     context)
                              // //                                                                 .textTheme
                              // //                                                                 .headline3,
                              // //                                                           ),
                              // //                                                           onPressed: () {
                              // //                                                             setState(() {
                              // //                                                               showNotesBox =
                              // //                                                                   true;
                              // //                                                             });
                              // //                                                           },
                              // //                                                         ))
                              // //                                                     : Container()
                              // //                                               ],
                              // //                                             )),
                              // //                                 ]))
                              // //                       ])),
                              // //             ],
                              // //           ),
                              // //   ));
                              // // }

                              // // Future<dynamic> addSharing(BuildContext context) {
                              // //   return showModalBottomSheet(
                              // //     backgroundColor: Theme.of(context).colorScheme.whiteColor,
                              // //     isDismissible: false,
                              // //     isScrollControlled: true,
                              // //     context: context,
                              // //     shape: const RoundedRectangleBorder(
                              // //       borderRadius: BorderRadius.only(
                              // //         topRight: Radius.circular(20),
                              // //         topLeft: Radius.circular(20),
                              // //       ),
                              // //     ),
                              // //     builder: (context) {
                              // //       return SizedBox(
                              // //           height: 450,
                              // //           child: SingleChildScrollView(
                              // //             child: Container(
                              // //               padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              // //               child: Form(
                              // //                   key: _formKey,
                              // //                   child: ListView(
                              // //                       shrinkWrap: true,
                              // //                       physics: const ClampingScrollPhysics(),
                              // //                       children: [
                              // //                         Row(
                              // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // //                             children: [
                              // //                               Container(
                              // //                                   padding: const EdgeInsets.all(10),
                              // //                                   alignment: Alignment.center,
                              // //                                   child: Text("Share Document",
                              // //                                       style: TextStyle(
                              // //                                         fontSize: 18,
                              // //                                         color: Theme.of(context).primaryColor,
                              // //                                         fontWeight: FontWeight.w600,
                              // //                                       ))),
                              // //                               Padding(
                              // //                                 padding: const EdgeInsets.all(10.0),
                              // //                                 child: Container(
                              // //                                     alignment: Alignment.centerRight,
                              // //                                     child: IconButton(
                              // //                                         onPressed: () {
                              // //                                           Navigator.pop(context);
                              // //                                         },
                              // //                                         icon: Icon(
                              // //                                           Icons.close,
                              // //                                           color: Theme.of(context)
                              // //                                               .colorScheme
                              // //                                               .blackColor,
                              // //                                         ))),
                              // //                               ),
                              // //                             ]),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              // //                           child: Row(
                              // //                             children: [
                              // //                               Text("Sharer’s Name",
                              // //                                   style:
                              // //                                       Theme.of(context).textTheme.headline6),
                              // //                               // Text("*",
                              // //                               //     style: TextStyle(
                              // //                               //         color: Theme.of(context)
                              // //                               //             .colorScheme
                              // //                               //             .redColor)),
                              // //                             ],
                              // //                           ),
                              // //                         ),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              // //                           width: MediaQuery.of(context).size.width / 3,
                              // //                           child: DropdownButtonFormField(
                              // //                               isExpanded: true,
                              // //                               style: CustomTextStyle.textBoxStyle,
                              // //                               iconEnabledColor:
                              // //                                   Theme.of(context).iconTheme.color,
                              // //                               hint: Text("Select sharer",
                              // //                                   style: TextStyle(
                              // //                                       color: Theme.of(context)
                              // //                                           .colorScheme
                              // //                                           .fadeGrayColor)),
                              // //                               validator: (value) {
                              // //                                 if (value == null) {
                              // //                                   return 'Sharer is required';
                              // //                                 }
                              // //                                 return null;
                              // //                               },
                              // //                               decoration: InputDecoration(
                              // //                                 contentPadding:
                              // //                                     const EdgeInsets.fromLTRB(6, 15, 6, 16),
                              // //                                 filled: true,
                              // //                                 fillColor: Theme.of(context)
                              // //                                     .colorScheme
                              // //                                     .textfiledColor,
                              // //                                 border: OutlineInputBorder(
                              // //                                     borderSide: BorderSide.none,
                              // //                                     borderRadius: BorderRadius.circular(6)),
                              // //                                 focusedBorder: OutlineInputBorder(
                              // //                                     borderSide: BorderSide.none,
                              // //                                     borderRadius: BorderRadius.circular(6.0)),
                              // //                               ),
                              // //                               items: listSharerUser.map((UserSharerVm item) {
                              // //                                 return DropdownMenuItem(
                              // //                                   child: Text(
                              // //                                     item.name,
                              // //                                   ),
                              // //                                   value: item.userId,
                              // //                                 );
                              // //                               }).toList(),
                              // //                               onChanged: (value) {
                              // //                                 setState(() {
                              // //                                   addDocShare.userId = value as String;
                              // //                                 });
                              // //                               }),
                              // //                         ),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              // //                           child: Text(
                              // //                               "Sharer’s that you have already added and they have accepted your request to join your sharer list are visible only. To add a new sharer go to “Manage Sharer List” in the left menu on the dashboard.",
                              // //                               textAlign: TextAlign.justify,
                              // //                               style: Theme.of(context).textTheme.headline6),
                              // //                         ),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              // //                           child: Row(
                              // //                             children: [
                              // //                               Text("Access",
                              // //                                   style:
                              // //                                       Theme.of(context).textTheme.headline6),
                              // //                               // Text("*",
                              // //                               //     style: TextStyle(
                              // //                               //         color: Theme.of(context)
                              // //                               //             .colorScheme
                              // //                               //             .redColor)),
                              // //                             ],
                              // //                           ),
                              // //                         ),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              // //                           width: MediaQuery.of(context).size.width / 3,
                              // //                           child: DropdownButtonFormField(
                              // //                               isExpanded: true,
                              // //                               iconEnabledColor:
                              // //                                   Theme.of(context).iconTheme.color,
                              // //                               style: CustomTextStyle.textBoxStyle,
                              // //                               hint: Text("Select access level",
                              // //                                   style: TextStyle(
                              // //                                       color: Theme.of(context)
                              // //                                           .colorScheme
                              // //                                           .fadeGrayColor)),
                              // //                               validator: (value) {
                              // //                                 if (value == null) {
                              // //                                   return 'Access Type  is required';
                              // //                                 }
                              // //                                 return null;
                              // //                               },
                              // //                               decoration: InputDecoration(
                              // //                                 contentPadding:
                              // //                                     const EdgeInsets.fromLTRB(6, 16, 6, 16),
                              // //                                 filled: true,
                              // //                                 fillColor: Theme.of(context)
                              // //                                     .colorScheme
                              // //                                     .textfiledColor,
                              // //                                 border: OutlineInputBorder(
                              // //                                     borderSide: BorderSide.none,
                              // //                                     borderRadius: BorderRadius.circular(6)),
                              // //                                 focusedBorder: OutlineInputBorder(
                              // //                                     borderSide: BorderSide.none,
                              // //                                     borderRadius: BorderRadius.circular(6.0)),
                              // //                               ),
                              // //                               items: listAccessType.map((TblAccessType item) {
                              // //                                 return DropdownMenuItem(
                              // //                                   child: Text(
                              // //                                     item.title,
                              // //                                   ),
                              // //                                   value: item.id,
                              // //                                 );
                              // //                               }).toList(),
                              // //                               onChanged: (value) {
                              // //                                 setState(() {
                              // //                                   addDocShare.accessTypeId = value as String;
                              // //                                 });
                              // //                               }),
                              // //                         ),
                              // //                         Container(
                              // //                           padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                              // //                           child: ElevatedButton(
                              // //                             style: ElevatedButton.styleFrom(
                              // //                               padding: const EdgeInsets.all(15),
                              // //                               elevation: 0,
                              // //                               primary: Theme.of(context).primaryColor,
                              // //                               shape: RoundedRectangleBorder(
                              // //                                   borderRadius: BorderRadius.circular(6)),
                              // //                             ),
                              // //                             child: Text(
                              // //                               'Share',
                              // //                               style: Theme.of(context).textTheme.headline3,
                              // //                             ),
                              // //                             onPressed: () {
                              // //                               if (_formKey.currentState!.validate()) {
                              // //                                 _formKey.currentState!.save();
                              // //                                 setState(() {
                              // //                                   addDocShare.docId = docId;
                              // //                                 });
                              // //                                 EasyLoading.addStatusCallback((status) {});
                              // //                                 EasyLoading.show(status: 'loading...');
                              // //                                 addDocSharing(addDocShare).then((response) {
                              // //                                   getDocSharingDataTable(docId)
                              // //                                       .then((response) {
                              // //                                     setState(() {
                              // //                                       docSharingList = response!;
                              // //                                     });
                              // //                                     EasyLoading.dismiss();
                              // //                                   });
                              // //                                   addDocShare.accessTypeId = "";
                              // //                                   addDocShare.userId = "";

                              // //                                   String _msg = "";
                              // //                                   if (response == "-3") {
                              // //                                     _msg =
                              // //                                         "The document is already shared with this user.";
                              // //                                     EasyLoading.dismiss();
                              // //                                     String title = "";
                              // //                                     String _icon =
                              // //                                         "assets/images/Success.json";
                              // //                                     var respStatus = showInfoAlert(
                              // //                                         title, _msg, _icon, context);
                              // //                                     Future.delayed(const Duration(seconds: 3),
                              // //                                         () {
                              // //                                       Navigator.pop(context);
                              // //                                     });
                              // //                                   } else if (response == "1") {
                              // //                                     _msg = "The document " +
                              // //                                         modal.docName +
                              // //                                         " has been shared.";
                              // //                                     EasyLoading.dismiss();
                              // //                                     String title = "";
                              // //                                     String _icon =
                              // //                                         "assets/images/Success.json";
                              // //                                     var respStatus = showInfoAlert(
                              // //                                         title, _msg, _icon, context);
                              // //                                     Future.delayed(const Duration(seconds: 3),
                              // //                                         () {
                              // //                                       Navigator.pop(context);
                              // //                                       checkPushNotificationEnable()
                              // //                                           .then((rsp) {
                              // //                                         if (rsp!.shared = true) {
                              // //                                           final NotificationService
                              // //                                               _notificationService =
                              // //                                               NotificationService();
                              // //                                           _notificationService
                              // //                                               .initialiseNotifications();
                              // //                                           _notificationService.sendNotifications(
                              // //                                               "Shared Document",
                              // //                                               "You have shared a document.");
                              // //                                         }
                              // //                                       });
                              // //                                     });
                              // //                                   } else if (response == "-5") {
                              // //                                     String _msg =
                              // //                                         "You have limited No. of resources for sharing documents!\n \n Please upgrade your plan.";
                              // //                                     EasyLoading.dismiss();
                              // //                                     String title = "";
                              // //                                     String _icon = "assets/images/alert.json";
                              // //                                     var response = showUpgradePackageAlert(
                              // //                                         title, _msg, _icon, context);
                              // //                                   } else if (response == "-6") {
                              // //                                     String _msg =
                              // //                                         "You have limited No. of resources for sharing documents with a sharer!\n \n Please upgrade your plan.";
                              // //                                     EasyLoading.dismiss();
                              // //                                     String title = "";
                              // //                                     String _icon = "assets/images/alert.json";
                              // //                                     var response = showUpgradePackageAlert(
                              // //                                         title, _msg, _icon, context);
                              // //                                   }
                              // //                                 });
                              // //                               }
                              // //                             },
                              // //                           ),
                              // //                         ),
                              // //                       ])),
                              // //             ),
                              //           ));
                              //     },
                              //   );
                              // }

                              // Future<dynamic> deleteSharing(BuildContext context, String id) {
                              //   return showModalBottomSheet(
                              //     context: context,
                              //     isDismissible: false,
                              //     shape: const RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.only(
                              //       topRight: Radius.circular(20),
                              //       topLeft: Radius.circular(20),
                              //     )),
                              //     builder: (BuildContext context) {
                              //       return StatefulBuilder(builder: (context, setState) {
                              //         return Container(
                              //           padding: const EdgeInsets.all(15),
                              //           height: MediaQuery.of(context).size.width / 2,
                              //           alignment: Alignment.center,
                              //           child: Column(
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             crossAxisAlignment: CrossAxisAlignment.center,
                              //             children: [
                              //               const Text("Are you sure?",
                              //                   style: CustomTextStyle.heading2NOunderLIne),
                              //               Container(
                              //                 padding: const EdgeInsets.all(8),
                              //                 child: Text(
                              //                     "Once removed, document & tasks shared with the Sharer will be removed from their account.",
                              //                     style: Theme.of(context).textTheme.headline6,
                              //                     textAlign: TextAlign.center),
                              //               ),
                              //               Expanded(
                              //                 child: Container(
                              //                   alignment: Alignment.bottomCenter,
                              //                   padding: const EdgeInsets.all(15),
                              //                   child: Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                     children: [
                              //                       SizedBox(
                              //                         width: MediaQuery.of(context).size.width / 2.5,
                              //                         child: ElevatedButton(
                              //                             style: ElevatedButton.styleFrom(
                              //                               padding: const EdgeInsets.all(0.0),
                              //                               elevation: 0,
                              //                               primary: Colors.grey[200],
                              //                               shape: RoundedRectangleBorder(
                              //                                 borderRadius: BorderRadius.circular(25),
                              //                                 // side: BorderSide(
                              //                                 //     color: Theme.of(context)
                              //                                 //         .colorScheme
                              //                                 //         .textBoxBorderColor),
                              //                               ),
                              //                             ),
                              //                             child: const Text("Cancel",
                              //                                 style: CustomTextStyle.heading44),
                              //                             onPressed: () {
                              //                               Navigator.pop(context);
                              //                             }),
                              //                       ),
                              //                       SizedBox(
                              //                         width: MediaQuery.of(context).size.width / 2.5,
                              //                         child: ElevatedButton(
                              //                             style: ElevatedButton.styleFrom(
                              //                               padding: const EdgeInsets.all(0.0),
                              //                               elevation: 0,
                              //                               primary:
                              //                                   Theme.of(context).colorScheme.primryColor,
                              //                               shape: RoundedRectangleBorder(
                              //                                   borderRadius: BorderRadius.circular(6)),
                              //                             ),
                              //                             child: const Text(
                              //                               "Remove",
                              //                               style: CustomTextStyle.headingWhite,
                              //                             ),
                              //                             onPressed: () {
                              //                               deleteDocSharing(id).then((response) {
                              //                                 if (response == "1") {
                              //                                   Navigator.pop(context);
                              //                                   String _msg =
                              //                                       "Shared Document has been successfully deleted.";
                              //                                   EasyLoading.dismiss();
                              //                                   String title = "";
                              //                                   String _icon = "assets/images/Success.json";
                              //                                   var response = showInfoAlert(
                              //                                       title, _msg, _icon, context);
                              //                                 }
                              //                                 EasyLoading.dismiss();
                              //                               });
                              //                             }),
                              //                       )
                              //                     ],
                              //                   ),
                              //                 ),
                              //               )
                              //             ],
                              //           ),
                              //         );
                              //       });
                              //     },
                              //   ).whenComplete(() {
                              //     getDocSharingDataTable(docId).then((response) {
                              //       setState(() {
                              //         docSharingList = response!;
                              //       });
                              //       EasyLoading.dismiss();
                              //     });
                              //     Future.delayed(const Duration(seconds: 3), () {
                              //       Navigator.pop(context);
                              //     });
                              //   });
                              // }

                              // Future<dynamic> changeDocStatus(
                              //     BuildContext context, bool isDocCreated, bool docSharingEditAccess) {
                              //   return showModalBottomSheet(
                              //       isDismissible: true,
                              //       isScrollControlled: true,
                              //       context: context,
                              //       shape: const RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.only(
                              //           topRight: Radius.circular(20),
                              //           topLeft: Radius.circular(20),
                              //         ),
                              //       ),
                              //       builder: (BuildContext context) {
                              //         return StatefulBuilder(builder: (context, setState) {
                              //           return SizedBox(
                              //             height: 330,
                              //             child: Container(
                              //                 padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              //                 child: ListView(children: [
                              //                   Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                     children: [
                              //                       Container(
                              //                           padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                              //                           // alignment: Alignment.center,
                              //                           child: Text(
                              //                             "Update Document Status",
                              //                             style: TextStyle(
                              //                                 color: Theme.of(context).primaryColor),
                              //                           )),
                              //                       Container(
                              //                           // alignment: Alignment.centerRight,
                              //                           padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                              //                           child: IconButton(
                              //                               onPressed: () {
                              //                                 Navigator.pop(context);
                              //                               },
                              //                               icon: Icon(
                              //                                 Icons.close,
                              //                                 color:
                              //                                     Theme.of(context).colorScheme.blackColor,
                              //                               ))),
                              //                     ],
                              //                   ),
                              //                   Container(
                              //                     padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
                              //                     child: Row(
                              //                       children: [
                              //                         Radio(
                              //                           value: 1,
                              //                           groupValue: docStatus,
                              //                           visualDensity: const VisualDensity(
                              //                               horizontal: -4, vertical: -4),
                              //                           onChanged: (value) {
                              //                             setState(() {
                              //                               modal.docUserStatusId = value as int;
                              //                               docStatus = modal.docUserStatusId;
                              //                             });
                              //                           },
                              //                         ),
                              //                         Column(
                              //                           crossAxisAlignment: CrossAxisAlignment.start,
                              //                           children: const [
                              //                             Text("Pending Renewal",
                              //                                 style: CustomTextStyle.heading11),
                              //                             Text("Renewal process not initiated",
                              //                                 style: CustomTextStyle.heading10),
                              //                           ],
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     padding: const EdgeInsets.all(15),
                              //                     child: Row(
                              //                       children: [
                              //                         Radio(
                              //                           value: 2,
                              //                           groupValue: docStatus,
                              //                           visualDensity: const VisualDensity(
                              //                               horizontal: -4, vertical: -4),
                              //                           onChanged: (value) {
                              //                             setState(() {
                              //                               modal.docUserStatusId = value as int;
                              //                               docStatus = modal.docUserStatusId;
                              //                             });
                              //                           },
                              //                         ),
                              //                         Column(
                              //                           crossAxisAlignment: CrossAxisAlignment.start,
                              //                           children: const [
                              //                             Text("Renewal In-Progress",
                              //                                 style: CustomTextStyle.heading11),
                              //                             Text("Process underway",
                              //                                 style: CustomTextStyle.heading10),
                              //                           ],
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   isDocCreated == true || docSharingEditAccess == true
                              //                       ? Container(
                              //                           padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                              //                           child: ElevatedButton(
                              //                             style: ElevatedButton.styleFrom(
                              //                               padding: const EdgeInsets.all(15),
                              //                               elevation: 0,
                              //                               primary: Theme.of(context).primaryColor,
                              //                               shape: RoundedRectangleBorder(
                              //                                   borderRadius: BorderRadius.circular(6)),
                              //                             ),
                              //                             child: Text(
                              //                               'Update Status',
                              //                               style: Theme.of(context).textTheme.headline3,
                              //                             ),
                              //                             onPressed: () {
                              //                               updateUserDocStatus(
                              //                                       docId, modal.docUserStatusId)
                              //                                   .then((response) {
                              //                                 Navigator.of(context).pop();
                              //                                 checkPushNotificationEnable().then((rsp) {
                              //                                   if (rsp!.statusChange == true) {
                              //                                     final NotificationService
                              //                                         _notificationService =
                              //                                         NotificationService();
                              //                                     _notificationService
                              //                                         .initialiseNotifications();
                              //                                     _notificationService.sendNotifications(
                              //                                         "Document Status",
                              //                                         "The status of the document " +
                              //                                             modal.docName +
                              //                                             " has been changed.");
                              //                                   }
                              // });
                              // });
                              // },
                              // ),
                              // )
                              // : Container()
                              //       ])),
                              //   //  extra brackets
                              // ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: () {
                              updatedetail(context);
                            },
                            child: Container(
                              height: 44,
                              // width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xff00A3FF),
                              ),
                              child: Center(
                                child: Text('Mark as Renewed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            color: const Color(0xffFFFFFF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
    // });
    // })
    //     .whenComplete(() {
    //   setState(() {
    //     modal.docUserStatusId = docStatus;
    //   });
    // });
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

  Future<dynamic> addSharing(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
            height: 480,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                color: const Color(0xffFFFFFF),
                child: Form(
                    key: _formKey,
                    child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .blackColor,
                                  ))),
                          Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Share Document",
                                style: CustomTextStyle.topHeading.copyWith(
                                    color: Theme.of(context).primaryColor),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Row(
                              children: [
                                Text("Sharer’s Name",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                // Text("*",
                                //     style: TextStyle(
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .redColor)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            width: MediaQuery.of(context).size.width / 3,
                            child: DropdownButtonFormField(
                                isExpanded: true,
                                style: CustomTextStyle.textBoxStyle,
                                iconEnabledColor:
                                    Theme.of(context).iconTheme.color,
                                hint: Text("Select sharer",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fadeGrayColor)),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Sharer is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(17),
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
                                // decoration: InputDecoration(
                                //   contentPadding:
                                //       const EdgeInsets.fromLTRB(6, 15, 6, 16),
                                //   enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color: Theme.of(context)
                                //               .colorScheme
                                //               .textBoxBorderColor),
                                //       borderRadius: BorderRadius.circular(5.0)),
                                //   focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color:
                                //               Theme.of(context).primaryColor),
                                //       borderRadius: BorderRadius.circular(5.0)),
                                // ),
                                items: listSharerUser.map((UserSharerVm item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.name,
                                    ),
                                    value: item.userId,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    addDocShare.userId = value as String;
                                  });
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Text(
                                "Sharer’s that you have already added and they have accepted your request to join your sharer list are visible only. To add a new sharer go to “Manage Sharer List” in the left menu on the dashboard.",
                                textAlign: TextAlign.justify,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.grey)),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Row(
                              children: [
                                Text("Access",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                // Text("*",
                                //     style: TextStyle(
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .redColor)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            width: MediaQuery.of(context).size.width / 3,
                            child: DropdownButtonFormField(
                                isExpanded: true,
                                iconEnabledColor:
                                    Theme.of(context).iconTheme.color,
                                style: CustomTextStyle.textBoxStyle,
                                hint: Text("Select access level",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fadeGrayColor)),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Access Type  is required';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(17),
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
                                // decoration: InputDecoration(
                                //   contentPadding:
                                //       const EdgeInsets.fromLTRB(6, 16, 6, 16),
                                //   enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color: Theme.of(context)
                                //               .colorScheme
                                //               .textBoxBorderColor),
                                //       borderRadius: BorderRadius.circular(5.0)),
                                //   focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1.5,
                                //           color:
                                //               Theme.of(context).primaryColor),
                                //       borderRadius: BorderRadius.circular(5.0)),
                                // ),
                                items: listAccessType.map((TblAccessType item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.title,
                                    ),
                                    value: item.id,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    addDocShare.accessTypeId = value as String;
                                  });
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                elevation: 0,
                                primary: const Color(0xff00A3FF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Text(
                                'Share',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  setState(() {
                                    addDocShare.docId = docId;
                                  });
                                  EasyLoading.addStatusCallback((status) {});
                                  EasyLoading.show(status: 'loading...');
                                  addDocSharing(addDocShare).then((response) {
                                    getDocSharingDataTable(docId)
                                        .then((response) {
                                      setState(() {
                                        docSharingList = response!;
                                      });
                                      EasyLoading.dismiss();
                                    });
                                    addDocShare.accessTypeId = "";
                                    addDocShare.userId = "";

                                    String _msg = "";
                                    if (response == "-3") {
                                      _msg =
                                          "The document is already shared with this user.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon =
                                          "assets/images/Success.json";
                                      var respStatus = showInfoAlert(
                                          title, _msg, _icon, context);
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    } else if (response == "1") {
                                      _msg = "The document " +
                                          modal.docName +
                                          " has been shared.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon =
                                          "assets/images/Success.json";
                                      var respStatus = showInfoAlert(
                                          title, _msg, _icon, context);
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        Navigator.pop(context);
                                        checkPushNotificationEnable()
                                            .then((rsp) {
                                          if (rsp!.shared = true) {
                                            final NotificationService
                                                _notificationService =
                                                NotificationService();
                                            _notificationService
                                                .initialiseNotifications();
                                            _notificationService.sendNotifications(
                                                "Shared Document",
                                                "You have shared a document.");
                                          }
                                        });
                                      });
                                    } else if (response == "-5") {
                                      String _msg =
                                          "You have limited No. of resources for sharing documents!\n \n Please upgrade your plan.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon = "assets/images/alert.json";
                                      var response = showUpgradePackageAlert(
                                          title, _msg, _icon, context);
                                    } else if (response == "-6") {
                                      String _msg =
                                          "You have limited No. of resources for sharing documents with a sharer!\n \n Please upgrade your plan.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon = "assets/images/alert.json";
                                      var response = showUpgradePackageAlert(
                                          title, _msg, _icon, context);
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                        ])),
              ),
            ));
      },
    );
  }

  Future<dynamic> updatedetail(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        DateTime startDate = DateTime(2000);
        DateTime enddate = DateTime(2050);
        final DateFormat customFormat = DateFormat('MMM dd, yyyy');
        TextEditingController expiryDateController = TextEditingController();
        TextEditingController issueDateController = TextEditingController();

        DateTime? _parseDate(String? dateStr) {
          if (dateStr == null) return null;
          try {
            return DateFormat('yyyy-MM-dd').parseStrict(dateStr);
          } catch (e) {
            print("Invalid date format: $e");
            return null;
          }
        }

        return SizedBox(
            height: 700,
            child: SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return Container(
                  color: const Color(0xffF2F3F7),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .blackColor,
                                    ))),
                            Container(
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Update expiration details",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700)),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  Text(
                                      "Add new expiration date after successful renewal to move the document to Active status.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontSize: 14,
                                              color: const Color(0xffA7A8BB),
                                              fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Row(
                                children: [
                                  Text("Expiration Date",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: expiryDateController,
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return 'Expiration Date is required';
                                //   }
                                //   return null;
                                // },
                                style: const TextStyle(
                                    fontSize:
                                        16.0), // Replace with your CustomTextStyle.textBoxStyle
                                decoration: InputDecoration(
                                  suffixIcon: Image.asset(
                                    'assets/images/Calendar.png',
                                    scale: 3,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(6, 15, 6, 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: .5, color: Color(0xffD0D5DD)),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0.5, color: Color(0xffD0D5DD)),
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  DateTime? initialDate =
                                      _parseDate(modal.issueDate) ??
                                          DateTime.now();
                                  DateTime? firstDate =
                                      _parseDate(modal.issueDate) ?? startDate;

                                  DateTime? date = await showDatePicker(
                                    context: context,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    initialDate: initialDate,
                                    firstDate: firstDate,
                                    lastDate: enddate,
                                  );

                                  if (date != null) {
                                    setState(() {
                                      expiryDateController.text =
                                          customFormat.format(date);
                                      modal.expiryDate = date
                                          .toString(); // Assuming `modal` is defined somewhere in your code
                                    });
                                  }
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  checkColor: const Color(0xff00A3FF),
                                  value: checkBoxValue,
                                  activeColor: const Color(0xffc2e3f9),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      checkBoxValue = newValue!;
                                    });
                                  },
                                ),
                                const Text(
                                  'I have issue date and validity period.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff5E6278),
                                      fontSize:
                                          14), // Optional: customize the text style
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            checkBoxValue == false
                                ? DottedBorder(
                                    radius: const Radius.circular(12),
                                    borderType: BorderType.RRect,
                                    color: const Color(0xff00A3FF),
                                    strokeWidth: .5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          const Radius.circular(12)),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF1FAFF),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/Icon.png',
                                                // : 'assets/images/jpg.png',
                                                height: 33,
                                                width: 35,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: const [
                                                  SizedBox(
                                                    height: 13,
                                                  ),
                                                  Text(
                                                    'Quick file uploader',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff475467)),
                                                  ),
                                                  Text(
                                                    'Drag & Drop or choose up to 2 files \n(max 03 MB size) from your computer',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xffA7A8BB)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 5, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Issue Date",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                color: const Color(
                                                                    0xff475467),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 10, 0),
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width /
                                                  //     2.2,
                                                  child: TextFormField(
                                                    controller:
                                                        issueDateController,
                                                    keyboardType:
                                                        TextInputType.datetime,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      hintText: "Jan 01, 2024",
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                      suffixIcon: Image.asset(
                                                        'assets/images/Calendar.png',
                                                        scale: 3,
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              6, 15, 6, 16),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: .5,
                                                                  color: Color(
                                                                      0xffD0D5DD)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: const BorderSide(
                                                              width: 0.5,
                                                              color: const Color(
                                                                  0xffD0D5DD)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0)),
                                                    ),
                                                    onTap: () async {
                                                      DateTime? date =
                                                          DateTime(1900);
                                                      // FocusScope.of(context).requestFocus(FocusNode());
                                                      FocusScope.of(context)
                                                          .unfocus();

                                                      date =
                                                          (await showDatePicker(
                                                        context: context,
                                                        initialEntryMode:
                                                            DatePickerEntryMode
                                                                .calendarOnly,
                                                        initialDate: modal
                                                                .expiryDate
                                                                .isEmpty
                                                            ? DateTime.now()
                                                            : DateTime.parse(
                                                                modal
                                                                    .expiryDate),
                                                        firstDate: startDate,
                                                        lastDate: modal
                                                                .expiryDate
                                                                .isEmpty
                                                            ? enddate
                                                            : DateTime.parse(
                                                                modal
                                                                    .expiryDate),
                                                      ));
                                                      DateTime curentDate =
                                                          DateTime.now();
                                                      DateTime dateOnly =
                                                          DateTime(
                                                              curentDate.year,
                                                              curentDate.month,
                                                              curentDate.day);
                                                      if (date != null) {
                                                        if (date.isBefore(
                                                            dateOnly)) {
                                                          issueDateController
                                                                  .text =
                                                              customFormat
                                                                  .format(date);
                                                          modal.issueDate =
                                                              date.toString();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Validity",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .copyWith(
                                                              color: const Color(
                                                                  0xff475467),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.2,
                                                child: TextFormField(
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    // suffixIcon: Image.asset(
                                                    //   'assets/images/Calendar.png',
                                                    //   scale: 3,
                                                    // ),
                                                    hintText: "1 year/s",

                                                    hintStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            6, 15, 6, 16),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: .5,
                                                                color: Color(
                                                                    0xffD0D5DD)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 0.5,
                                                                color: Color(
                                                                    0xffD0D5DD)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        // padding: const EdgeInsets.fromLTRB(
                                        //     10, 20, 10, 0),
                                        child: Row(
                                          children: [
                                            Text("Update Document",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            // clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .5,
                                                      color: const Color(
                                                          0xffcfd5db)),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/pdf.png',
                                                        // : 'assets/images/jpg.png',
                                                        height: 48,
                                                        width: 48,
                                                      ),
                                                      const SizedBox(
                                                        height: 13,
                                                      ),
                                                      const Text(
                                                        'Insurance Card',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff475467)),
                                                      ),
                                                      const Text(
                                                        '1.4 MB',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xffA7A8BB)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Positioned(
                                                right: 5,
                                                top: 5,
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Color(0xffB5B5C3),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          DottedBorder(
                                            radius: const Radius.circular(12),
                                            borderType: BorderType.RRect,
                                            color: const Color(0xff00A3FF),
                                            strokeWidth: .5,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius
                                                      .all(
                                                  const Radius.circular(12)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF1FAFF),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/Icon.png',
                                                        // : 'assets/images/jpg.png',
                                                        height: 48,
                                                        width: 48,
                                                      ),
                                                      const SizedBox(
                                                        height: 13,
                                                      ),
                                                      const Text(
                                                        'File Uploader',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff475467)),
                                                      ),
                                                      const Text(
                                                        'Drag and drop',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xffA7A8BB)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            // Container(
                            //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 2),
                            //         child: Text(
                            //             "Attachments (" +
                            //                 (image.length +
                            //                         selectedfiles.length)
                            //                     .toString() +
                            //                 "/" +
                            //                 userPackage.attachPerDoc
                            //                     .toString() +
                            //                 ")",
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .headline6),
                            //       ),
                            //       image.isNotEmpty || selectedfiles.isNotEmpty
                            //           ? GestureDetector(
                            //               onTap: () {
                            //                 showAttachemnts(context);
                            //               },
                            //               child: Row(
                            //                 children: [
                            //                   Icon(Icons.add_circle_sharp,
                            //                       color: Theme.of(context)
                            //                           .colorScheme
                            //                           .linkTextColor,
                            //                       size: 18),
                            //                   const Padding(
                            //                     padding:
                            //                         EdgeInsets.only(left: 2),
                            //                     child: Text("Add more",
                            //                         style: CustomTextStyle
                            //                             .blueText),
                            //                   ),
                            //                 ],
                            //               ))
                            //           : Container(),
                            //     ],
                            //   ),
                            // ),
                            // image.isEmpty &&
                            //         selectedfiles.isEmpty &&
                            //         modal.attachmentList!.isEmpty
                            //     ? GestureDetector(
                            //         onTap: () {
                            //           showAttachemnts(context);
                            //         },
                            //         child: Container(
                            //           padding: const EdgeInsets.only(
                            //               top: 20, bottom: 20),
                            //           width: MediaQuery.of(context).size.width,
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //                   BorderRadius.circular(6),
                            //               color: Theme.of(context)
                            //                   .colorScheme
                            //                   .textfiledColor),
                            //           child: SizedBox(
                            //             width:
                            //                 MediaQuery.of(context).size.width,
                            //             height: 120,
                            //             child: Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //               children: [
                            //                 CircleAvatar(
                            //                   backgroundColor: Theme.of(context)
                            //                       .colorScheme
                            //                       .iconBackColor,
                            //                   child: Image.asset(
                            //                       "assets/Icons/uploadAttach.png",
                            //                       width: 35,
                            //                       height: 35),
                            //                 ),
                            //                 Padding(
                            //                   padding:
                            //                       const EdgeInsets.only(top: 8),
                            //                   child: Text(
                            //                     "Tap to upload",
                            //                     textAlign: TextAlign.center,
                            //                     style: TextStyle(
                            //                         color: Theme.of(context)
                            //                             .primaryColor),
                            //                   ),
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.all(2),
                            //                   child: Text(
                            //                     "SVG, PNG, JPG or GIF (max. 3 MB)",
                            //                     textAlign: TextAlign.center,
                            //                     style: Theme.of(context)
                            //                         .textTheme
                            //                         .headline6,
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : Container(),
                            // modal.attachmentList!.isNotEmpty
                            //     ? GridView.builder(
                            //         shrinkWrap: true,
                            //         physics: const ClampingScrollPhysics(),
                            //         gridDelegate:
                            //             const SliverGridDelegateWithFixedCrossAxisCount(
                            //           crossAxisCount: 3,
                            //         ),
                            //         itemCount: modal.attachmentList!.length,
                            //         itemBuilder:
                            //             (BuildContext context, int index) {
                            //           return Padding(
                            //             padding: const EdgeInsets.all(2.0),
                            //             child: Stack(
                            //               fit: StackFit.expand,
                            //               children: [
                            //                 modal.attachmentList![index]
                            //                             .fileExtention ==
                            //                         ".pdf"
                            //                     ? Container(
                            //                         alignment: Alignment.center,
                            //                         width: double.infinity,
                            //                         decoration: BoxDecoration(
                            //                             color: const Color
                            //                                     .fromARGB(
                            //                                 255, 250, 152, 4),
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(6)),
                            //                         child: Text(
                            //                           modal
                            //                               .attachmentList![
                            //                                   index]
                            //                               .fileExtention,
                            //                           style: const TextStyle(
                            //                             fontSize: 28,
                            //                             fontWeight:
                            //                                 FontWeight.bold,
                            //                             color: Colors.white,
                            //                           ),
                            //                         ))
                            //                     : ClipRRect(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 6),
                            //                         child: Container(
                            //                           height: 100,
                            //                           width: 150,
                            //                           decoration: BoxDecoration(
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(6),
                            //                           ),
                            //                           child: Image.network(
                            //                             imageUrl +
                            //                                 modal
                            //                                     .attachmentList![
                            //                                         index]
                            //                                     .attachmentUrl,
                            //                             fit: BoxFit.cover,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                 Positioned(
                            //                   right: -4,
                            //                   top: -4,
                            //                   child: IconButton(
                            //                       onPressed: () {
                            //                         setState(() {
                            //                           EasyLoading.show(
                            //                               status:
                            //                                   'Deleting...');
                            //                           deleteAttachment(modal
                            //                                   .attachmentList![
                            //                                       index]
                            //                                   .id)
                            //                               .then((reponse) {
                            //                             getDocumentById(
                            //                                     modal.id)
                            //                                 .then((response) {
                            //                               setState(() {
                            //                                 modal = response!;
                            //                                 EasyLoading
                            //                                     .dismiss();
                            //                               });
                            //                             });
                            //                           });
                            //                         });
                            //                       },
                            //                       icon: Container(
                            //                         height: 25,
                            //                         width: 25,
                            //                         decoration: BoxDecoration(
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   15),
                            //                           color: Theme.of(context)
                            //                               .colorScheme
                            //                               .profileEditColor,
                            //                         ),
                            //                         child: const Icon(
                            //                           Icons.close,
                            //                           size: 15,
                            //                         ),
                            //                       ),
                            //                       color: Colors.black),
                            //                 )
                            //               ],
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     : Container(),
                            // image.isNotEmpty
                            //     ? GridView.builder(
                            //         shrinkWrap: true,
                            //         physics: const ClampingScrollPhysics(),
                            //         gridDelegate:
                            //             const SliverGridDelegateWithFixedCrossAxisCount(
                            //           crossAxisCount: 3,
                            //         ),
                            //         itemCount: image.isEmpty ? 0 : image.length,
                            //         itemBuilder:
                            //             (BuildContext context, int index) {
                            //           return Padding(
                            //             padding: const EdgeInsets.all(2.0),
                            //             child: Stack(
                            //               fit: StackFit.expand,
                            //               children: [
                            //                 ClipRRect(
                            //                   borderRadius:
                            //                       BorderRadius.circular(6),
                            //                   child: Image.file(
                            //                       File(image[index].path),
                            //                       fit: BoxFit.cover),
                            //                 ),
                            //                 Positioned(
                            //                   right: -4,
                            //                   top: -4,
                            //                   child: IconButton(
                            //                       onPressed: () {
                            //                         setState(() {
                            //                           image.removeAt(index);
                            //                         });
                            //                       },
                            //                       icon: Container(
                            //                           height: 25,
                            //                           width: 25,
                            //                           decoration: BoxDecoration(
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(15),
                            //                             color: Theme.of(context)
                            //                                 .colorScheme
                            //                                 .profileEditColor,
                            //                           ),
                            //                           child: const Icon(
                            //                             Icons.close,
                            //                             size: 15,
                            //                           )),
                            //                       color: Colors.black),
                            //                 )
                            //               ],
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     : Container(),
                            // selectedfiles.isNotEmpty
                            //     ? GridView.builder(
                            //         shrinkWrap: true,
                            //         physics: const ClampingScrollPhysics(),
                            //         gridDelegate:
                            //             const SliverGridDelegateWithFixedCrossAxisCount(
                            //           crossAxisCount: 3,
                            //         ),
                            //         itemCount: selectedfiles.isEmpty
                            //             ? 0
                            //             : selectedfiles.length,
                            //         itemBuilder:
                            //             (BuildContext context, int index) {
                            //           return Padding(
                            //             padding: const EdgeInsets.all(2.0),
                            //             child: Stack(
                            //               fit: StackFit.expand,
                            //               children: [
                            //                 Container(
                            //                     alignment: Alignment.center,
                            //                     width: double.infinity,
                            //                     decoration: BoxDecoration(
                            //                         color: const Color.fromARGB(
                            //                             255, 250, 152, 4),
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 6)),
                            //                     child: Text(
                            //                       "." +
                            //                           selectedfiles[index]
                            //                               .extension!,
                            //                       style: const TextStyle(
                            //                         fontSize: 28,
                            //                         fontWeight: FontWeight.bold,
                            //                         color: Colors.white,
                            //                       ),
                            //                     )),
                            //                 Positioned(
                            //                   right: -4,
                            //                   top: -4,
                            //                   child: IconButton(
                            //                       onPressed: () {
                            //                         setState(() {
                            //                           selectedfiles
                            //                               .removeAt(index);
                            //                         });
                            //                       },
                            //                       icon: Container(
                            //                           height: 25,
                            //                           width: 25,
                            //                           decoration: BoxDecoration(
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(15),
                            //                             color: Theme.of(context)
                            //                                 .colorScheme
                            //                                 .profileEditColor,
                            //                           ),
                            //                           child: const Icon(
                            //                             Icons.close,
                            //                             size: 15,
                            //                           )),
                            //                       color: Colors.black),
                            //                 )
                            //               ],
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     : Container(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                    elevation: 0,
                                    primary: const Color(0xff00A3FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  child: Text(
                                    'Update Document',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                          ])),
                );
              }),
            ));
      },
    );
  }
}
