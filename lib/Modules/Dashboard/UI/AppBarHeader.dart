// ignore_for_file: import_of_legacy_library_into_null_safe, no_logic_in_create_state,file_names

import 'package:flutter/material.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Dashboard/UI/notification.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/notification_service.dart';

class AppBarHeader extends StatefulWidget {
  late bool notify = false;
   AppBarHeader({Key? key,required this.notify}) : super(key: key);

  @override
  AppBarHeaderState createState() => AppBarHeaderState(notify);
}

class AppBarHeaderState extends State<AppBarHeader> {
  late bool newNotification = false;
  final NotificationService _notificationService = NotificationService();
  final UserInfo _user = UserInfo();
  AppBarHeaderState(this.newNotification);
  @override
  void initState() {
    super.initState();
    _notificationService.initialiseNotifications();

    SessionMangement _sm = SessionMangement();
    _sm.getNoOfDocuments().then((response) {
      setState(() {
        _user.noOfDocuments = int.parse(response!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      actions: [
      /*   _user.noOfDocuments > 0
            ? IconButton(
                icon: Icon(Icons.filter_list,
                    size: 20, color: Theme.of(context).colorScheme.iconColor),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterScreen()),
                  );
                })
            : Container(), */
        Stack(children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Theme.of(context).colorScheme.iconColor,
              ),
              onPressed: () {
                SessionMangement _sm = SessionMangement();
                setState(() {
                  _sm.removeNewNotify();
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationInfo()),
                );
              }),
          newNotification == true
              ? Positioned(
                  right: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                  ),
                )
              : Container()
        ]),
      ],
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.iconColor,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }
}
