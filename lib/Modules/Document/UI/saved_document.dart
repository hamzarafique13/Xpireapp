import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Dashboard/UI/Drawer.dart';
import 'package:Xpiree/Modules/Dashboard/UI/NavigationBottom.dart';
import 'package:Xpiree/Modules/Document/UI/update_assignedtask_screen.dart';
import 'package:Xpiree/Modules/Document/UI/update_mytask_screen.dart';
import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

class SavedDocument extends StatefulWidget {
  const SavedDocument({Key? key}) : super(key: key);

  @override
  SavedDocumentState createState() => SavedDocumentState();
}

class SavedDocumentState extends State<SavedDocument>
    with TickerProviderStateMixin {
  int countNotify = 0;
  List<Document> listOfSavedDoc = [];
  int orderby = 1;
  late String countStr = "00";
  DocumentVM? listOfActiveDoc;
  DocumentVM? listOfExpiringDoc;
  DocumentVM? listOfExpiredDoc;
  late String xpiredCountTabStr = "00";
  late String xpiringCountTabStr = "00";
  late String activeCountTabStr = "00";
  bool checkBoxvalue = false;
  int xpiredCount = 00;
  int xpiringCount = 00;
  int activeCount = 00;

  int _selectedIndex = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //_tabController.animateTo(1);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
        EasyLoading.addStatusCallback((status) {});
        EasyLoading.show(status: 'loading...');
        if (_selectedIndex == 0) {
          _selectedIndex = 0;
          getBookedMarkExpiredDocList().then((response) {
            setState(() {
              listOfExpiredDoc = response!;
            });
            EasyLoading.dismiss();
          });
        } else if (_selectedIndex == 1) {
          _selectedIndex = 1;
          getBookedMarkExpiringDocList().then((response) {
            setState(() {
              listOfExpiringDoc = response!;
            });
            EasyLoading.dismiss();
          });
        } else if (_selectedIndex == 2) {
          _selectedIndex = 2;
          getBookedMarkActiveDocList().then((response) {
            setState(() {
              listOfActiveDoc = response!;
            });
            EasyLoading.dismiss();
          });
        }
      });
    });

    // EasyLoading.addStatusCallback((status) {});
    // EasyLoading.show(status: 'loading...');
    // getSavedDocumentDataTable(orderby).then((response) {
    //   setState(() {
    //     listOfSavedDoc = response!;
    //     countStr = listOfSavedDoc.length < 10
    //         ? "0" + listOfSavedDoc.length.toString()
    //         : listOfSavedDoc.length.toString();
    //     EasyLoading.dismiss();
    //   });
    // });
    // getBookedMarkActiveDocList().then((response) {
    //   setState(() {
    //     listOfActiveDoc = response!;
    //     activeCount = listOfActiveDoc!.item2;
    //     activeCountTabStr = activeCount < 10
    //         ? "0" + activeCount.toString()
    //         : activeCount.toString();
    //   });
    //   EasyLoading.dismiss();
    // });
    // getBookedMarkExpiredDocList().then((response) {
    //   setState(() {
    //     listOfExpiredDoc = response!;
    //     xpiredCount = listOfExpiredDoc!.item2;
    //     xpiredCountTabStr = xpiredCount < 10
    //         ? "0" + xpiredCount.toString()
    //         : xpiredCount.toString();
    //   });
    //   EasyLoading.dismiss();
    // });

    // getBookedMarkExpiringDocList().then((response) {
    //   setState(() {
    //     listOfExpiringDoc = response!;
    //     xpiringCount = listOfExpiringDoc!.item2;
    //     xpiringCountTabStr = xpiringCount < 10
    //         ? "0" + xpiringCount.toString()
    //         : xpiringCount.toString();
    //   });
    //   EasyLoading.dismiss();
    // });
  }

  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),
      //   appBar: AppBar(
      //       backgroundColor: Theme.of(context).colorScheme.backgroundColor,
      //       elevation: 0.0,
      //       centerTitle: true,
      //       leadingWidth: 0,
      //       leading: Icon(
      //         Icons.arrow_back,
      //         color: Theme.of(context).colorScheme.backgroundColor,
      //       ),
      //       title: Text(
      //         "Bookmarked Documents ",
      //         style: CustomTextStyle.topHeading.copyWith(
      //           color: Theme.of(context).primaryColor,
      //         ),
      //       )),
      //   body: WillPopScope(
      //     onWillPop: () async {
      //       return await confirmExitApp(context);
      //     },
      //     child: RefreshIndicator(
      //       onRefresh: () {
      //         return Future.delayed(const Duration(seconds: 1), () {
      //           getSavedDocumentDataTable(orderby).then((response) {
      //             setState(() {
      //               listOfSavedDoc = response!;
      //               EasyLoading.dismiss();
      //             });
      //           });
      //         });
      //       },
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           listOfSavedDoc.isEmpty
      //               ? Container()
      //               : Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Container(
      //                       margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      //                       child: Text(countStr + " Documents",
      //                           style: Theme.of(context).textTheme.headline6),
      //                     ),
      //                     /* IconButton(
      //                         onPressed: () {},
      //                         icon: Icon(Icons.sort_by_alpha,
      //                             color: Theme.of(context)
      //                                 .colorScheme
      //                                 .warmGreyColor)) */
      //                   ],
      //                 ),
      //           Expanded(
      //             child: Container(
      //               child: listOfSavedDoc.isEmpty
      //                   ? Container(
      //                       alignment: Alignment.center,
      //                       padding:
      //                           const EdgeInsets.only(left: 50.0, right: 50.0),
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Padding(
      //                             padding: const EdgeInsets.only(bottom: 50),
      //                             child: Image.asset("assets/Icons/image16.png"),
      //                           ),
      //                           const Padding(
      //                             padding: EdgeInsets.all(5),
      //                             child: Text(
      //                               "No Document Bookmarked",
      //                               style: CustomTextStyle.heading12,
      //                               textAlign: TextAlign.center,
      //                             ),
      //                           ),
      //                           Text(
      //                             "To bookmark a document click the \n bookmark icon \n on the top right corner of the document.",
      //                             style: Theme.of(context).textTheme.headline6,
      //                             textAlign: TextAlign.center,
      //                           ),
      //                         ],
      //                       ),
      //                     )
      //                   : DefaultTabController(
      //                       length: 3,
      //                       initialIndex: _selectedIndex,
      //                       child: Column(children: <Widget>[
      //                         TabBar(
      //                           controller: _tabController,
      //                           labelColor:
      //                               Theme.of(context).colorScheme.blackColor,
      //                           unselectedLabelColor:
      //                               Theme.of(context).colorScheme.iconThemeGray,
      //                           indicatorColor: _selectedIndex == 0
      //                               ? Theme.of(context).colorScheme.expiredColor
      //                               : _selectedIndex == 1
      //                                   ? Theme.of(context)
      //                                       .colorScheme
      //                                       .expiringColor
      //                                   : Theme.of(context)
      //                                       .colorScheme
      //                                       .activeColor,
      //                           indicatorWeight: 2,
      //                           labelStyle: CustomTextStyle.heading5,
      //                           onTap: (index) {
      //                             EasyLoading.addStatusCallback((status) {});
      //                             EasyLoading.show(status: 'loading...');
      //                             if (index == 0) {
      //                               _selectedIndex = 0;
      //                               getBookedMarkExpiredDocList()
      //                                   .then((response) {
      //                                 setState(() {
      //                                   listOfExpiredDoc = response!;
      //                                 });
      //                                 EasyLoading.dismiss();
      //                               });
      //                             } else if (index == 1) {
      //                               _selectedIndex = 1;
      //                               getBookedMarkExpiringDocList()
      //                                   .then((response) {
      //                                 setState(() {
      //                                   listOfExpiringDoc = response!;
      //                                 });
      //                                 EasyLoading.dismiss();
      //                               });
      //                             } else if (index == 2) {
      //                               _selectedIndex = 2;
      //                               getBookedMarkActiveDocList().then((response) {
      //                                 setState(() {
      //                                   listOfActiveDoc = response!;
      //                                 });
      //                                 EasyLoading.dismiss();
      //                               });
      //                             }
      //                           },
      //                           tabs: [
      //                             Tab(
      //                                 text: "Expired (" +
      //                                     xpiredCountTabStr.toString() +
      //                                     ")"),
      //                             Tab(
      //                                 text: "Expiring (" +
      //                                     xpiringCountTabStr.toString() +
      //                                     ")"),
      //                             Tab(
      //                                 text: "Active (" +
      //                                     activeCountTabStr.toString() +
      //                                     ")"),
      //                           ],
      //                         ),
      //                         Container(
      //                             height:
      //                                 MediaQuery.of(context).size.height * 0.7,
      //                             decoration: const BoxDecoration(
      //                                 border: Border(
      //                                     top: BorderSide(
      //                                         color: Colors.grey, width: 0.5))),
      //                             child: TabBarView(
      //                                 controller: _tabController,
      //                                 physics:
      //                                     const NeverScrollableScrollPhysics(),
      //                                 children: <Widget>[
      //                                   Container(
      //                                     padding: const EdgeInsets.all(10),
      //                                     child:
      //                                         listOfExpiredDoc == null ||
      //                                                 listOfExpiredDoc!.item2 == 0
      //                                             ? Container(
      //                                                 alignment: Alignment.center,
      //                                                 child: Text(
      //                                                     "No expired document",
      //                                                     style: Theme.of(context)
      //                                                         .textTheme
      //                                                         .headline6),
      //                                               )
      //                                             : ListView.builder(
      //                                                 primary: false,
      //                                                 shrinkWrap: true,
      //                                                 itemCount:
      //                                                     listOfExpiredDoc!.item2,
      //                                                 itemBuilder:
      //                                                     (context, index) {
      //                                                   return GestureDetector(
      //                                                     onTap: () {
      //                                                       Navigator.push(
      //                                                         context,
      //                                                         MaterialPageRoute(
      //                                                             builder: (context) => DocumentData(
      //                                                                 docId: listOfExpiredDoc!
      //                                                                     .item1![
      //                                                                         index]
      //                                                                     .id,
      //                                                                 indexTab:
      //                                                                     0)),
      //                                                       );
      //                                                     },
      //                                                     child: Container(
      //                                                         height: 142,
      //                                                         padding:
      //                                                             const EdgeInsets
      //                                                                     .only(
      //                                                                 top: 4),
      //                                                         margin:
      //                                                             const EdgeInsets
      //                                                                 .all(10),
      //                                                         // decoration:
      //                                                         //     BoxDecoration(
      //                                                         //   color: Theme.of(
      //                                                         //           context)
      //                                                         //       .colorScheme
      //                                                         //       .expiredColor,
      //                                                         //   borderRadius:
      //                                                         //       BorderRadius
      //                                                         //           .circular(
      //                                                         //               16),
      //                                                         // ),
      //                                                         child: Container(
      //                                                           height: 160,
      //                                                           padding:
      //                                                               const EdgeInsets
      //                                                                       .fromLTRB(
      //                                                                   15,
      //                                                                   15,
      //                                                                   15,
      //                                                                   15),
      //                                                           decoration:
      //                                                               BoxDecoration(
      //                                                                   color: listOfExpiredDoc!.item1![index].docSharingUserId.isNotEmpty &&
      //                                                                           listOfExpiredDoc!.item1![index].isDocCreated ==
      //                                                                               false
      //                                                                       ? Theme.of(context)
      //                                                                           .colorScheme
      //                                                                           .sharerColor
      //                                                                       : const Color.fromRGBO(
      //                                                                           255,
      //                                                                           255,
      //                                                                           255,
      //                                                                           1),
      //                                                                   // border: Border.all(
      //                                                                   //     width:
      //                                                                   //         0.5,
      //                                                                   //     color: Theme.of(
      //                                                                   //             context)
      //                                                                   //         .colorScheme
      //                                                                   //         .tabBorderColor),
      //                                                                   borderRadius:
      //                                                                       BorderRadius.circular(
      //                                                                           16),
      //                                                                   boxShadow: [
      //                                                                 BoxShadow(
      //                                                                   color: Theme.of(
      //                                                                           context)
      //                                                                       .colorScheme
      //                                                                       .expiredColor,
      //                                                                   blurRadius:
      //                                                                       1.0,
      //                                                                   spreadRadius:
      //                                                                       0.1,
      //                                                                   offset:
      //                                                                       const Offset(
      //                                                                           0,
      //                                                                           2),
      //                                                                 )
      //                                                               ]),
      //                                                           // boxShadow: [
      //                                                           //   BoxShadow(
      //                                                           //     color: Theme.of(
      //                                                           //             context)
      //                                                           //         .colorScheme
      //                                                           //         .iconThemeGray,
      //                                                           //     blurRadius:
      //                                                           //         15.0,
      //                                                           //     spreadRadius:
      //                                                           //         0.1,
      //                                                           //     offset:
      //                                                           //         const Offset(
      //                                                           //             4,
      //                                                           //             8),
      //                                                           //   )
      //                                                           // ]),
      //                                                           child: Column(
      //                                                             crossAxisAlignment:
      //                                                                 CrossAxisAlignment
      //                                                                     .start,
      //                                                             children: [
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     bottom:
      //                                                                         12),
      //                                                                 child: Row(
      //                                                                   crossAxisAlignment:
      //                                                                       CrossAxisAlignment
      //                                                                           .center,
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   children: [
      //                                                                     Text(
      //                                                                         listOfExpiredDoc!.item1![index].docName.length > 30
      //                                                                             ? listOfExpiredDoc!.item1![index].docName.substring(0, 32) + " ..."
      //                                                                             : listOfExpiredDoc!.item1![index].docName,
      //                                                                         style: Theme.of(context).textTheme.headline5),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         GestureDetector(
      //                                                                           onTap: () {
      //                                                                             Navigator.push(
      //                                                                               context,
      //                                                                               MaterialPageRoute(builder: (context) => DocumentData(docId: listOfExpiredDoc!.item1![index].id, indexTab: 2)),
      //                                                                             );
      //                                                                           },
      //                                                                           child: Icon(Icons.share, size: 20, color: Theme.of(context).primaryColor),
      //                                                                         ),
      //                                                                         const SizedBox(
      //                                                                           width: 10,
      //                                                                         ),
      //                                                                         listOfExpiredDoc!.item1![index].remindMe == false
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.notifications_off_outlined,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container(),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                               Row(
      //                                                                 mainAxisAlignment:
      //                                                                     MainAxisAlignment
      //                                                                         .spaceBetween,
      //                                                                 children: [
      //                                                                   Container(
      //                                                                     padding: const EdgeInsets.fromLTRB(
      //                                                                         8,
      //                                                                         2,
      //                                                                         8,
      //                                                                         2),
      //                                                                     // decoration:
      //                                                                     //     BoxDecoration(
      //                                                                     //   color: Theme.of(context)
      //                                                                     //       .colorScheme
      //                                                                     //       .expiredColor,
      //                                                                     //   borderRadius:
      //                                                                     //       BorderRadius.circular(15),
      //                                                                     // ),
      //                                                                     child:
      //                                                                         Row(
      //                                                                       children: [
      //                                                                         Padding(
      //                                                                           padding: const EdgeInsets.only(right: 5),
      //                                                                           // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
      //                                                                           child: Image.asset(
      //                                                                             "assets/Icons/v_expired.png",
      //                                                                             color: Theme.of(context).colorScheme.expiredColor,
      //                                                                           ),
      //                                                                         ),
      //                                                                         Text(
      //                                                                           getDateFormate(listOfExpiredDoc!.item1![index].expiryDate),
      //                                                                           style: TextStyle(color: Theme.of(context).colorScheme.expiredColor, fontWeight: FontWeight.w600, fontSize: 12),
      //                                                                         ),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ),
      //                                                                   RichText(
      //                                                                       text: TextSpan(
      //                                                                           children: [
      //                                                                         const TextSpan(
      //                                                                           text: "Expired ",
      //                                                                           style: CustomTextStyle.simple12Text,
      //                                                                         ),
      //                                                                         TextSpan(
      //                                                                             text: listOfExpiredDoc!.item1![index].diffTotalDays > 9 ? listOfExpiredDoc!.item1![index].diffTotalDays.toString().replaceAll(RegExp('-'), '') : "0" + listOfExpiredDoc!.item1![index].diffTotalDays.toString().replaceAll(RegExp('-'), ''),
      //                                                                             style: TextStyle(color: Theme.of(context).colorScheme.expiredColor, fontWeight: FontWeight.w700)),
      //                                                                         listOfExpiredDoc!.item1![index].diffTotalDays > 1
      //                                                                             ? const TextSpan(
      //                                                                                 text: " days ago",
      //                                                                                 style: CustomTextStyle.simple12Text,
      //                                                                               )
      //                                                                             : const TextSpan(
      //                                                                                 text: " day ago",
      //                                                                                 style: CustomTextStyle.simple12Text,
      //                                                                               ),
      //                                                                       ])),
      //                                                                 ],
      //                                                               ),
      //                                                               const SizedBox(
      //                                                                 height: 10,
      //                                                               ),
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     top:
      //                                                                         10),
      //                                                                 // padding: const EdgeInsets
      //                                                                 //         .only(
      //                                                                 //     top: 5,
      //                                                                 //     bottom:
      //                                                                 //         5),
      //                                                                 // decoration: const BoxDecoration(
      //                                                                 //     border: Border(
      //                                                                 //         top:
      //                                                                 //             BorderSide(color: Colors.grey, width: 0.7),
      //                                                                 //         bottom: BorderSide(color: Colors.grey, width: 0.7))
      //                                                                 // ),

      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   children: [
      //                                                                     Container(
      //                                                                         padding: const EdgeInsets.fromLTRB(
      //                                                                             10,
      //                                                                             3,
      //                                                                             5,
      //                                                                             3),
      //                                                                         decoration:
      //                                                                             BoxDecoration(color: Theme.of(context).colorScheme.blackColor, borderRadius: BorderRadius.circular(15)),
      //                                                                         width: 150,
      //                                                                         child: Row(
      //                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                                                           children: [
      //                                                                             Text(
      //                                                                               listOfExpiredDoc!.item1![index].docUserStatusId == 1
      //                                                                                   ? "Pending Renewal"
      //                                                                                   : listOfExpiredDoc!.item1![index].docUserStatusId == 2
      //                                                                                       ? "Renewal In-Progress"
      //                                                                                       : "Renewed",
      //                                                                               style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.whiteColor, fontWeight: FontWeight.w600),
      //                                                                             ),
      //                                                                             Icon(
      //                                                                               Icons.keyboard_arrow_down,
      //                                                                               color: Theme.of(context).colorScheme.whiteColor,
      //                                                                             ),
      //                                                                           ],
      //                                                                         )),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         Row(
      //                                                                           children: [
      //                                                                             Container(
      //                                                                               padding: const EdgeInsets.only(right: 15),
      //                                                                             ),
      //                                                                             listOfExpiredDoc!.item1![index].isbookmark == true
      //                                                                                 ? GestureDetector(
      //                                                                                     onTap: () {
      //                                                                                       EasyLoading.addStatusCallback((status) {});
      //                                                                                       EasyLoading.show(status: 'loading...');
      //                                                                                       addBookmark(listOfExpiredDoc!.item1![index].id.toString(), false).then((response) {
      //                                                                                         if (response == "1") {
      //                                                                                           getExpiredDocDataTable().then((response) {
      //                                                                                             setState(() {
      //                                                                                               listOfExpiredDoc = response!;
      //                                                                                             });
      //                                                                                           });
      //                                                                                         }
      //                                                                                         EasyLoading.dismiss();
      //                                                                                       });
      //                                                                                     },
      //                                                                                     child: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.warmGreyColor))
      //                                                                                 : GestureDetector(
      //                                                                                     onTap: () {
      //                                                                                       EasyLoading.addStatusCallback((status) {});
      //                                                                                       EasyLoading.show(status: 'loading...');
      //                                                                                       addBookmark(listOfExpiredDoc!.item1![index].id.toString(), true).then((response) {
      //                                                                                         if (response == "1") {
      //                                                                                           getExpiredDocDataTable().then((response) {
      //                                                                                             setState(() {
      //                                                                                               listOfExpiredDoc = response!;
      //                                                                                             });
      //                                                                                           });
      //                                                                                         }
      //                                                                                         EasyLoading.dismiss();
      //                                                                                       });
      //                                                                                     },
      //                                                                                     child: Icon(Icons.bookmark_outline_sharp, color: Theme.of(context).colorScheme.warmGreyColor),
      //                                                                                   )
      //                                                                           ],
      //                                                                         ),
      //                                                                         listOfExpiredDoc!.item1![index].attachmentCount > 1
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.attach_file,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container()
      //                                                                       ],
      //                                                                     )
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                               Expanded(
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   crossAxisAlignment:
      //                                                                       CrossAxisAlignment
      //                                                                           .end,
      //                                                                   children: [
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         listOfExpiredDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiredDoc!.item1![index].isDocCreated == false
      //                                                                             ? Row(
      //                                                                                 children: [
      //                                                                                   Padding(
      //                                                                                     padding: const EdgeInsets.only(right: 5),
      //                                                                                     child: Icon(
      //                                                                                       FontAwesomeIcons.userGroup,
      //                                                                                       color: Theme.of(context).colorScheme.sharerIconColor,
      //                                                                                       size: 12,
      //                                                                                     ),
      //                                                                                   ),
      //                                                                                   ListView.builder(
      //                                                                                       scrollDirection: Axis.horizontal,
      //                                                                                       shrinkWrap: true,
      //                                                                                       itemCount: 1,
      //                                                                                       itemBuilder: (context, index2) {
      //                                                                                         return Row(
      //                                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                           children: [
      //                                                                                             SizedBox(
      //                                                                                               width: 35,
      //                                                                                               child: listOfExpiredDoc!.item1![index].sharerByList!.profilePic == null
      //                                                                                                   ? CircleAvatar(
      //                                                                                                       radius: 40,
      //                                                                                                       backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                                       child: Text(getUserFirstLetetrs(listOfExpiredDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
      //                                                                                                     )
      //                                                                                                   : CircleAvatar(
      //                                                                                                       radius: 25,
      //                                                                                                       backgroundImage: CachedNetworkImageProvider(imageUrl + listOfExpiredDoc!.item1![index].sharerByList!.profilePic.toString()),
      //                                                                                                     ),
      //                                                                                             )
      //                                                                                           ],
      //                                                                                         );
      //                                                                                       })
      //                                                                                 ],
      //                                                                               )
      //                                                                             : ListView.builder(
      //                                                                                 scrollDirection: Axis.horizontal,
      //                                                                                 shrinkWrap: true,
      //                                                                                 itemCount: listOfExpiredDoc == null
      //                                                                                     ? 0
      //                                                                                     : listOfExpiredDoc!.item1![index].sharerList == null
      //                                                                                         ? 0
      //                                                                                         : listOfExpiredDoc!.item1![index].sharerList!.length,
      //                                                                                 itemBuilder: (context, index2) {
      //                                                                                   return Row(
      //                                                                                     mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                     children: [
      //                                                                                       SizedBox(
      //                                                                                         width: 40,
      //                                                                                         child: CircleAvatar(
      //                                                                                           radius: 50,
      //                                                                                           backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                           child: Text(getUserFirstLetetrs(listOfExpiredDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
      //                                                                                         ),
      //                                                                                       )
      //                                                                                     ],
      //                                                                                   );
      //                                                                                 }),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                             ],
      //                                                           ),
      //                                                         )),
      //                                                   );
      //                                                 }),
      //                                   ),
      //                                   Container(
      //                                     padding: const EdgeInsets.all(10),
      //                                     child:
      //                                         listOfExpiringDoc == null ||
      //                                                 listOfExpiringDoc!.item2 ==
      //                                                     0
      //                                             ? Container(
      //                                                 alignment: Alignment.center,
      //                                                 child: Text(
      //                                                     "No expiring document",
      //                                                     style: Theme.of(context)
      //                                                         .textTheme
      //                                                         .headline6),
      //                                               )
      //                                             : ListView.builder(
      //                                                 primary: false,
      //                                                 shrinkWrap: true,
      //                                                 itemCount:
      //                                                     listOfExpiringDoc!
      //                                                         .item1!.length,
      //                                                 itemBuilder:
      //                                                     (context, index) {
      //                                                   return GestureDetector(
      //                                                     onTap: () {
      //                                                       Navigator.push(
      //                                                         context,
      //                                                         MaterialPageRoute(
      //                                                             builder: (context) => DocumentData(
      //                                                                 docId: listOfExpiringDoc!
      //                                                                     .item1![
      //                                                                         index]
      //                                                                     .id,
      //                                                                 indexTab:
      //                                                                     0)),
      //                                                       );
      //                                                     },
      //                                                     child: Container(
      //                                                         height: 162,
      //                                                         padding:
      //                                                             const EdgeInsets
      //                                                                     .only(
      //                                                                 top: 4),
      //                                                         margin:
      //                                                             const EdgeInsets
      //                                                                 .all(10),
      //                                                         decoration:
      //                                                             BoxDecoration(
      //                                                           color: Theme.of(
      //                                                                   context)
      //                                                               .colorScheme
      //                                                               .expiringColor,
      //                                                           borderRadius:
      //                                                               BorderRadius
      //                                                                   .circular(
      //                                                                       6),
      //                                                         ),
      //                                                         child: Container(
      //                                                           height: 160,
      //                                                           padding:
      //                                                               const EdgeInsets
      //                                                                       .fromLTRB(
      //                                                                   15,
      //                                                                   15,
      //                                                                   15,
      //                                                                   15),
      //                                                           decoration: BoxDecoration(
      //                                                               color: listOfExpiringDoc!
      //                                                                           .item1![
      //                                                                               index]
      //                                                                           .docSharingUserId
      //                                                                           .isNotEmpty &&
      //                                                                       listOfExpiringDoc!.item1![index].isDocCreated ==
      //                                                                           false
      //                                                                   ? Theme.of(context)
      //                                                                       .colorScheme
      //                                                                       .sharerColor
      //                                                                   : Colors
      //                                                                       .white,
      //                                                               border: Border.all(
      //                                                                   width:
      //                                                                       0.5,
      //                                                                   color: Theme.of(
      //                                                                           context)
      //                                                                       .colorScheme
      //                                                                       .tabBorderColor),
      //                                                               borderRadius:
      //                                                                   BorderRadius
      //                                                                       .circular(
      //                                                                           6),
      //                                                               boxShadow: [
      //                                                                 BoxShadow(
      //                                                                   color: Theme.of(
      //                                                                           context)
      //                                                                       .colorScheme
      //                                                                       .iconThemeGray,
      //                                                                   blurRadius:
      //                                                                       15.0,
      //                                                                   spreadRadius:
      //                                                                       0.1,
      //                                                                   offset:
      //                                                                       const Offset(
      //                                                                           4,
      //                                                                           8),
      //                                                                 )
      //                                                               ]),
      //                                                           child: Column(
      //                                                             crossAxisAlignment:
      //                                                                 CrossAxisAlignment
      //                                                                     .start,
      //                                                             children: [
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     bottom:
      //                                                                         12),
      //                                                                 child: Text(
      //                                                                     listOfExpiringDoc!.item1![index].docName.length > 30
      //                                                                         ? listOfExpiringDoc!.item1![index].docName.substring(0, 32) +
      //                                                                             " ..."
      //                                                                         : listOfExpiringDoc!
      //                                                                             .item1![
      //                                                                                 index]
      //                                                                             .docName,
      //                                                                     style: Theme.of(context)
      //                                                                         .textTheme
      //                                                                         .headline5),
      //                                                               ),
      //                                                               Row(
      //                                                                 mainAxisAlignment:
      //                                                                     MainAxisAlignment
      //                                                                         .spaceBetween,
      //                                                                 children: [
      //                                                                   Container(
      //                                                                     padding: const EdgeInsets.fromLTRB(
      //                                                                         8,
      //                                                                         2,
      //                                                                         8,
      //                                                                         2),
      //                                                                     decoration:
      //                                                                         BoxDecoration(
      //                                                                       color: Theme.of(context)
      //                                                                           .colorScheme
      //                                                                           .expiringColor,
      //                                                                       borderRadius:
      //                                                                           BorderRadius.circular(15),
      //                                                                     ),
      //                                                                     child:
      //                                                                         Row(
      //                                                                       children: [
      //                                                                         Padding(
      //                                                                           padding: const EdgeInsets.only(right: 5),
      //                                                                           // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
      //                                                                           child: Image.asset("assets/Icons/v_expiring.png"),
      //                                                                         ),
      //                                                                         Text(
      //                                                                           getDateFormate(listOfExpiringDoc!.item1![index].expiryDate),
      //                                                                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
      //                                                                         ),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ),
      //                                                                   RichText(
      //                                                                       text: TextSpan(
      //                                                                           children: [
      //                                                                         const TextSpan(
      //                                                                             text: "Expiring in ",
      //                                                                             style: CustomTextStyle.simple12Text),
      //                                                                         TextSpan(
      //                                                                             text: listOfExpiringDoc!.item1![index].diffTotalDays > 9 ? listOfExpiringDoc!.item1![index].diffTotalDays.toString() : "0" + listOfExpiringDoc!.item1![index].diffTotalDays.toString(),
      //                                                                             style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w700)),
      //                                                                         listOfExpiringDoc!.item1![index].diffTotalDays > 1
      //                                                                             ? const TextSpan(
      //                                                                                 text: " days",
      //                                                                                 style: CustomTextStyle.simple12Text,
      //                                                                               )
      //                                                                             : const TextSpan(
      //                                                                                 text: " day",
      //                                                                                 style: CustomTextStyle.simple12Text,
      //                                                                               ),
      //                                                                       ])),
      //                                                                 ],
      //                                                               ),
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     top:
      //                                                                         10),
      //                                                                 padding: const EdgeInsets
      //                                                                         .only(
      //                                                                     top: 5,
      //                                                                     bottom:
      //                                                                         5),
      //                                                                 decoration: const BoxDecoration(
      //                                                                     border: Border(
      //                                                                         top:
      //                                                                             BorderSide(color: Colors.grey, width: 0.7),
      //                                                                         bottom: BorderSide(color: Colors.grey, width: 0.7))),
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   children: [
      //                                                                     Container(
      //                                                                         padding: const EdgeInsets.fromLTRB(
      //                                                                             10,
      //                                                                             3,
      //                                                                             5,
      //                                                                             3),
      //                                                                         decoration:
      //                                                                             BoxDecoration(color: Theme.of(context).colorScheme.iconBackColor, borderRadius: BorderRadius.circular(15)),
      //                                                                         width: 150,
      //                                                                         child: Row(
      //                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                                                           children: [
      //                                                                             Text(
      //                                                                               listOfExpiringDoc!.item1![index].docUserStatusId == 1
      //                                                                                   ? "Pending Renewal"
      //                                                                                   : listOfExpiringDoc!.item1![index].docUserStatusId == 2
      //                                                                                       ? "Renewal In-Progress"
      //                                                                                       : "Renewed",
      //                                                                               style: const TextStyle(fontSize: 12, color: Color(0xFF323232), fontWeight: FontWeight.w600),
      //                                                                             ),
      //                                                                             const Icon(
      //                                                                               Icons.keyboard_arrow_down,
      //                                                                               color: Color(0xFF323232),
      //                                                                             ),
      //                                                                           ],
      //                                                                         )),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         listOfExpiringDoc!.item1![index].remindMe == false
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.notifications_off_outlined,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container(),
      //                                                                         listOfExpiringDoc!.item1![index].attachmentCount > 1
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.attach_file,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container()
      //                                                                       ],
      //                                                                     )
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                               Expanded(
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   crossAxisAlignment:
      //                                                                       CrossAxisAlignment
      //                                                                           .end,
      //                                                                   children: [
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         listOfExpiringDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiringDoc!.item1![index].isDocCreated == false
      //                                                                             ? Row(
      //                                                                                 children: [
      //                                                                                   Padding(
      //                                                                                     padding: const EdgeInsets.only(right: 5),
      //                                                                                     child: Icon(
      //                                                                                       FontAwesomeIcons.userGroup,
      //                                                                                       color: Theme.of(context).colorScheme.sharerIconColor,
      //                                                                                       size: 12,
      //                                                                                     ),
      //                                                                                   ),
      //                                                                                   ListView.builder(
      //                                                                                       scrollDirection: Axis.horizontal,
      //                                                                                       shrinkWrap: true,
      //                                                                                       itemCount: 1,
      //                                                                                       itemBuilder: (context, index2) {
      //                                                                                         return Row(
      //                                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                           children: [
      //                                                                                             SizedBox(
      //                                                                                               width: 35,
      //                                                                                               child: listOfExpiringDoc!.item1![index].sharerByList!.profilePic == null
      //                                                                                                   ? CircleAvatar(
      //                                                                                                       radius: 40,
      //                                                                                                       backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                                       child: Text(getUserFirstLetetrs(listOfExpiringDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
      //                                                                                                     )
      //                                                                                                   : CircleAvatar(
      //                                                                                                       radius: 25,
      //                                                                                                       backgroundImage: CachedNetworkImageProvider(imageUrl + listOfExpiringDoc!.item1![index].sharerByList!.profilePic.toString()),
      //                                                                                                     ),
      //                                                                                             )
      //                                                                                           ],
      //                                                                                         );
      //                                                                                       })
      //                                                                                 ],
      //                                                                               )
      //                                                                             : ListView.builder(
      //                                                                                 scrollDirection: Axis.horizontal,
      //                                                                                 shrinkWrap: true,
      //                                                                                 itemCount: listOfExpiringDoc == null
      //                                                                                     ? 0
      //                                                                                     : listOfExpiringDoc!.item1![index].sharerList == null
      //                                                                                         ? 0
      //                                                                                         : listOfExpiringDoc!.item1![index].sharerList!.length,
      //                                                                                 itemBuilder: (context, index2) {
      //                                                                                   return Row(
      //                                                                                     mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                     children: [
      //                                                                                       SizedBox(
      //                                                                                         width: 40,
      //                                                                                         child: CircleAvatar(
      //                                                                                           radius: 50,
      //                                                                                           backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                           child: Text(getUserFirstLetetrs(listOfExpiringDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
      //                                                                                         ),
      //                                                                                       )
      //                                                                                     ],
      //                                                                                   );
      //                                                                                 }),
      //                                                                       ],
      //                                                                     ),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         Container(
      //                                                                             padding: const EdgeInsets.only(right: 15),
      //                                                                             child: GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   Navigator.push(
      //                                                                                     context,
      //                                                                                     MaterialPageRoute(builder: (context) => DocumentData(docId: listOfExpiringDoc!.item1![index].id, indexTab: 2)),
      //                                                                                   );
      //                                                                                 },
      //                                                                                 child: Icon(Icons.share, color: Theme.of(context).colorScheme.warmGreyColor))),
      //                                                                         listOfExpiringDoc!.item1![index].isbookmark == true
      //                                                                             ? GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   EasyLoading.addStatusCallback((status) {});
      //                                                                                   EasyLoading.show(status: 'loading...');
      //                                                                                   addBookmark(listOfExpiringDoc!.item1![index].id.toString(), false).then((response) {
      //                                                                                     if (response == "1") {
      //                                                                                       getExpiringDocDataTable().then((response) {
      //                                                                                         setState(() {
      //                                                                                           listOfExpiringDoc = response!;
      //                                                                                         });
      //                                                                                       });
      //                                                                                     }
      //                                                                                     EasyLoading.dismiss();
      //                                                                                   });
      //                                                                                 },
      //                                                                                 child: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.warmGreyColor))
      //                                                                             : GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   EasyLoading.addStatusCallback((status) {});
      //                                                                                   EasyLoading.show(status: 'loading...');
      //                                                                                   addBookmark(listOfExpiringDoc!.item1![index].id.toString(), true).then((response) {
      //                                                                                     if (response == "1") {
      //                                                                                       getExpiringDocDataTable().then((response) {
      //                                                                                         setState(() {
      //                                                                                           listOfExpiringDoc = response!;
      //                                                                                         });
      //                                                                                       });
      //                                                                                     }
      //                                                                                     EasyLoading.dismiss();
      //                                                                                   });
      //                                                                                 },
      //                                                                                 child: Icon(Icons.bookmark_outline_sharp, color: Theme.of(context).colorScheme.warmGreyColor))
      //                                                                       ],
      //                                                                     )
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                             ],
      //                                                           ),
      //                                                         )),
      //                                                   );
      //                                                 },
      //                                               ),
      //                                   ),
      //                                   Container(
      //                                     padding: const EdgeInsets.all(10),
      //                                     child:
      //                                         listOfActiveDoc == null ||
      //                                                 listOfActiveDoc!.item2 == 0
      //                                             ? Container(
      //                                                 alignment: Alignment.center,
      //                                                 child: Text(
      //                                                     "No active document",
      //                                                     style: Theme.of(context)
      //                                                         .textTheme
      //                                                         .headline6),
      //                                               )
      //                                             : ListView.builder(
      //                                                 primary: false,
      //                                                 shrinkWrap: true,
      //                                                 itemCount: listOfActiveDoc!
      //                                                     .item1!.length,
      //                                                 itemBuilder:
      //                                                     (context, index) {
      //                                                   return GestureDetector(
      //                                                     onTap: () {
      //                                                       Navigator.push(
      //                                                         context,
      //                                                         MaterialPageRoute(
      //                                                             builder: (context) => DocumentData(
      //                                                                 docId: listOfActiveDoc!
      //                                                                     .item1![
      //                                                                         index]
      //                                                                     .id,
      //                                                                 indexTab:
      //                                                                     0)),
      //                                                       );
      //                                                     },
      //                                                     child: Container(
      //                                                         height: 162,
      //                                                         padding:
      //                                                             const EdgeInsets
      //                                                                     .only(
      //                                                                 top: 4),
      //                                                         margin:
      //                                                             const EdgeInsets
      //                                                                 .all(10),
      //                                                         decoration:
      //                                                             BoxDecoration(
      //                                                           color: Theme.of(
      //                                                                   context)
      //                                                               .colorScheme
      //                                                               .activeColor,
      //                                                           borderRadius:
      //                                                               BorderRadius
      //                                                                   .circular(
      //                                                                       6),
      //                                                         ),
      //                                                         child: Container(
      //                                                           height: 160,
      //                                                           padding:
      //                                                               const EdgeInsets
      //                                                                       .fromLTRB(
      //                                                                   15,
      //                                                                   15,
      //                                                                   15,
      //                                                                   15),
      //                                                           decoration: BoxDecoration(
      //                                                               color: listOfActiveDoc!
      //                                                                           .item1![
      //                                                                               index]
      //                                                                           .docSharingUserId
      //                                                                           .isNotEmpty &&
      //                                                                       listOfActiveDoc!.item1![index].isDocCreated ==
      //                                                                           false
      //                                                                   ? Theme.of(context)
      //                                                                       .colorScheme
      //                                                                       .sharerColor
      //                                                                   : Colors
      //                                                                       .white,
      //                                                               border: Border.all(
      //                                                                   width:
      //                                                                       0.5,
      //                                                                   color: Theme.of(
      //                                                                           context)
      //                                                                       .colorScheme
      //                                                                       .tabBorderColor),
      //                                                               borderRadius:
      //                                                                   BorderRadius
      //                                                                       .circular(
      //                                                                           6),
      //                                                               boxShadow: [
      //                                                                 BoxShadow(
      //                                                                   color: Theme.of(
      //                                                                           context)
      //                                                                       .colorScheme
      //                                                                       .iconThemeGray,
      //                                                                   blurRadius:
      //                                                                       15.0,
      //                                                                   spreadRadius:
      //                                                                       0.1,
      //                                                                   offset:
      //                                                                       const Offset(
      //                                                                           4,
      //                                                                           8),
      //                                                                 )
      //                                                               ]),
      //                                                           child: Column(
      //                                                             crossAxisAlignment:
      //                                                                 CrossAxisAlignment
      //                                                                     .start,
      //                                                             children: [
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     bottom:
      //                                                                         12),
      //                                                                 child: Text(
      //                                                                     listOfActiveDoc!.item1![index].docName.length > 30
      //                                                                         ? listOfActiveDoc!.item1![index].docName.substring(0, 32) +
      //                                                                             " ..."
      //                                                                         : listOfActiveDoc!
      //                                                                             .item1![
      //                                                                                 index]
      //                                                                             .docName,
      //                                                                     style: Theme.of(context)
      //                                                                         .textTheme
      //                                                                         .headline5),
      //                                                               ),
      //                                                               Row(
      //                                                                 mainAxisAlignment:
      //                                                                     MainAxisAlignment
      //                                                                         .spaceBetween,
      //                                                                 children: [
      //                                                                   Container(
      //                                                                     padding: const EdgeInsets.fromLTRB(
      //                                                                         8,
      //                                                                         2,
      //                                                                         8,
      //                                                                         2),
      //                                                                     decoration:
      //                                                                         BoxDecoration(
      //                                                                       color: Theme.of(context)
      //                                                                           .colorScheme
      //                                                                           .activeColor,
      //                                                                       borderRadius:
      //                                                                           BorderRadius.circular(15),
      //                                                                     ),
      //                                                                     child:
      //                                                                         Row(
      //                                                                       children: [
      //                                                                         Padding(
      //                                                                           padding: const EdgeInsets.only(right: 5),
      //                                                                           // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
      //                                                                           child: Image.asset("assets/Icons/v_active.png"),
      //                                                                         ),
      //                                                                         Text(
      //                                                                           getDateFormate(listOfActiveDoc!.item1![index].expiryDate),
      //                                                                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
      //                                                                         ),
      //                                                                       ],
      //                                                                     ),
      //                                                                   ),
      //                                                                   const Text(
      //                                                                     "Active",
      //                                                                     style: CustomTextStyle
      //                                                                         .simple12Text,
      //                                                                   )
      //                                                                 ],
      //                                                               ),
      //                                                               Container(
      //                                                                 margin: const EdgeInsets
      //                                                                         .only(
      //                                                                     top:
      //                                                                         10),
      //                                                                 padding: const EdgeInsets
      //                                                                         .only(
      //                                                                     top: 5,
      //                                                                     bottom:
      //                                                                         5),
      //                                                                 decoration: const BoxDecoration(
      //                                                                     border: Border(
      //                                                                         top:
      //                                                                             BorderSide(color: Colors.grey, width: 0.7),
      //                                                                         bottom: BorderSide(color: Colors.grey, width: 0.7))),
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   children: [
      //                                                                     Container(
      //                                                                       padding: const EdgeInsets.fromLTRB(
      //                                                                           8,
      //                                                                           3,
      //                                                                           5,
      //                                                                           3),
      //                                                                       width:
      //                                                                           150,
      //                                                                       child:
      //                                                                           const Text(
      //                                                                         "No action required",
      //                                                                         style: TextStyle(
      //                                                                             fontSize: 12,
      //                                                                             color: Color(0xFF323232),
      //                                                                             fontWeight: FontWeight.w600),
      //                                                                       ),
      //                                                                     ),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         listOfActiveDoc!.item1![index].remindMe == false
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.notifications_off_outlined,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container(),
      //                                                                         listOfActiveDoc!.item1![index].attachmentCount > 1
      //                                                                             ? Container(
      //                                                                                 padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
      //                                                                                 child: Icon(
      //                                                                                   Icons.attach_file,
      //                                                                                   color: Theme.of(context).primaryColor,
      //                                                                                   size: 20,
      //                                                                                 ),
      //                                                                               )
      //                                                                             : Container()
      //                                                                       ],
      //                                                                     )
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                               Expanded(
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment:
      //                                                                       MainAxisAlignment
      //                                                                           .spaceBetween,
      //                                                                   crossAxisAlignment:
      //                                                                       CrossAxisAlignment
      //                                                                           .end,
      //                                                                   children: [
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         listOfActiveDoc!.item1![index].docSharingUserId.isNotEmpty && listOfActiveDoc!.item1![index].isDocCreated == false
      //                                                                             ? Row(
      //                                                                                 children: [
      //                                                                                   Padding(
      //                                                                                     padding: const EdgeInsets.only(right: 5),
      //                                                                                     child: Icon(
      //                                                                                       FontAwesomeIcons.userGroup,
      //                                                                                       color: Theme.of(context).colorScheme.sharerIconColor,
      //                                                                                       size: 12,
      //                                                                                     ),
      //                                                                                   ),
      //                                                                                   ListView.builder(
      //                                                                                       scrollDirection: Axis.horizontal,
      //                                                                                       shrinkWrap: true,
      //                                                                                       itemCount: 1,
      //                                                                                       itemBuilder: (context, index2) {
      //                                                                                         return Row(
      //                                                                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                           children: [
      //                                                                                             SizedBox(
      //                                                                                               width: 35,
      //                                                                                               child: listOfActiveDoc!.item1![index].sharerByList!.profilePic == null
      //                                                                                                   ? CircleAvatar(
      //                                                                                                       radius: 40,
      //                                                                                                       backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                                       child: Text(getUserFirstLetetrs(listOfActiveDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
      //                                                                                                     )
      //                                                                                                   : CircleAvatar(
      //                                                                                                       radius: 25,
      //                                                                                                       backgroundImage: CachedNetworkImageProvider(imageUrl + listOfActiveDoc!.item1![index].sharerByList!.profilePic.toString()),
      //                                                                                                     ),
      //                                                                                             )
      //                                                                                           ],
      //                                                                                         );
      //                                                                                       })
      //                                                                                 ],
      //                                                                               )
      //                                                                             : ListView.builder(
      //                                                                                 scrollDirection: Axis.horizontal,
      //                                                                                 shrinkWrap: true,
      //                                                                                 itemCount: listOfActiveDoc == null
      //                                                                                     ? 0
      //                                                                                     : listOfActiveDoc!.item1![index].sharerList == null
      //                                                                                         ? 0
      //                                                                                         : listOfActiveDoc!.item1![index].sharerList!.length,
      //                                                                                 itemBuilder: (context, index2) {
      //                                                                                   return Row(
      //                                                                                     mainAxisAlignment: MainAxisAlignment.start,
      //                                                                                     children: [
      //                                                                                       SizedBox(
      //                                                                                         width: 40,
      //                                                                                         child: CircleAvatar(
      //                                                                                           radius: 50,
      //                                                                                           backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
      //                                                                                           child: Text(getUserFirstLetetrs(listOfActiveDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
      //                                                                                         ),
      //                                                                                       )
      //                                                                                     ],
      //                                                                                   );
      //                                                                                 }),
      //                                                                       ],
      //                                                                     ),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         Container(
      //                                                                             padding: const EdgeInsets.only(right: 15),
      //                                                                             child: GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   Navigator.push(
      //                                                                                     context,
      //                                                                                     MaterialPageRoute(builder: (context) => DocumentData(docId: listOfActiveDoc!.item1![index].id, indexTab: 2)),
      //                                                                                   );
      //                                                                                 },
      //                                                                                 child: Icon(Icons.share, color: Theme.of(context).colorScheme.warmGreyColor))),
      //                                                                         listOfActiveDoc!.item1![index].isbookmark == true
      //                                                                             ? GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   EasyLoading.addStatusCallback((status) {});
      //                                                                                   EasyLoading.show(status: 'loading...');
      //                                                                                   addBookmark(listOfActiveDoc!.item1![index].id.toString(), false).then((response) {
      //                                                                                     if (response == "1") {
      //                                                                                       getActiveDocDataTable().then((response) {
      //                                                                                         setState(() {
      //                                                                                           listOfActiveDoc = response!;
      //                                                                                         });
      //                                                                                       });
      //                                                                                     }
      //                                                                                     EasyLoading.dismiss();
      //                                                                                   });
      //                                                                                 },
      //                                                                                 child: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.warmGreyColor))
      //                                                                             : GestureDetector(
      //                                                                                 onTap: () {
      //                                                                                   EasyLoading.addStatusCallback((status) {});
      //                                                                                   EasyLoading.show(status: 'loading...');
      //                                                                                   addBookmark(listOfActiveDoc!.item1![index].id.toString(), true).then((response) {
      //                                                                                     if (response == "1") {
      //                                                                                       getActiveDocDataTable().then((response) {
      //                                                                                         setState(() {
      //                                                                                           listOfActiveDoc = response!;
      //                                                                                         });
      //                                                                                       });
      //                                                                                     }
      //                                                                                     EasyLoading.dismiss();
      //                                                                                   });
      //                                                                                 },
      //                                                                                 child: Icon(Icons.bookmark_outline_sharp, color: Theme.of(context).colorScheme.warmGreyColor))
      //                                                                       ],
      //                                                                     )
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                             ],
      //                                                           ),
      //                                                         )),
      //                                                   );
      //                                                 }),
      //                                   ),
      //                                 ]))
      //                       ])),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      //   // floatingActionButton: FloatingActionButton(
      //   //   backgroundColor: Theme.of(context).primaryColor,
      //   //   child: const Icon(Icons.add),
      //   //   onPressed: () {
      //   //     Navigator.push(
      //   //       context,
      //   //       MaterialPageRoute(builder: (context) => const AddDocument()),
      //   //     );
      //   //   },
      //   // ),
      //   // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //   bottomNavigationBar: const NavigationBottom(selectedIndex: 2),
      //  backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
      drawerEnableOpenDragGesture: false,
      drawer: const MenuDrawer(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/xpiree logo-1.png',
                      width: 120,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    // Text(
                    //   'Xpiree',
                    //   style: TextStyle(
                    //       color: Theme.of(context).primaryColor,
                    //       fontSize: 30,

                    //       fontWeight: FontWeight.bold),
                    // ),
                    Row(children: <Widget>[
                      Builder(builder: (context) {
                        return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.settings,
                              size: 24,
                              color: Theme.of(context).primaryColor,
                            ));
                      }),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          child: Image.asset(
                        'assets/images/sms.png',
                        scale: 2.4,
                      ))
                    ]),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Task Overview',
                      style: CustomTextStyle.simpleText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.blackColor,
                      ),
                    ),
                    Text(
                      "Details about all tasks created and assigned to you",
                      style: CustomTextStyle.simpleText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffB5B5C3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DottedBorder(
                            radius: const Radius.circular(12),
                            borderType: BorderType.RRect,
                            color: const Color(0xffB5B5C3),
                            strokeWidth: .5,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 2,
                                // margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '88',
                                        style:
                                            CustomTextStyle.simpleText.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .blackColor,
                                        ),
                                      ),
                                      Text(
                                        "Total Tasks",
                                        style:
                                            CustomTextStyle.simpleText.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffB5B5C3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Your existing container
                          DottedBorder(
                            radius: const Radius.circular(12),
                            borderType: BorderType.RRect,
                            color: const Color(0xffB5B5C3),
                            strokeWidth: .5,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 2,
                                // margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '88',
                                        style:
                                            CustomTextStyle.simpleText.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xffF1416C),
                                        ),
                                      ),
                                      Text(
                                        "Overdue",
                                        style:
                                            CustomTextStyle.simpleText.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffB5B5C3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Stack(clipBehavior: Clip.none, children: [
                        DottedBorder(
                          radius: const Radius.circular(12),
                          borderType: BorderType.RRect,
                          color: const Color(0xffB5B5C3),
                          strokeWidth: .5,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width / 2,
                              // margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '88',
                                      style:
                                          CustomTextStyle.simpleText.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .blackColor,
                                      ),
                                    ),
                                    Text(
                                      "Total Tasks",
                                      style:
                                          CustomTextStyle.simpleText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xffB5B5C3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //   ),
                        // ),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Tasks",
                            style: CustomTextStyle.simple12Text.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: " by Recent Updates ↓",
                            style: CustomTextStyle.simple12Text.copyWith(
                                fontSize: 14,
                                color: const Color(0xffA7A8BB),
                                fontWeight: FontWeight.w400)),
                      ]),
                    ),
                    GestureDetector(
                      onTap: (() {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Container(
                                padding: const EdgeInsets.all(15),
                                height: 300,
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(Icons.close,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .darkGrayColor),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        'View all',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        'Bookmarked only',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        'Shared with me',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(15.0),
                                            elevation: 0,
                                            primary: Color(0xff00A3FF),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                          ),
                                          child: Text(
                                            "Sort",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          onPressed: () {}),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      }),
                      child: Container(
                        height: 35,
                        width: 99,
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Show All',
                              style: CustomTextStyle.simple12Text.copyWith(
                                  fontSize: 12,
                                  color: const Color(0xffA7A8BB),
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xff7E8299),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTabController(
                      length: 2,
                      initialIndex: _selectedIndex,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TabBar(
                            isScrollable: false,
                            controller: _tabController,
                            unselectedLabelColor: const Color(0xffA7A8BB),
                            labelColor: const Color(0xff475467),
                            indicatorColor: const Color(0xff475467),
                            // indicatorWeight: 2,
                            labelStyle:
                                CustomTextStyle.heading5.copyWith(fontSize: 13),

                            tabs: const [
                              Tab(
                                text: "My Tasks (14) ",
                              ),
                              Tab(text: "Assigned (06)")
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24.0, 20, 24, 0),
                                          child: Container(
                                            height: 86,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Renew or Adjusting Coverage',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffA7A8BB),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Text(
                                                            'Completed',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff0BB783),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Text(
                                                            '@Myself',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffA7A8BB),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 14.0),
                                                    child: Image.asset(
                                                      'assets/images/checkboxes.png',
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UpdateMyTaskScreen()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0),
                                          child: Container(
                                            height: 86,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Apply for passport refusal Scan ',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff475467),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Text(
                                                            'Overdue',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Text(
                                                            'Travel Docs',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffA7A8BB),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Checkbox(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    checkColor:
                                                        const Color(0xff00A3FF),
                                                    value: checkBoxvalue,
                                                    activeColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      setState(() {
                                                        checkBoxvalue =
                                                            newValue!;
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0),
                                        child: Container(
                                          height: 86,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 14.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            'previous copies of pass',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff475467),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            height: 26,
                                                            width: 47,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffebf8ff)),
                                                            child: const Center(
                                                              child: Text(
                                                                'new',
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
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          'Due jun 24,2024',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Text(
                                                          'Travel Docs',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffA7A8BB),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14.0),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        height: 33,
                                                        width: 33,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Text(
                                                          'S',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            24.0, 20, 24, 0),
                                        child: Container(
                                          height: 86,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Renew or Adjusting Coverage',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffA7A8BB),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          'Completed',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff0BB783),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Text(
                                                          '@Myself',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffA7A8BB),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Image.asset(
                                                    'assets/images/checkboxes.png',
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0),
                                        child: Container(
                                          height: 86,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Apply for passport refusal Scan ',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff475467),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          'Overdue',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        Text(
                                                          'Travel Docs',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffA7A8BB),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        height: 33,
                                                        width: 33,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Text(
                                                          'S',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: -16,
                                                        child: Container(
                                                          height: 34,
                                                          width: 34,
                                                          decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: Image.asset(
                                                              'assets/images/s.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UpdateAssignedTaskScreen()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0),
                                          child: Container(
                                            height: 86,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              'previous copies of pass',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff475467),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Container(
                                                              height: 26,
                                                              width: 47,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: const Color(
                                                                      0xffebf8ff)),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'new',
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
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: const [
                                                          Text(
                                                            'Due jun 24,2024',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Text(
                                                            'Travel Docs',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffA7A8BB),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          height: 33,
                                                          width: 33,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          child: const Text(
                                                            'S',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavigationBottom(selectedIndex: 2),
    );
  }
}
