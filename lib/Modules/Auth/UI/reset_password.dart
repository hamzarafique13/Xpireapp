import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Auth/UI/reset_pwd_msg.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class ResetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();

  ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.whiteColor,
        // centerTitle: true,
        // title: Text(
        //   "Password Reset",
        //   style: CustomTextStyle.topHeading
        //       .copyWith(color: Theme.of(context).primaryColor),
        // ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.all(25),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        "Password Reset",
                        style: Theme.of(context).textTheme.headline1,
                      )),
                  Text(
                    "Enter the email address associated with your account and we’ll send an email with instructions to reset your password.",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                      child: Text("Email Address",
                          style: Theme.of(context).textTheme.headline6)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextFormField(
                        controller: userNameController,
                        style: CustomTextStyle.textBoxStyle,
                        validator: (value) {
                          if (value == null) {
                            return 'Email address is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.textfiledColor,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(6)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(6.0)),
                          hintText: 'example@Xpiree.com',
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          child: Center(
                            child: Text(
                              'Send Instructions',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            EasyLoading.show(status: 'Sending...');
                            forgetPassword(userNameController.text)
                                .then((reponse) {
                              EasyLoading.dismiss();
                              if (reponse == "1") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPwdMsg(
                                          email: userNameController.text)),
                                );
                              } else if (reponse == "-1") {
                                showAlertDialog(
                                    "Oops!",
                                    "This email does not exist. Please try again with a valid email address.",
                                    context);
                              } else {
                                showAlertDialog(
                                    "Oops!",
                                    "An error has occurred in sending this email. Please try again.",
                                    context);
                              }
                            });
                          }
                        },
                      )),
                ],
              ))),
    );
  }
}
