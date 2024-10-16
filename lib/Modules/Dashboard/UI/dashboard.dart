import 'package:Xpiree/Modules/Dashboard/UI/notification.dart';
import 'package:Xpiree/Modules/Dashboard/UI/widgets/slider.dart';
import 'package:Xpiree/Modules/Document/UI/add_document.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Dashboard/UI/Drawer.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Modules/Document/UI/document_detail.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavigationBottom.dart';

enum Filtertype { viewAll, bookMarked, shared }

class Dashboard extends StatefulWidget {
  final int indexTab;
  const Dashboard({Key? key, required this.indexTab}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  DocumentVM? listOfActiveDoc;
  DocumentVM? listOfExpiringDoc;
  DocumentVM? listOfExpiredDoc;
  DocumentVM? listOfExpiringDocBookmark;
  DashboardCountVm _counts = DashboardCountVm();
  final UserInfo _user = UserInfo();
  String userShortName = "";
  CarouselController btnCarouselCt = CarouselController();

  late int _selectedIndex;
  late TabController _tabController;
  int xpiredCount = 00;
  int xpiringCount = 00;
  int activeCount = 00;

  late String xpiredCountStr = "00";
  late String xpiringCountStr = "00";
  late String activeCountStr = "00";
  late String pendigTaskStr = "00";

  late String xpiredCountTabStr = "00";
  late String xpiringCountTabStr = "00";
  late String activeCountTabStr = "00";
  // Timer? timer;
  late bool newNotification = false;
  List<SliderList> sliderList = SliderList.getList();

  Filtertype? _character = Filtertype.viewAll;
  bool _showSlider = false;
  int filter = 0;
  @override
  void initState() {
    super.initState();
    /* timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      getNotificationCount();
        SessionMangement _sm = SessionMangement();
       _sm.getNewNotify().then((response) {
      setState(() {
        newNotification = response!;
      });
    });
    }); 
 */
    const SliderWidget();
    // checkFirstTimeLogin();
    setState(() {
      _selectedIndex = widget.indexTab;
    });

    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(_selectedIndex);
    if (filter == 0) {
      _tabController.addListener(() {
        setState(() {
          _selectedIndex = _tabController.index;
          if (_selectedIndex == 0) {
            _selectedIndex = 0;
            getExpiredDocDataTable().then((response) {
              setState(() {
                listOfExpiredDoc = response!;
              });
              EasyLoading.dismiss();
            });
          } else if (_selectedIndex == 1) {
            _selectedIndex = 1;
            getExpiringDocDataTable().then((response) {
              setState(() {
                listOfExpiringDoc = response!;
              });
              EasyLoading.dismiss();
            });
          } else if (_selectedIndex == 2) {
            _selectedIndex = 2;
            getActiveDocDataTable().then((response) {
              setState(() {
                listOfActiveDoc = response!;
              });
              EasyLoading.dismiss();
            });
          }
        });
      });
    }
    SessionMangement _sm = SessionMangement();

    EasyLoading.show(status: 'loading...');

    _sm.getUserName().then((response) {
      setState(() {
        _user.userName = response!;
        var data = response.split(" ");
        for (int i = 0; i < 2; i++) {
          userShortName = userShortName + data[i][0];
        }
      });
    });
    _sm.getProfilePic().then((response) {
      setState(() {
        _user.userPic = response!;
      });
    });
    _sm.getNoOfFolders().then((response) {
      setState(() {
        _user.noOfFolders = int.parse(response!);
      });
    });
    _sm.getNoOfDocuments().then((response) {
      setState(() {
        _user.noOfDocuments = int.parse(response!);
      });
    });

    getExpiredDocDataTable().then((response) {
      setState(() {
        listOfExpiredDoc = response!;
        xpiredCount = listOfExpiredDoc!.item2;
        xpiredCountTabStr = xpiredCount < 10
            ? "0" + xpiredCount.toString()
            : xpiredCount.toString();
      });
      EasyLoading.dismiss();
    });
    getDashboardCounts().then((response) {
      setState(() {
        _counts = response;
        xpiredCountStr = _counts.expiredDoc < 10
            ? "0" + _counts.expiredDoc.toString()
            : _counts.expiredDoc.toString();
        xpiringCountStr = _counts.expiringDoc < 10
            ? "0" + _counts.expiringDoc.toString()
            : _counts.expiringDoc.toString();
        activeCountStr = _counts.activeDoc < 10
            ? "0" + _counts.activeDoc.toString()
            : _counts.activeDoc.toString();
        pendigTaskStr = _counts.taskCount < 10
            ? "0" + _counts.taskCount.toString()
            : _counts.taskCount.toString();
      });
      if (_counts.isVisited == false) {
        showSliderAlert(_user.userName, context);
      }
      EasyLoading.dismiss();
    });
    getExpiringDocDataTable().then((response) {
      setState(() {
        listOfExpiringDoc = response!;
        xpiringCount = listOfExpiringDoc!.item2;
        xpiringCountTabStr = xpiringCount < 10
            ? "0" + xpiringCount.toString()
            : xpiringCount.toString();
      });
      EasyLoading.dismiss();
    });
    getActiveDocDataTable().then((response) {
      setState(() {
        listOfActiveDoc = response!;
        activeCount = listOfActiveDoc!.item2;
        activeCountTabStr = activeCount < 10
            ? "0" + activeCount.toString()
            : activeCount.toString();
      });
      EasyLoading.dismiss();
    });
  }
// Future<void> checkFirstTimeLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isFirstTime = prefs.getBool('isFirstTime') ?? true;

//     if (isFirstTime) {
//       setState(() {
//         _showSlider = true;
//       });
//       await prefs.setBool('isFirstTime', false);
//     }
//   }
  @override
  void dispose() {
    // timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),

      drawerEnableOpenDragGesture: false,
      drawer: const MenuDrawer(),
      body:
          //  _showSlider
          //     ? const SliderWidget()
          //     :
          WillPopScope(
              onWillPop: () async {
                return await confirmExitApp(context);
              },
              child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      SessionMangement _sm = SessionMangement();
                      _sm.getUserName().then((response) {
                        userShortName = "";
                        setState(() {
                          _user.userName = response!;
                          var data = response.split(" ");
                          for (int i = 0; i < 2; i++) {
                            userShortName = userShortName + data[i][0];
                          }
                        });
                      });
                      _sm.getProfilePic().then((response) {
                        setState(() {
                          _user.userPic = response!;
                        });
                      });
                      _sm.getNoOfDocuments().then((response) {
                        setState(() {
                          _user.noOfDocuments = int.parse(response!);
                        });
                      });
                      if (filter == 0) {
                        getExpiredDocDataTable().then((response) {
                          setState(() {
                            listOfExpiredDoc = response!;
                          });
                          EasyLoading.dismiss();
                        });
                      } else {
                        getExpiredDocDataTableBookmark().then((response) {
                          setState(() {
                            listOfExpiringDocBookmark = response!;
                          });
                          EasyLoading.dismiss();
                        });
                      }
                      getDashboardCounts().then((response) {
                        setState(() {
                          _counts = response;
                        });
                        if (_counts.isVisited == false) {
                          showSliderAlert(_user.userName, context);
                        }
                        EasyLoading.dismiss();
                      });
                    });
                  },
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
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
                                      onTap: () {
                                        SessionMangement _sm =
                                            SessionMangement();
                                        setState(() {
                                          _sm.removeNewNotify();
                                        });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationInfo()),
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/images/sms.png',
                                        scale: 2.4,
                                      ))
                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.message,
                                  //       color:
                                  //           Theme.of(context).colorScheme.iconColor,
                                  //     ),
                                  //     onPressed: () {
                                  //       // SessionMangement _sm = SessionMangement();
                                  //       // setState(() {
                                  //       //   _sm.removeNewNotify();
                                  //       // });

                                  //       // Navigator.push(
                                  //       //   context,
                                  //       //   MaterialPageRoute(
                                  //       //       builder: (context) =>
                                  //       //           const NotificationInfo()),
                                  //       // );
                                  //     }),
                                  // newNotification == true
                                  //     ? Positioned(
                                  //         right: 14,
                                  //         top: 14,
                                  //         child: Container(
                                  //           padding: const EdgeInsets.all(2),
                                  //           decoration: BoxDecoration(
                                  //             color: Colors.red,
                                  //             borderRadius: BorderRadius.circular(6),
                                  //           ),
                                  //           constraints: const BoxConstraints(
                                  //             minWidth: 10,
                                  //             minHeight: 10,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Container()
                                ]),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                // _user.userPic.isEmpty || _user.userPic == ""
                                //     ? CircleAvatar(
                                //         radius: 25,
                                //         backgroundColor: Theme.of(context)
                                //             .colorScheme
                                //             .profileEditColor,
                                //         child: Text(userShortName.toUpperCase(),
                                //             style: TextStyle(
                                //                 color:
                                //                     Theme.of(context).primaryColor)),
                                //       )
                                //     : CircleAvatar(
                                //         radius: 25,
                                //         backgroundImage: CachedNetworkImageProvider(
                                //             imageUrl + _user.userPic),
                                //       ),
                                Flexible(
                                  child: Column(
                                    children: [
                                      // Container(
                                      //   alignment: Alignment.centerLeft,
                                      //   padding: const EdgeInsets.only(left: 10),
                                      //   child: Text(
                                      //     _user.userName.isEmpty
                                      //         ? ""
                                      //         : _user.userName
                                      //             .split(" ")
                                      //             .map((str) => capitalize(str))
                                      //             .join(" "),
                                      //     style: CustomTextStyle.topHeading,
                                      //   ),
                                      // ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                _user.noOfDocuments
                                                            .toString() ==
                                                        "0"
                                                    ? "No document"
                                                    : _user.noOfDocuments
                                                                .toString() ==
                                                            "1"
                                                        ? _user.noOfDocuments
                                                                .toString() +
                                                            " Document "
                                                        : _user.noOfDocuments
                                                                .toString() +
                                                            " Documents ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                            // _user.noOfFolders != 0 ||
                                            //         _user.noOfDocuments != 0
                                            //     ? Text(" | ",
                                            //         style: Theme.of(context)
                                            //             .textTheme
                                            //             .headline6)
                                            //     : Container(),
                                            Text(
                                                _user.noOfFolders.toString() ==
                                                        "0"
                                                    ? " "
                                                    : _user.noOfFolders
                                                                .toString() ==
                                                            "1"
                                                        ? _user.noOfFolders
                                                                .toString() +
                                                            " Folder"
                                                        : _user.noOfFolders
                                                                .toString() +
                                                            " Folders",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color(
                                                            0xffA7A8BB))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          xpiredCount == 0 &&
                                  xpiringCount == 0 &&
                                  activeCount == 0
                              ? Container()
                              : Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              height: 70,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffF1416C),
                                                // color: Theme.of(context)
                                                //     .colorScheme
                                                //     .expiredColor,
                                                /*  border: Border.all(
                                        width: 0.001,
                                      ),  */
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     // color: Color(0xffFFF7F6),
                                                //     color: Theme.of(context)
                                                //         .primaryColor
                                                //         .withOpacity(0.4),

                                                //     blurRadius: 5.0,
                                                //     spreadRadius: 0.1,
                                                //     offset: Offset(0, 1),
                                                //   )
                                                // ]),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(xpiredCountStr,
                                                        style: CustomTextStyle
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .whiteColor)),
                                                    Text("Expired",
                                                        style: CustomTextStyle
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .whiteColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Positioned(
                                            //   top: -18,
                                            //   left: 15,
                                            //   child: Container(
                                            //     child: Image.asset(
                                            //         "assets/Icons/Vector3.png",
                                            //         width: 20,
                                            //         height: 20),
                                            //     padding: const EdgeInsets.all(10),
                                            //     margin:
                                            //         const EdgeInsets.only(left: 10),
                                            //     decoration: BoxDecoration(
                                            //       color: Theme.of(context)
                                            //           .colorScheme
                                            //           .pinkColor,
                                            //       borderRadius:
                                            //           BorderRadius.circular(6),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            // Your existing container
                                            Container(
                                              height: 70,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Color(0xffFFA621),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     // color: Color(0xffFFF7F6),
                                                //     color: Theme.of(context)
                                                //         .primaryColor
                                                //         .withOpacity(0.4),

                                                //     blurRadius: 5.0,
                                                //     spreadRadius: 0.1,
                                                //     offset: Offset(0, 1),
                                                //   )
                                                // ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(xpiringCountStr,
                                                        style: CustomTextStyle
                                                            .simpleText
                                                            .copyWith(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .whiteColor)),
                                                    Text(
                                                      "Expiring",
                                                      style: CustomTextStyle
                                                          .simpleText
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .whiteColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Positioned container
                                            // Positioned(
                                            //   left: 15,
                                            //   top: -18,
                                            //   child: Container(
                                            //     child: Image.asset(
                                            //       "assets/Icons/Vector1.png",
                                            //       width: 16,
                                            //       height: 16,
                                            //     ),
                                            //     padding: const EdgeInsets.all(12),
                                            //     margin: const EdgeInsets.only(left: 10),
                                            //     decoration: BoxDecoration(
                                            //       color: Theme.of(context)
                                            //           .colorScheme
                                            //           .yellowColor,
                                            //       borderRadius:
                                            //           BorderRadius.circular(6),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                height: 70,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                margin: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff0BB783),
                                                  /* border: Border.all(
                                        width: 0.05,
                                      ),  */
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     // color: Color(0xffFFF7F6),
                                                  //     color: Theme.of(context)
                                                  //         .primaryColor
                                                  //         .withOpacity(0.4),

                                                  //     blurRadius: 5.0,
                                                  //     spreadRadius: 0.1,
                                                  //     offset: Offset(0, 1),
                                                  //   )
                                                  // ]
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(activeCountStr,
                                                          style: CustomTextStyle
                                                              .simpleText
                                                              .copyWith(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .whiteColor)),
                                                      Text("Active",
                                                          style: CustomTextStyle
                                                              .simpleText
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .whiteColor)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   top: -18,
                                              //   left: 15,
                                              //   child: Container(
                                              //     child: Image.asset(
                                              //         "assets/Icons/Vector2.png",
                                              //         width: 20,
                                              //         height: 20),
                                              //     padding: const EdgeInsets.all(12),
                                              //     margin: const EdgeInsets.only(left: 10),
                                              //     decoration: BoxDecoration(
                                              //       color: Theme.of(context)
                                              //           .colorScheme
                                              //           .lightGreenColor,
                                              //       /* border: Border.all(
                                              //         width: 0.05,
                                              //       ),  */
                                              //       borderRadius:
                                              //           BorderRadius.circular(6),
                                              //     ),
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
                          _user.noOfDocuments == 0
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Overview",
                                              style: CustomTextStyle
                                                  .simple12Text
                                                  .copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          TextSpan(
                                              text: " by Recent Updates ↓",
                                              style: CustomTextStyle
                                                  .simple12Text
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xffA7A8BB),
                                                      fontWeight:
                                                          FontWeight.w400)),
                                        ]),
                                      ),
                                      GestureDetector(
                                        onTap: (() {
                                          showModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            // shape: const RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.only(
                                            //   topRight: Radius.circular(20),
                                            //   topLeft: Radius.circular(20),
                                            // )),
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                  builder: (context, setState) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  height: 300,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.close,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .darkGrayColor),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      ListTile(
                                                        title: const Text(
                                                          'View all',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        leading:
                                                            Radio<Filtertype>(
                                                          value: Filtertype
                                                              .viewAll,
                                                          groupValue:
                                                              _character,
                                                          onChanged:
                                                              (Filtertype?
                                                                  value) {
                                                            setState(() {
                                                              _character =
                                                                  value;
                                                              filter = 0;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      ListTile(
                                                        title: const Text(
                                                          'Bookmarked only',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        leading:
                                                            Radio<Filtertype>(
                                                          value: Filtertype
                                                              .bookMarked,
                                                          groupValue:
                                                              _character,
                                                          onChanged:
                                                              (Filtertype?
                                                                  value) {
                                                            setState(() {
                                                              _character =
                                                                  value;
                                                              filter = 1;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      ListTile(
                                                        title: const Text(
                                                          'Shared with me',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        leading:
                                                            Radio<Filtertype>(
                                                          value:
                                                              Filtertype.shared,
                                                          groupValue:
                                                              _character,
                                                          onChanged:
                                                              (Filtertype?
                                                                  value) {
                                                            setState(() {
                                                              _character =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              elevation: 0,
                                                              primary:
                                                                  const Color(
                                                                      0xff00A3FF),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                            ),
                                                            child: Text(
                                                              "Sort",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline3,
                                                            ),
                                                            onPressed: () {
                                                              if (filter == 1) {
                                                                // getExpiredDocDataTableBookmark()
                                                                //     .then(
                                                                //         (response) {
                                                                //   setState(() {
                                                                //     listOfExpiredDoc =
                                                                //         response!;
                                                                //   });
                                                                //   EasyLoading
                                                                //       .dismiss();
                                                                // });

                                                                getExpiringDocDataTableBookmark()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfExpiringDoc =
                                                                        response!;
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });

                                                                getActiveDocDataTableBookmarkdata()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfActiveDoc =
                                                                        response!;
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                                getExpiredDocDataTableBookmark()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfExpiringDocBookmark =
                                                                        response!;
                                                                    xpiredCount =
                                                                        listOfExpiringDocBookmark!
                                                                            .item2;
                                                                    xpiredCountTabStr = xpiredCount <
                                                                            10
                                                                        ? "0" +
                                                                            xpiredCount
                                                                                .toString()
                                                                        : xpiredCount
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });

                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                getExpiredDocDataTable()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfExpiredDoc =
                                                                        response!;
                                                                    xpiredCount =
                                                                        listOfExpiredDoc!
                                                                            .item2;
                                                                    xpiredCountTabStr = xpiredCount <
                                                                            10
                                                                        ? "0" +
                                                                            xpiredCount
                                                                                .toString()
                                                                        : xpiredCount
                                                                            .toString();
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                                getExpiredDocDataTable()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfExpiredDoc =
                                                                        response!;
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });

                                                                getExpiringDocDataTable()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfExpiringDoc =
                                                                        response!;
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });

                                                                getActiveDocDataTable()
                                                                    .then(
                                                                        (response) {
                                                                  setState(() {
                                                                    listOfActiveDoc =
                                                                        response!;
                                                                  });
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              }
                                                            }),
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
                                          // width: 99,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, top: 8, bottom: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Show All',
                                                  style: CustomTextStyle
                                                      .simple12Text
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: const Color(
                                                              0xffA7A8BB),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                // const SizedBox(
                                                //   width: 10,
                                                // ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color:
                                                      const Color(0xff7E8299),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                          xpiredCount == 0 &&
                                  xpiringCount == 0 &&
                                  activeCount == 0
                              ? Container()
                              : Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 0, 25, 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      // Expanded(
                                      //   child: Stack(
                                      //       clipBehavior: Clip.none,
                                      //       children: const [
                                      //         // Container(
                                      //         //   height: 70,
                                      //         //   // width:
                                      //         //   //     MediaQuery.of(context).size.width / 2,
                                      //         //   margin: const EdgeInsets.all(5),
                                      //         //   decoration: BoxDecoration(
                                      //         //     color: Theme.of(context).primaryColor,
                                      //         //     /*   border: Border.all(
                                      //         //       width: 0.05,
                                      //         //     ), */
                                      //         //     borderRadius: BorderRadius.circular(6),
                                      //         //     // boxShadow: [
                                      //         //     //   BoxShadow(
                                      //         //     //     // color: Color(0xffFFF7F6),
                                      //         //     //     color: Theme.of(context)
                                      //         //     //         .primaryColor
                                      //         //     //         .withOpacity(0.4),

                                      //         //     //     blurRadius: 5.0,
                                      //         //     //     spreadRadius: 0.1,
                                      //         //     //     offset: Offset(0, 1),
                                      //         //     //   )
                                      //         //     // ]
                                      //         //   ),
                                      //         //   child: Center(
                                      //         //     child: Column(
                                      //         //       crossAxisAlignment:
                                      //         //           CrossAxisAlignment.start,
                                      //         //       mainAxisAlignment:
                                      //         //           MainAxisAlignment.center,
                                      //         //       children: [
                                      //         //         Text(pendigTaskStr,
                                      //         //             style: CustomTextStyle
                                      //         //                 .simpleText
                                      //         //                 .copyWith(
                                      //         //                     fontSize: 16,
                                      //         //                     fontWeight:
                                      //         //                         FontWeight.bold,
                                      //         //                     color: Theme.of(context)
                                      //         //                         .colorScheme
                                      //         //                         .whiteColor)),
                                      //         //         Text("Pending tasks",
                                      //         //             style: CustomTextStyle
                                      //         //                 .simpleText
                                      //         //                 .copyWith(
                                      //         //                     fontSize: 16,
                                      //         //                     color: Theme.of(context)
                                      //         //                         .colorScheme
                                      //         //                         .whiteColor)),
                                      //         //       ],
                                      //         //     ),
                                      //         //   ),
                                      //         // ),
                                      //         // Positioned(
                                      //         //   left: 15,
                                      //         //   top: -18,
                                      //         //   child: Container(
                                      //         //     child: Image.asset(
                                      //         //         "assets/Icons/Vector4.png",
                                      //         //         width: 20,
                                      //         //         height: 20),
                                      //         //     padding: const EdgeInsets.all(12),
                                      //         //     margin: const EdgeInsets.only(left: 10),
                                      //         //     decoration: BoxDecoration(
                                      //         //       color: Theme.of(context)
                                      //         //           .colorScheme
                                      //         //           .lightPurpleColor,
                                      //         //       /*    border: Border.all(
                                      //         //       width: 0.05,
                                      //         //     ),  */
                                      //         //       borderRadius:
                                      //         //           BorderRadius.circular(6),
                                      //         //     ),
                                      //         //   ),
                                      //         // ),
                                      //       ]),
                                      // ),
                                    ],
                                  ),
                                ),
                          xpiredCount == 0 &&
                                  xpiringCount == 0 &&
                                  activeCount == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/Slider/5.png",
                                            width: 200, height: 200),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              50, 20, 50, 20),
                                          child: Text(
                                            "Start by adding a document that you wish to track",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddDocument()),
                                            );
                                          },
                                          child: Container(
                                            height: 44,
                                            width: 228,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff00A3FF),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Add New Document',
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 5, right: 5),
                                  child: Column(
                                    children: [
                                      // Divider(
                                      //     thickness: 0.8,
                                      //     color: Theme.of(context)
                                      //         .colorScheme
                                      //         .textBoxBorderColor),
                                      DefaultTabController(
                                          length: 3,
                                          initialIndex: _selectedIndex,
                                          child: Column(children: <Widget>[
                                            TabBar(
                                              // indicator: BoxDecoration(
                                              //   color: Theme.of(context).primaryColor,
                                              //   borderRadius:
                                              //       BorderRadius.circular(25),
                                              // ),

                                              isScrollable: false,
                                              controller: _tabController,
                                              labelColor: Theme.of(context)
                                                  .colorScheme
                                                  .blackColor,
                                              unselectedLabelColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .iconThemeGray,
                                              indicatorColor:
                                                  _selectedIndex == 0
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .expiredColor
                                                      : _selectedIndex == 1
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .expiringColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .activeColor,
                                              // indicatorWeight: 2,
                                              labelStyle: CustomTextStyle
                                                  .heading5
                                                  .copyWith(fontSize: 13),
                                              onTap: (index) {
                                                if (filter == 0) {
                                                  if (index == 0) {
                                                    _selectedIndex = 0;
                                                    getExpiredDocDataTable()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfExpiredDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  } else if (index == 1) {
                                                    _selectedIndex = 1;
                                                    getExpiringDocDataTable()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfExpiringDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  } else if (index == 2) {
                                                    _selectedIndex = 2;
                                                    getActiveDocDataTable()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfActiveDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  }
                                                } else {
                                                  if (index == 0) {
                                                    _selectedIndex = 0;
                                                    getExpiredDocDataTableBookmark()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfExpiredDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  } else if (index == 1) {
                                                    _selectedIndex = 1;
                                                    getExpiringDocDataTableBookmark()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfExpiringDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  } else if (index == 2) {
                                                    _selectedIndex = 2;
                                                    getActiveDocDataTableBookmarkdata()
                                                        .then((response) {
                                                      setState(() {
                                                        listOfActiveDoc =
                                                            response!;
                                                      });
                                                      EasyLoading.dismiss();
                                                    });
                                                  }
                                                }
                                              },
                                              tabs: [
                                                Tab(
                                                  text: "Expired (" +
                                                      xpiredCountTabStr
                                                          .toString() +
                                                      ")",
                                                ),
                                                Tab(
                                                    text: "Expiring (" +
                                                        xpiringCountTabStr
                                                            .toString() +
                                                        ")"),
                                                Tab(
                                                    text: "Active (" +
                                                        activeCountTabStr
                                                            .toString() +
                                                        ")"),
                                              ],
                                            ),
                                            Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.40,
                                                // decoration: const BoxDecoration(
                                                //     border: Border(
                                                //         top: BorderSide(
                                                //             color: Colors.red,
                                                //             width: 0.5))),
                                                child: TabBarView(
                                                    controller: _tabController,
                                                    children: <Widget>[
                                                      Container(
                                                        // color: const Color(0xff4FC2F8)
                                                        //     .withOpacity(0.1),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: listOfExpiredDoc ==
                                                                    null ||
                                                                listOfExpiredDoc!
                                                                        .item2 ==
                                                                    0
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No expired document",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline6),
                                                              )
                                                            : ListView.builder(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        50),
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    listOfExpiredDoc!
                                                                        .item2,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                DocumentData(docId: listOfExpiredDoc!.item1![index].id, indexTab: 0)),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              0.0),
                                                                      child: Container(
                                                                          // height: 140,
                                                                          padding: const EdgeInsets.only(top: 4),
                                                                          margin: const EdgeInsets.only(top: 10),
                                                                          // foregroundDecoration:
                                                                          //     BoxDecoration(
                                                                          //   gradient:
                                                                          //       LinearGradient(
                                                                          //     begin: Alignment
                                                                          //         .bottomCenter,
                                                                          //     end: Alignment
                                                                          //         .topCenter,
                                                                          //     colors: [
                                                                          //       const Color(
                                                                          //               0xff4FC2F8)
                                                                          //           .withOpacity(
                                                                          //               0.80),
                                                                          //       const Color(
                                                                          //               0xff4FC2F8)
                                                                          //           .withOpacity(
                                                                          //               0.1),
                                                                          //     ],
                                                                          //     stops: const [
                                                                          //       0.1,
                                                                          //       0.24
                                                                          //     ],
                                                                          // ),
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                                                          // borderRadius:
                                                                          //     BorderRadius
                                                                          //         .circular(
                                                                          //             6),
                                                                          // ),
                                                                          child: Container(
                                                                            height:
                                                                                140,
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                15,
                                                                                15,
                                                                                15,
                                                                                15),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              // color: Colors
                                                                              //     .white,
                                                                              color: listOfExpiredDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiredDoc!.item1![index].isDocCreated == false ? Theme.of(context).colorScheme.sharerColor : Colors.white,
                                                                              border: Border.all(width: 0.5, color: Theme.of(context).colorScheme.tabBorderColor),
                                                                              borderRadius: BorderRadius.circular(16),
                                                                            ),
                                                                            // boxShadow: [
                                                                            //   BoxShadow(
                                                                            //     // color: Color(0xffFFF7F6),
                                                                            //     color:
                                                                            //         Theme.of(context).primaryColor,

                                                                            //     blurRadius:
                                                                            //         1.0,
                                                                            //     spreadRadius:
                                                                            //         0.1,
                                                                            //     offset:
                                                                            //         const Offset(0, 2),
                                                                            //   )
                                                                            // ]
                                                                            // boxShadow: [
                                                                            //   BoxShadow(
                                                                            //     color: Theme.of(context)
                                                                            //         .colorScheme
                                                                            //         .iconThemeGray,
                                                                            //     blurRadius:
                                                                            //         15.0,
                                                                            //     spreadRadius:
                                                                            //         0.1,
                                                                            //     offset: const Offset(
                                                                            //         4,
                                                                            //         8),
                                                                            //   )
                                                                            // ]
                                                                            // ),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.only(bottom: 0),
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 26,
                                                                                        width: 64,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xffFFF5F8)),
                                                                                        child: const Center(
                                                                                          child: Text(
                                                                                            'Expired',
                                                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffF1416C)),
                                                                                            // textAlign: Alignment.center,
                                                                                          ),
                                                                                        ),
                                                                                      ),

                                                                                      listOfExpiredDoc!.item1![index].isbookmark == true
                                                                                          ? GestureDetector(
                                                                                              onTap: () {
                                                                                                EasyLoading.addStatusCallback((status) {});
                                                                                                EasyLoading.show(status: 'loading...');
                                                                                                addBookmark(listOfExpiredDoc!.item1![index].id.toString(), false).then((response) {
                                                                                                  if (response == "1") {
                                                                                                    getExpiredDocDataTable().then((response) {
                                                                                                      setState(() {
                                                                                                        listOfExpiredDoc = response!;
                                                                                                      });
                                                                                                    });
                                                                                                  }
                                                                                                  EasyLoading.dismiss();
                                                                                                });
                                                                                              },
                                                                                              child: const Icon(
                                                                                                Icons.bookmark, color: Color(0xffD6D6E0),
                                                                                                // Theme.of(context).colorScheme.warmGreyColor
                                                                                              ))
                                                                                          : GestureDetector(
                                                                                              onTap: () {
                                                                                                EasyLoading.addStatusCallback((status) {});
                                                                                                EasyLoading.show(status: 'loading...');
                                                                                                addBookmark(listOfExpiredDoc!.item1![index].id.toString(), true).then((response) {
                                                                                                  if (response == "1") {
                                                                                                    getExpiredDocDataTable().then((response) {
                                                                                                      setState(() {
                                                                                                        listOfExpiredDoc = response!;
                                                                                                      });
                                                                                                    });
                                                                                                  }
                                                                                                  EasyLoading.dismiss();
                                                                                                });
                                                                                              },
                                                                                              child: const Icon(
                                                                                                Icons.bookmark_outline_sharp, color: Color(0xffD6D6E0),
                                                                                                //  Theme.of(context).colorScheme.warmGreyColor
                                                                                              )),
                                                                                      // Row(
                                                                                      //   children: [
                                                                                      //     Container(
                                                                                      //         padding: const EdgeInsets.only(right: 10),
                                                                                      //         child: GestureDetector(
                                                                                      //             onTap: () {
                                                                                      //               Navigator.push(
                                                                                      //                 context,
                                                                                      //                 MaterialPageRoute(builder: (context) => DocumentData(docId: listOfActiveDoc!.item1![index].id, indexTab: 2)),
                                                                                      //               );
                                                                                      //             },
                                                                                      //             child: Icon(Icons.share, size: 20, color: Theme.of(context).iconTheme.color))),
                                                                                      //     listOfExpiredDoc!.item1![index].remindMe == false
                                                                                      //         ? Container(
                                                                                      //             padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                                                                                      //             child: Icon(
                                                                                      //               Icons.notifications_off_outlined,
                                                                                      //               color: Theme.of(context).iconTheme.color,
                                                                                      //               size: 20,
                                                                                      //             ),
                                                                                      //           )
                                                                                      //         : Container(),
                                                                                      //   ],
                                                                                      // )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(listOfExpiredDoc!.item1![index].docName.length > 30 ? listOfExpiredDoc!.item1![index].docName.substring(0, 32) + " ..." : listOfExpiredDoc!.item1![index].docName, style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Container(
                                                                                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                                                      decoration: BoxDecoration(
                                                                                        // color: Theme.of(context).iconTheme.color,
                                                                                        // color: Colors.black,
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Row(
                                                                                            children: const [
                                                                                              Icon(
                                                                                                Icons.folder_open_rounded,
                                                                                                color: Color(0xffD6D6E0),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 8,
                                                                                              ),
                                                                                              Text(
                                                                                                'Business',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 16,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  color: Color(0xffB5B5C3),
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
                                                                                          Text(
                                                                                            getDateFormate(listOfExpiredDoc!.item1![index].expiryDate),
                                                                                            style: const TextStyle(color: Color(0xffF1416C), fontWeight: FontWeight.w600, fontSize: 12),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    // RichText(
                                                                                    //     text: TextSpan(children: [
                                                                                    //   const TextSpan(
                                                                                    //     text: "Expired ",
                                                                                    //     style: CustomTextStyle.simple12Text,
                                                                                    //   ),
                                                                                    //   TextSpan(text: listOfExpiredDoc!.item1![index].diffTotalDays > 9 ? listOfExpiredDoc!.item1![index].diffTotalDays.toString().replaceAll(RegExp('-'), '') : "0" + listOfExpiredDoc!.item1![index].diffTotalDays.toString().replaceAll(RegExp('-'), ''), style: TextStyle(color: Theme.of(context).colorScheme.expiredColor, fontWeight: FontWeight.w700)),
                                                                                    //   listOfExpiredDoc!.item1![index].diffTotalDays > 1
                                                                                    //       ? const TextSpan(
                                                                                    //           text: " days ago",
                                                                                    //           style: CustomTextStyle.simple12Text,
                                                                                    //         )
                                                                                    //       : const TextSpan(
                                                                                    //           text: " day ago",
                                                                                    //           style: CustomTextStyle.simple12Text,
                                                                                    //         ),
                                                                                    // ])),
                                                                                  ],
                                                                                ),
                                                                                // Container(
                                                                                //   margin:
                                                                                //       const EdgeInsets.only(top: 10),
                                                                                //   padding:
                                                                                //       const EdgeInsets.only(top: 5, bottom: 5),
                                                                                //   decoration: const BoxDecoration(
                                                                                //       border: Border(
                                                                                //           // top: BorderSide(color: Colors.grey,width: 0.7),
                                                                                //           // bottom: BorderSide(color: Color.fromARGB(255, 143, 17, 17),width: 0.7)
                                                                                //           )),
                                                                                //   child:
                                                                                //       Row(
                                                                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //     children: [
                                                                                //       Container(
                                                                                //           padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
                                                                                //           decoration: BoxDecoration(
                                                                                //               color: Colors.black,
                                                                                //               // color: Theme.of(context).iconTheme.color,
                                                                                //               borderRadius: BorderRadius.circular(15)),
                                                                                //           width: 150,
                                                                                //           child: Row(
                                                                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //             children: [
                                                                                //               Text(
                                                                                //                 listOfExpiredDoc!.item1![index].docUserStatusId == 1
                                                                                //                     ? "Pending Renewal"
                                                                                //                     : listOfExpiredDoc!.item1![index].docUserStatusId == 2
                                                                                //                         ? "Renewal In-Progress"
                                                                                //                         : "Renewed",
                                                                                //                 style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600),
                                                                                //               ),
                                                                                //               const Icon(
                                                                                //                 Icons.keyboard_arrow_down,
                                                                                //                 color: Color(0xFFFFFFFF),
                                                                                //               ),
                                                                                //             ],
                                                                                //           )),
                                                                                //       Row(
                                                                                //         children: [
                                                                                //           //      listOfExpiredDoc!.item1![index].remindMe == false
                                                                                //           // ? Container(
                                                                                //           //     padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                                                                                //           //     child: Icon(
                                                                                //           //       Icons.notifications_off_outlined,
                                                                                //           //       color: Theme.of(context).primaryColor,
                                                                                //           //       size: 20,
                                                                                //           //     ),
                                                                                //           //   )
                                                                                //           // : Container(),
                                                                                //           listOfExpiredDoc!.item1![index].attachmentCount > 1
                                                                                //               ? Container(
                                                                                //                   padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
                                                                                //                   child: Icon(
                                                                                //                     Icons.attach_file,
                                                                                //                     color: Theme.of(context).primaryColor,
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
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          listOfExpiredDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiredDoc!.item1![index].isDocCreated == false
                                                                                              ? Row(
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(right: 5),
                                                                                                      child: Icon(
                                                                                                        FontAwesomeIcons.userGroup,
                                                                                                        color: Theme.of(context).colorScheme.sharerIconColor,
                                                                                                        size: 12,
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListView.builder(
                                                                                                        scrollDirection: Axis.horizontal,
                                                                                                        shrinkWrap: true,
                                                                                                        itemCount: 1,
                                                                                                        itemBuilder: (context, index2) {
                                                                                                          return Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                width: 35,
                                                                                                                child: listOfExpiredDoc!.item1![index].sharerByList!.profilePic == null
                                                                                                                    ? CircleAvatar(
                                                                                                                        radius: 40,
                                                                                                                        backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                                        child: Text(getUserFirstLetetrs(listOfExpiredDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                                      )
                                                                                                                    : CircleAvatar(
                                                                                                                        radius: 25,
                                                                                                                        backgroundImage: CachedNetworkImageProvider(imageUrl + listOfExpiredDoc!.item1![index].sharerByList!.profilePic.toString()),
                                                                                                                      ),
                                                                                                              )
                                                                                                            ],
                                                                                                          );
                                                                                                        })
                                                                                                  ],
                                                                                                )
                                                                                              : ListView.builder(
                                                                                                  scrollDirection: Axis.horizontal,
                                                                                                  shrinkWrap: true,
                                                                                                  itemCount: listOfExpiredDoc == null
                                                                                                      ? 0
                                                                                                      : listOfExpiredDoc!.item1![index].sharerList == null
                                                                                                          ? 0
                                                                                                          : listOfExpiredDoc!.item1![index].sharerList!.length,
                                                                                                  itemBuilder: (context, index2) {
                                                                                                    return Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          width: 40,
                                                                                                          child: CircleAvatar(
                                                                                                            radius: 50,
                                                                                                            backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                            child: Text(getUserFirstLetetrs(listOfExpiredDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
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
                                                                                          //     padding: const EdgeInsets.only(right: 15),
                                                                                          //     child: GestureDetector(
                                                                                          //         onTap: () {
                                                                                          //           Navigator.push(
                                                                                          //             context,
                                                                                          //             MaterialPageRoute(builder: (context) => DocumentData(docId: listOfExpiredDoc!.item1![index].id, indexTab: 2)),
                                                                                          //           );
                                                                                          //         },
                                                                                          //         child: Icon(Icons.share, color: Theme.of(context).colorScheme.warmGreyColor))),
                                                                                          // listOfExpiredDoc!.item1![index].isbookmark == true
                                                                                          //     ? GestureDetector(
                                                                                          //         onTap: () {
                                                                                          //           EasyLoading.addStatusCallback((status) {});
                                                                                          //           EasyLoading.show(status: 'loading...');
                                                                                          //           addBookmark(listOfExpiredDoc!.item1![index].id.toString(), false).then((response) {
                                                                                          //             if (response == "1") {
                                                                                          //               getExpiredDocDataTable().then((response) {
                                                                                          //                 setState(() {
                                                                                          //                   listOfExpiredDoc = response!;
                                                                                          //                 });
                                                                                          //               });
                                                                                          //             }
                                                                                          //             EasyLoading.dismiss();
                                                                                          //           });
                                                                                          //         },
                                                                                          //         child: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.warmGreyColor))
                                                                                          //     : GestureDetector(
                                                                                          //         onTap: () {
                                                                                          //           EasyLoading.addStatusCallback((status) {});
                                                                                          //           EasyLoading.show(status: 'loading...');
                                                                                          //           addBookmark(listOfExpiredDoc!.item1![index].id.toString(), true).then((response) {
                                                                                          //             if (response == "1") {
                                                                                          //               getExpiredDocDataTable().then((response) {
                                                                                          //                 setState(() {
                                                                                          //                   listOfExpiredDoc = response!;
                                                                                          //                 });
                                                                                          //               });
                                                                                          //             }
                                                                                          //             EasyLoading.dismiss();
                                                                                          //           });
                                                                                          //         },
                                                                                          //         child: Icon(Icons.bookmark_outline_sharp, color: Theme.of(context).colorScheme.warmGreyColor))
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  );
                                                                }),
                                                      ),
                                                      Container(
                                                        // color: const Color(0xff4FC2F8)
                                                        //     .withOpacity(0.1),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: listOfExpiringDoc ==
                                                                    null ||
                                                                listOfExpiringDoc!
                                                                        .item2 ==
                                                                    0
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No expiring document",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline6),
                                                              )
                                                            : ListView.builder(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            40),
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    listOfExpiringDoc!
                                                                        .item1!
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                DocumentData(docId: listOfExpiringDoc!.item1![index].id, indexTab: 0)),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                        height: 140,
                                                                        padding: const EdgeInsets.only(top: 4),
                                                                        margin: const EdgeInsets.only(top: 10),
                                                                        child: Container(
                                                                          height:
                                                                              140,
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              15,
                                                                              15,
                                                                              15),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: listOfExpiringDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiringDoc!.item1![index].isDocCreated == false
                                                                                ? Theme.of(context).colorScheme.sharerColor
                                                                                : Colors.white,
                                                                            border:
                                                                                Border.all(width: 0.5, color: Theme.of(context).colorScheme.whiteColor),
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            // boxShadow: [
                                                                            //   BoxShadow(
                                                                            //     color: Theme.of(context).colorScheme.expiringColor,
                                                                            //     blurRadius: 1.0,
                                                                            //     spreadRadius: 0.1,
                                                                            //     offset: const Offset(0, 2),
                                                                            //   )
                                                                            // ]
                                                                          ),
                                                                          // boxShadow: [
                                                                          //   BoxShadow(
                                                                          //     // color: Color(0xffFFF7F6),
                                                                          //     color: Theme.of(context).primaryColor,

                                                                          //     blurRadius: 1.0,
                                                                          //     spreadRadius: 0.1,
                                                                          //     offset: const Offset(0, 2),
                                                                          //   )
                                                                          // ]
                                                                          // // border:
                                                                          //     Border.all(),
                                                                          // boxShadow: [
                                                                          //   BoxShadow(
                                                                          //     color: Theme.of(context).primaryColor,
                                                                          //     blurRadius: 4.0,
                                                                          //     spreadRadius: 0.1,
                                                                          //     offset: const Offset(1, 1),
                                                                          //   )
                                                                          // ]
                                                                          // gradient:
                                                                          //     LinearGradient(
                                                                          //   begin: Alignment.bottomCenter,
                                                                          //   end: Alignment.topCenter,
                                                                          //   colors: [
                                                                          //     const Color(0xff4FC2F8).withOpacity(0.2),
                                                                          //     const Color(0xff4FC2F8).withOpacity(0.2),
                                                                          //   ],
                                                                          //   stops: const [
                                                                          //     0.1,
                                                                          //     0.2
                                                                          //   ],
                                                                          // ),
                                                                          // ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 26,
                                                                                    width: 64,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xffFFF8DD)),
                                                                                    child: const Center(
                                                                                      child: Text(
                                                                                        'Expiring',
                                                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffFFA621)),
                                                                                        // textAlign: Alignment.center,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  listOfExpiringDoc!.item1![index].isbookmark == true
                                                                                      ? GestureDetector(
                                                                                          onTap: () {
                                                                                            EasyLoading.addStatusCallback((status) {});
                                                                                            EasyLoading.show(status: 'loading...');
                                                                                            addBookmark(listOfExpiringDoc!.item1![index].id.toString(), false).then((response) {
                                                                                              if (response == "1") {
                                                                                                getExpiringDocDataTable().then((response) {
                                                                                                  setState(() {
                                                                                                    listOfExpiringDoc = response!;
                                                                                                  });
                                                                                                });
                                                                                              }
                                                                                              EasyLoading.dismiss();
                                                                                            });
                                                                                          },
                                                                                          child: const Icon(
                                                                                            Icons.bookmark,
                                                                                            color: Color(0xffD6D6E0),
                                                                                          ))
                                                                                      : GestureDetector(
                                                                                          onTap: () {
                                                                                            EasyLoading.addStatusCallback((status) {});
                                                                                            EasyLoading.show(status: 'loading...');
                                                                                            addBookmark(listOfExpiringDoc!.item1![index].id.toString(), true).then((response) {
                                                                                              if (response == "1") {
                                                                                                getExpiringDocDataTable().then((response) {
                                                                                                  setState(() {
                                                                                                    listOfExpiringDoc = response!;
                                                                                                  });
                                                                                                });
                                                                                              }
                                                                                              EasyLoading.dismiss();
                                                                                            });
                                                                                          },
                                                                                          child: const Icon(
                                                                                            Icons.bookmark_outline_sharp,
                                                                                            color: Color(0xffD6D6E0),
                                                                                          ),
                                                                                        ),
                                                                                ],
                                                                              ),

                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Container(
                                                                                margin: const EdgeInsets.only(bottom: 12),
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(listOfExpiringDoc!.item1![index].docName.length > 30 ? listOfExpiringDoc!.item1![index].docName.substring(0, 32) + " ..." : listOfExpiringDoc!.item1![index].docName, style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                    const SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    // Row(
                                                                                    //   children: [
                                                                                    //     Container(
                                                                                    //         padding: const EdgeInsets.only(right: 5),
                                                                                    //         child: GestureDetector(
                                                                                    //             onTap: () {
                                                                                    //               Navigator.push(
                                                                                    //                 context,
                                                                                    //                 MaterialPageRoute(builder: (context) => DocumentData(docId: listOfExpiringDoc!.item1![index].id, indexTab: 2)),
                                                                                    //               );
                                                                                    //             },
                                                                                    //             child: Icon(Icons.share, size: 20, color: Theme.of(context).primaryColor))),
                                                                                    //     listOfExpiringDoc!.item1![index].remindMe == false
                                                                                    //         ? Container(
                                                                                    //             padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                                                                                    //             child: Icon(
                                                                                    //               Icons.notifications_off_outlined,
                                                                                    //               color: Theme.of(context).primaryColor,
                                                                                    //               size: 20,
                                                                                    //             ),
                                                                                    //           )
                                                                                    //         : Container(),
                                                                                    //   ],
                                                                                    // ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              // Row(
                                                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              //   children: [
                                                                              //     Container(
                                                                              //       padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                                              //       decoration: BoxDecoration(
                                                                              //         color: Theme.of(context).colorScheme.expiringColor,
                                                                              //         borderRadius: BorderRadius.circular(15),
                                                                              //       ),
                                                                              //       child: Row(
                                                                              //         children: [
                                                                              //           Padding(
                                                                              //             padding: const EdgeInsets.only(right: 5),
                                                                              //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                                                              //             child: Image.asset("assets/Icons/v_expiring.png"),
                                                                              //           ),
                                                                              //           Text(
                                                                              //             getDateFormate(listOfExpiringDoc!.item1![index].expiryDate),
                                                                              //             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                                                                              //           ),
                                                                              //         ],
                                                                              //       ),
                                                                              //     ),
                                                                              //     RichText(
                                                                              //         text: TextSpan(children: [
                                                                              //       const TextSpan(text: "Expiring in ", style: CustomTextStyle.simple12Text),
                                                                              //       TextSpan(text: listOfExpiringDoc!.item1![index].diffTotalDays > 9 ? listOfExpiringDoc!.item1![index].diffTotalDays.toString() : "0" + listOfExpiringDoc!.item1![index].diffTotalDays.toString(), style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w700)),
                                                                              //       listOfExpiringDoc!.item1![index].diffTotalDays > 1
                                                                              //           ? const TextSpan(
                                                                              //               text: " days",
                                                                              //               style: CustomTextStyle.simple12Text,
                                                                              //             )
                                                                              //           : const TextSpan(
                                                                              //               text: " day",
                                                                              //               style: CustomTextStyle.simple12Text,
                                                                              //             ),
                                                                              //     ])),
                                                                              //   ],
                                                                              // ),
                                                                              // Container(
                                                                              //   margin: const EdgeInsets.only(top: 10),
                                                                              //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                              //   // decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color.fromARGB(255, 145, 19, 19), width: 0.7), bottom: BorderSide(color: Colors.grey, width: 0.7))),
                                                                              //   child: Row(
                                                                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              //     children: [
                                                                              //       // Container(
                                                                              //       //     padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
                                                                              //       //     decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                                                                              //       //     width: 150,
                                                                              //       //     child: Row(
                                                                              //       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              //       //       children: [
                                                                              //       //         Text(
                                                                              //       //           listOfExpiringDoc!.item1![index].docUserStatusId == 1
                                                                              //       //               ? "Pending Renewal"
                                                                              //       //               : listOfExpiringDoc!.item1![index].docUserStatusId == 2
                                                                              //       //                   ? "Renewal In-Progress"
                                                                              //       //                   : "Renewed",
                                                                              //       //           style: const TextStyle(fontSize: 12, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600),
                                                                              //       //         ),
                                                                              //       //         const Icon(
                                                                              //       //           Icons.keyboard_arrow_down,
                                                                              //       //           color: Color(0xFFFFFFFF),
                                                                              //       //         ),
                                                                              //       //       ],
                                                                              //       //     )),
                                                                              //       Row(
                                                                              //         children: [
                                                                              //           listOfExpiringDoc!.item1![index].isbookmark == true
                                                                              //               ? GestureDetector(
                                                                              //                   onTap: () {
                                                                              //                     EasyLoading.addStatusCallback((status) {});
                                                                              //                     EasyLoading.show(status: 'loading...');
                                                                              //                     addBookmark(listOfExpiringDoc!.item1![index].id.toString(), false).then((response) {
                                                                              //                       if (response == "1") {
                                                                              //                         getExpiringDocDataTable().then((response) {
                                                                              //                           setState(() {
                                                                              //                             listOfExpiringDoc = response!;
                                                                              //                           });
                                                                              //                         });
                                                                              //                       }
                                                                              //                       EasyLoading.dismiss();
                                                                              //                     });
                                                                              //                   },
                                                                              //                   child: const Icon(Icons.bookmark, color: Colors.yellow))
                                                                              //               : GestureDetector(
                                                                              //                   onTap: () {
                                                                              //                     EasyLoading.addStatusCallback((status) {});
                                                                              //                     EasyLoading.show(status: 'loading...');
                                                                              //                     addBookmark(listOfExpiringDoc!.item1![index].id.toString(), true).then((response) {
                                                                              //                       if (response == "1") {
                                                                              //                         getExpiringDocDataTable().then((response) {
                                                                              //                           setState(() {
                                                                              //                             listOfExpiringDoc = response!;
                                                                              //                           });
                                                                              //                         });
                                                                              //                       }
                                                                              //                       EasyLoading.dismiss();
                                                                              //                     });
                                                                              //                   },
                                                                              //                   child: Icon(Icons.bookmark_outline_sharp, color: Theme.of(context).colorScheme.blackColor),
                                                                              //                 ),
                                                                              //           listOfExpiringDoc!.item1![index].attachmentCount > 1
                                                                              //               ? Container(
                                                                              //                   padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
                                                                              //                   child: Icon(
                                                                              //                     Icons.attach_file,
                                                                              //                     color: Theme.of(context).primaryColor,
                                                                              //                     size: 20,
                                                                              //                   ),
                                                                              //                 )
                                                                              //               : Container()
                                                                              //         ],
                                                                              //       )
                                                                              //     ],
                                                                              //   ),
                                                                              // ),
                                                                              Row(
                                                                                children: [
                                                                                  Row(
                                                                                    children: const [
                                                                                      Icon(
                                                                                        Icons.folder_open_rounded,
                                                                                        color: Color(0xffD6D6E0),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 8,
                                                                                      ),
                                                                                      Text(
                                                                                        'Family Docs',
                                                                                        style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: Color(0xffB5B5C3),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  Text(
                                                                                    getDateFormate(listOfExpiringDoc!.item1![index].expiryDate),
                                                                                    style: const TextStyle(color: Color(0xffFFA621), fontWeight: FontWeight.w600, fontSize: 12),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Expanded(
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        listOfExpiringDoc!.item1![index].docSharingUserId.isNotEmpty && listOfExpiringDoc!.item1![index].isDocCreated == false
                                                                                            ? Row(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(right: 5),
                                                                                                    child: Icon(
                                                                                                      FontAwesomeIcons.userGroup,
                                                                                                      color: Theme.of(context).colorScheme.sharerIconColor,
                                                                                                      size: 12,
                                                                                                    ),
                                                                                                  ),
                                                                                                  ListView.builder(
                                                                                                      scrollDirection: Axis.horizontal,
                                                                                                      shrinkWrap: true,
                                                                                                      itemCount: 1,
                                                                                                      itemBuilder: (context, index2) {
                                                                                                        return Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              width: 35,
                                                                                                              child: listOfExpiringDoc!.item1![index].sharerByList!.profilePic == null
                                                                                                                  ? CircleAvatar(
                                                                                                                      radius: 40,
                                                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                                      child: Text(getUserFirstLetetrs(listOfExpiringDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                                    )
                                                                                                                  : CircleAvatar(
                                                                                                                      radius: 25,
                                                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfExpiringDoc!.item1![index].sharerByList!.profilePic.toString()),
                                                                                                                    ),
                                                                                                            )
                                                                                                          ],
                                                                                                        );
                                                                                                      })
                                                                                                ],
                                                                                              )
                                                                                            : ListView.builder(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                shrinkWrap: true,
                                                                                                itemCount: listOfExpiringDoc == null
                                                                                                    ? 0
                                                                                                    : listOfExpiringDoc!.item1![index].sharerList == null
                                                                                                        ? 0
                                                                                                        : listOfExpiringDoc!.item1![index].sharerList!.length,
                                                                                                itemBuilder: (context, index2) {
                                                                                                  return Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        width: 40,
                                                                                                        child: CircleAvatar(
                                                                                                          radius: 50,
                                                                                                          backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                          child: Text(getUserFirstLetetrs(listOfExpiringDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  );
                                                                                                }),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: const [],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  );
                                                                },
                                                              ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: listOfActiveDoc ==
                                                                    null ||
                                                                listOfActiveDoc!
                                                                        .item2 ==
                                                                    0
                                                            ? Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    "No active document",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline6),
                                                              )
                                                            : ListView.builder(
                                                                primary: false,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    listOfActiveDoc!
                                                                        .item1!
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                DocumentData(docId: listOfActiveDoc!.item1![index].id, indexTab: 0)),
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                        height: 140,
                                                                        padding: const EdgeInsets.only(top: 4),
                                                                        margin: const EdgeInsets.all(10),
                                                                        // decoration:
                                                                        //     BoxDecoration(
                                                                        //   color: Theme.of(context)
                                                                        //       .colorScheme
                                                                        //       .activeColor,
                                                                        //   borderRadius:
                                                                        //       BorderRadius.circular(6),
                                                                        // ),
                                                                        child: Container(
                                                                          height:
                                                                              140,
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              15,
                                                                              15,
                                                                              15),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: listOfActiveDoc!.item1![index].docSharingUserId.isNotEmpty && listOfActiveDoc!.item1![index].isDocCreated == false
                                                                                ? Theme.of(context).colorScheme.sharerColor
                                                                                : Colors.white,
                                                                            border:
                                                                                Border.all(width: 0.5, color: Theme.of(context).colorScheme.whiteColor),
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 26,
                                                                                    width: 64,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xffE8FFF3)),
                                                                                    child: const Center(
                                                                                      child: Text(
                                                                                        'Active',
                                                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff50CD89)),
                                                                                        // textAlign: Alignment.center,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  listOfActiveDoc!.item1![index].isbookmark == true
                                                                                      ? GestureDetector(
                                                                                          onTap: () {
                                                                                            EasyLoading.addStatusCallback((status) {});
                                                                                            EasyLoading.show(status: 'loading...');
                                                                                            addBookmark(listOfActiveDoc!.item1![index].id.toString(), false).then((response) {
                                                                                              if (response == "1") {
                                                                                                getActiveDocDataTable().then((response) {
                                                                                                  setState(() {
                                                                                                    listOfActiveDoc = response!;
                                                                                                  });
                                                                                                });
                                                                                              }
                                                                                              EasyLoading.dismiss();
                                                                                            });
                                                                                          },
                                                                                          child: const Icon(
                                                                                            Icons.bookmark,
                                                                                            color: const Color(0xffD6D6E0),
                                                                                          ))
                                                                                      : GestureDetector(
                                                                                          onTap: () {
                                                                                            EasyLoading.addStatusCallback((status) {});
                                                                                            EasyLoading.show(status: 'loading...');
                                                                                            addBookmark(listOfActiveDoc!.item1![index].id.toString(), true).then((response) {
                                                                                              if (response == "1") {
                                                                                                getActiveDocDataTable().then((response) {
                                                                                                  setState(() {
                                                                                                    listOfActiveDoc = response!;
                                                                                                  });
                                                                                                });
                                                                                              }
                                                                                              EasyLoading.dismiss();
                                                                                            });
                                                                                          },
                                                                                          child: const Icon(
                                                                                            Icons.bookmark_outline_sharp,
                                                                                            color: const Color(0xffD6D6E0),
                                                                                          )),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Text(
                                                                                listOfActiveDoc!.item1![index].docName.length > 30 ? listOfActiveDoc!.item1![index].docName.substring(0, 32) + " ..." : listOfActiveDoc!.item1![index].docName,
                                                                                style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                                                                    // decoration: BoxDecoration(
                                                                                    //   color: Theme.of(context).colorScheme.activeColor,
                                                                                    //   borderRadius: BorderRadius.circular(15),
                                                                                    // ),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Row(
                                                                                          children: const [
                                                                                            Icon(
                                                                                              Icons.folder_open_rounded,
                                                                                              color: Color(0xffD6D6E0),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 8,
                                                                                            ),
                                                                                            Text(
                                                                                              'House Lease',
                                                                                              style: TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Color(0xffB5B5C3),
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
                                                                                          getDateFormate(listOfActiveDoc!.item1![index].expiryDate),
                                                                                          style: const TextStyle(color: Color(0xff0BB783), fontWeight: FontWeight.w600, fontSize: 12),
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
                                                                              // Container(
                                                                              //   margin: const EdgeInsets.only(top: 10),
                                                                              //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                              //   // decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.7), bottom: BorderSide(color: Colors.grey, width: 0.7))),
                                                                              //   child: Row(
                                                                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              //     children: [
                                                                              //       Container(
                                                                              //         padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
                                                                              //         width: 150,
                                                                              //         child: const Text(
                                                                              //           "No action required",
                                                                              //           style: TextStyle(fontSize: 12, color: Color(0xFF323232), fontWeight: FontWeight.w600),
                                                                              //         ),
                                                                              //       ),
                                                                              //       Row(
                                                                              //         children: [
                                                                              //           listOfActiveDoc!.item1![index].attachmentCount > 1
                                                                              //               ? Container(
                                                                              //                   padding: const EdgeInsets.fromLTRB(0, 2, 8, 2),
                                                                              //                   child: Icon(
                                                                              //                     Icons.attach_file,
                                                                              //                     color: Theme.of(context).primaryColor,
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
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        listOfActiveDoc!.item1![index].docSharingUserId.isNotEmpty && listOfActiveDoc!.item1![index].isDocCreated == false
                                                                                            ? Row(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(right: 5),
                                                                                                    child: Icon(
                                                                                                      FontAwesomeIcons.userGroup,
                                                                                                      color: Theme.of(context).colorScheme.sharerIconColor,
                                                                                                      size: 12,
                                                                                                    ),
                                                                                                  ),
                                                                                                  ListView.builder(
                                                                                                      scrollDirection: Axis.horizontal,
                                                                                                      shrinkWrap: true,
                                                                                                      itemCount: 1,
                                                                                                      itemBuilder: (context, index2) {
                                                                                                        return Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              width: 35,
                                                                                                              child: listOfActiveDoc!.item1![index].sharerByList!.profilePic == null
                                                                                                                  ? CircleAvatar(
                                                                                                                      radius: 40,
                                                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                                      child: Text(getUserFirstLetetrs(listOfActiveDoc!.item1![index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                                    )
                                                                                                                  : CircleAvatar(
                                                                                                                      radius: 25,
                                                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfActiveDoc!.item1![index].sharerByList!.profilePic.toString()),
                                                                                                                    ),
                                                                                                            )
                                                                                                          ],
                                                                                                        );
                                                                                                      })
                                                                                                ],
                                                                                              )
                                                                                            : ListView.builder(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                shrinkWrap: true,
                                                                                                itemCount: listOfActiveDoc == null
                                                                                                    ? 0
                                                                                                    : listOfActiveDoc!.item1![index].sharerList == null
                                                                                                        ? 0
                                                                                                        : listOfActiveDoc!.item1![index].sharerList!.length,
                                                                                                itemBuilder: (context, index2) {
                                                                                                  return Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        width: 40,
                                                                                                        child: CircleAvatar(
                                                                                                          radius: 50,
                                                                                                          backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                          child: Text(getUserFirstLetetrs(listOfActiveDoc!.item1![index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  );
                                                                                                }),
                                                                                      ],
                                                                                    ),
                                                                                    Row(
                                                                                      children: const [],
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
                                                    ]))
                                          ])),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ))),
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
      bottomNavigationBar: const NavigationBottom(
        selectedIndex: 0,
      ),
    );
  }
}
