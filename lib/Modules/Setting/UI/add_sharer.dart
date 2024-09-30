import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Modules/Setting/UI/sharer_list.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

// ignore: must_be_immutable
class AddSharer extends StatefulWidget {
  TblUserSharer forumModel = TblUserSharer();
  AddSharer({Key? key}) : super(key: key);

  @override
  AddSharerState createState() => AddSharerState();
}

class AddSharerState extends State<AddSharer> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.backgroundColor,
            centerTitle: true,
            elevation: 0.0,
            leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, size: 20, color: Color(0xffA7A8BB)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SharerList()),
                  );
                }),
            title: Text(
              "Add a Sharer",
              textAlign: TextAlign.left,
              style: CustomTextStyle.topHeading.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Row(
                      children: [
                        Text("Sharer's Name",
                            style: Theme.of(context).textTheme.headline6),
                        // Text("*",
                        //     style: TextStyle(
                        //         color:
                        //             Theme.of(context).colorScheme.redColor)),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    style: CustomTextStyle.textBoxStyle,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                          allow: true)
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      } else if (value.length > 35) {
                        return 'Maximum up 35 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.textfiledColor,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6.0)),
                        hintText: 'Leslie Alexander',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.fadeGrayColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 10),
                    child: Row(
                      children: [
                        Text("Sharer's Email",
                            style: Theme.of(context).textTheme.headline6),
                        // Text("*",
                        //     style: TextStyle(
                        //         color:
                        //             Theme.of(context).colorScheme.redColor)),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: CustomTextStyle.textBoxStyle,
                    validator: (value) {
                      String pattern =
                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regex = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'Email is required';
                      } else if (value.length > 35) {
                        return 'Maximum up 35 characters';
                      } else if (!regex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.textfiledColor,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6.0)),
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.fadeGrayColor)),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2.5,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         padding: const EdgeInsets.all(0.0),
                  //         elevation: 0,
                  //         primary: Theme.of(context)
                  //             .colorScheme
                  //             .textfiledColor,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6),
                  //           side: BorderSide(
                  //               color: Theme.of(context)
                  //                   .colorScheme
                  //                   .textfiledColor),
                  //         ),
                  //       ),
                  //       child: const Text("Cancel",
                  //           style: CustomTextStyle.heading44),
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //         Navigator.of(context).pop();
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const SharerList()),
                  //         );
                  //       }),
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0.0),
                                elevation: 0,
                                // primary: Theme.of(context).primaryColor,
                                primary: Color(0xff00A3FF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text("Add",
                                  style: CustomTextStyle.headingWhite.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  EasyLoading.show(status: 'Saving...');
                                  addSharer(emailController.text,
                                          nameController.text)
                                      .then((response) {
                                    String _msg;
                                    if (response == "1") {
                                      EasyLoading.dismiss();
                                      String _msg = "Sharer has been added.";
                                      String title = "";
                                      String _icon =
                                          "assets/images/Success.json";
                                      var response = showInfoAlert(
                                          title, _msg, _icon, context);
                                    }
                                    if (response == "-3") {
                                      EasyLoading.dismiss();
                                      _msg =
                                          "This sharer already exists in the system.";
                                      String title = "";
                                      String _icon = "assets/images/alert.json";
                                      var response = showInfoAlert(
                                          title, _msg, _icon, context);
                                    }
                                    if (response == "4") {
                                      EasyLoading.dismiss();
                                      var response =
                                          showInvitationAlert(context);
                                    }
                                    if (response == "-4") {
                                      _msg =
                                          "This email address belongs to this account. Try another email.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon = "assets/images/alert.json";
                                      var response = showInfoAlert(
                                          title, _msg, _icon, context);
                                    } else if (response == "-5") {
                                      String _msg =
                                          "You have limited No. of resources for adding more sharers!\n \n Please upgrade your plan.";
                                      EasyLoading.dismiss();
                                      String title = "";
                                      String _icon = "assets/images/alert.json";
                                      var response = showUpgradePackageAlert(
                                          title, _msg, _icon, context);
                                    }
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              //     ),
              //   )
              // ]),
            ),
          )),
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SharerList()),
        );
        return true;
      },
    );
  }
}
