import 'package:flutter/services.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  FeedBackState createState() => FeedBackState();
}

class FeedBackState extends State<FeedBack> {
  final _formKey = GlobalKey<FormState>();
  FeedBackVm modal = FeedBackVm();
  TextEditingController subjectController = TextEditingController();
  TextEditingController detailController = TextEditingController();
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
            title: Text("Feedback",
                style: CustomTextStyle.topHeading.copyWith(
                  color: Theme.of(context).primaryColor,
                ))),
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text("Subject",
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        TextFormField(
                          controller: subjectController,
                          style: CustomTextStyle.textBoxStyle,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                                allow: true)
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Subject is required';
                            } else if (value.length > 35) {
                              return 'Maximum up 35 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              modal.subject = value;
                            });
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
                              hintText: 'Add subject here',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fadeGrayColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Text("Description",
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        TextFormField(
                            controller: detailController,
                            style: CustomTextStyle.textBoxStyle,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 12,
                            maxLength: 500,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Detail is required';
                              } else if (value.length > 500) {
                                return 'Maximum up 35 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                modal.detail = value;
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
                                hintText: 'Write feedback here',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor))),
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
                                      Radius.circular(6))),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                EasyLoading.addStatusCallback((status) {});
                                EasyLoading.show(status: 'loading...');
                                addFeedBack(modal).then((reponse) {
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);

                                  String _msg = "Feedback has been submitted.";
                                  String title = "";
                                  String _icon = "assets/images/Success.json";
                                  var response = showInfoAlert(
                                      title, _msg, _icon, context);
                                });
                              }
                            },
                          ),
                        ))
                      ],
                    ),
                  )))
        ]));
  }
}
