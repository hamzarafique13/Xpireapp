
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Modules/Document/UI/document_detail.dart';



class FilterDocument extends StatefulWidget {

  final List<Document>? listdata;
   const FilterDocument({Key? key,this.listdata}) : super(key: key);

  @override
  FilterDocumentState createState() => FilterDocumentState();
}

class FilterDocumentState extends State<FilterDocument> {
  int countNotify = 0;
 late List<Document> listdata=[];
  @override
  void initState() {
    super.initState();
    listdata=widget.listdata!;
      
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft,color: Theme.of(context).colorScheme.blackColor,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        title: const Text("Filtered Documents",
          textAlign: TextAlign.left,
         style: CustomTextStyle.topHeading,
        ),
      ),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
               margin: const EdgeInsets.all(15),
               alignment: Alignment.center,
               child: Text(
                          listdata == null?"0":listdata.length.toString()+" documents",
                          style: Theme.of(context).textTheme.headline6,
                        ),
             ),
            
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child:  listdata == null
                ? Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "No record found!",
                    ),
                  )
                :ListView.builder(
                      itemCount: listdata.length,
                      itemBuilder: (context, index) {
                        return listdata[index].status == 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DocumentData(
                                            docId: listdata[index].id,
                                            indexTab: 0)),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                        color: listdata[index].docSharingUserId.isNotEmpty &&
                                                                      listdata[index].isDocCreated ==
                                                                                  false
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .sharerColor
                                                                          : Colors
                                                                              .white,
                                      
                                       border:Border.all(width: 0.5, color: Theme.of(context).colorScheme.tabBorderColor ),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .iconThemeGray,
                                          blurRadius: 15.0,
                                          spreadRadius: 0.1,
                                          offset: const Offset(4, 8),
                                        )
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              listdata[index]
                                                          .docName
                                                          .length >
                                                      20
                                                  ? listdata[index]
                                                          .docName
                                                          .substring(0, 20) +
                                                      "..."
                                                  : listdata[index]
                                                      .docName,
                                              style: Theme.of(context).textTheme.headline5),
                                          Row(
                                            children: [
                                          

                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocumentData(
                                                                    docId: listdata[
                                                                            index]
                                                                        .id,
                                                                    indexTab:
                                                                        2)),
                                                      );
                                                    },
                                                    child: Icon(Icons.share,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .warmGreyColor),
                                                  )),
                                              listdata[index]
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
                                                                listdata[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                false)
                                                            .then((response) {
                                                          
                                                          EasyLoading.dismiss();
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.bookmark,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .warmGreyColor))
                                                  : GestureDetector(
                                                      onTap: () {
                                                        EasyLoading
                                                            .addStatusCallback(
                                                                (status) {});
                                                        EasyLoading.show(
                                                            status:
                                                                'loading...');
                                                        addBookmark(
                                                                listdata[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                true)
                                                            .then((response) {
                                                         
                                                          EasyLoading.dismiss();
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons
                                                              .bookmark_outline_sharp,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .warmGreyColor))
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 2, 8, 2),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .activeColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              getDateFormate(
                                                  listdata[index]
                                                      .expiryDate),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                   fontWeight: FontWeight.w600,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          listdata[index].remindMe ==
                                                  false
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 2, 2, 2),
                                                  child: Icon(
                                                    Icons
                                                        .notifications_off_outlined,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(),
                                          listdata[index]
                                                      .attachmentCount >
                                                  1
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 2, 8, 2),
                                                  child: Icon(
                                                    Icons.attach_file,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                listdata[index]
                                                            .docSharingUserId
                                                            .isNotEmpty &&
                                                        listdata[index]
                                                                .isDocCreated ==
                                                            false
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .userGroup,
                                                          size: 12,
                                                        ),
                                                      )
                                                    : Container(),
                                                ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount: listdata ==
                                                            null
                                                        ? 0
                                                        : listdata[index]
                                                                .sharerList!
                                                                .isEmpty
                                                            ? 0
                                                            : listdata[
                                                                    index]
                                                                .sharerList!
                                                                .length,
                                                    itemBuilder:
                                                        (context, index2) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 40,
                                                            child: CircleAvatar(
                                                              radius: 50,
                                                              backgroundColor: Theme
                                                                      .of(context)
                                                                  .colorScheme
                                                                  .iceBlueColor,
                                                              child: Text(
                                                                  getUserFirstLetetrs(listdata[
                                                                          index]
                                                                      .sharerList![
                                                                          index2]
                                                                      .name),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Icon(
                                                      Icons.access_time_filled,
                                                      size: 15,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .warmGreyColor),
                                                ),
                                                const Text("Active",
                                                    style:  CustomTextStyle.simple12Text,)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            : listdata[index].status == 2
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DocumentData(
                                                docId:
                                                    listdata[index].id,
                                                indexTab: 0)),
                                      );
                                    },
                                    child: Container(
                                      height: 150,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                                 color: listdata[index].docSharingUserId.isNotEmpty &&
                                                                      listdata[index].isDocCreated ==
                                                                                  false
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .sharerColor
                                                                          : Colors
                                                                              .white,
                                        /*   gradient: LinearGradient(
                                              stops: const [
                                                0.02,
                                                0.02
                                              ],
                                              colors: [
                                                Theme.of(context)
                                                    .colorScheme
                                                    .expiringColor,
                                                Colors.white
                                              ]), */
                                           border:Border.all(
                                                                  width: 0.5,
                                                                  color: Theme.of(context).colorScheme.tabBorderColor ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .iconThemeGray,
                                              blurRadius: 15.0,
                                              spreadRadius: 0.1,
                                              offset: const Offset(4, 8),
                                            )
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  listdata[index]
                                                              .docName
                                                              .length >
                                                          20
                                                      ? listdata[index]
                                                              .docName
                                                              .substring(
                                                                  0, 20) +
                                                          "..."
                                                      : listdata[index]
                                                          .docName,
                                                  style:  Theme.of(context).textTheme.headline5),
                                              Row(
                                                children: [
                                                  /*                  Container(
                                                   padding:  const EdgeInsets.only(right: 5),
                                                   child: GestureDetector( onTap: () {
                                                          Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DocumentData(docId:listdata[index].id,indexTab: 0,)),
                                                        );

                                                      }, 
                                                   child: const Icon(FontAwesomeIcons.list,size: 15), ),
                                                 ), */

                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DocumentData(
                                                                        docId: listdata[index]
                                                                            .id,
                                                                        indexTab:
                                                                            2)),
                                                          );
                                                        },
                                                        child: Icon(Icons.share,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .warmGreyColor),
                                                      )),
                                                  listdata[index]
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
                                                                    listdata[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    false)
                                                                .then(
                                                                    (response) {
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons.bookmark,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor))
                                                      : GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listdata[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    true)
                                                                .then(
                                                                    (response) {
                                                              
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .bookmark_outline_sharp,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor))
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 2, 8, 2),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .expiringColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  getDateFormate(
                                                      listdata[index]
                                                          .expiryDate),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              listdata[index].remindMe ==
                                                      false
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 2, 2, 2),
                                                      child: Icon(
                                                        Icons
                                                            .notifications_off_outlined,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Container(),
                                              listdata[index]
                                                          .attachmentCount >
                                                      1
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.attach_file,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 5, 10),
                                              child: Text(
                                                  listdata[index]
                                                              .docUserStatusId ==
                                                          1
                                                      ? "Pending Renewal"
                                                      : listdata[index]
                                                                  .docUserStatusId ==
                                                              2
                                                          ? "Renewal In-Progress"
                                                          : "Renewed",
                                                  style:  CustomTextStyle.simple12Text,)),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    listdata[index]
                                                                .docSharingUserId
                                                                .isNotEmpty &&
                                                            listdata[
                                                                        index]
                                                                    .isDocCreated ==
                                                                false
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .userGroup,
                                                              size: 12,
                                                            ),
                                                          )
                                                        : Container(),
                                                    ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount: listdata ==
                                                                null
                                                            ? 0
                                                            : listdata[
                                                                        index]
                                                                    .sharerList!
                                                                    .isEmpty
                                                                ? 0
                                                                : listdata[
                                                                        index]
                                                                    .sharerList!
                                                                    .length,
                                                        itemBuilder:
                                                            (context, index2) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 40,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 50,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .iceBlueColor,
                                                                  child: Text(
                                                                      getUserFirstLetetrs(listdata[
                                                                              index]
                                                                          .sharerList![
                                                                              index2]
                                                                          .name),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14)),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Icon(
                                                          Icons
                                                              .access_time_filled,
                                                          size: 15,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .warmGreyColor),
                                                    ),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      const TextSpan(
                                                          text: "Expiring in ",
                                                          style: CustomTextStyle.simple12Text,),
                                                      TextSpan(
                                                          text: listdata[
                                                                  index]
                                                              .diffTotalDays
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                      const TextSpan(
                                                          text: " days",
                                                          style: CustomTextStyle.simple12Text,),
                                                    ])),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DocumentData(
                                                docId:
                                                    listdata[index].id,
                                                indexTab: 0)),
                                      );
                                    },
                                    child: Container(
                                      height: 150,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: listdata[index].docSharingUserId.isNotEmpty &&
                                                                      listdata[index].isDocCreated ==
                                                                                  false
                                                                          ? Theme.of(context)
                                                                              .colorScheme
                                                                              .sharerColor
                                                                          : Colors
                                                                              .white,
                                          /* gradient: const LinearGradient(
                                              stops: [
                                                0.02,
                                                0.02
                                              ],
                                              colors: [
                                                Colors.red,
                                                Colors.white
                                              ]), */
                                           border:Border.all(
                                                                  width: 0.5,
                                                                  color: Theme.of(context).colorScheme.tabBorderColor ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .iconThemeGray,
                                              blurRadius: 15.0,
                                              spreadRadius: 0.1,
                                              offset: const Offset(4, 8),
                                            )
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                listdata[index]
                                                            .docName
                                                            .length >
                                                        20
                                                    ? listdata[index]
                                                            .docName
                                                            .substring(0, 20) +
                                                        "..."
                                                    : listdata[index]
                                                        .docName,
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DocumentData(
                                                                        docId: listdata[index]
                                                                            .id,
                                                                        indexTab:
                                                                            2)),
                                                          );
                                                        },
                                                        child: Icon(Icons.share,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .warmGreyColor),
                                                      )),
                                                  listdata[index]
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
                                                                    listdata[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    false)
                                                                .then(
                                                                    (response) {
                                                              
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons.bookmark,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor))
                                                      : GestureDetector(
                                                          onTap: () {
                                                            EasyLoading
                                                                .addStatusCallback(
                                                                    (status) {});
                                                            EasyLoading.show(
                                                                status:
                                                                    'loading...');
                                                            addBookmark(
                                                                    listdata[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    true)
                                                                .then(
                                                                    (response) {
                                                            
                                                              EasyLoading
                                                                  .dismiss();
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .bookmark_outline_sharp,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor))
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 2, 8, 2),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .expiredColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  getDateFormate(
                                                      listdata[index]
                                                          .expiryDate),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                       fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              listdata[index].remindMe ==
                                                      false
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(8, 2, 2, 2),
                                                      child: Icon(
                                                        Icons
                                                            .notifications_off_outlined,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Container(),
                                              listdata[index]
                                                          .attachmentCount >
                                                      1
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.attach_file,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 5, 10),
                                              child: Text(
                                                  listdata[index]
                                                              .docUserStatusId ==
                                                          1
                                                      ? "Pending Renewal"
                                                      : listdata[index]
                                                                  .docUserStatusId ==
                                                              2
                                                          ? "Renewal In-Progress"
                                                          : "Renewed",
                                                  style: CustomTextStyle.simple12Text,)),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    listdata[index]
                                                                .docSharingUserId
                                                                .isNotEmpty &&
                                                            listdata[
                                                                        index]
                                                                    .isDocCreated ==
                                                                false
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .userGroup,
                                                              size: 12,
                                                            ),
                                                          )
                                                        : Container(),
                                                    ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount: listdata ==
                                                                null
                                                            ? 0
                                                            : listdata[
                                                                        index]
                                                                    .sharerList!
                                                                    .isEmpty
                                                                ? 0
                                                                : listdata[
                                                                        index]
                                                                    .sharerList!
                                                                    .length,
                                                        itemBuilder:
                                                            (context, index2) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 40,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 50,
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .iceBlueColor,
                                                                  child: Text(
                                                                      getUserFirstLetetrs(listdata[
                                                                              index]
                                                                          .sharerList![
                                                                              index2]
                                                                          .name),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14)),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: Icon(
                                                          Icons
                                                              .access_time_filled,
                                                          size: 15,
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .warmGreyColor),
                                                    ),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      const TextSpan(
                                                          text: "Expired ",
                                                          style:CustomTextStyle.simple12Text,),
                                                      TextSpan(
                                                          text: listdata[
                                                                  index]
                                                              .diffTotalDays
                                                              .toString()
                                                              .replaceAll(
                                                                  RegExp('-'),
                                                                  ''),
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .warmGreyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                      const TextSpan(
                                                          text: " days ago",
                                                          style:CustomTextStyle.simple12Text,),
                                                    ])),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                      }),
                ),
         )
          ],
        ),
                           
        );
  }
}
