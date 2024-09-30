import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class OnEmailNotify extends StatefulWidget {
  const OnEmailNotify({Key? key}) : super(key: key);

  @override
  OnEmailNotifyState createState() => OnEmailNotifyState();
}

class OnEmailNotifyState extends State<OnEmailNotify> {
  List<TblNotificationType> notifyList = [];
  List<TblNotificationEnable> notifyEnableList = [];
  @override
  void initState() {
    super.initState();

    getNotifyTypeDDL(2).then((value) {
      setState(() {
        notifyList = value!;
        EasyLoading.dismiss();
      });
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
          title: Text("On Email",
              textAlign: TextAlign.left,
              style: CustomTextStyle.topHeading.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 20)),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListView(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(15),
                              child: Text(notifyList[index].title)),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: notifyList[index].childList.length,
                              itemBuilder: (BuildContext context, int index2) {
                                return Row(
                                  children: [
                                    Checkbox(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: notifyList[index]
                                            .childList[index2]
                                            .selected,
                                        side: const BorderSide(
                                            color: Color(0xFFA4A3A3)),
                                        onChanged: (value) {
                                          if (value == true) {
                                            setState(() {
                                              notifyList[index]
                                                  .childList[index2]
                                                  .selected = true;
                                              TblNotificationEnable
                                                  _enableList =
                                                  TblNotificationEnable();
                                              _enableList.notifyTypeId =
                                                  notifyList[index]
                                                      .childList[index2]
                                                      .id;
                                              _enableList.id = notifyList[index]
                                                  .childList[index2]
                                                  .id;
                                              _enableList.userId =
                                                  notifyList[index]
                                                      .childList[index2]
                                                      .id;
                                              _enableList.createdOn =
                                                  DateTime.now().toString();
                                              _enableList.onEmail = true;
                                              notifyEnableList.add(_enableList);
                                            });
                                          } else {
                                            setState(() {
                                              notifyList[index]
                                                  .childList[index2]
                                                  .selected = false;
                                              TblNotificationEnable
                                                  _enableList =
                                                  TblNotificationEnable();
                                              _enableList.notifyTypeId =
                                                  notifyList[index]
                                                      .childList[index2]
                                                      .id;
                                              _enableList.id = notifyList[index]
                                                  .childList[index2]
                                                  .id;
                                              _enableList.userId =
                                                  notifyList[index]
                                                      .childList[index2]
                                                      .id;
                                              _enableList.createdOn =
                                                  DateTime.now().toString();
                                              _enableList.onEmail = false;
                                              notifyEnableList.add(_enableList);
                                            });
                                          }
                                        }),
                                    Text(
                                      notifyList[index].childList[index2].title,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ],
                                );
                              })
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomCenter,
                      child: /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.0),
                            elevation: 0,
                            primary: Theme.of(context).colorScheme.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textBoxBorderColor),
                            ),
                          ),
                          child: Text("Turn off all",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme.blackColor)),
                          onPressed: () {
                            turnAllOFFnotify(2).then((response) {
                              if (response == "1") {
                                String _msg =
                                    "Email notifications have been disabled.";
                                String title = "";
                                String _icon = "assets/images/Success.json";
                                var response = showInfoAlert(
                                    title, _msg, _icon, context);
                                getNotifyTypeDDL(2).then((value) {
                                  setState(() {
                                    notifyList = value!;
                                    EasyLoading.dismiss();
                                  });
                                });
                              } else if (response == null) {
                                String _msg =
                                    "No email notifications have been disabled.";
                                String title = "";
                                String _icon = "assets/images/alert.json";
                                showInfoAlert(title, _msg, _icon, context);
                              }
                            });
                          }),
                    ),
                    */
                          SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              elevation: 0,
                              primary: Color(0xff00A3FF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(
                              "Update",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            onPressed: () {
                              updateNotifySetting(notifyEnableList)
                                  .then((response) {
                                if (response == "1") {
                                  String _msg =
                                      "Email notifications have been enabled.";
                                  String title = "";
                                  String _icon = "assets/images/Success.json";
                                  var response = showInfoAlert(
                                      title, _msg, _icon, context);
                                  getNotifyTypeDDL(2).then((value) {
                                    setState(() {
                                      notifyList = value!;
                                      EasyLoading.dismiss();
                                    });
                                  });
                                } else {
                                  String _msg =
                                      "Something wrong to enable email notifications";
                                  String title = "";
                                  String _icon = "assets/images/alert.json";
                                  showInfoAlert(title, _msg, _icon, context);
                                }
                              });
                            }),
                      )
                      /*  ],
                    ), */
                      )
                ],
              )),
        ));
  }
}
