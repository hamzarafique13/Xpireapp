import 'package:Xpiree/Modules/Dashboard/UI/NavigationBottom.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:Xpiree/Modules/Document/UI/folder_document.dart';
import 'package:Xpiree/Modules/FolderList/Model/FolderModel.dart';
import 'package:Xpiree/Modules/FolderList/Utils/FolderDataHelper.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class FolderList extends StatefulWidget {
  const FolderList({Key? key}) : super(key: key);

  @override
  FolderListState createState() => FolderListState();
}

class FolderListState extends State<FolderList> {
  int countNotify = 0;
  List<FolderVM> listOfFolders = [];
  final _formKey = GlobalKey<FormState>();
  AddFolder modal = AddFolder();
  int orderby = 1;

  TextEditingController folderNameController = TextEditingController();
  int groupValue = 1;
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {});
    EasyLoading.show(status: 'loading...');
    getfolderlist();
    EasyLoading.dismiss();
  }

  List<FolderVM> getfolderlist() {
    getFolderDataTable(orderby).then((response) {
      setState(() {
        listOfFolders = response!;
      });
    });
    return listOfFolders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
        centerTitle: true,
        leadingWidth: 0,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.dashboardbackGround,
        ),
        title: Text(
          "Folders",
          style: CustomTextStyle.topHeading.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                EasyLoading.addStatusCallback((status) {});
                EasyLoading.show(status: 'loading...');

                if (orderby == 1) {
                  setState(() {
                    orderby = 2;
                  });
                } else {
                  setState(() {
                    orderby = 1;
                  });
                }
                getfolderlist();
                EasyLoading.dismiss();
              },
              icon: Icon(Icons.sort_by_alpha,
                  color: Theme.of(context).colorScheme.warmGreyColor))
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await confirmExitApp(context);
        },
        child: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              getfolderlist();
              EasyLoading.dismiss();
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listOfFolders.isEmpty
                  ? SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            folderNameController.text = "";
                          });
                          showModalBottomSheet(
                            backgroundColor:
                                Theme.of(context).colorScheme.whiteColor,
                            context: context,
                            isScrollControlled: true,
                            // shape: const RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.only(
                            //   topRight: Radius.circular(20),
                            //   topLeft: Radius.circular(20),
                            // )),
                            builder: (_) {
                              return SingleChildScrollView(
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .whiteColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20),
                                                )),
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            child: Row(
                                              children: [
                                                Text("Folder Name",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                                // Text("*",
                                                //     style: TextStyle(
                                                //         color: Theme.of(context)
                                                //             .colorScheme
                                                //             .redColor)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            child: TextFormField(
                                              controller: folderNameController,
                                              style:
                                                  CustomTextStyle.textBoxStyle,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              inputFormatters: [
                                                FilteringTextInputFormatter(
                                                    RegExp("[a-zA-Z0-9 ]"),
                                                    allow: true)
                                              ],
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
                                                  modal.name = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Theme.of(context)
                                                      .colorScheme
                                                      .textfiledColor,
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide
                                                          .none,
                                                      borderRadius: BorderRadius
                                                          .circular(6)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide
                                                              .none,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0)),
                                                  hintText:
                                                      'New Folder e.g. Work Docs',
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Choose color",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          // const Color(
                                                          //     0xFF2D98DA),

                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 1,
                                                          groupValue:
                                                              groupValue,
                                                          activeColor:
                                                              Colors.black,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#2D98DA';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFA65EEA),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 2,
                                                          activeColor:
                                                              Colors.black,
                                                          groupValue:
                                                              groupValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#A65EEA';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFFF747D0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 3,
                                                          activeColor:
                                                              Colors.black,
                                                          groupValue:
                                                              groupValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#F747D0';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                                  0xFF948D61)
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 4,
                                                          activeColor:
                                                              Colors.black,
                                                          groupValue:
                                                              groupValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#948D61';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFF99A4B2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 5,
                                                          activeColor:
                                                              Colors.black,
                                                          groupValue:
                                                              groupValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#99A4B2';
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        width: 20,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFF3D5E8C),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Radio(
                                                          value: 6,
                                                          activeColor:
                                                              Colors.black,
                                                          groupValue:
                                                              groupValue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              groupValue =
                                                                  value as int;
                                                              modal.color =
                                                                  '#3D5E8C';
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        elevation: 0,
                                                        primary:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .textfiledColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                          "Cancel",
                                                          style: CustomTextStyle
                                                              .heading44),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        elevation: 0,
                                                        primary:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                      ),
                                                      child: const Text(
                                                        "Create",
                                                        style: CustomTextStyle
                                                            .headingWhite,
                                                      ),
                                                      onPressed: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          _formKey.currentState!
                                                              .save();
                                                          addFolder(modal)
                                                              .then((reponse) {
                                                            if (reponse ==
                                                                "1") {
                                                              SessionMangement
                                                                  _sm =
                                                                  SessionMangement();
                                                              _sm
                                                                  .getNoOfFolders()
                                                                  .then(
                                                                      (response) {
                                                                int sum = int.parse(
                                                                        response!) +
                                                                    1;
                                                                setState(() {
                                                                  _sm.setNoOfFolders(
                                                                      sum);
                                                                });
                                                              });
                                                              Navigator.pop(
                                                                  context);

                                                              String _msg =
                                                                  "The folder " +
                                                                      modal
                                                                          .name +
                                                                      " has been created.";
                                                              EasyLoading
                                                                  .dismiss();
                                                              String title =
                                                                  "Folder created";
                                                              String _icon =
                                                                  "assets/images/Success.json";
                                                              String resStatus =
                                                                  showInfoAlert(
                                                                      title,
                                                                      _msg,
                                                                      _icon,
                                                                      context);
                                                              if (resStatus ==
                                                                  "1") {
                                                                getfolderlist();
                                                              }
                                                            } else if (reponse ==
                                                                "-3") {
                                                              String _msg =
                                                                  "This folder name is already in use.";

                                                              String title = "";
                                                              String _icon =
                                                                  "assets/images/alert.json";
                                                              var response =
                                                                  showInfoAlert(
                                                                      title,
                                                                      _msg,
                                                                      _icon,
                                                                      context);
                                                            } else if (reponse ==
                                                                "-5") {
                                                              String _msg =
                                                                  "You have limited No. of resources for creating new folders!\n \n Please upgrade your plan.";
                                                              EasyLoading
                                                                  .dismiss();
                                                              String title = "";
                                                              String _icon =
                                                                  "assets/images/alert.json";
                                                              var response =
                                                                  showUpgradePackageAlert(
                                                                      title,
                                                                      _msg,
                                                                      _icon,
                                                                      context);
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
                            },
                          );
                        },
                        child:
                            // DottedBorder(
                            //     borderType: BorderType.RRect,
                            //     radius: const Radius.circular(6),
                            //     child:
                            Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            " +Add New Folder",
                            style: CustomTextStyle.heading44
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      )
                      // ),
                      ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: listOfFolders.isNotEmpty
                        ? GridView.builder(
                            itemCount: listOfFolders.length,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 1
                                    // MediaQuery.of(context).size.width /
                                    //     (MediaQuery.of(context).size.height / 1),
                                    ),
                            itemBuilder: (context, index) {
                              String getColor =
                                  listOfFolders[index].color.substring(1);
                              String colorStr = '0xFF' + getColor;
                              int color = int.parse(colorStr);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FolderDocument(
                                              folderId: listOfFolders[index].id,
                                              folderName:
                                                  listOfFolders[index].name,
                                            )),
                                  );
                                },
                                child: Container(
                                    // height: 150,
                                    // width: 170,
                                    margin:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8
                                          // topRight: Radius.circular(6),
                                          // bottomLeft: Radius.circular(6),
                                          // bottomRight: Radius.circular(6),
                                          ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8, top: 8),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      futheraction(context,
                                                          listOfFolders[index]);
                                                    },
                                                    child: const Icon(
                                                      Icons.more_vert_sharp,
                                                      color: Color(0xffA7A8BB),
                                                      size: 24,
                                                    )),
                                              ),
                                            ]),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.folder,
                                                color: Color(color),
                                                size: 90,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0),
                                                child: Text(
                                                    listOfFolders[
                                                                    index]
                                                                .name
                                                                .length >
                                                            15
                                                        ? listOfFolders[index]
                                                                .name
                                                                .substring(
                                                                    0, 15) +
                                                            "..."
                                                        : listOfFolders[index]
                                                            .name,
                                                    style: CustomTextStyle
                                                        .heading3White
                                                        .copyWith(
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Text(
                                                '${listOfFolders[index].docCount < 10 ? '0${listOfFolders[index].docCount}' : listOfFolders[index].docCount.toString()} Documents',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xffA7A8BB),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding:
                                              //       const EdgeInsets.only(
                                              //           top: 5),
                                              //   child: Text(
                                              //       "Last updated . " +
                                              //           getDateFormate(
                                              //               listOfFolders[
                                              //                       index]
                                              //                   .updatedOn),
                                              //       style: const TextStyle(
                                              //         fontSize: 9,
                                              //         fontWeight:
                                              //             FontWeight.normal,
                                              //         color:
                                              //             Color(0xffA7A8BB),
                                              //       )),
                                              // ),
                                            ])
                                      ],
                                    )),
                              );
                            })
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/undraw_folder_files_re_2cbm 1.png',
                                scale: 4,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No folder created.",
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    folderNameController.text = "";
                                  });
                                  showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .whiteColor,
                                    context: context,
                                    isScrollControlled: true,
                                    // shape: const RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.only(
                                    //   topRight: Radius.circular(20),
                                    //   topLeft: Radius.circular(20),
                                    // )),
                                    builder: (_) {
                                      return SingleChildScrollView(
                                        child: StatefulBuilder(
                                            builder: (context, setState) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .whiteColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                        )),
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 15, 15, 0),
                                                    child: Row(
                                                      children: [
                                                        Text("Folder Name",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6),
                                                        // Text("*",
                                                        //     style: TextStyle(
                                                        //         color: Theme.of(context)
                                                        //             .colorScheme
                                                        //             .redColor)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: TextFormField(
                                                      controller:
                                                          folderNameController,
                                                      style: CustomTextStyle
                                                          .textBoxStyle,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter(
                                                            RegExp(
                                                                "[a-zA-Z0-9 ]"),
                                                            allow: true)
                                                      ],
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Folder Name is required';
                                                        } else if (value
                                                                .length >
                                                            20) {
                                                          return 'Maximum up 20 characters';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        setState(() {
                                                          modal.name = value;
                                                        });
                                                      },
                                                      decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Theme.of(context)
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
                                                                      BorderRadius.circular(
                                                                          6.0)),
                                                          hintText:
                                                              'New Folder e.g. Work Docs',
                                                          hintStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Choose color",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  // const Color(
                                                                  //     0xFF2D98DA),

                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 1,
                                                                  groupValue:
                                                                      groupValue,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#2D98DA';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFA65EEA),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 2,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#A65EEA';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFF747D0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 3,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#F747D0';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                          0xFF948D61)
                                                                      .withOpacity(
                                                                          0.3),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 4,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#948D61';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFF99A4B2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 5,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#99A4B2';
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                width: 20,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFF3D5E8C),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child: Radio(
                                                                  value: 6,
                                                                  activeColor:
                                                                      Colors
                                                                          .black,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          value
                                                                              as int;
                                                                      modal.color =
                                                                          '#3D5E8C';
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
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                elevation: 0,
                                                                primary: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .textfiledColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  "Cancel",
                                                                  style: CustomTextStyle
                                                                      .heading44),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                elevation: 0,
                                                                primary: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6)),
                                                              ),
                                                              child: const Text(
                                                                "Create",
                                                                style: CustomTextStyle
                                                                    .headingWhite,
                                                              ),
                                                              onPressed: () {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  _formKey
                                                                      .currentState!
                                                                      .save();
                                                                  addFolder(
                                                                          modal)
                                                                      .then(
                                                                          (reponse) {
                                                                    if (reponse ==
                                                                        "1") {
                                                                      SessionMangement
                                                                          _sm =
                                                                          SessionMangement();
                                                                      _sm
                                                                          .getNoOfFolders()
                                                                          .then(
                                                                              (response) {
                                                                        int sum =
                                                                            int.parse(response!) +
                                                                                1;
                                                                        setState(
                                                                            () {
                                                                          _sm.setNoOfFolders(
                                                                              sum);
                                                                        });
                                                                      });
                                                                      Navigator.pop(
                                                                          context);

                                                                      String
                                                                          _msg =
                                                                          "The folder " +
                                                                              modal.name +
                                                                              " has been created.";
                                                                      EasyLoading
                                                                          .dismiss();
                                                                      String
                                                                          title =
                                                                          "Folder created";
                                                                      String
                                                                          _icon =
                                                                          "assets/images/Success.json";
                                                                      String resStatus = showInfoAlert(
                                                                          title,
                                                                          _msg,
                                                                          _icon,
                                                                          context);
                                                                      if (resStatus ==
                                                                          "1") {
                                                                        getfolderlist();
                                                                      }
                                                                    } else if (reponse ==
                                                                        "-3") {
                                                                      String
                                                                          _msg =
                                                                          "This folder name is already in use.";

                                                                      String
                                                                          title =
                                                                          "";
                                                                      String
                                                                          _icon =
                                                                          "assets/images/alert.json";
                                                                      var response = showInfoAlert(
                                                                          title,
                                                                          _msg,
                                                                          _icon,
                                                                          context);
                                                                    } else if (reponse ==
                                                                        "-5") {
                                                                      String
                                                                          _msg =
                                                                          "You have limited No. of resources for creating new folders!\n \n Please upgrade your plan.";
                                                                      EasyLoading
                                                                          .dismiss();
                                                                      String
                                                                          title =
                                                                          "";
                                                                      String
                                                                          _icon =
                                                                          "assets/images/alert.json";
                                                                      var response = showUpgradePackageAlert(
                                                                          title,
                                                                          _msg,
                                                                          _icon,
                                                                          context);
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
                                    },
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffdfedf8),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Create Folder",
                                    style: CustomTextStyle.heading44.copyWith(
                                        color: const Color(0xff00A3FF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddDocument()),
      //     );
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const NavigationBottom(selectedIndex: 3),
    );
  }

  Future<dynamic> futheraction(BuildContext context, FolderVM modal) {
    return showModalBottomSheet(
      context: context,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(20),
      //   topLeft: Radius.circular(20),
      // )),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(45, 15, 45, 5),
            height: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                        primary: Theme.of(context).colorScheme.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      child: Text("Edit",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal)),
                      onPressed: () {
                        editFolder(context, modal);
                      }),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                        primary: Theme.of(context).colorScheme.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.redColor),
                        ),
                      ),
                      child: Text("Delete",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.redColor,
                              fontWeight: FontWeight.normal)),
                      onPressed: () {
                        String msg;
                        String icon;
                        if (modal.docCount < 1) {
                          msg = "Folder has been deleted successfully.";
                          icon = "assets/images/Success.json";
                          EasyLoading.addStatusCallback((status) {});
                          EasyLoading.show(status: 'loading...');
                          deleteFolder(modal.id).then((response) {
                            SessionMangement _sm = SessionMangement();
                            _sm.getNoOfFolders().then((res) {
                              int sum = int.parse(res!) - 1;
                              _sm.setNoOfFolders(sum);
                            });
                            getfolderlist();
                            EasyLoading.dismiss();
                          });
                        } else {
                          msg =
                              "Seems like you are trying to delete a folder that contains documents.Try emptying folder first.";
                          icon = "assets/images/redalert.json";
                        }

                        deleteAlert(context, msg, icon);
                      }),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: CustomTextStyle.headingWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Future<dynamic> editFolder(BuildContext context, FolderVM modal) {
    UpdateFolder modal2 = UpdateFolder();
    setState(() {
      folderNameController.text = modal.name;
      modal2.id = modal.id;
      modal2.color = modal.color;
      modal2.name = modal.name;
    });

    switch (modal.color) {
      case '#2D98DA':
        groupValue = 1;
        break;
      case '#A65EEA':
        groupValue = 2;
        break;
      case '#F747D0':
        groupValue = 3;
        break;
      case '#948D61':
        groupValue = 4;
        break;
      case '#99A4B2':
        groupValue = 5;
        break;
      case '#3D5E8C':
        groupValue = 6;
        break;
      default:
        groupValue = 1;
        break;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.whiteColor,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(20),
      //   topLeft: Radius.circular(20),
      // )),
      builder: (_) {
        return SingleChildScrollView(
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              // decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //   topRight: Radius.circular(20),
              //   topLeft: Radius.circular(20),
              // )),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Row(
                        children: [
                          Text("Folder Name",
                              style: Theme.of(context).textTheme.headline6),
                          // Text("*",
                          //     style: TextStyle(
                          //         color:
                          //             Theme.of(context).colorScheme.redColor)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: folderNameController,
                        textCapitalization: TextCapitalization.words,
                        style: CustomTextStyle.textBoxStyle,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("[a-zA-Z0-9 ]"),
                              allow: true)
                        ],
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
                            modal2.name = value;
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
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 1,
                                    groupValue: groupValue,
                                    activeColor: Colors.black,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#2D98DA';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA65EEA),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 2,
                                    activeColor: Colors.black,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#A65EEA';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF747D0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 3,
                                    activeColor: Colors.black,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#F747D0';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF948D61)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 4,
                                    activeColor: Colors.black,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#948D61';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF99A4B2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 5,
                                    activeColor: Colors.black,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#99A4B2';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3D5E8C),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Radio(
                                    value: 6,
                                    activeColor: Colors.black,
                                    groupValue: groupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value as int;
                                        modal2.color = '#3D5E8C';
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0.0),
                                  elevation: 0,
                                  primary: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: const Text(
                                  "Update",
                                  style: CustomTextStyle.headingWhite,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    updateFolder(modal2).then((reponse) {
                                      if (reponse == "1") {
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        String _msg = "The folder " +
                                            modal2.name +
                                            " has been updated.";
                                        String title = "Update Folder";
                                        String _icon =
                                            "assets/images/Success.json";
                                        String resStatus = showInfoAlert(
                                            title, _msg, _icon, context);
                                        if (resStatus == "1") {
                                          getfolderlist();
                                        }
                                      } else if (reponse == "-3") {
                                        String _msg =
                                            "This folder name already exists.";
                                        String title = "";
                                        String _icon =
                                            "assets/images/alert.json";
                                        showInfoAlert(
                                            title, _msg, _icon, context);
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
      },
    );
  }

  Future<dynamic> deleteAlert(
      BuildContext context, String message, String icon) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topRight: Radius.circular(20),
      //   topLeft: Radius.circular(20),
      // )),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.width / 2,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(icon, height: 50, width: 50),
                Padding(
                  padding: const EdgeInsets.fromLTRB(55, 0, 55, 0),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text(
                        "Back",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          );
        });
      },
    );
  }
}

/* class folderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 6);
    path.lineTo(size.width / 2, size.height / 6);
    
    //path.quadraticBezierTo(size.width/2 ,size.height/5,0,0);
    
    path.lineTo(size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} */
