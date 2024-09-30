import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class ResetPwdMsg extends StatefulWidget {
  final String email;
  const ResetPwdMsg({Key? key, required this.email}) : super(key: key);

  @override
  ResetPwdMsgState createState() => ResetPwdMsgState();
}

class ResetPwdMsgState extends State<ResetPwdMsg> {
  late String email = widget.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Theme.of(context).primaryColor),
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Image.asset("assets/images/verifyemail.png",
                    width: 150, height: 150),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(15, 50, 20, 0),
                  child: Text(
                    "Check Your Mail",
                    style: Theme.of(context).textTheme.headline1,
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(15, 50, 20, 0),
                  child: Text(
                    "We've sent you a password reset link to",
                    style: Theme.of(context).textTheme.headline6,
                  )),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.headline6,
                  )),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const Text(
                                "Did not receive a mail?Try checking your spam folder",
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF777777)))),
                        Container(
                          alignment: Alignment.center,
                          child: RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                                text: "or ", style: CustomTextStyle.heading11),
                            TextSpan(
                              text: "resend email.",
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF4FC3F7)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  forgetPassword(email).then((reponse) {
                                    String _msg =
                                        "A link to create a new password has been sent to your email.";
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
              ),
            ],
          )),
    );
  }
}
