import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail> {
  final _formKey = GlobalKey<FormState>();
  late String verifyCode;
  late String email = widget.email;

  bool isDisable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(25),
          alignment: Alignment.center,
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.asset("assets/images/verifyemail.png",
                        width: 150, height: 150),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(15, 30, 20, 0),
                      child: Text(
                        "Verify your Email",
                        style: Theme.of(context).textTheme.headline1,
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                      child: const Text(
                        "A verification code has been sent to the",
                        style: CustomTextStyle.heading2,
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: const Text(
                        "email address you used for account setup",
                        style: CustomTextStyle.heading2,
                      )),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(15, 50, 20, 20),
                    child: VerificationCode(
                      textStyle: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColor),
                      keyboardType: TextInputType.number,
                      underlineColor: Theme.of(context).primaryColor,
                      length: 4,
                      fullBorder: true,
                      onCompleted: (String value) {
                        setState(() {
                          verifyCode = value;
                          isDisable = true;
                        });
                      },
                      onEditing: (bool value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        elevation: 0,
                        primary: isDisable == true
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.labelColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      onPressed: isDisable == true
                          ? () {
                              EasyLoading.addStatusCallback((status) {});
                              EasyLoading.show(status: 'loading...');
                              verifyEmailAddress(email, verifyCode)
                                  .then((response) {
                                if (response == "1") {
                                  String _msg = "Your email has been verified.";
                                  String title = "Congratulations!";
                                  String _icon = "assets/images/Success.json";
                                  showVerifyEmailAlert(
                                      title, _msg, _icon, context);
                                }
                                if (response == "-1") {
                                  setState(() {
                                    String _msg =
                                        "Please enter the code again or resend email.";
                                    String title = "Invalid Verification Code";
                                    String _icon = "assets/images/alert.json";
                                    showVerifyEmailAlert(
                                        title, _msg, _icon, context);
                                  });
                                }
                                EasyLoading.dismiss();
                              });
                            }
                          : null,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(children: [
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          child: const Text(
                            "Did not receive a mail? Try checking your spam filter",
                            style: CustomTextStyle.simpleText,
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                            text: "or ",
                            style: CustomTextStyle.simpleText,
                          ),
                          TextSpan(
                            text: "resend email.",
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF4FC3F7)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                forgetPassword(email).then((reponse) {
                                  String _msg =
                                      "The email verification code has been sent to your email.";
                                  String title = "";
                                  String _icon = "assets/images/Success.json";
                                  showInfoAlert(title, _msg, _icon, context);
                                });
                              },
                          )
                        ])),
                      ),
                    ]),
                  ),
                ],
              ))),
    );
  }
}
