import 'package:Xpiree/Modules/Setting/UI/confirm_mobile_no.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditPhoneNumber extends StatefulWidget {
  const EditPhoneNumber({Key? key}) : super(key: key);

  @override
  EditPhoneNumberState createState() => EditPhoneNumberState();
}

class EditPhoneNumberState extends State<EditPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  var maskMobileFormatter = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  late String phoneNumber;
  late String phoneCode;
  @override
  void initState() {
    super.initState();
    phoneCode = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.backgroundColor,
          // backgroundColor: Color(0xff4FC2F8).withOpacity(0.1),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            padding: const EdgeInsets.all(15),
            icon: Icon(Icons.arrow_back, size: 20, color: Color(0xffA7A8BB)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Edit Phone Number",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "We use your number only for sending notifications and reminders.",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Text(
                                "Country",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textfiledColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              child: CountryListPick(
                                theme: CountryTheme(
                                  isShowFlag: true,
                                  isShowTitle: false,
                                  isShowCode: true,
                                  isDownIcon: false,
                                  showEnglishName: false,
                                ),
                                initialSelection: 'US',
                                onChanged: (CountryCode? code) {
                                  setState(() {
                                    phoneCode = code!.dialCode!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Mobile Number",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Container(
                            width: 230,
                            padding: const EdgeInsets.only(top: 3, bottom: 3),
                            child: TextFormField(
                              controller: numberController,
                              style: CustomTextStyle.textBoxStyle,
                              keyboardType: TextInputType.number,
                              inputFormatters: [maskMobileFormatter],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Mobile no is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  phoneNumber = value.replaceAll("-", "");
                                });
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .textfiledColor,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(6)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(6.0)),
                                  hintText: 'Enter number',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fadeGrayColor)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 50,
                // ),
                // Text(
                //   "A 4-digit code will be sent to your mobile number for verification.Standard message and data rates apply.",
                //   style: Theme.of(context).textTheme.headline6,
                // ),
                // const SizedBox(
                //   height: 50,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 8,
                    decoration: BoxDecoration(
                        color: Color(0xff00A3FF),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Center(
                      child: Text(
                        'Send Verification Code',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (phoneCode == "") {
                        phoneCode = '+1';
                      }
                      EasyLoading.show(status: 'loading...');
                      editPhoneNumber(phoneCode, phoneNumber).then((reponse) {
                        EasyLoading.dismiss();
                        if (reponse == "1") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmMobileNo(
                                      code: phoneCode,
                                      phoneNo: phoneNumber,
                                    )),
                          );
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
