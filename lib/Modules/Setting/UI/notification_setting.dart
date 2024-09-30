import 'package:Xpiree/Modules/Setting/UI/notify_onemail.dart';
import 'package:Xpiree/Modules/Setting/UI/notify_onphone.dart';
import 'package:Xpiree/Modules/Setting/UI/notify_onXpiree.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  NotificationSettingState createState() => NotificationSettingState();
}

class NotificationSettingState extends State<NotificationSetting> {
  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.all(15),
            icon: Icon(Icons.arrow_back, size: 20, color: Color(0xffA7A8BB)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Notifications",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(14),
          child: ListView(
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.textfiledColor,
                // padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: ListTile(
                  title: Text('Within App',
                      style: Theme.of(context).textTheme.headline5),
                  iconColor: Theme.of(context).colorScheme.blackColor,
                  subtitle: Text(
                      "Pick which notifications to see while in the app",
                      style: Theme.of(context).textTheme.headline4),
                  trailing: GestureDetector(
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: Colors.grey
                        // color: Theme.of(context).colorScheme.blackColor,
                        ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnXpireeNotify()),
                    );
                  },
                ),
              ),
              Card(
                elevation: 0,
                // padding: const EdgeInsets.all(15),
                color: Theme.of(context).colorScheme.textfiledColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: ListTile(
                  title: Text('On Email',
                      style: Theme.of(context).textTheme.headline5),
                  iconColor: Theme.of(context).colorScheme.blackColor,
                  subtitle: Text("Pick which notifications to get by email",
                      style: Theme.of(context).textTheme.headline4),
                  trailing: GestureDetector(
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnEmailNotify()),
                    );
                  },
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Theme.of(context).colorScheme.textfiledColor,
                // padding: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text('Push Notifications',
                      style: Theme.of(context).textTheme.headline5),
                  iconColor: Theme.of(context).colorScheme.blackColor,
                  subtitle: Text(
                      "Pick which notifications to get on your phone",
                      style: Theme.of(context).textTheme.headline4),
                  trailing: GestureDetector(
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: Colors.grey
                        // color: Theme.of(context).colorScheme.blackColor,
                        ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnPhoneNotify()),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
