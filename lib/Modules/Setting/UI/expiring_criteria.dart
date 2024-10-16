import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class ExpiringCriteria extends StatefulWidget {
  const ExpiringCriteria({Key? key}) : super(key: key);

  @override
  ExpiringCriteriaState createState() => ExpiringCriteriaState();
}

class ExpiringCriteriaState extends State<ExpiringCriteria> {
  int defaultCreteria = 60;
  TextEditingController criteriaController = TextEditingController();
  bool showError = false;

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {});
    EasyLoading.show(status: 'loading...');
    getUserInfo().then((response) {
      setState(() {
        criteriaController.text = response!.docExpiringCriteria.toString();

        defaultCreteria = response.docExpiringCriteria;
        if (response.docExpiringCriteria == 0) {
          defaultCreteria = 60;
          criteriaController.text = "60";
        }
      });
      EasyLoading.dismiss();
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
            "Expiring Criteria",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Specify how much time before a document becomes eligible for “Expiring” status.',
                      style: CustomTextStyle.simpleText,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2.6,
                      child: TextFormField(
                        controller: criteriaController,
                        style: CustomTextStyle.textBoxStyle,
                        keyboardType: TextInputType.number,
                        textAlign:
                            TextAlign.center, // Text ko center align karta hai
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              defaultCreteria = int.parse(value);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.textfiledColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical:
                                  10.0), // Text ko center align karne mein help karega
                          prefixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Icon(
                                  Icons.minimize,
                                  size: 18,
                                  color:
                                      Theme.of(context).colorScheme.whiteColor,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (defaultCreteria > 60) {
                                defaultCreteria = defaultCreteria - 1;
                                criteriaController.text =
                                    defaultCreteria.toString();
                              }
                            },
                          ),
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.whiteColor,
                                size: 15,
                              ),
                            ),
                            onPressed: () {
                              if (defaultCreteria == 0) {
                                defaultCreteria = 60;
                              }
                              if (defaultCreteria < 120) {
                                defaultCreteria = defaultCreteria + 1;
                                criteriaController.text =
                                    defaultCreteria.toString();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    showError == true
                        ? const Text(
                            "Please enter a number between 60-120",
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : Container(),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Days Before Expiration Date",
                        style: CustomTextStyle.heading5,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Can only be set between 60-120 days. Default is 60 days.',
                        style: CustomTextStyle.simpleText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width,
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                          text: "Try system default setting?",
                          style: CustomTextStyle.simpleText,
                        ),
                        TextSpan(
                          text: " Reset",
                          style: CustomTextStyle.heading2BlueBold,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              defaultCreteria = 60;
                              criteriaController.text =
                                  defaultCreteria.toString();
                            },
                        ),
                      ])),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0.0),
                          elevation: 0,
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff00A3FF),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Update',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (defaultCreteria < 60 || defaultCreteria > 120) {
                            setState(() {
                              showError = true;
                            });
                          } else {
                            EasyLoading.addStatusCallback((status) {});
                            EasyLoading.show(status: 'loading...');
                            setExpiringCriteria(defaultCreteria)
                                .then((reponse) {
                              EasyLoading.dismiss();
                              setState(() {
                                showError = false;
                              });
                              if (reponse == "1") {
                                String _msg =
                                    "Expiration criteria has been submitted.";
                                String title = "";
                                String _icon = "assets/images/Success.json";
                                var response =
                                    showInfoAlert(title, _msg, _icon, context);
                              }
                            });
                          }
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
