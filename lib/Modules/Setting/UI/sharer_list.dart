import 'package:Xpiree/Modules/Setting/UI/add_sharer.dart';
import 'package:Xpiree/Modules/Setting/UI/subscription_plan.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class SharerList extends StatefulWidget {
  const SharerList({Key? key}) : super(key: key);

  @override
  SharerListState createState() => SharerListState();
}

class SharerListState extends State<SharerList> {
  int totalPages = 0;
  int noOfInvitation = 0;
  int noOfInvitationSharers = 0;
  SharerListVM? listOfSharer;
  String usernameSearch = "";
  EditUserSharer shareModal = EditUserSharer();
  final List _option3 = [
    'Remove',
  ];

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {});
    EasyLoading.show(status: 'loading...');
    getSharerList();
  }

  Future<SharerListVM?> getSharerList() {
    return getSharerDataTable(usernameSearch).then((value) {
      setState(() {
        listOfSharer = value!;
        noOfInvitation = listOfSharer!.item1
            .where((element) => element.isInvitedEmail == true)
            .length;
        noOfInvitationSharers = listOfSharer!.item1.length;
        EasyLoading.dismiss();
      });
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.backgroundColor,
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 20, color: Color(0xffA7A8BB)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Manage Sharer List",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                getSharerList();
              });
            },
            child: Column(
              children: [
                listOfSharer == null || listOfSharer!.item1.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.textfiledColor,
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  noOfInvitation.toString() +
                                      " of " +
                                      noOfInvitationSharers.toString() +
                                      " sharers invited. ",
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SubscriptionPlan()),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        // color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            width: 1, color: Color(0xFFD8D8D8)),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Text(
                                        "Upgrade for me",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                listOfSharer == null || listOfSharer!.item1.isEmpty
                    ? Expanded(
                        child: Container(
                        alignment: Alignment.center,
                        child: Text("No sharer added yet.",
                            style: Theme.of(context).textTheme.headline6),
                      ))
                    : Expanded(
                        child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: true,
                            itemCount: listOfSharer == null
                                ? 0
                                : listOfSharer!.item1.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Card(
                                  elevation: 0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textfiledColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        listOfSharer!.item1[index].profilePic
                                                    .isEmpty ||
                                                listOfSharer!.item1[index]
                                                        .profilePic ==
                                                    ""
                                            ? CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .profileEditColor,
                                                child: Text(
                                                    getUserFirstLetetrs(
                                                        listOfSharer!
                                                            .item1[index].name
                                                            .split(" ")
                                                            .map((str) =>
                                                                capitalize(str))
                                                            .join(" ")),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              )
                                            : CircleAvatar(
                                                radius: 25,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        imageUrl +
                                                            listOfSharer!
                                                                .item1[index]
                                                                .profilePic),
                                              ),
                                        Expanded(
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listOfSharer!
                                                          .item1[index].name
                                                          .split(" ")
                                                          .map((str) =>
                                                              capitalize(str))
                                                          .join(" "),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5!
                                                          .copyWith(
                                                              fontSize: 14),
                                                    ),
                                                    Text(
                                                        listOfSharer!
                                                            .item1[index].email,
                                                        style: CustomTextStyle
                                                            .simple12Text
                                                            .copyWith(
                                                                fontSize: 10)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                        color: listOfSharer!
                                                                    .item1[
                                                                        index]
                                                                    .requestStatus ==
                                                                2
                                                            ? Colors.green
                                                            : listOfSharer!
                                                                        .item1[
                                                                            index]
                                                                        .requestStatus ==
                                                                    3
                                                                ? Colors.red
                                                                : const Color(
                                                                    0xFF4FC3F7),
                                                        border: Border.all(
                                                          width: 0.05,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: Text(
                                                        listOfSharer!
                                                                    .item1[
                                                                        index]
                                                                    .requestStatus ==
                                                                2
                                                            ? "Accepted"
                                                            : listOfSharer!
                                                                        .item1[
                                                                            index]
                                                                        .requestStatus ==
                                                                    3
                                                                ? "Rejected"
                                                                : listOfSharer!
                                                                            .item1[index]
                                                                            .requestStatus ==
                                                                        4
                                                                    ? "Invited"
                                                                    : "Pending",
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    PopupMenuButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .warmGreyColor,
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext bc) {
                                                        return _option3
                                                            .map((obj) =>
                                                                PopupMenuItem(
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                          "assets/Icons/delete.png",
                                                                          width:
                                                                              25,
                                                                          height:
                                                                              25),
                                                                      Text(
                                                                        obj,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.redColor),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  value: obj,
                                                                ))
                                                            .toList();
                                                      },
                                                      onSelected: (value) {
                                                        if (value == "Remove") {
                                                          Widget deletebutton =
                                                              Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3,
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        padding:
                                                                            const EdgeInsets.all(0.0),
                                                                        elevation:
                                                                            0,
                                                                        primary: Theme.of(context)
                                                                            .colorScheme
                                                                            .redColor,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5)),
                                                                      ),
                                                                      child: const Text(
                                                                        "Yes, Remove",
                                                                        style: CustomTextStyle
                                                                            .headingWhite,
                                                                      ),
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        EasyLoading.addStatusCallback(
                                                                            (status) {});
                                                                        EasyLoading.show(
                                                                            status:
                                                                                'loading...');
                                                                        deleteSharer(listOfSharer!.item1[index].id,
                                                                                listOfSharer!.item1[index].isInvitedEmail)
                                                                            .then((response) async {
                                                                          EasyLoading
                                                                              .dismiss();
                                                                          if (response ==
                                                                              "1") {
                                                                            String
                                                                                _msg =
                                                                                "Sharer has been deleted.";
                                                                            String
                                                                                title =
                                                                                "";
                                                                            String
                                                                                _icon =
                                                                                "assets/images/Success.json";
                                                                            final action = showInfoAlert(
                                                                                title,
                                                                                _msg,
                                                                                _icon,
                                                                                context);
                                                                            Future.delayed(const Duration(seconds: 3),
                                                                                () {
                                                                              Navigator.pop(context, true);
                                                                            });
                                                                            getSharerList();
                                                                          }
                                                                        });
                                                                      }),
                                                                ),
                                                                SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                          padding:
                                                                              const EdgeInsets.all(0.0),
                                                                          elevation:
                                                                              0,
                                                                          primary: Theme.of(context)
                                                                              .colorScheme
                                                                              .whiteColor,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            side:
                                                                                BorderSide(color: Theme.of(context).colorScheme.textBoxBorderColor),
                                                                          ),
                                                                        ),
                                                                        child: const Text("Cancel", style: CustomTextStyle.heading44),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }))
                                                              ],
                                                            ),
                                                          );

                                                          AlertDialog alert =
                                                              AlertDialog(
                                                            title: const Text(
                                                                "Confirmation",
                                                                style: CustomTextStyle
                                                                    .heading2NOunderLIne,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            content: Text(
                                                                "Are you sure you want to delete this?",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            actions: [
                                                              deletebutton
                                                            ],
                                                          );
                                                          // show the dialog
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return alert;
                                                            },
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    // padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          primary: Color(0xff00A3FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Text('Add New Sharer',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddSharer()));
                        }),
                  ),
                ),
              ],
            )));
  }
}
