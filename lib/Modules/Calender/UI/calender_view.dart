import 'dart:io';

import 'package:Xpiree/Modules/Dashboard/UI/Drawer.dart';
import 'package:Xpiree/Modules/Dashboard/UI/NavigationBottom.dart';
import 'package:Xpiree/Modules/Dashboard/UI/notification.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Modules/Document/UI/document_detail.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Xpiree/Modules/Calender/Utils/calenderDataHelper.dart';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  CalenderViewState createState() => CalenderViewState();
}

class CalenderViewState extends State<CalenderView> {
  Map<DateTime, List<Document>?> selectedEvents = {
    /*   DateTime.utc(2022, 08, 27): [],
     DateTime.utc(2022, 08, 29): [],    */
  };
  List<Document> listOfDoc = [];
  List<Document> listOfDocSelected = [];

  late String xpiredCountStr = "00";
  late String xpiringCountStr = "00";
  late String activeCountStr = "00";
  late String pendigTaskStr = "00";

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now().add(const Duration(days: 2));
  DateTime currentDay = DateTime.now();
  DashboardCountVm _counts = DashboardCountVm();
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //EasyLoading.show(status: 'loading...');
    getDocumentByMonth(
            selectedDay.month.toString(), selectedDay.year.toString())
        .then((response) {
      setState(() {
        listOfDoc = response!;
        listOfDocSelected = response;

        for (int i = 0; i < listOfDoc.length; i++) {
          DateTime expireeDoc = DateTime.parse(response[i].expiryDate + 'Z');

          if (selectedEvents[expireeDoc] == null) {
            selectedEvents[expireeDoc] = [response[i]];
          } else {
            // ignore: iterable_contains_unrelated_type
            if (!selectedEvents.values.contains(response[i]) &&
                !selectedEvents.keys.contains(expireeDoc)) {
              selectedEvents[expireeDoc]!.add(response[i]);
            }
          }
        }
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

          EasyLoading.dismiss();
        });
        /*  listOfDoc=response!;
               for(int i=0;i<response.length;i++)
               {

                DateTime  expireeDoc=  DateTime.parse(response[i].expiryDate + 'Z');
                 // selectedEvents[expireeDoc]=[response[i]];
                selectedEvents[expireeDoc]!.add(response[i]);

               } */
      });
      //   EasyLoading.dismiss();
    });
  }

  List<Document> _getDocumentsfromDay(DateTime date) {
    /*   if(date!=null)
    {
        setState(() {
          listOfDocSelected=selectedEvents[date] ?? [];
        }); 

    }
   */
    return selectedEvents[date] ?? [];
  }

  List<Document> _getDocByDay(DateTime date) {
    if (date != null) {
      setState(() {
        listOfDocSelected = selectedEvents[date] ?? [];
      });
    }
    return listOfDocSelected;
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const MenuDrawer(),
      backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
      // appBar: AppBar(
      //     backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
      //     centerTitle: true,
      //     leadingWidth: 0,
      //     elevation: 0.0,
      //     title: Text("Calender View",
      //         textAlign: TextAlign.left,
      //         style: CustomTextStyle.topHeading.copyWith(
      //           color: Theme.of(context).primaryColor,
      //         ))),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return await confirmExitApp(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
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
                            onTap: () {
                              SessionMangement _sm = SessionMangement();
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
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, right: 24, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calendar',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'All your documents along with their current status',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              // clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(xpiredCountStr,
                                            style: CustomTextStyle.simpleText
                                                .copyWith(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w900,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .expiredColor)),
                                        Text("Expired this month",
                                            style: CustomTextStyle.simpleText
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              // clipBehavior: Clip.none,
                              children: [
                                // Your existing container
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  // margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .whiteColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(xpiringCountStr,
                                            style: CustomTextStyle.simpleText
                                                .copyWith(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w900,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .expiringColor)),
                                        Text(
                                          "Expiring this month",
                                          style: CustomTextStyle.simpleText
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onPageChanged: (date) {
                      getDocumentByMonth(
                              date.month.toString(), date.year.toString())
                          .then((response) {
                        setState(() {
                          listOfDoc = response!;
                          listOfDocSelected = response;
                          selectedDay = date;

                          for (int i = 0; i < listOfDoc.length; i++) {
                            DateTime expireeDoc =
                                DateTime.parse(response[i].expiryDate + 'Z');

                            if (selectedEvents[expireeDoc] == null) {
                              selectedEvents[expireeDoc] = [response[i]];
                            } else {
                              // ignore: iterable_contains_unrelated_type
                              if (!selectedEvents.values
                                      .contains(response[i]) &&
                                  !selectedEvents.keys.contains(expireeDoc)) {
                                selectedEvents[expireeDoc]!.add(response[i]);
                              }
                            }
                          }
                        });
                      });
                    },
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color: Theme.of(context).colorScheme.labelColor,
                          fontSize: 14),
                      weekendStyle: TextStyle(
                          color: Theme.of(context).colorScheme.labelColor,
                          fontSize: 14),
                    ),

                    //Day Changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;

                        // _getDocByDay(selectDay);
                      });
                      showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.dashboardbackGround,
                        // shape: const RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.only(
                        //   topRight: Radius.circular(20),
                        //   topLeft: Radius.circular(20),
                        // )),
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {
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
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: listOfDocSelected.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return listOfDocSelected[index]
                                                    .status ==
                                                1
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DocumentData(
                                                                docId:
                                                                    listOfDocSelected[
                                                                            index]
                                                                        .id,
                                                                indexTab: 0)),
                                                  );
                                                },
                                                child: Container(
                                                    height: 140,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                      //   color:
                                                      //       Theme.of(context).colorScheme.activeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Container(
                                                      height: 160,
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 15, 15),
                                                      decoration: BoxDecoration(
                                                        color: listOfDocSelected[
                                                                        index]
                                                                    .docSharingUserId
                                                                    .isNotEmpty &&
                                                                listOfDocSelected[
                                                                            index]
                                                                        .isDocCreated ==
                                                                    false
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .sharerColor
                                                            : Colors.white,
                                                        // border: Border.all(
                                                        //     width: 0.5,
                                                        //     color: Theme.of(context)
                                                        //         .colorScheme
                                                        //         .tabBorderColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color: Theme.of(context)
                                                        //         .colorScheme
                                                        //         .iconThemeGray,
                                                        //     blurRadius: 15.0,
                                                        //     spreadRadius: 0.1,
                                                        //     offset: const Offset(4, 8),
                                                        //   )
                                                        // ]
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 26,
                                                            width: 64,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                color: const Color(
                                                                    0xffE8FFF3)),
                                                            child: const Center(
                                                              child: Text(
                                                                'Active',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color(
                                                                        0xff50CD89)),
                                                                // textAlign: Alignment.center,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 12),
                                                            child: Text(
                                                                listOfDocSelected[index]
                                                                            .docName
                                                                            .length >
                                                                        30
                                                                    ? listOfDocSelected[index]
                                                                            .docName
                                                                            .substring(0,
                                                                                32) +
                                                                        " ..."
                                                                    : listOfDocSelected[
                                                                            index]
                                                                        .docName,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline5!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        8,
                                                                        2,
                                                                        8,
                                                                        2),
                                                                // decoration: BoxDecoration(
                                                                //   color: Theme.of(context)
                                                                //       .colorScheme
                                                                //       .activeColor,
                                                                //   borderRadius:
                                                                //       BorderRadius.circular(15),
                                                                // ),
                                                                child: Row(
                                                                  children: [
                                                                    Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .folder_open_rounded,
                                                                          color:
                                                                              Color(0xffD6D6E0),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          'Business',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
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
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(
                                                                    //       right: 5),
                                                                    //   // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                                                                    //   child: Image.asset(
                                                                    //       "assets/Icons/v_active.png"),
                                                                    // ),
                                                                    Text(
                                                                      getDateFormate(
                                                                          listOfDocSelected[index]
                                                                              .expiryDate),
                                                                      style: const TextStyle(
                                                                          color: Color(
                                                                              0xff0BB783),
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // const Text(
                                                              //   "Acve",
                                                              //   style: CustomTextStyle.simple12Text,
                                                              // )
                                                            ],
                                                          ),
                                                          // Container(
                                                          //   margin: const EdgeInsets.only(top: 10),
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
                                                          //         MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       Container(
                                                          //         padding: const EdgeInsets.fromLTRB(
                                                          //             8, 3, 5, 3),
                                                          //         width: 150,
                                                          //         child: const Text(
                                                          //           "No action required",
                                                          //           style: TextStyle(
                                                          //               fontSize: 12,
                                                          //               color: Color(0xFF323232),
                                                          //               fontWeight: FontWeight.w600),
                                                          //         ),
                                                          //       ),
                                                          //       Row(
                                                          //         children: [
                                                          //           listOfDocSelected[index]
                                                          //                       .remindMe ==
                                                          //                   false
                                                          //               ? Container(
                                                          //                   padding: const EdgeInsets
                                                          //                       .fromLTRB(8, 2, 2, 2),
                                                          //                   child: Icon(
                                                          //                     Icons
                                                          //                         .notifications_off_outlined,
                                                          //                     color: Theme.of(context)
                                                          //                         .primaryColor,
                                                          //                     size: 20,
                                                          //                   ),
                                                          //                 )
                                                          //               : Container(),
                                                          //           listOfDocSelected[index]
                                                          //                       .attachmentCount >
                                                          //                   1
                                                          //               ? Container(
                                                          //                   padding: const EdgeInsets
                                                          //                       .fromLTRB(0, 2, 8, 2),
                                                          //                   child: Icon(
                                                          //                     Icons.attach_file,
                                                          //                     color: Theme.of(context)
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
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    listOfDocSelected[index].docSharingUserId.isNotEmpty &&
                                                                            listOfDocSelected[index].isDocCreated ==
                                                                                false
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
                                                                                          child: listOfDocSelected[index].sharerByList!.profilePic == null
                                                                                              ? CircleAvatar(
                                                                                                  radius: 40,
                                                                                                  backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                  child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                )
                                                                                              : CircleAvatar(
                                                                                                  radius: 25,
                                                                                                  backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
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
                                                                            itemCount: listOfDocSelected.isEmpty
                                                                                ? 0
                                                                                : listOfDocSelected[index].sharerList == null
                                                                                    ? 0
                                                                                    : listOfDocSelected[index].sharerList!.length,
                                                                            itemBuilder: (context, index2) {
                                                                              return Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 40,
                                                                                    child: CircleAvatar(
                                                                                      radius: 50,
                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                      child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              );
                                                                            }),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            : listOfDocSelected[index].status ==
                                                    2
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocumentData(
                                                                    docId: listOfDocSelected[
                                                                            index]
                                                                        .id,
                                                                    indexTab:
                                                                        0)),
                                                      );
                                                    },
                                                    child: Container(
                                                        height: 142,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Theme.of(context)
                                                          //     .colorScheme
                                                          //     .expiringColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Container(
                                                          height: 140,
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15,
                                                                  15,
                                                                  15,
                                                                  15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: listOfDocSelected[
                                                                            index]
                                                                        .docSharingUserId
                                                                        .isNotEmpty &&
                                                                    listOfDocSelected[index]
                                                                            .isDocCreated ==
                                                                        false
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .sharerColor
                                                                : Colors.white,
                                                            // border: Border.all(
                                                            //     width: 0.5,
                                                            //     color: Theme.of(context)
                                                            //         .colorScheme
                                                            //         .tabBorderColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            // boxShadow: [
                                                            //   BoxShadow(
                                                            //     color: Theme.of(context)
                                                            //         .colorScheme
                                                            //         .iconThemeGray,
                                                            //     blurRadius: 15.0,
                                                            //     spreadRadius: 0.1,
                                                            //     offset: const Offset(4, 8),
                                                            //   )
                                                            // ]
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: 26,
                                                                    width: 64,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        color: const Color(
                                                                            0xffFFF8DD)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        'Expiring',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Color(0xffFFA621)),
                                                                        // textAlign: Alignment.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .bookmark_outline_sharp,
                                                                    color: Color(
                                                                        0xffD6D6E0),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            12),
                                                                child: Text(
                                                                    listOfDocSelected[index].docName.length >
                                                                            30
                                                                        ? listOfDocSelected[index].docName.substring(0, 32) +
                                                                            " ..."
                                                                        : listOfDocSelected[index]
                                                                            .docName,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                                              //             .expiringColor,
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
                                                              //                 "assets/Icons/v_expiring.png"),
                                                              //           ),
                                                              //           // Text(
                                                              //           //   getDateFormate(
                                                              //           //       listOfDocSelected[index]
                                                              //           //           .expiryDate),
                                                              //           //   style: const TextStyle(
                                                              //           //       color: Colors.white,
                                                              //           //       fontWeight:
                                                              //           //           FontWeight.w600,
                                                              //           //       fontSize: 12),
                                                              //           // ),
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
                                                              //           text: listOfDocSelected[index]
                                                              //                       .diffTotalDays >
                                                              //                   9
                                                              //               ? listOfDocSelected[index]
                                                              //                   .diffTotalDays
                                                              //                   .toString()
                                                              //               : "0" +
                                                              //                   listOfDocSelected[
                                                              //                           index]
                                                              //                       .diffTotalDays
                                                              //                       .toString(),
                                                              //           style: TextStyle(
                                                              //               color: Theme.of(context)
                                                              //                   .colorScheme
                                                              //                   .blackColor,
                                                              //               fontWeight:
                                                              //                   FontWeight.w700)),
                                                              //       listOfDocSelected[index]
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
                                                              //         MainAxisAlignment.spaceBetween,
                                                              //     children: [
                                                              //       Container(
                                                              //           padding:
                                                              //               const EdgeInsets.fromLTRB(
                                                              //                   10, 3, 5, 3),
                                                              //           decoration: BoxDecoration(
                                                              //               color: Theme.of(context)
                                                              //                   .colorScheme
                                                              //                   .iconBackColor,
                                                              //               borderRadius:
                                                              //                   BorderRadius.circular(
                                                              //                       15)),
                                                              //           width: 150,
                                                              //           child: Row(
                                                              //             mainAxisAlignment:
                                                              //                 MainAxisAlignment
                                                              //                     .spaceBetween,
                                                              //             children: [
                                                              //               Text(
                                                              //                 listOfDocSelected[index]
                                                              //                             .docUserStatusId ==
                                                              //                         1
                                                              //                     ? "Pending wal"
                                                              //                     : listOfDocSelected[
                                                              //                                     index]
                                                              //                                 .docUserStatusId ==
                                                              //                             2
                                                              //                         ? "Renewal In-Press"
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
                                                              //                 color:
                                                              //                     Color(0xFF323232),
                                                              //               ),
                                                              //             ],
                                                              //           )),
                                                              //       Row(
                                                              //         children: [
                                                              //           listOfDocSelected[index]
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
                                                              //           listOfDocSelected[index]
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

                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .folder_open_rounded,
                                                                        color: Color(
                                                                            0xffD6D6E0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        'Family Docs',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
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
                                                                        listOfDocSelected[index]
                                                                            .expiryDate),
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xffFFA621),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        listOfDocSelected[index].docSharingUserId.isNotEmpty &&
                                                                                listOfDocSelected[index].isDocCreated == false
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
                                                                                              child: listOfDocSelected[index].sharerByList!.profilePic == null
                                                                                                  ? CircleAvatar(
                                                                                                      radius: 40,
                                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                      child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                    )
                                                                                                  : CircleAvatar(
                                                                                                      radius: 25,
                                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
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
                                                                                itemCount: listOfDocSelected.isEmpty
                                                                                    ? 0
                                                                                    : listOfDocSelected[index].sharerList == null
                                                                                        ? 0
                                                                                        : listOfDocSelected[index].sharerList!.length,
                                                                                itemBuilder: (context, index2) {
                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 40,
                                                                                        child: CircleAvatar(
                                                                                          radius: 50,
                                                                                          backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                          child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                }),
                                                                      ],
                                                                    ),
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
                                                            builder: (context) =>
                                                                DocumentData(
                                                                    docId: listOfDocSelected[
                                                                            index]
                                                                        .id,
                                                                    indexTab:
                                                                        0)),
                                                      );
                                                    },
                                                    child: Container(
                                                        height: 142,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Theme.of(context)
                                                          //     .colorScheme
                                                          //     .expiredColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Container(
                                                          height: 140,
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15,
                                                                  15,
                                                                  15,
                                                                  15),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: listOfDocSelected[
                                                                            index]
                                                                        .docSharingUserId
                                                                        .isNotEmpty &&
                                                                    listOfDocSelected[index]
                                                                            .isDocCreated ==
                                                                        false
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .sharerColor
                                                                : Colors.white,
                                                            // border: Border.all(
                                                            //     width: 0.5,
                                                            //     color: Theme.of(context)
                                                            //         .colorScheme
                                                            //         .tabBorderColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            // boxShadow: [
                                                            // BoxShadow(
                                                            //   color: Theme.of(context)
                                                            //       .colorScheme
                                                            //       .iconThemeGray,
                                                            //   blurRadius: 15.0,
                                                            //   spreadRadius: 0.1,
                                                            //   offset: const Offset(4, 8),
                                                            // )
                                                            // ]
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    height: 26,
                                                                    width: 64,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                6),
                                                                        color: const Color(
                                                                            0xffFFF5F8)),
                                                                    child:
                                                                        const Center(
                                                                      child:
                                                                          Text(
                                                                        'Expired',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Color(0xffF1416C)),
                                                                        // textAlign: Alignment.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .bookmark_outline_sharp,
                                                                    color: Color(
                                                                        0xffD6D6E0),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            12),
                                                                child: Text(
                                                                    listOfDocSelected[index].docName.length >
                                                                            30
                                                                        ? listOfDocSelected[index].docName.substring(0, 32) +
                                                                            " ..."
                                                                        : listOfDocSelected[index]
                                                                            .docName,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                                              //             .expiredColor,
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
                                                              //                 "assets/Icons/v_expired.png"),
                                                              //           ),
                                                              //           Text(
                                                              //             getDateFormate(
                                                              //                 listOfDocSelected[index]
                                                              //                     .expiryDate),
                                                              //             style: const TextStyle(
                                                              //                 color: Colors.white,
                                                              //                 fontWeight:
                                                              //                     FontWeight.w600,
                                                              //                 fontSize: 12),
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
                                                              //           text: listOfDocSelected[index]
                                                              //                       .diffTotalDays
                                                              //                       .abs() >
                                                              //                   9
                                                              //               ? listOfDocSelected[index]
                                                              //                   .diffTotalDays
                                                              //                   .toString()
                                                              //                   .replaceAll(
                                                              //                       RegExp('-'), '')
                                                              //               : "0" +
                                                              //                   listOfDocSelected[
                                                              //                           index]
                                                              //                       .diffTotalDays
                                                              //                       .toString()
                                                              //                       .replaceAll(
                                                              //                           RegExp('-'),
                                                              //                           ''),
                                                              //           style: TextStyle(
                                                              //               color: Theme.of(context)
                                                              //                   .colorScheme
                                                              //                   .blackColor,
                                                              //               fontWeight:
                                                              //                   FontWeight.w700)),
                                                              //       listOfDocSelected[index]
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
                                                              //         MainAxisAlignment.spaceBetween,
                                                              //     children: [
                                                              //       Container(
                                                              //           padding:
                                                              //               const EdgeInsets.fromLTRB(
                                                              //                   10, 3, 5, 3),
                                                              //           decoration: BoxDecoration(
                                                              //               color: Theme.of(context)
                                                              //                   .colorScheme
                                                              //                   .iconBackColor,
                                                              //               borderRadius:
                                                              //                   BorderRadius.circular(
                                                              //                       15)),
                                                              //           width: 150,
                                                              //           child: Row(
                                                              //             mainAxisAlignment:
                                                              //                 MainAxisAlignment
                                                              //                     .spaceBetween,
                                                              //             children: [
                                                              //               Text(
                                                              //                 listOfDocSelected[index]
                                                              //                             .docUserStatusId ==
                                                              //                         1
                                                              //                     ? "Pending Renewal"
                                                              //                     : listOfDocSelected[
                                                              //                                     index]
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
                                                              //                 color:
                                                              //                     Color(0xFF323232),
                                                              //               ),
                                                              //             ],
                                                              //           )),
                                                              //       Row(
                                                              //         children: [
                                                              //           listOfDocSelected[index]
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
                                                              //           listOfDocSelected[index]
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
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .folder_open_rounded,
                                                                        color: Color(
                                                                            0xffD6D6E0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      Text(
                                                                        'Family Docs',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
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
                                                                        listOfDocSelected[index]
                                                                            .expiryDate),
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xffF1416C),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        listOfDocSelected[index].docSharingUserId.isNotEmpty &&
                                                                                listOfDocSelected[index].isDocCreated == false
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
                                                                                              child: listOfDocSelected[index].sharerByList!.profilePic == null
                                                                                                  ? CircleAvatar(
                                                                                                      radius: 40,
                                                                                                      backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                                      child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                                                                                                    )
                                                                                                  : CircleAvatar(
                                                                                                      radius: 25,
                                                                                                      backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
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
                                                                                itemCount: listOfDocSelected.isEmpty
                                                                                    ? 0
                                                                                    : listOfDocSelected[index].sharerList == null
                                                                                        ? 0
                                                                                        : listOfDocSelected[index].sharerList!.length,
                                                                                itemBuilder: (context, index2) {
                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 40,
                                                                                        child: CircleAvatar(
                                                                                          radius: 50,
                                                                                          backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                                                                                          child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerList![index2].name), style: const TextStyle(fontSize: 14)),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                }),
                                                                      ],
                                                                    ),
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
                                ],
                              ),
                            );
                          });
                        },
                      );
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(currentDay, date);
                    },

                    eventLoader: _getDocumentsfromDay,

                    //To style the Calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: false,
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,

                        // borderRadius: BorderRadius.circular(5.0),
                      ),
                      selectedTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                      defaultTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      weekendTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      holidayTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 14),
                      outsideTextStyle: const TextStyle(
                          color: Color(0xFFAEAEAE), fontSize: 14),
                      todayDecoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      headerPadding: const EdgeInsets.only(
                          right: 16, left: 16, top: 30, bottom: 10),
                      // titleCentered: true,

                      formatButtonShowsNext: false,

                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      formatButtonTextStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      singleMarkerBuilder: (context, date, Document doc) {
                        return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: doc.status == 1
                                  ? Theme.of(context).colorScheme.activeColor
                                  : doc.status == 2
                                      ? Theme.of(context)
                                          .colorScheme
                                          .expiringColor
                                      : Colors.red), //Change color
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        );
                      },
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: listOfDocSelected.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return listOfDocSelected[index].status == 1
                //           ? GestureDetector(
                //               onTap: () {
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => DocumentData(
                //                           docId: listOfDocSelected[index].id,
                //                           indexTab: 0)),
                //                 );
                //               },
                //               child: Container(
                //                   height: 140,
                //                   padding: const EdgeInsets.only(top: 4),
                //                   margin: const EdgeInsets.all(10),
                //                   decoration: BoxDecoration(
                //                     //   color:
                //                     //       Theme.of(context).colorScheme.activeColor,
                //                     borderRadius: BorderRadius.circular(12),
                //                   ),
                //                   child: Container(
                //                     height: 160,
                //                     padding: const EdgeInsets.fromLTRB(
                //                         15, 15, 15, 15),
                //                     decoration: BoxDecoration(
                //                       color: listOfDocSelected[index]
                //                                   .docSharingUserId
                //                                   .isNotEmpty &&
                //                               listOfDocSelected[index]
                //                                       .isDocCreated ==
                //                                   false
                //                           ? Theme.of(context)
                //                               .colorScheme
                //                               .sharerColor
                //                           : Colors.white,
                //                       // border: Border.all(
                //                       //     width: 0.5,
                //                       //     color: Theme.of(context)
                //                       //         .colorScheme
                //                       //         .tabBorderColor),
                //                       borderRadius: BorderRadius.circular(12),
                //                       // boxShadow: [
                //                       //   BoxShadow(
                //                       //     color: Theme.of(context)
                //                       //         .colorScheme
                //                       //         .iconThemeGray,
                //                       //     blurRadius: 15.0,
                //                       //     spreadRadius: 0.1,
                //                       //     offset: const Offset(4, 8),
                //                       //   )
                //                       // ]
                //                     ),
                //                     child: Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         Container(
                //                           height: 26,
                //                           width: 64,
                //                           decoration: BoxDecoration(
                //                               borderRadius:
                //                                   BorderRadius.circular(6),
                //                               color: const Color(0xffE8FFF3)),
                //                           child: const Center(
                //                             child: Text(
                //                               'Active',
                //                               style: TextStyle(
                //                                   fontSize: 12,
                //                                   fontWeight: FontWeight.bold,
                //                                   color: Color(0xff50CD89)),
                //                               // textAlign: Alignment.center,
                //                             ),
                //                           ),
                //                         ),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         Container(
                //                           margin:
                //                               const EdgeInsets.only(bottom: 12),
                //                           child:
                //                               Text(
                //                                   listOfDocSelected[index]
                //                                               .docName
                //                                               .length >
                //                                           30
                //                                       ? listOfDocSelected[index]
                //                                               .docName
                //                                               .substring(
                //                                                   0, 32) +
                //                                           " ..."
                //                                       : listOfDocSelected[index]
                //                                           .docName,
                //                                   style: Theme.of(context)
                //                                       .textTheme
                //                                       .headline5!
                //                                       .copyWith(
                //                                           fontSize: 20,
                //                                           fontWeight:
                //                                               FontWeight.bold)),
                //                         ),
                //                         Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             Container(
                //                               padding:
                //                                   const EdgeInsets.fromLTRB(
                //                                       8, 2, 8, 2),
                //                               // decoration: BoxDecoration(
                //                               //   color: Theme.of(context)
                //                               //       .colorScheme
                //                               //       .activeColor,
                //                               //   borderRadius:
                //                               //       BorderRadius.circular(15),
                //                               // ),
                //                               child: Row(
                //                                 children: [
                //                                   Row(
                //                                     children: const [
                //                                       Icon(
                //                                         Icons
                //                                             .folder_open_rounded,
                //                                         color:
                //                                             Color(0xffD6D6E0),
                //                                       ),
                //                                       SizedBox(
                //                                         width: 8,
                //                                       ),
                //                                       Text(
                //                                         'Business',
                //                                         style: TextStyle(
                //                                           fontSize: 16,
                //                                           fontWeight:
                //                                               FontWeight.w600,
                //                                           color:
                //                                               Color(0xffB5B5C3),
                //                                         ),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                   const SizedBox(
                //                                     width: 20,
                //                                   ),
                //                                   // Padding(
                //                                   //   padding: const EdgeInsets.only(
                //                                   //       right: 5),
                //                                   //   // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                //                                   //   child: Image.asset(
                //                                   //       "assets/Icons/v_active.png"),
                //                                   // ),
                //                                   Text(
                //                                     getDateFormate(
                //                                         listOfDocSelected[index]
                //                                             .expiryDate),
                //                                     style: const TextStyle(
                //                                         color:
                //                                             Color(0xff0BB783),
                //                                         fontWeight:
                //                                             FontWeight.w600,
                //                                         fontSize: 12),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                             // const Text(
                //                             //   "Acve",
                //                             //   style: CustomTextStyle.simple12Text,
                //                             // )
                //                           ],
                //                         ),
                //                         // Container(
                //                         //   margin: const EdgeInsets.only(top: 10),
                //                         //   padding: const EdgeInsets.only(
                //                         //       top: 5, bottom: 5),
                //                         //   decoration: const BoxDecoration(
                //                         //       border: Border(
                //                         //           top: BorderSide(
                //                         //               color: Colors.grey,
                //                         //               width: 0.7),
                //                         //           bottom: BorderSide(
                //                         //               color: Colors.grey,
                //                         //               width: 0.7))),
                //                         //   child: Row(
                //                         //     mainAxisAlignment:
                //                         //         MainAxisAlignment.spaceBetween,
                //                         //     children: [
                //                         //       Container(
                //                         //         padding: const EdgeInsets.fromLTRB(
                //                         //             8, 3, 5, 3),
                //                         //         width: 150,
                //                         //         child: const Text(
                //                         //           "No action required",
                //                         //           style: TextStyle(
                //                         //               fontSize: 12,
                //                         //               color: Color(0xFF323232),
                //                         //               fontWeight: FontWeight.w600),
                //                         //         ),
                //                         //       ),
                //                         //       Row(
                //                         //         children: [
                //                         //           listOfDocSelected[index]
                //                         //                       .remindMe ==
                //                         //                   false
                //                         //               ? Container(
                //                         //                   padding: const EdgeInsets
                //                         //                       .fromLTRB(8, 2, 2, 2),
                //                         //                   child: Icon(
                //                         //                     Icons
                //                         //                         .notifications_off_outlined,
                //                         //                     color: Theme.of(context)
                //                         //                         .primaryColor,
                //                         //                     size: 20,
                //                         //                   ),
                //                         //                 )
                //                         //               : Container(),
                //                         //           listOfDocSelected[index]
                //                         //                       .attachmentCount >
                //                         //                   1
                //                         //               ? Container(
                //                         //                   padding: const EdgeInsets
                //                         //                       .fromLTRB(0, 2, 8, 2),
                //                         //                   child: Icon(
                //                         //                     Icons.attach_file,
                //                         //                     color: Theme.of(context)
                //                         //                         .primaryColor,
                //                         //                     size: 20,
                //                         //                   ),
                //                         //                 )
                //                         //               : Container()
                //                         //         ],
                //                         //       )
                //                         //     ],
                //                         //   ),
                //                         // ),
                //                         Expanded(
                //                           child: Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.end,
                //                             children: [
                //                               Row(
                //                                 children: [
                //                                   listOfDocSelected[index]
                //                                               .docSharingUserId
                //                                               .isNotEmpty &&
                //                                           listOfDocSelected[
                //                                                       index]
                //                                                   .isDocCreated ==
                //                                               false
                //                                       ? Row(
                //                                           children: [
                //                                             Padding(
                //                                               padding:
                //                                                   const EdgeInsets
                //                                                           .only(
                //                                                       right: 5),
                //                                               child: Icon(
                //                                                 FontAwesomeIcons
                //                                                     .userGroup,
                //                                                 color: Theme.of(
                //                                                         context)
                //                                                     .colorScheme
                //                                                     .sharerIconColor,
                //                                                 size: 12,
                //                                               ),
                //                                             ),
                //                                             ListView.builder(
                //                                                 scrollDirection:
                //                                                     Axis
                //                                                         .horizontal,
                //                                                 shrinkWrap:
                //                                                     true,
                //                                                 itemCount: 1,
                //                                                 itemBuilder:
                //                                                     (context,
                //                                                         index2) {
                //                                                   return Row(
                //                                                     mainAxisAlignment:
                //                                                         MainAxisAlignment
                //                                                             .start,
                //                                                     children: [
                //                                                       SizedBox(
                //                                                         width:
                //                                                             35,
                //                                                         child: listOfDocSelected[index].sharerByList!.profilePic ==
                //                                                                 null
                //                                                             ? CircleAvatar(
                //                                                                 radius: 40,
                //                                                                 backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                //                                                                 child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                //                                                               )
                //                                                             : CircleAvatar(
                //                                                                 radius: 25,
                //                                                                 backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
                //                                                               ),
                //                                                       )
                //                                                     ],
                //                                                   );
                //                                                 })
                //                                           ],
                //                                         )
                //                                       : ListView.builder(
                //                                           scrollDirection:
                //                                               Axis.horizontal,
                //                                           shrinkWrap: true,
                //                                           itemCount: listOfDocSelected
                //                                                   .isEmpty
                //                                               ? 0
                //                                               : listOfDocSelected[
                //                                                               index]
                //                                                           .sharerList ==
                //                                                       null
                //                                                   ? 0
                //                                                   : listOfDocSelected[
                //                                                           index]
                //                                                       .sharerList!
                //                                                       .length,
                //                                           itemBuilder: (context,
                //                                               index2) {
                //                                             return Row(
                //                                               mainAxisAlignment:
                //                                                   MainAxisAlignment
                //                                                       .start,
                //                                               children: [
                //                                                 SizedBox(
                //                                                   width: 40,
                //                                                   child:
                //                                                       CircleAvatar(
                //                                                     radius: 50,
                //                                                     backgroundColor: Theme.of(
                //                                                             context)
                //                                                         .colorScheme
                //                                                         .iceBlueColor,
                //                                                     child: Text(
                //                                                         getUserFirstLetetrs(listOfDocSelected[index]
                //                                                             .sharerList![
                //                                                                 index2]
                //                                                             .name),
                //                                                         style: const TextStyle(
                //                                                             fontSize:
                //                                                                 14)),
                //                                                   ),
                //                                                 )
                //                                               ],
                //                                             );
                //                                           }),
                //                                 ],
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   )),
                //             )
                //           : listOfDocSelected[index].status == 2
                //               ? GestureDetector(
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => DocumentData(
                //                               docId:
                //                                   listOfDocSelected[index].id,
                //                               indexTab: 0)),
                //                     );
                //                   },
                //                   child: Container(
                //                       height: 142,
                //                       padding: const EdgeInsets.only(top: 4),
                //                       margin: const EdgeInsets.all(10),
                //                       decoration: BoxDecoration(
                //                         // color: Theme.of(context)
                //                         //     .colorScheme
                //                         //     .expiringColor,
                //                         borderRadius: BorderRadius.circular(12),
                //                       ),
                //                       child: Container(
                //                         height: 140,
                //                         padding: const EdgeInsets.fromLTRB(
                //                             15, 15, 15, 15),
                //                         decoration: BoxDecoration(
                //                           color: listOfDocSelected[index]
                //                                       .docSharingUserId
                //                                       .isNotEmpty &&
                //                                   listOfDocSelected[index]
                //                                           .isDocCreated ==
                //                                       false
                //                               ? Theme.of(context)
                //                                   .colorScheme
                //                                   .sharerColor
                //                               : Colors.white,
                //                           // border: Border.all(
                //                           //     width: 0.5,
                //                           //     color: Theme.of(context)
                //                           //         .colorScheme
                //                           //         .tabBorderColor),
                //                           borderRadius:
                //                               BorderRadius.circular(12),
                //                           // boxShadow: [
                //                           //   BoxShadow(
                //                           //     color: Theme.of(context)
                //                           //         .colorScheme
                //                           //         .iconThemeGray,
                //                           //     blurRadius: 15.0,
                //                           //     spreadRadius: 0.1,
                //                           //     offset: const Offset(4, 8),
                //                           //   )
                //                           // ]
                //                         ),
                //                         child: Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           children: [
                //                             Row(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.center,
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Container(
                //                                   height: 26,
                //                                   width: 64,
                //                                   decoration: BoxDecoration(
                //                                       borderRadius:
                //                                           BorderRadius.circular(
                //                                               6),
                //                                       color: const Color(
                //                                           0xffFFF8DD)),
                //                                   child: const Center(
                //                                     child: Text(
                //                                       'Expiring',
                //                                       style: TextStyle(
                //                                           fontSize: 12,
                //                                           fontWeight:
                //                                               FontWeight.bold,
                //                                           color: Color(
                //                                               0xffFFA621)),
                //                                       // textAlign: Alignment.center,
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 const Icon(
                //                                   Icons.bookmark_outline_sharp,
                //                                   color: Color(0xffD6D6E0),
                //                                 ),
                //                               ],
                //                             ),
                //                             const SizedBox(
                //                               height: 10,
                //                             ),
                //                             Container(
                //                               margin: const EdgeInsets.only(
                //                                   bottom: 12),
                //                               child: Text(
                //                                   listOfDocSelected[index]
                //                                               .docName
                //                                               .length >
                //                                           30
                //                                       ? listOfDocSelected[index]
                //                                               .docName
                //                                               .substring(
                //                                                   0, 32) +
                //                                           " ..."
                //                                       : listOfDocSelected[index]
                //                                           .docName,
                //                                   style: Theme.of(context)
                //                                       .textTheme
                //                                       .headline5!
                //                                       .copyWith(
                //                                           fontSize: 20,
                //                                           fontWeight:
                //                                               FontWeight.bold)),
                //                             ),
                //                             // Row(
                //                             //   mainAxisAlignment:
                //                             //       MainAxisAlignment.spaceBetween,
                //                             //   children: [
                //                             //     Container(
                //                             //       padding:
                //                             //           const EdgeInsets.fromLTRB(
                //                             //               8, 2, 8, 2),
                //                             //       decoration: BoxDecoration(
                //                             //         color: Theme.of(context)
                //                             //             .colorScheme
                //                             //             .expiringColor,
                //                             //         borderRadius:
                //                             //             BorderRadius.circular(15),
                //                             //       ),
                //                             //       child: Row(
                //                             //         children: [
                //                             //           Padding(
                //                             //             padding:
                //                             //                 const EdgeInsets.only(
                //                             //                     right: 5),
                //                             //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                //                             //             child: Image.asset(
                //                             //                 "assets/Icons/v_expiring.png"),
                //                             //           ),
                //                             //           // Text(
                //                             //           //   getDateFormate(
                //                             //           //       listOfDocSelected[index]
                //                             //           //           .expiryDate),
                //                             //           //   style: const TextStyle(
                //                             //           //       color: Colors.white,
                //                             //           //       fontWeight:
                //                             //           //           FontWeight.w600,
                //                             //           //       fontSize: 12),
                //                             //           // ),
                //                             //         ],
                //                             //       ),
                //                             //     ),
                //                             //     RichText(
                //                             //         text: TextSpan(children: [
                //                             //       const TextSpan(
                //                             //           text: "Expiring in ",
                //                             //           style: CustomTextStyle
                //                             //               .simple12Text),
                //                             //       TextSpan(
                //                             //           text: listOfDocSelected[index]
                //                             //                       .diffTotalDays >
                //                             //                   9
                //                             //               ? listOfDocSelected[index]
                //                             //                   .diffTotalDays
                //                             //                   .toString()
                //                             //               : "0" +
                //                             //                   listOfDocSelected[
                //                             //                           index]
                //                             //                       .diffTotalDays
                //                             //                       .toString(),
                //                             //           style: TextStyle(
                //                             //               color: Theme.of(context)
                //                             //                   .colorScheme
                //                             //                   .blackColor,
                //                             //               fontWeight:
                //                             //                   FontWeight.w700)),
                //                             //       listOfDocSelected[index]
                //                             //                   .diffTotalDays >
                //                             //               1
                //                             //           ? const TextSpan(
                //                             //               text: " days",
                //                             //               style: CustomTextStyle
                //                             //                   .simple12Text,
                //                             //             )
                //                             //           : const TextSpan(
                //                             //               text: " day",
                //                             //               style: CustomTextStyle
                //                             //                   .simple12Text,
                //                             //             ),
                //                             //     ])),
                //                             //   ],
                //                             // ),
                //                             // Container(
                //                             //   margin:
                //                             //       const EdgeInsets.only(top: 10),
                //                             //   padding: const EdgeInsets.only(
                //                             //       top: 5, bottom: 5),
                //                             //   decoration: const BoxDecoration(
                //                             //       border: Border(
                //                             //           top: BorderSide(
                //                             //               color: Colors.grey,
                //                             //               width: 0.7),
                //                             //           bottom: BorderSide(
                //                             //               color: Colors.grey,
                //                             //               width: 0.7))),
                //                             //   child: Row(
                //                             //     mainAxisAlignment:
                //                             //         MainAxisAlignment.spaceBetween,
                //                             //     children: [
                //                             //       Container(
                //                             //           padding:
                //                             //               const EdgeInsets.fromLTRB(
                //                             //                   10, 3, 5, 3),
                //                             //           decoration: BoxDecoration(
                //                             //               color: Theme.of(context)
                //                             //                   .colorScheme
                //                             //                   .iconBackColor,
                //                             //               borderRadius:
                //                             //                   BorderRadius.circular(
                //                             //                       15)),
                //                             //           width: 150,
                //                             //           child: Row(
                //                             //             mainAxisAlignment:
                //                             //                 MainAxisAlignment
                //                             //                     .spaceBetween,
                //                             //             children: [
                //                             //               Text(
                //                             //                 listOfDocSelected[index]
                //                             //                             .docUserStatusId ==
                //                             //                         1
                //                             //                     ? "Pending wal"
                //                             //                     : listOfDocSelected[
                //                             //                                     index]
                //                             //                                 .docUserStatusId ==
                //                             //                             2
                //                             //                         ? "Renewal In-Press"
                //                             //                         : "Renewed",
                //                             //                 style: const TextStyle(
                //                             //                     fontSize: 12,
                //                             //                     color: Color(
                //                             //                         0xFF323232),
                //                             //                     fontWeight:
                //                             //                         FontWeight
                //                             //                             .w600),
                //                             //               ),
                //                             //               const Icon(
                //                             //                 Icons
                //                             //                     .keyboard_arrow_down,
                //                             //                 color:
                //                             //                     Color(0xFF323232),
                //                             //               ),
                //                             //             ],
                //                             //           )),
                //                             //       Row(
                //                             //         children: [
                //                             //           listOfDocSelected[index]
                //                             //                       .remindMe ==
                //                             //                   false
                //                             //               ? Container(
                //                             //                   padding:
                //                             //                       const EdgeInsets
                //                             //                               .fromLTRB(
                //                             //                           8, 2, 2, 2),
                //                             //                   child: Icon(
                //                             //                     Icons
                //                             //                         .notifications_off_outlined,
                //                             //                     color: Theme.of(
                //                             //                             context)
                //                             //                         .primaryColor,
                //                             //                     size: 20,
                //                             //                   ),
                //                             //                 )
                //                             //               : Container(),
                //                             //           listOfDocSelected[index]
                //                             //                       .attachmentCount >
                //                             //                   1
                //                             //               ? Container(
                //                             //                   padding:
                //                             //                       const EdgeInsets
                //                             //                               .fromLTRB(
                //                             //                           0, 2, 8, 2),
                //                             //                   child: Icon(
                //                             //                     Icons.attach_file,
                //                             //                     color: Theme.of(
                //                             //                             context)
                //                             //                         .primaryColor,
                //                             //                     size: 20,
                //                             //                   ),
                //                             //                 )
                //                             //               : Container()
                //                             //         ],
                //                             //       )
                //                             //     ],
                //                             //   ),
                //                             // ),

                //                             Row(
                //                               children: [
                //                                 Row(
                //                                   children: const [
                //                                     Icon(
                //                                       Icons.folder_open_rounded,
                //                                       color: Color(0xffD6D6E0),
                //                                     ),
                //                                     SizedBox(
                //                                       width: 8,
                //                                     ),
                //                                     Text(
                //                                       'Family Docs',
                //                                       style: TextStyle(
                //                                         fontSize: 16,
                //                                         fontWeight:
                //                                             FontWeight.w600,
                //                                         color:
                //                                             Color(0xffB5B5C3),
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 const SizedBox(
                //                                   width: 20,
                //                                 ),
                //                                 Text(
                //                                   getDateFormate(
                //                                       listOfDocSelected[index]
                //                                           .expiryDate),
                //                                   style: const TextStyle(
                //                                       color: Color(0xffFFA621),
                //                                       fontWeight:
                //                                           FontWeight.w600,
                //                                       fontSize: 12),
                //                                 ),
                //                               ],
                //                             ),
                //                             Expanded(
                //                               child: Row(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment
                //                                         .spaceBetween,
                //                                 crossAxisAlignment:
                //                                     CrossAxisAlignment.end,
                //                                 children: [
                //                                   Row(
                //                                     children: [
                //                                       listOfDocSelected[index]
                //                                                   .docSharingUserId
                //                                                   .isNotEmpty &&
                //                                               listOfDocSelected[
                //                                                           index]
                //                                                       .isDocCreated ==
                //                                                   false
                //                                           ? Row(
                //                                               children: [
                //                                                 Padding(
                //                                                   padding: const EdgeInsets
                //                                                           .only(
                //                                                       right: 5),
                //                                                   child: Icon(
                //                                                     FontAwesomeIcons
                //                                                         .userGroup,
                //                                                     color: Theme.of(
                //                                                             context)
                //                                                         .colorScheme
                //                                                         .sharerIconColor,
                //                                                     size: 12,
                //                                                   ),
                //                                                 ),
                //                                                 ListView
                //                                                     .builder(
                //                                                         scrollDirection:
                //                                                             Axis
                //                                                                 .horizontal,
                //                                                         shrinkWrap:
                //                                                             true,
                //                                                         itemCount:
                //                                                             1,
                //                                                         itemBuilder:
                //                                                             (context,
                //                                                                 index2) {
                //                                                           return Row(
                //                                                             mainAxisAlignment:
                //                                                                 MainAxisAlignment.start,
                //                                                             children: [
                //                                                               SizedBox(
                //                                                                 width: 35,
                //                                                                 child: listOfDocSelected[index].sharerByList!.profilePic == null
                //                                                                     ? CircleAvatar(
                //                                                                         radius: 40,
                //                                                                         backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                //                                                                         child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                //                                                                       )
                //                                                                     : CircleAvatar(
                //                                                                         radius: 25,
                //                                                                         backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
                //                                                                       ),
                //                                                               )
                //                                                             ],
                //                                                           );
                //                                                         })
                //                                               ],
                //                                             )
                //                                           : ListView.builder(
                //                                               scrollDirection:
                //                                                   Axis
                //                                                       .horizontal,
                //                                               shrinkWrap: true,
                //                                               itemCount: listOfDocSelected
                //                                                       .isEmpty
                //                                                   ? 0
                //                                                   : listOfDocSelected[index]
                //                                                               .sharerList ==
                //                                                           null
                //                                                       ? 0
                //                                                       : listOfDocSelected[
                //                                                               index]
                //                                                           .sharerList!
                //                                                           .length,
                //                                               itemBuilder:
                //                                                   (context,
                //                                                       index2) {
                //                                                 return Row(
                //                                                   mainAxisAlignment:
                //                                                       MainAxisAlignment
                //                                                           .start,
                //                                                   children: [
                //                                                     SizedBox(
                //                                                       width: 40,
                //                                                       child:
                //                                                           CircleAvatar(
                //                                                         radius:
                //                                                             50,
                //                                                         backgroundColor: Theme.of(context)
                //                                                             .colorScheme
                //                                                             .iceBlueColor,
                //                                                         child: Text(
                //                                                             getUserFirstLetetrs(listOfDocSelected[index].sharerList![index2].name),
                //                                                             style: const TextStyle(fontSize: 14)),
                //                                                       ),
                //                                                     )
                //                                                   ],
                //                                                 );
                //                                               }),
                //                                     ],
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       )),
                //                 )
                //               : GestureDetector(
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => DocumentData(
                //                               docId:
                //                                   listOfDocSelected[index].id,
                //                               indexTab: 0)),
                //                     );
                //                   },
                //                   child: Container(
                //                       height: 142,
                //                       padding: const EdgeInsets.only(top: 4),
                //                       margin: const EdgeInsets.all(10),
                //                       decoration: BoxDecoration(
                //                         // color: Theme.of(context)
                //                         //     .colorScheme
                //                         //     .expiredColor,
                //                         borderRadius: BorderRadius.circular(12),
                //                       ),
                //                       child: Container(
                //                         height: 140,
                //                         padding: const EdgeInsets.fromLTRB(
                //                             15, 15, 15, 15),
                //                         decoration: BoxDecoration(
                //                           color: listOfDocSelected[index]
                //                                       .docSharingUserId
                //                                       .isNotEmpty &&
                //                                   listOfDocSelected[index]
                //                                           .isDocCreated ==
                //                                       false
                //                               ? Theme.of(context)
                //                                   .colorScheme
                //                                   .sharerColor
                //                               : Colors.white,
                //                           // border: Border.all(
                //                           //     width: 0.5,
                //                           //     color: Theme.of(context)
                //                           //         .colorScheme
                //                           //         .tabBorderColor),
                //                           borderRadius:
                //                               BorderRadius.circular(12),
                //                           // boxShadow: [
                //                           // BoxShadow(
                //                           //   color: Theme.of(context)
                //                           //       .colorScheme
                //                           //       .iconThemeGray,
                //                           //   blurRadius: 15.0,
                //                           //   spreadRadius: 0.1,
                //                           //   offset: const Offset(4, 8),
                //                           // )
                //                           // ]
                //                         ),
                //                         child: Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           children: [
                //                             Row(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.center,
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment
                //                                       .spaceBetween,
                //                               children: [
                //                                 Container(
                //                                   height: 26,
                //                                   width: 64,
                //                                   decoration: BoxDecoration(
                //                                       borderRadius:
                //                                           BorderRadius.circular(
                //                                               6),
                //                                       color: const Color(
                //                                           0xffFFF5F8)),
                //                                   child: const Center(
                //                                     child: Text(
                //                                       'Expired',
                //                                       style: TextStyle(
                //                                           fontSize: 12,
                //                                           fontWeight:
                //                                               FontWeight.bold,
                //                                           color: Color(
                //                                               0xffF1416C)),
                //                                       // textAlign: Alignment.center,
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 const Icon(
                //                                   Icons.bookmark_outline_sharp,
                //                                   color: Color(0xffD6D6E0),
                //                                 ),
                //                               ],
                //                             ),
                //                             const SizedBox(
                //                               height: 10,
                //                             ),
                //                             Container(
                //                               margin: const EdgeInsets.only(
                //                                   bottom: 12),
                //                               child: Text(
                //                                   listOfDocSelected[index]
                //                                               .docName
                //                                               .length >
                //                                           30
                //                                       ? listOfDocSelected[index]
                //                                               .docName
                //                                               .substring(
                //                                                   0, 32) +
                //                                           " ..."
                //                                       : listOfDocSelected[index]
                //                                           .docName,
                //                                   style: Theme.of(context)
                //                                       .textTheme
                //                                       .headline5!
                //                                       .copyWith(
                //                                           fontSize: 20,
                //                                           fontWeight:
                //                                               FontWeight.bold)),
                //                             ),
                //                             // Row(
                //                             //   mainAxisAlignment:
                //                             //       MainAxisAlignment.spaceBetween,
                //                             //   children: [
                //                             //     Container(
                //                             //       padding:
                //                             //           const EdgeInsets.fromLTRB(
                //                             //               8, 2, 8, 2),
                //                             //       decoration: BoxDecoration(
                //                             //         color: Theme.of(context)
                //                             //             .colorScheme
                //                             //             .expiredColor,
                //                             //         borderRadius:
                //                             //             BorderRadius.circular(15),
                //                             //       ),
                //                             //       child: Row(
                //                             //         children: [
                //                             //           Padding(
                //                             //             padding:
                //                             //                 const EdgeInsets.only(
                //                             //                     right: 5),
                //                             //             // child: Icon(Icons.access_time_filled, size: 15, color: Theme.of(context).colorScheme.warmGreyColor),
                //                             //             child: Image.asset(
                //                             //                 "assets/Icons/v_expired.png"),
                //                             //           ),
                //                             //           Text(
                //                             //             getDateFormate(
                //                             //                 listOfDocSelected[index]
                //                             //                     .expiryDate),
                //                             //             style: const TextStyle(
                //                             //                 color: Colors.white,
                //                             //                 fontWeight:
                //                             //                     FontWeight.w600,
                //                             //                 fontSize: 12),
                //                             //           ),
                //                             //         ],
                //                             //       ),
                //                             //     ),
                //                             //     RichText(
                //                             //         text: TextSpan(children: [
                //                             //       const TextSpan(
                //                             //         text: "Expired ",
                //                             //         style: CustomTextStyle
                //                             //             .simple12Text,
                //                             //       ),
                //                             //       TextSpan(
                //                             //           text: listOfDocSelected[index]
                //                             //                       .diffTotalDays
                //                             //                       .abs() >
                //                             //                   9
                //                             //               ? listOfDocSelected[index]
                //                             //                   .diffTotalDays
                //                             //                   .toString()
                //                             //                   .replaceAll(
                //                             //                       RegExp('-'), '')
                //                             //               : "0" +
                //                             //                   listOfDocSelected[
                //                             //                           index]
                //                             //                       .diffTotalDays
                //                             //                       .toString()
                //                             //                       .replaceAll(
                //                             //                           RegExp('-'),
                //                             //                           ''),
                //                             //           style: TextStyle(
                //                             //               color: Theme.of(context)
                //                             //                   .colorScheme
                //                             //                   .blackColor,
                //                             //               fontWeight:
                //                             //                   FontWeight.w700)),
                //                             //       listOfDocSelected[index]
                //                             //                   .diffTotalDays >
                //                             //               1
                //                             //           ? const TextSpan(
                //                             //               text: " days ago",
                //                             //               style: CustomTextStyle
                //                             //                   .simple12Text,
                //                             //             )
                //                             //           : const TextSpan(
                //                             //               text: " day ago",
                //                             //               style: CustomTextStyle
                //                             //                   .simple12Text,
                //                             //             ),
                //                             //     ])),
                //                             //   ],
                //                             // ),
                //                             // Container(
                //                             //   margin:
                //                             //       const EdgeInsets.only(top: 10),
                //                             //   padding: const EdgeInsets.only(
                //                             //       top: 5, bottom: 5),
                //                             //   decoration: const BoxDecoration(
                //                             //       border: Border(
                //                             //           top: BorderSide(
                //                             //               color: Colors.grey,
                //                             //               width: 0.7),
                //                             //           bottom: BorderSide(
                //                             //               color: Colors.grey,
                //                             //               width: 0.7))),
                //                             //   child: Row(
                //                             //     mainAxisAlignment:
                //                             //         MainAxisAlignment.spaceBetween,
                //                             //     children: [
                //                             //       Container(
                //                             //           padding:
                //                             //               const EdgeInsets.fromLTRB(
                //                             //                   10, 3, 5, 3),
                //                             //           decoration: BoxDecoration(
                //                             //               color: Theme.of(context)
                //                             //                   .colorScheme
                //                             //                   .iconBackColor,
                //                             //               borderRadius:
                //                             //                   BorderRadius.circular(
                //                             //                       15)),
                //                             //           width: 150,
                //                             //           child: Row(
                //                             //             mainAxisAlignment:
                //                             //                 MainAxisAlignment
                //                             //                     .spaceBetween,
                //                             //             children: [
                //                             //               Text(
                //                             //                 listOfDocSelected[index]
                //                             //                             .docUserStatusId ==
                //                             //                         1
                //                             //                     ? "Pending Renewal"
                //                             //                     : listOfDocSelected[
                //                             //                                     index]
                //                             //                                 .docUserStatusId ==
                //                             //                             2
                //                             //                         ? "Renewal In-Progress"
                //                             //                         : "Renewed",
                //                             //                 style: const TextStyle(
                //                             //                     fontSize: 12,
                //                             //                     color: Color(
                //                             //                         0xFF323232),
                //                             //                     fontWeight:
                //                             //                         FontWeight
                //                             //                             .w600),
                //                             //               ),
                //                             //               const Icon(
                //                             //                 Icons
                //                             //                     .keyboard_arrow_down,
                //                             //                 color:
                //                             //                     Color(0xFF323232),
                //                             //               ),
                //                             //             ],
                //                             //           )),
                //                             //       Row(
                //                             //         children: [
                //                             //           listOfDocSelected[index]
                //                             //                       .remindMe ==
                //                             //                   false
                //                             //               ? Container(
                //                             //                   padding:
                //                             //                       const EdgeInsets
                //                             //                               .fromLTRB(
                //                             //                           8, 2, 2, 2),
                //                             //                   child: Icon(
                //                             //                     Icons
                //                             //                         .notifications_off_outlined,
                //                             //                     color: Theme.of(
                //                             //                             context)
                //                             //                         .primaryColor,
                //                             //                     size: 20,
                //                             //                   ),
                //                             //                 )
                //                             //               : Container(),
                //                             //           listOfDocSelected[index]
                //                             //                       .attachmentCount >
                //                             //                   1
                //                             //               ? Container(
                //                             //                   padding:
                //                             //                       const EdgeInsets
                //                             //                               .fromLTRB(
                //                             //                           0, 2, 8, 2),
                //                             //                   child: Icon(
                //                             //                     Icons.attach_file,
                //                             //                     color: Theme.of(
                //                             //                             context)
                //                             //                         .primaryColor,
                //                             //                     size: 20,
                //                             //                   ),
                //                             //                 )
                //                             //               : Container()
                //                             //         ],
                //                             //       )
                //                             //     ],
                //                             //   ),
                //                             // ),
                //                             Row(
                //                               children: [
                //                                 Row(
                //                                   children: const [
                //                                     Icon(
                //                                       Icons.folder_open_rounded,
                //                                       color: Color(0xffD6D6E0),
                //                                     ),
                //                                     SizedBox(
                //                                       width: 8,
                //                                     ),
                //                                     Text(
                //                                       'Family Docs',
                //                                       style: TextStyle(
                //                                         fontSize: 16,
                //                                         fontWeight:
                //                                             FontWeight.w600,
                //                                         color:
                //                                             Color(0xffB5B5C3),
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 const SizedBox(
                //                                   width: 20,
                //                                 ),
                //                                 Text(
                //                                   getDateFormate(
                //                                       listOfDocSelected[index]
                //                                           .expiryDate),
                //                                   style: const TextStyle(
                //                                       color: Color(0xffF1416C),
                //                                       fontWeight:
                //                                           FontWeight.w600,
                //                                       fontSize: 12),
                //                                 ),
                //                               ],
                //                             ),
                //                             Expanded(
                //                               child: Row(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment
                //                                         .spaceBetween,
                //                                 crossAxisAlignment:
                //                                     CrossAxisAlignment.end,
                //                                 children: [
                //                                   Row(
                //                                     children: [
                //                                       listOfDocSelected[index]
                //                                                   .docSharingUserId
                //                                                   .isNotEmpty &&
                //                                               listOfDocSelected[
                //                                                           index]
                //                                                       .isDocCreated ==
                //                                                   false
                //                                           ? Row(
                //                                               children: [
                //                                                 Padding(
                //                                                   padding: const EdgeInsets
                //                                                           .only(
                //                                                       right: 5),
                //                                                   child: Icon(
                //                                                     FontAwesomeIcons
                //                                                         .userGroup,
                //                                                     color: Theme.of(
                //                                                             context)
                //                                                         .colorScheme
                //                                                         .sharerIconColor,
                //                                                     size: 12,
                //                                                   ),
                //                                                 ),
                //                                                 ListView
                //                                                     .builder(
                //                                                         scrollDirection:
                //                                                             Axis
                //                                                                 .horizontal,
                //                                                         shrinkWrap:
                //                                                             true,
                //                                                         itemCount:
                //                                                             1,
                //                                                         itemBuilder:
                //                                                             (context,
                //                                                                 index2) {
                //                                                           return Row(
                //                                                             mainAxisAlignment:
                //                                                                 MainAxisAlignment.start,
                //                                                             children: [
                //                                                               SizedBox(
                //                                                                 width: 35,
                //                                                                 child: listOfDocSelected[index].sharerByList!.profilePic == null
                //                                                                     ? CircleAvatar(
                //                                                                         radius: 40,
                //                                                                         backgroundColor: Theme.of(context).colorScheme.iceBlueColor,
                //                                                                         child: Text(getUserFirstLetetrs(listOfDocSelected[index].sharerByList!.name), style: const TextStyle(fontSize: 14)),
                //                                                                       )
                //                                                                     : CircleAvatar(
                //                                                                         radius: 25,
                //                                                                         backgroundImage: CachedNetworkImageProvider(imageUrl + listOfDocSelected[index].sharerByList!.profilePic.toString()),
                //                                                                       ),
                //                                                               )
                //                                                             ],
                //                                                           );
                //                                                         })
                //                                               ],
                //                                             )
                //                                           : ListView.builder(
                //                                               scrollDirection:
                //                                                   Axis
                //                                                       .horizontal,
                //                                               shrinkWrap: true,
                //                                               itemCount: listOfDocSelected
                //                                                       .isEmpty
                //                                                   ? 0
                //                                                   : listOfDocSelected[index]
                //                                                               .sharerList ==
                //                                                           null
                //                                                       ? 0
                //                                                       : listOfDocSelected[
                //                                                               index]
                //                                                           .sharerList!
                //                                                           .length,
                //                                               itemBuilder:
                //                                                   (context,
                //                                                       index2) {
                //                                                 return Row(
                //                                                   mainAxisAlignment:
                //                                                       MainAxisAlignment
                //                                                           .start,
                //                                                   children: [
                //                                                     SizedBox(
                //                                                       width: 40,
                //                                                       child:
                //                                                           CircleAvatar(
                //                                                         radius:
                //                                                             50,
                //                                                         backgroundColor: Theme.of(context)
                //                                                             .colorScheme
                //                                                             .iceBlueColor,
                //                                                         child: Text(
                //                                                             getUserFirstLetetrs(listOfDocSelected[index].sharerList![index2].name),
                //                                                             style: const TextStyle(fontSize: 14)),
                //                                                       ),
                //                                                     )
                //                                                   ],
                //                                                 );
                //                                               }),
                //                                     ],
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       )),
                //                 );
                //     },
                //   ),
                // ),
              ],
            ),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: const NavigationBottom(
        selectedIndex: 1,
      ),
    );
  }
}
