import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Modules/Document/UI/document_detail.dart';

class FolderDocument extends StatefulWidget {
  final String folderId;
  final String folderName;
  const FolderDocument(
      {Key? key, required this.folderId, required this.folderName})
      : super(key: key);

  @override
  FolderDocumentState createState() => FolderDocumentState();
}

class FolderDocumentState extends State<FolderDocument> {
  int countNotify = 0;
  late String folderId;
  late String folderName;
  List<Document> listOfFolderDoc = [];
  String countTabStr = "00";

  @override
  void initState() {
    super.initState();
    folderId = widget.folderId;
    folderName = widget.folderName;
    EasyLoading.show(status: 'loading...');
    getDocumentByFolderId(folderId).then((response) {
      setState(() {
        listOfFolderDoc = response!;
        countTabStr = listOfFolderDoc.length < 10
            ? "0" + listOfFolderDoc.length.toString()
            : listOfFolderDoc.length.toString();
      });
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f3f7),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20, color: Color(0xffA7A8BB)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          folderName,
          textAlign: TextAlign.left,
          style: CustomTextStyle.topHeading
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Text(
              countTabStr + " documents",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: listOfFolderDoc == null
                  ? Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "No record found!",
                      ),
                    )
                  : ListView.builder(
                      itemCount: listOfFolderDoc.length,
                      itemBuilder: (context, index) {
                        return listOfFolderDoc[index].status == 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DocumentData(
                                            docId: listOfFolderDoc[index].id,
                                            indexTab: 0)),
                                  );
                                },
                                child: Container(
                                    height: 140,
                                    padding: const EdgeInsets.only(top: 4),
                                    margin: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 140,
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                      decoration: BoxDecoration(
                                        color: listOfFolderDoc[index]
                                                    .docSharingUserId
                                                    .isNotEmpty &&
                                                listOfFolderDoc[index]
                                                        .isDocCreated ==
                                                    false
                                            ? Theme.of(context)
                                                .colorScheme
                                                .sharerColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 26,
                                                width: 64,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: const Color(
                                                        0xffE8FFF3)),
                                                child: const Center(
                                                  child: Text(
                                                    'Active',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff50CD89)),
                                                    // textAlign: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                              listOfFolderDoc[index]
                                                          .isbookmark ==
                                                      true
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        EasyLoading
                                                            .addStatusCallback(
                                                                (status) {});
                                                        EasyLoading.show(
                                                            status:
                                                                'loading...');
                                                        addBookmark(
                                                                listOfFolderDoc[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                false)
                                                            .then((response) {
                                                          if (response == "1") {
                                                            getDocumentByFolderId(
                                                                    folderId)
                                                                .then(
                                                                    (response) {
                                                              setState(() {
                                                                listOfFolderDoc =
                                                                    response!;
                                                                countTabStr = listOfFolderDoc
                                                                            .length <
                                                                        10
                                                                    ? "0" +
                                                                        listOfFolderDoc
                                                                            .length
                                                                            .toString()
                                                                    : listOfFolderDoc
                                                                        .length
                                                                        .toString();
                                                              });
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          }
                                                          EasyLoading.dismiss();
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.bookmark,
                                                        color: const Color(
                                                            0xffD6D6E0),
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        EasyLoading
                                                            .addStatusCallback(
                                                                (status) {});
                                                        EasyLoading.show(
                                                            status:
                                                                'loading...');
                                                        addBookmark(
                                                                listOfFolderDoc[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                true)
                                                            .then((response) {
                                                          if (response == "1") {
                                                            getDocumentByFolderId(
                                                                    folderId)
                                                                .then(
                                                                    (response) {
                                                              setState(() {
                                                                listOfFolderDoc =
                                                                    response!;
                                                                countTabStr = listOfFolderDoc
                                                                            .length <
                                                                        10
                                                                    ? "0" +
                                                                        listOfFolderDoc
                                                                            .length
                                                                            .toString()
                                                                    : listOfFolderDoc
                                                                        .length
                                                                        .toString();
                                                              });
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          }
                                                          EasyLoading.dismiss();
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .bookmark_outline_sharp,
                                                        color:
                                                            Color(0xffD6D6E0),
                                                      ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 12),
                                            child: Text(
                                                listOfFolderDoc[
                                                                index]
                                                            .docName
                                                            .length >
                                                        30
                                                    ? listOfFolderDoc[index]
                                                            .docName
                                                            .substring(0, 32) +
                                                        " ..."
                                                    : listOfFolderDoc[index]
                                                        .docName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                // decoration: BoxDecoration(
                                                //   color: Theme.of(context).colorScheme.activeColor,
                                                //   borderRadius: BorderRadius.circular(15),
                                                // ),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .folder_open_rounded,
                                                          color:
                                                              Color(0xffD6D6E0),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          folderName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xffB5B5C3),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(right: 5),
                                                    //   // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                                    //   child: Image.asset("assets/Icons/v_active.png"),
                                                    // ),
                                                    Text(
                                                      getDateFormate(
                                                          listOfFolderDoc[index]
                                                              .expiryDate),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff0BB783),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // const Text(
                                              //   "Active",
                                              //   style: CustomTextStyle.simple12Text,
                                              // )
                                            ],
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Container(
                                          //       padding:
                                          //           const EdgeInsets.fromLTRB(
                                          //               8, 2, 8, 2),
                                          //       decoration: BoxDecoration(
                                          //         color: Theme.of(context)
                                          //             .colorScheme
                                          //             .activeColor,
                                          //         borderRadius:
                                          //             BorderRadius.circular(15),
                                          //       ),
                                          //       child: Row(
                                          //         children: [
                                          //           Padding(
                                          //             padding:
                                          //                 const EdgeInsets.only(
                                          //                     right: 5),
                                          //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                          //             child: Image.asset(
                                          //                 "assets/Icons/v_active.png"),
                                          //           ),
                                          // Text(
                                          //   getDateFormate(
                                          //       listOfFolderDoc[index]
                                          //           .expiryDate),
                                          //   style: const TextStyle(
                                          //       color: Colors.white,
                                          //       fontWeight:
                                          //           FontWeight.w600,
                                          //       fontSize: 12),
                                          // ),
                                          //     ],
                                          //   ),
                                          // ),
                                          //     const Text(
                                          //       "Active",
                                          //       style: CustomTextStyle
                                          //           .simple12Text,
                                          //     ),
                                          //   ],
                                          // ),
                                          // Container(
                                          //   margin:
                                          //       const EdgeInsets.only(top: 10),
                                          //   padding: const EdgeInsets.only(
                                          //       top: 5, bottom: 5),
                                          //   decoration: const BoxDecoration(
                                          //       border: Border(
                                          //           top: BorderSide(
                                          //               color: Colors.grey,
                                          //               width: 0.7),
                                          //           bottom: BorderSide(
                                          //               color: Colors.grey,
                                          //               width: 0.7))),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Container(
                                          //         padding:
                                          //             const EdgeInsets.fromLTRB(
                                          //                 8, 3, 5, 3),
                                          //         width: 150,
                                          //         child: const Text(
                                          //           "No action required",
                                          //           style: TextStyle(
                                          //               fontSize: 12,
                                          //               color:
                                          //                   Color(0xFF323232),
                                          //               fontWeight:
                                          //                   FontWeight.w600),
                                          //         ),
                                          //       ),
                                          //       Row(
                                          //         children: [
                                          //           listOfFolderDoc[index]
                                          //                       .remindMe ==
                                          //                   false
                                          //               ? Container(
                                          //                   padding:
                                          //                       const EdgeInsets
                                          //                               .fromLTRB(
                                          //                           8, 2, 2, 2),
                                          //                   child: Icon(
                                          //                     Icons
                                          //                         .notifications_off_outlined,
                                          //                     color: Theme.of(
                                          //                             context)
                                          //                         .primaryColor,
                                          //                     size: 20,
                                          //                   ),
                                          //                 )
                                          //               : Container(),
                                          //           listOfFolderDoc[index]
                                          //                       .attachmentCount >
                                          //                   1
                                          //               ? Container(
                                          //                   padding:
                                          //                       const EdgeInsets
                                          //                               .fromLTRB(
                                          //                           0, 2, 8, 2),
                                          //                   child: Icon(
                                          //                     Icons.attach_file,
                                          //                     color: Theme.of(
                                          //                             context)
                                          //                         .primaryColor,
                                          //                     size: 20,
                                          //                   ),
                                          //                 )
                                          //               : Container()
                                          //         ],
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    listOfFolderDoc[index]
                                                                .docSharingUserId
                                                                .isNotEmpty &&
                                                            listOfFolderDoc[
                                                                        index]
                                                                    .isDocCreated ==
                                                                false
                                                        ? Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5),
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .userGroup,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .sharerIconColor,
                                                                  size: 12,
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: 1,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index2) {
                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              35,
                                                                          child: listOfFolderDoc[index].sharerByList!.profilePic == null
                                                                              ? CircleAvatar(
                                                                                  radius: 40,
                                                                                  backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                  child: Text(getUserFirstLetetrs(listOfFolderDoc[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                )
                                                                              : CircleAvatar(
                                                                                  radius: 25,
                                                                                  backgroundImage: CachedNetworkImageProvider(imageUrl + listOfFolderDoc[index].sharerByList!.profilePic.toString()),
                                                                                ),
                                                                        )
                                                                      ],
                                                                    );
                                                                  })
                                                            ],
                                                          )
                                                        : ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            itemCount: listOfFolderDoc
                                                                    .isEmpty
                                                                ? 0
                                                                : listOfFolderDoc[index]
                                                                            .sharerList ==
                                                                        null
                                                                    ? 0
                                                                    : listOfFolderDoc[
                                                                            index]
                                                                        .sharerList!
                                                                        .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index2) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 40,
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          50,
                                                                      backgroundColor: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .iceBlueColor,
                                                                      child: Text(
                                                                          getUserFirstLetetrs(listOfFolderDoc[index]
                                                                              .sharerList![
                                                                                  index2]
                                                                              .name),
                                                                          style:
                                                                              const TextStyle(fontSize: 14)),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                  ],
                                                ),
                                                Row(
                                                  children: const [
                                                    // Container(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //                 .only(
                                                    //             right: 15),
                                                    //     child: GestureDetector(
                                                    //         onTap: () {
                                                    //           Navigator.push(
                                                    //             context,
                                                    //             MaterialPageRoute(
                                                    //                 builder: (context) => DocumentData(
                                                    //                     docId: listOfFolderDoc[index]
                                                    //                         .id,
                                                    //                     indexTab:
                                                    //                         2)),
                                                    //           );
                                                    //         },
                                                    //         child: Icon(
                                                    //             Icons.share,
                                                    //             color: Theme.of(
                                                    //                     context)
                                                    //                 .colorScheme
                                                    //                 .warmGreyColor))),
                                                    // listOfFolderDoc[index]
                                                    //             .isbookmark ==
                                                    //         true
                                                    //     ? GestureDetector(
                                                    //         onTap: () {
                                                    //           EasyLoading
                                                    //               .addStatusCallback(
                                                    //                   (status) {});
                                                    //           EasyLoading.show(
                                                    //               status:
                                                    //                   'loading...');
                                                    //           addBookmark(
                                                    //                   listOfFolderDoc[
                                                    //                           index]
                                                    //                       .id
                                                    //                       .toString(),
                                                    //                   false)
                                                    //               .then(
                                                    //                   (response) {
                                                    //             if (response ==
                                                    //                 "1") {
                                                    //               getDocumentByFolderId(
                                                    //                       folderId)
                                                    //                   .then(
                                                    //                       (response) {
                                                    //                 setState(
                                                    //                     () {
                                                    //                   listOfFolderDoc =
                                                    //                       response!;
                                                    //                   countTabStr = listOfFolderDoc.length <
                                                    //                           10
                                                    //                       ? "0" +
                                                    //                           listOfFolderDoc.length
                                                    //                               .toString()
                                                    //                       : listOfFolderDoc
                                                    //                           .length
                                                    //                           .toString();
                                                    //                 });
                                                    //                 EasyLoading
                                                    //                     .dismiss();
                                                    //               });
                                                    //             }
                                                    //             EasyLoading
                                                    //                 .dismiss();
                                                    //           });
                                                    //         },
                                                    //         child: Icon(
                                                    //             Icons.bookmark,
                                                    //             color: Theme.of(
                                                    //                     context)
                                                    //                 .colorScheme
                                                    //                 .warmGreyColor))
                                                    //     : GestureDetector(
                                                    //         onTap: () {
                                                    //           EasyLoading
                                                    //               .addStatusCallback(
                                                    //                   (status) {});
                                                    //           EasyLoading.show(
                                                    //               status:
                                                    //                   'loading...');
                                                    //           addBookmark(
                                                    //                   listOfFolderDoc[
                                                    //                           index]
                                                    //                       .id
                                                    //                       .toString(),
                                                    //                   true)
                                                    //               .then(
                                                    //                   (response) {
                                                    //             if (response ==
                                                    //                 "1") {
                                                    //               getDocumentByFolderId(
                                                    //                       folderId)
                                                    //                   .then(
                                                    //                       (response) {
                                                    //                 setState(
                                                    //                     () {
                                                    //                   listOfFolderDoc =
                                                    //                       response!;
                                                    //                   countTabStr = listOfFolderDoc.length <
                                                    //                           10
                                                    //                       ? "0" +
                                                    //                           listOfFolderDoc.length
                                                    //                               .toString()
                                                    //                       : listOfFolderDoc
                                                    //                           .length
                                                    //                           .toString();
                                                    //                 });
                                                    //                 EasyLoading
                                                    //                     .dismiss();
                                                    //               });
                                                    //             }
                                                    //             EasyLoading
                                                    //                 .dismiss();
                                                    //           });
                                                    //         },
                                                    //         child: Icon(
                                                    //             Icons
                                                    //                 .bookmark_outline_sharp,
                                                    //             color: Theme.of(
                                                    //                     context)
                                                    //                 .colorScheme
                                                    //                 .warmGreyColor))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            : listOfFolderDoc[index].status == 2
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DocumentData(
                                                docId:
                                                    listOfFolderDoc[index].id,
                                                indexTab: 0)),
                                      );
                                    },
                                    child: Container(
                                        height: 140,
                                        padding: const EdgeInsets.only(top: 4),
                                        margin: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 140,
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          decoration: BoxDecoration(
                                            color: listOfFolderDoc[index]
                                                        .docSharingUserId
                                                        .isNotEmpty &&
                                                    listOfFolderDoc[index]
                                                            .isDocCreated ==
                                                        false
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .sharerColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 26,
                                                    width: 64,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: const Color(
                                                            0xffFFF8DD)),
                                                    child: const Center(
                                                      child: Text(
                                                        'Expiring',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffFFA621)),
                                                        // textAlign: Alignment.center,
                                                      ),
                                                    ),
                                                  ),
                                                  listOfFolderDoc[index]
                                                              .isbookmark ==
                                                          true
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listOfFolderDoc[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    false)
                                                                .then(
                                                                    (response) {
                                                              if (response ==
                                                                  "1") {
                                                                getDocumentByFolderId(
                                                                        folderId)
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfFolderDoc =
                                                                        response!;
                                                                    countTabStr = listOfFolderDoc.length <
                                                                            10
                                                                        ? "0" +
                                                                            listOfFolderDoc.length
                                                                                .toString()
                                                                        : listOfFolderDoc
                                                                            .length
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              }
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.bookmark,
                                                            color: const Color(
                                                                0xffD6D6E0),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listOfFolderDoc[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    true)
                                                                .then(
                                                                    (response) {
                                                              if (response ==
                                                                  "1") {
                                                                getDocumentByFolderId(
                                                                        folderId)
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfFolderDoc =
                                                                        response!;
                                                                    countTabStr = listOfFolderDoc.length <
                                                                            10
                                                                        ? "0" +
                                                                            listOfFolderDoc.length
                                                                                .toString()
                                                                        : listOfFolderDoc
                                                                            .length
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              }
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .bookmark_outline_sharp,
                                                            color: const Color(
                                                                0xffD6D6E0),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                listOfFolderDoc[
                                                                index]
                                                            .docName
                                                            .length >
                                                        30
                                                    ? listOfFolderDoc[index]
                                                            .docName
                                                            .substring(0, 32) +
                                                        " ..."
                                                    : listOfFolderDoc[index]
                                                        .docName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .folder_open_rounded,
                                                        color: const Color(
                                                            0xffD6D6E0),
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        folderName,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xffB5B5C3),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    getDateFormate(
                                                        listOfFolderDoc[index]
                                                            .expiryDate),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xffFFA621),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceBetween,
                                              //   children: [
                                              //     Container(
                                              //       padding: const EdgeInsets
                                              //           .fromLTRB(8, 2, 8, 2),
                                              //       decoration: BoxDecoration(
                                              //         color: Theme.of(context)
                                              //             .colorScheme
                                              //             .expiringColor,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 15),
                                              //       ),
                                              //       child: Row(
                                              //         children: [
                                              //           Padding(
                                              //             padding:
                                              //                 const EdgeInsets
                                              //                         .only(
                                              //                     right: 5),
                                              //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                              //             child: Image.asset(
                                              //                 "assets/Icons/v_expiring.png"),
                                              //           ),
                                              // Text(
                                              //   getDateFormate(
                                              //       listOfFolderDoc[
                                              //               index]
                                              //           .expiryDate),
                                              //   style:
                                              //       const TextStyle(
                                              //           color: Colors
                                              //               .white,
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .w600,
                                              //           fontSize: 12),
                                              // ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     RichText(
                                              //         text: TextSpan(children: [
                                              //       const TextSpan(
                                              //           text: "Expiring in ",
                                              //           style: CustomTextStyle
                                              //               .simple12Text),
                                              //       TextSpan(
                                              //           text: listOfFolderDoc[
                                              //                           index]
                                              //                       .diffTotalDays >
                                              //                   9
                                              //               ? listOfFolderDoc[
                                              //                       index]
                                              //                   .diffTotalDays
                                              //                   .toString()
                                              //               : "0" +
                                              //                   listOfFolderDoc[
                                              //                           index]
                                              //                       .diffTotalDays
                                              //                       .toString(),
                                              //           style: TextStyle(
                                              //               color: Theme.of(
                                              //                       context)
                                              //                   .colorScheme
                                              //                   .blackColor,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w700)),
                                              //       listOfFolderDoc[index]
                                              //                   .diffTotalDays >
                                              //               1
                                              //           ? const TextSpan(
                                              //               text: " days",
                                              //               style: CustomTextStyle
                                              //                   .simple12Text,
                                              //             )
                                              //           : const TextSpan(
                                              //               text: " day",
                                              //               style: CustomTextStyle
                                              //                   .simple12Text,
                                              //             ),
                                              //     ])),
                                              //   ],
                                              // ),
                                              // Container(
                                              //   margin: const EdgeInsets.only(
                                              //       top: 10),
                                              //   padding: const EdgeInsets.only(
                                              //       top: 5, bottom: 5),
                                              //   decoration: const BoxDecoration(
                                              //       border: Border(
                                              //           top: BorderSide(
                                              //               color: Colors.grey,
                                              //               width: 0.7),
                                              //           bottom: BorderSide(
                                              //               color: Colors.grey,
                                              //               width: 0.7))),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              //       Container(
                                              //           padding:
                                              //               const EdgeInsets
                                              //                       .fromLTRB(
                                              //                   10, 3, 5, 3),
                                              //           decoration: BoxDecoration(
                                              //               color: Theme.of(
                                              //                       context)
                                              //                   .colorScheme
                                              //                   .iconBackColor,
                                              //               borderRadius:
                                              //                   BorderRadius
                                              //                       .circular(
                                              //                           15)),
                                              //           width: 150,
                                              //           child: Row(
                                              //             mainAxisAlignment:
                                              //                 MainAxisAlignment
                                              //                     .spaceBetween,
                                              //             children: [
                                              //               Text(
                                              //                 listOfFolderDoc[index]
                                              //                             .docUserStatusId ==
                                              //                         1
                                              //                     ? "Pending Renewal"
                                              //                     : listOfFolderDoc[index]
                                              //                                 .docUserStatusId ==
                                              //                             2
                                              //                         ? "Renewal In-Progress"
                                              //                         : "Renewed",
                                              //                 style: const TextStyle(
                                              //                     fontSize: 12,
                                              //                     color: Color(
                                              //                         0xFF323232),
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w600),
                                              //               ),
                                              //               const Icon(
                                              //                 Icons
                                              //                     .keyboard_arrow_down,
                                              //                 color: Color(
                                              //                     0xFF323232),
                                              //               ),
                                              //             ],
                                              //           )),
                                              //       Row(
                                              //         children: [
                                              //           listOfFolderDoc[index]
                                              //                       .remindMe ==
                                              //                   false
                                              //               ? Container(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                               .fromLTRB(
                                              //                           8,
                                              //                           2,
                                              //                           2,
                                              //                           2),
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .notifications_off_outlined,
                                              //                     color: Theme.of(
                                              //                             context)
                                              //                         .primaryColor,
                                              //                     size: 20,
                                              //                   ),
                                              //                 )
                                              //               : Container(),
                                              //           listOfFolderDoc[index]
                                              //                       .attachmentCount >
                                              //                   1
                                              //               ? Container(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                               .fromLTRB(
                                              //                           0,
                                              //                           2,
                                              //                           8,
                                              //                           2),
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .attach_file,
                                              //                     color: Theme.of(
                                              //                             context)
                                              //                         .primaryColor,
                                              //                     size: 20,
                                              //                   ),
                                              //                 )
                                              //               : Container()
                                              //         ],
                                              //       )
                                              //     ],
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        listOfFolderDoc[index]
                                                                    .docSharingUserId
                                                                    .isNotEmpty &&
                                                                listOfFolderDoc[
                                                                            index]
                                                                        .isDocCreated ==
                                                                    false
                                                            ? Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5),
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .userGroup,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .sharerIconColor,
                                                                      size: 12,
                                                                    ),
                                                                  ),
                                                                  ListView.builder(
                                                                      scrollDirection: Axis.horizontal,
                                                                      shrinkWrap: true,
                                                                      itemCount: 1,
                                                                      itemBuilder: (context, index2) {
                                                                        return Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 35,
                                                                              child: listOfFolderDoc[index].sharerByList!.profilePic == null
                                                                                  ? CircleAvatar(
                                                                                      radius: 40,
                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                      child: Text(getUserFirstLetetrs(listOfFolderDoc[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                    )
                                                                                  : CircleAvatar(
                                                                                      radius: 25,
                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfFolderDoc[index].sharerByList!.profilePic.toString()),
                                                                                    ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: listOfFolderDoc
                                                                        .isEmpty
                                                                    ? 0
                                                                    : listOfFolderDoc[index].sharerList ==
                                                                            null
                                                                        ? 0
                                                                        : listOfFolderDoc[index]
                                                                            .sharerList!
                                                                            .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index2) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            40,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              50,
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .iceBlueColor,
                                                                          child: Text(
                                                                              getUserFirstLetetrs(listOfFolderDoc[index].sharerList![index2].name),
                                                                              style: const TextStyle(fontSize: 14)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                }),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        //     Container(
                                                        //         padding:
                                                        //             const EdgeInsets
                                                        //                     .only(
                                                        //                 right: 15),
                                                        //         child:
                                                        //             GestureDetector(
                                                        //                 onTap: () {
                                                        //                   Navigator
                                                        //                       .push(
                                                        //                     context,
                                                        //                     MaterialPageRoute(
                                                        //                         builder: (context) =>
                                                        //                             DocumentData(docId: listOfFolderDoc[index].id, indexTab: 2)),
                                                        //                   );
                                                        //                 },
                                                        //                 child: Icon(
                                                        //                     Icons
                                                        //                         .share,
                                                        //                     color: Theme.of(context)
                                                        //                         .colorScheme
                                                        //                         .warmGreyColor))),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DocumentData(
                                                docId:
                                                    listOfFolderDoc[index].id,
                                                indexTab: 0)),
                                      );
                                    },
                                    child: Container(
                                        height: 140,
                                        padding: const EdgeInsets.only(top: 4),
                                        margin: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 140,
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
                                          decoration: BoxDecoration(
                                            color: listOfFolderDoc[index]
                                                        .docSharingUserId
                                                        .isNotEmpty &&
                                                    listOfFolderDoc[index]
                                                            .isDocCreated ==
                                                        false
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .sharerColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 26,
                                                    width: 64,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: const Color(
                                                            0xffFFF5F8)),
                                                    child: const Center(
                                                      child: Text(
                                                        'Expired',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffF1416C)),
                                                        // textAlign: Alignment.center,
                                                      ),
                                                    ),
                                                  ),
                                                  listOfFolderDoc[index]
                                                              .isbookmark ==
                                                          true
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listOfFolderDoc[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    false)
                                                                .then(
                                                                    (response) {
                                                              if (response ==
                                                                  "1") {
                                                                getDocumentByFolderId(
                                                                        folderId)
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfFolderDoc =
                                                                        response!;
                                                                    countTabStr = listOfFolderDoc.length <
                                                                            10
                                                                        ? "0" +
                                                                            listOfFolderDoc.length
                                                                                .toString()
                                                                        : listOfFolderDoc
                                                                            .length
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              }
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons.bookmark,
                                                              color: Color(
                                                                  0xffD6D6E0)))
                                                      : GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listOfFolderDoc[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    true)
                                                                .then(
                                                                    (response) {
                                                              if (response ==
                                                                  "1") {
                                                                getDocumentByFolderId(
                                                                        folderId)
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfFolderDoc =
                                                                        response!;
                                                                    countTabStr = listOfFolderDoc.length <
                                                                            10
                                                                        ? "0" +
                                                                            listOfFolderDoc.length
                                                                                .toString()
                                                                        : listOfFolderDoc
                                                                            .length
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              }
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons
                                                                  .bookmark_outline_sharp,
                                                              color: const Color(
                                                                  0xffD6D6E0)))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 12),
                                                child: Text(
                                                    listOfFolderDoc[index]
                                                                .docName
                                                                .length >
                                                            30
                                                        ? listOfFolderDoc[index]
                                                                .docName
                                                                .substring(
                                                                    0, 32) +
                                                            " ..."
                                                        : listOfFolderDoc[index]
                                                            .docName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5!
                                                        .copyWith(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 2, 8, 2),
                                                decoration: BoxDecoration(
                                                  // color: Theme.of(context).iconTheme.color,
                                                  // color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .folder_open_rounded,
                                                          color:
                                                              Color(0xffD6D6E0),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          folderName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xffB5B5C3),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    // Text(listOfExpiredDoc!.item1![index].m),
                                                    // const Padding(
                                                    //   padding: EdgeInsets.only(right: 5),
                                                    //   child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                                    // child: Image.asset(
                                                    //   "assets/Icons/v_expired.png",
                                                    //   color: Theme.of(context).colorScheme.expiredColor,
                                                    // ),
                                                    //   child: Icon(
                                                    //     Icons.cancel_outlined,
                                                    //     size: 12,
                                                    //     color: Colors.white,
                                                    //   )
                                                    // ),
                                                    // Text(
                                                    //   getDateFormate(listOfExpiredDoc!.item1![index].expiryDate),
                                                    //   style: const TextStyle(color: Color(0xffF1416C), fontWeight: FontWeight.w600, fontSize: 12),
                                                    // ),
                                                    Text(
                                                      getDateFormate(
                                                          listOfFolderDoc[index]
                                                              .expiryDate),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xffF1416C),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceBetween,
                                              //   children: [
                                              //     Container(
                                              //       padding: const EdgeInsets
                                              //           .fromLTRB(8, 2, 8, 2),
                                              //       decoration: BoxDecoration(
                                              //         color: Theme.of(context)
                                              //             .colorScheme
                                              //             .expiredColor,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 15),
                                              //       ),
                                              //       child: Row(
                                              //         children: [
                                              //           Padding(
                                              //             padding:
                                              //                 const EdgeInsets
                                              //                         .only(
                                              //                     right: 5),
                                              //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                              //             child: Image.asset(
                                              //                 "assets/Icons/v_expired.png"),
                                              //           ),
                                              //           Text(
                                              //             getDateFormate(
                                              //                 listOfFolderDoc[
                                              //                         index]
                                              //                     .expiryDate),
                                              //             style:
                                              //                 const TextStyle(
                                              //                     color: Colors
                                              //                         .white,
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w600,
                                              //                     fontSize: 12),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     RichText(
                                              //         text: TextSpan(children: [
                                              //       const TextSpan(
                                              //         text: "Expired ",
                                              //         style: CustomTextStyle
                                              //             .simple12Text,
                                              //       ),
                                              //       TextSpan(
                                              //           text: listOfFolderDoc[
                                              //                           index]
                                              //                       .diffTotalDays
                                              //                       .abs() >
                                              //                   9
                                              //               ? listOfFolderDoc[
                                              //                       index]
                                              //                   .diffTotalDays
                                              //                   .toString()
                                              //                   .replaceAll(
                                              //                       RegExp('-'),
                                              //                       '')
                                              //               : "0" +
                                              //                   listOfFolderDoc[
                                              //                           index]
                                              //                       .diffTotalDays
                                              //                       .toString()
                                              //                       .replaceAll(
                                              //                           RegExp(
                                              //                               '-'),
                                              //                           ''),
                                              //           style: TextStyle(
                                              //               color: Theme.of(
                                              //                       context)
                                              //                   .colorScheme
                                              //                   .blackColor,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w700)),
                                              //       listOfFolderDoc[index]
                                              //                   .diffTotalDays >
                                              //               1
                                              //           ? const TextSpan(
                                              //               text: " days ago",
                                              //               style: CustomTextStyle
                                              //                   .simple12Text,
                                              //             )
                                              //           : const TextSpan(
                                              //               text: " day ago",
                                              //               style: CustomTextStyle
                                              //                   .simple12Text,
                                              //             ),
                                              //     ])),
                                              //   ],
                                              // ),
                                              // Container(
                                              //   margin: const EdgeInsets.only(
                                              //       top: 10),
                                              //   padding: const EdgeInsets.only(
                                              //       top: 5, bottom: 5),
                                              //   decoration: const BoxDecoration(
                                              //       border: Border(
                                              //           top: BorderSide(
                                              //               color: Colors.grey,
                                              //               width: 0.7),
                                              //           bottom: BorderSide(
                                              //               color: Colors.grey,
                                              //               width: 0.7))),
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceBetween,
                                              //     children: [
                                              //       Container(
                                              //           padding:
                                              //               const EdgeInsets
                                              //                       .fromLTRB(
                                              //                   10, 3, 5, 3),
                                              //           decoration: BoxDecoration(
                                              //               color: Theme.of(
                                              //                       context)
                                              //                   .colorScheme
                                              //                   .iconBackColor,
                                              //               borderRadius:
                                              //                   BorderRadius
                                              //                       .circular(
                                              //                           15)),
                                              //           width: 150,
                                              //           child: Row(
                                              //             mainAxisAlignment:
                                              //                 MainAxisAlignment
                                              //                     .spaceBetween,
                                              //             children: [
                                              //               Text(
                                              //                 listOfFolderDoc[index]
                                              //                             .docUserStatusId ==
                                              //                         1
                                              //                     ? "Pending Renewal"
                                              //                     : listOfFolderDoc[index]
                                              //                                 .docUserStatusId ==
                                              //                             2
                                              //                         ? "Renewal In-Progress"
                                              //                         : "Renewed",
                                              //                 style: const TextStyle(
                                              //                     fontSize: 12,
                                              //                     color: Color(
                                              //                         0xFF323232),
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w600),
                                              //               ),
                                              //               const Icon(
                                              //                 Icons
                                              //                     .keyboard_arrow_down,
                                              //                 color: Color(
                                              //                     0xFF323232),
                                              //               ),
                                              //             ],
                                              //           )),
                                              //       Row(
                                              //         children: [
                                              //           listOfFolderDoc[index]
                                              //                       .remindMe ==
                                              //                   false
                                              //               ? Container(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                               .fromLTRB(
                                              //                           8,
                                              //                           2,
                                              //                           2,
                                              //                           2),
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .notifications_off_outlined,
                                              //                     color: Theme.of(
                                              //                             context)
                                              //                         .primaryColor,
                                              //                     size: 20,
                                              //                   ),
                                              //                 )
                                              //               : Container(),
                                              //           listOfFolderDoc[index]
                                              //                       .attachmentCount >
                                              //                   1
                                              //               ? Container(
                                              //                   padding:
                                              //                       const EdgeInsets
                                              //                               .fromLTRB(
                                              //                           0,
                                              //                           2,
                                              //                           8,
                                              //                           2),
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .attach_file,
                                              //                     color: Theme.of(
                                              //                             context)
                                              //                         .primaryColor,
                                              //                     size: 20,
                                              //                   ),
                                              //                 )
                                              //               : Container()
                                              //         ],
                                              //       )
                                              //     ],
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        listOfFolderDoc[index]
                                                                    .docSharingUserId
                                                                    .isNotEmpty &&
                                                                listOfFolderDoc[
                                                                            index]
                                                                        .isDocCreated ==
                                                                    false
                                                            ? Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5),
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .userGroup,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .sharerIconColor,
                                                                      size: 12,
                                                                    ),
                                                                  ),
                                                                  ListView.builder(
                                                                      scrollDirection: Axis.horizontal,
                                                                      shrinkWrap: true,
                                                                      itemCount: 1,
                                                                      itemBuilder: (context, index2) {
                                                                        return Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 35,
                                                                              child: listOfFolderDoc[index].sharerByList!.profilePic == null
                                                                                  ? CircleAvatar(
                                                                                      radius: 40,
                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                      child: Text(getUserFirstLetetrs(listOfFolderDoc[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                    )
                                                                                  : CircleAvatar(
                                                                                      radius: 25,
                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfFolderDoc[index].sharerByList!.profilePic.toString()),
                                                                                    ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                                ],
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis
                                                                        .horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: listOfFolderDoc
                                                                        .isEmpty
                                                                    ? 0
                                                                    : listOfFolderDoc[index].sharerList ==
                                                                            null
                                                                        ? 0
                                                                        : listOfFolderDoc[index]
                                                                            .sharerList!
                                                                            .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index2) {
                                                                  return Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            40,
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              50,
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .iceBlueColor,
                                                                          child: Text(
                                                                              getUserFirstLetetrs(listOfFolderDoc[index].sharerList![index2].name),
                                                                              style: const TextStyle(fontSize: 14)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  );
                                                                }),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        // Container(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //                 .only(
                                                        //             right: 15),
                                                        //     child:
                                                        //         GestureDetector(
                                                        //             onTap: () {
                                                        //               Navigator
                                                        //                   .push(
                                                        //                 context,
                                                        //                 MaterialPageRoute(
                                                        //                     builder: (context) =>
                                                        //                         DocumentData(docId: listOfFolderDoc[index].id, indexTab: 2)),
                                                        //               );
                                                        //             },
                                                        //             child: Icon(
                                                        //                 Icons
                                                        //                     .share,
                                                        //                 color: Theme.of(context)
                                                        //                     .colorScheme
                                                        //                     .warmGreyColor))),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                      }),
            ),
          )
        ],
      ),
    );
  }
}
