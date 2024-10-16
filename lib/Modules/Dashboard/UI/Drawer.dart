import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Modules/Setting/UI/edit_profile.dart';
import 'package:Xpiree/Modules/Setting/UI/expiring_criteria.dart';
import 'package:Xpiree/Modules/Setting/UI/feed_back.dart';
import 'package:Xpiree/Modules/Setting/UI/notification_setting.dart';
import 'package:Xpiree/Modules/Setting/UI/sharer_list.dart';
import 'package:Xpiree/Modules/Setting/UI/subscription_plan.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';

import '../../Setting/UI/edit_phone_number.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  MenuDrawerState createState() => MenuDrawerState();
}

class MenuDrawerState extends State<MenuDrawer> {
  final UserInfo _user = UserInfo();
  String userShortName = "";
  @override
  void initState() {
    super.initState();

    SessionMangement _sm = SessionMangement();
    _sm.getUserName().then((response) {
      setState(() {
        userShortName = "";
        _user.userName =
            response!.split(" ").map((str) => capitalize(str)).join(" ");
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
    _sm.getNoOfFolders().then((response) {
      setState(() {
        _user.noOfFolders = int.parse(response!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: RefreshIndicator(
      onRefresh: () {
        return refreshList();
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 30, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 5),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.times,
                            color: Color(0xffA7A8BB),
                            //  Theme.of(context).colorScheme.blackColor,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            /* Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavigationBottom(
                                      selectedIndex: 0, dashboardTabIndex: 2)),
                            ); */
                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                    child: Row(
                      children: [
                        _user.userPic.isEmpty || _user.userPic == ""
                            ? CircleAvatar(
                                radius: 25,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(userShortName.toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .whiteColor)),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                    imageUrl + _user.userPic),
                              ),
                        Flexible(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  _user.userName.isEmpty ? "" : _user.userName,
                                  style: CustomTextStyle.topHeading,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  _user.email.isEmpty ? "" : _user.email,
                                  style: CustomTextStyle.topHeading.copyWith(
                                      color: const Color(0xffA7A8BB),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              // Container(
                              //   padding: const EdgeInsets.only(left: 10),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //           _user.noOfDocuments.toString() == "0"
                              //               ? "No document"
                              //               : _user.noOfDocuments.toString() ==
                              //                       "1"
                              //                   ? _user.noOfDocuments
                              //                           .toString() +
                              //                       " Document "
                              //                   : _user.noOfDocuments
                              //                           .toString() +
                              //                       " Documents ",
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline6),
                              //       _user.noOfFolders != 0 ||
                              //               _user.noOfDocuments != 0
                              //           ? Text(" | ",
                              //               style: Theme.of(context)
                              //                   .textTheme
                              //                   .headline6)
                              //           : Container(),
                              //       Text(
                              //           _user.noOfFolders.toString() == "0"
                              //               ? " "
                              //               : _user.noOfFolders.toString() ==
                              //                       "1"
                              //                   ? _user.noOfFolders.toString() +
                              //                       " Folder"
                              //                   : _user.noOfFolders.toString() +
                              //                       " Folders",
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline6),
                              //     ],
                              //   ),
                              // )

                              /*  Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                Text(_user.noOfDocuments.toString()=="0"? "No document": _user.noOfDocuments.toString()=="1"? _user.noOfDocuments.toString() + " Document ":_user.noOfDocuments.toString() + " Documents ",
                                  style:  Theme.of(context).textTheme.headline6
                                  ),
                                ],
                              ),
                            ) */
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.fromLTRB(64, 0, 64, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Theme.of(context).colorScheme.whiteColor,
                        side: const BorderSide(color: Color(0xFFD8D8D8)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SubscriptionPlan()),
                        );
                      },
                      child:
                          //  Row(
                          //   children: [
                          // Icon(
                          //   Icons.star,
                          //   size: 16,
                          //   color:
                          //       Theme.of(context).colorScheme.expiringColor,
                          // ),
                          // const SizedBox(
                          //   width: 2,
                          // ),
                          const Text(
                        "Upgrade Plan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      // ],
                      // ),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                      "assets/Icons/person.png",
                      width: 25,
                      height: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Account',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                  ),
                  ListTile(
                    title: Text('Edit Profile',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: const Color(0xffA7A8BB))),
                    visualDensity: const VisualDensity(vertical: -4),
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Add Phone Number',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: const Color(0xffA7A8BB))),
                    visualDensity: const VisualDensity(vertical: -4),
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditPhoneNumber()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Document Expiring Criteria',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: const Color(0xffA7A8BB))),
                    visualDensity: const VisualDensity(vertical: -4),
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpiringCriteria()),
                      );
                    },
                  ),
                  Container(
                    height: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  ListTile(
                    leading: Image.asset(
                        "assets/Icons/notifications_active.png",
                        color: Theme.of(context).primaryColor,
                        width: 25,
                        height: 25),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Notifications',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationSetting()),
                      );
                    },
                  ),
                  Container(
                    height: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/Icons/people_alt.png",
                        color: Theme.of(context).primaryColor,
                        width: 25,
                        height: 25),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Sharing',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SharerList()),
                      );
                    },
                  ),
                  Container(
                    height: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/Icons/sms.png",
                        color: Theme.of(context).primaryColor,
                        width: 25,
                        height: 25),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Feedback',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedBack()),
                      );
                    },
                  ),
                  Container(
                    height: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/Icons/subPlan.png",
                        color: Theme.of(context).primaryColor,
                        width: 25,
                        height: 25),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Subscription Plan',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                    // trailing: GestureDetector(
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Theme.of(context).colorScheme.blackColor,
                    //   ),
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubscriptionPlan()),
                      );
                    },
                  ),
                  Container(
                    height: 0.0,
                    padding: const EdgeInsets.all(0.0),
                    child: const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/Icons/settings_power.png",
                        color: Theme.of(context).primaryColor,
                        width: 25,
                        height: 25),
                    title: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: Text('Logout',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    iconColor: Theme.of(context).colorScheme.blackColor,
                    onTap: () {
                      logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(seconds: 1), () {
      SessionMangement _sm = SessionMangement();
      _sm.getUserName().then((response) {
        setState(() {
          userShortName = "";
          _user.userName =
              response!.split(" ").map((str) => capitalize(str)).join(" ");
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
    });
  }
}
