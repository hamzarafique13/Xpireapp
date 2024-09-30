import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Xpiree/Modules/Dashboard/Model/DashboardModel.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Modules/Document/UI/document_detail.dart';
import 'package:Xpiree/Modules/Setting/UI/notification_setting.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';

class NotificationInfo extends StatefulWidget {
  const NotificationInfo({Key? key}) : super(key: key);

  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationInfo> {
  int totalPages = 0;
  List<NotificationVm> listOfNotify = [];
  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {});
    EasyLoading.show(status: 'loading...');
    getNotificationDataTable().then((response) {
      setState(() {
        listOfNotify = response!;
        EasyLoading.dismiss();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              // FontAwesomeIcons.times,
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Dashboard(
                          indexTab: 1,
                        )),
              );
            },
          ),
          actions: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationSetting()),
                        );
                      },
                      icon: Icon(Icons.settings,
                          color: Theme.of(context).colorScheme.primryColor)),
                ))
          ],
          title: Text(
            "Notification Center",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              getNotificationDataTable().then((response) {
                setState(() {
                  listOfNotify = response!;
                  EasyLoading.dismiss();
                });
              });
            });
          },
          child: Column(
            children: [
              Expanded(
                  flex: 9,
                  child: Scrollbar(
                    child: listOfNotify.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: listOfNotify.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Slidable(
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          EasyLoading.addStatusCallback(
                                              (status) {});
                                          EasyLoading.show(
                                              status: 'loading...');
                                          readSingleNotify(
                                                  listOfNotify[index].id)
                                              .then((response) {
                                            if (response == "1") {
                                              setState(() {
                                                listOfNotify[index].isRead =
                                                    true;
                                              });
                                            }
                                            EasyLoading.dismiss();
                                          });
                                        },
                                        backgroundColor: Colors.black45,
                                        foregroundColor: Colors.white,
                                        label: 'Read',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          EasyLoading.addStatusCallback(
                                              (status) {});
                                          EasyLoading.show(
                                              status: 'loading...');
                                          clearSingleNotify(
                                                  listOfNotify[index].id)
                                              .then((response) {
                                            getNotificationDataTable()
                                                .then((response) {
                                              setState(() {
                                                listOfNotify = response!;
                                              });
                                            });
                                            EasyLoading.dismiss();
                                          });
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        label: 'Clear',
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 15, 5, 0),
                                                    color: listOfNotify[index]
                                                                .isRead ==
                                                            true
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .iceBlueColor,
                                                    child: Html(
                                                        data:
                                                            listOfNotify[index]
                                                                .message)),
                                              ),
                                            ],
                                          ),
                                          listOfNotify[index].isRead == false &&
                                                  listOfNotify[index]
                                                          .isSharerRequest !=
                                                      null
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  color: listOfNotify[index]
                                                              .isRead ==
                                                          true
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .iceBlueColor,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            elevation: 0,
                                                            primary:
                                                                Colors.green,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          onPressed: () {
                                                            acceptRejectInvitation(
                                                                    listOfNotify[
                                                                            index]
                                                                        .id,
                                                                    listOfNotify[
                                                                            index]
                                                                        .fromUserId,
                                                                    2)
                                                                .then(
                                                                    (response) {
                                                              getNotificationDataTable()
                                                                  .then(
                                                                      (response) {
                                                                setState(() {
                                                                  listOfNotify =
                                                                      response!;
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              });
                                                            });
                                                          },
                                                          child: const Text(
                                                              "Accept")),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            elevation: 0,
                                                            primary: Colors.red,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                          ),
                                                          onPressed: () {
                                                            acceptRejectInvitation(
                                                                    listOfNotify[
                                                                            index]
                                                                        .id,
                                                                    listOfNotify[
                                                                            index]
                                                                        .fromUserId,
                                                                    3)
                                                                .then(
                                                                    (response) {
                                                              getNotificationDataTable()
                                                                  .then(
                                                                      (response) {
                                                                setState(() {
                                                                  listOfNotify =
                                                                      response!;
                                                                  EasyLoading
                                                                      .dismiss();
                                                                });
                                                              });
                                                            });
                                                          },
                                                          child: const Text(
                                                              "Reject"))
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color:
                                                  listOfNotify[index].isRead ==
                                                          true
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .iceBlueColor,
                                              child: Text(
                                                timeago.format(
                                                    DateTime.parse(
                                                        listOfNotify[index]
                                                            .createdOn),
                                                    locale: 'en'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              )),
                                          const SizedBox(
                                            height: 5,
                                            child: Divider(
                                              thickness: 2,
                                              indent: 0,
                                              endIndent: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: listOfNotify[index]
                                              .docId
                                              .isNotEmpty
                                          ? () {
                                              late int _indexTab;
                                              if (listOfNotify[index]
                                                      .isTaskRelated ==
                                                  true) {
                                                _indexTab = 1;
                                              } else {
                                                _indexTab = 0;
                                              }

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DocumentData(
                                                            docId: listOfNotify[
                                                                    index]
                                                                .docId,
                                                            indexTab:
                                                                _indexTab)),
                                              );
                                            }
                                          : null));
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text("You have not notifications yet.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                  )),
              listOfNotify.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                child: Text(
                                  "Mark as All Read",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .darkGrayColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                EasyLoading.addStatusCallback((status) {});
                                EasyLoading.show(status: 'loading...');
                                readMultiNotify().then((value) {
                                  getNotificationDataTable().then((response) {
                                    setState(() {
                                      listOfNotify = response!;
                                    });
                                  });
                                  EasyLoading.dismiss();
                                });
                              },
                            ),
                            InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                child: Text(
                                  "Clear All",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .darkGrayColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              onTap: () {
                                EasyLoading.addStatusCallback((status) {});
                                EasyLoading.show(status: 'loading...');
                                clearMultiNotify().then((value) {
                                  getNotificationDataTable().then((response) {
                                    setState(() {
                                      listOfNotify = response!;
                                    });
                                  });
                                  EasyLoading.dismiss();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
