import 'package:Xpiree/Modules/Document/Utils/DocumentDataHelper.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/UI/payment_gateway.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubscriptionPlan extends StatefulWidget {
  const SubscriptionPlan({Key? key}) : super(key: key);

  @override
  SubscriptionPlanState createState() => SubscriptionPlanState();
}

class SubscriptionPlanState extends State<SubscriptionPlan> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  var userPackage;
  List<TblPackage> packageList = [];
  @override
  void initState() {
    super.initState();
    getPackageList().then((value) {
      setState(() {
        packageList = value!;
        EasyLoading.dismiss();
      });
    });
    getUserPackage().then((response) {
      userPackage = response;
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
            padding: const EdgeInsets.all(15),
            icon: const Icon(Icons.arrow_back,
                size: 20, color: Color(0xffA7A8BB)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Pricing",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor, fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: packageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Card(
                          color: Theme.of(context).colorScheme.textfiledColor,

                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          // padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: GestureDetector(
                              onTap: () {
                                planDetail(context, packageList[index]);
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(children: [
                                        packageList[index].price == 0
                                            ? TextSpan(
                                                text: 'Free',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .blackColor,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : TextSpan(
                                                text: '\$' +
                                                    packageList[index]
                                                        .price
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .blackColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ]),
                                      TextSpan(children: [
                                        TextSpan(
                                            text: " /month",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .blackColor)),
                                      ]),
                                    ])),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .blackColor,
                                    )
                                  ],
                                ),
                                title: Transform.translate(
                                  offset: const Offset(5, 0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(packageList[index].title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                      userPackage.id == packageList[index].id
                                          ? Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                //color: Theme.of(context).colorScheme.iconBackColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  style: BorderStyle.solid,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Text("Current Plan",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                          : Container()
                                    ],
                                  ),
                                ),
                                subtitle: packageList[index].price == 0
                                    ? Container()
                                    : Transform.translate(
                                        offset: const Offset(5, 0),
                                        child: Text(
                                          'Billed annually',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          // style: Theme.of(context)
                                          //     .textTheme
                                          //     .headline6!
                                          //     .copyWith(
                                          //         color: Color(0xFFD8D8D8)

                                          // )
                                        ),
                                      ),
                                iconColor:
                                    Theme.of(context).colorScheme.blackColor,
                              )),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

Future<dynamic> planDetail(BuildContext context, TblPackage _modal) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //   topRight: Radius.circular(20),
    //   topLeft: Radius.circular(20),
    // )),
    builder: (_) {
      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0),
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.blackColor,
                        ))),
                const Text("Personal",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("\$" + _modal.price.toString() + " / month",
                        style: CustomTextStyle.heading2BlueBold
                            .copyWith(fontWeight: FontWeight.w400)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Billed annually \$" + (_modal.price * 12).toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                _modal.isUnlimitedDocument == true
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text("Unlimited Documents",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.grey)),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text(
                                "Create up to " +
                                    _modal.noOfDocument.toString() +
                                    " documents",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14)),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "Attach up to " +
                            _modal.attachPerDoc.toString() +
                            " files per document",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "File upload size up to " +
                            ((_modal.perAttachSize / 1024) / 1024)
                                .toStringAsFixed(0) +
                            " MB",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "Share up to " +
                            (_modal.noOfDocShare).toString() +
                            " documents",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "Share up to " +
                            _modal.docShareWithShare.toString() +
                            " documents with a sharer",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _modal.isUnlimitedFolder == true
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text(
                              "Unlimited folders",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text(
                              "Maximum " +
                                  _modal.noOfFolderAllow.toString() +
                                  " folders",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                _modal.isUnlimitedSharers == false
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text(
                              "Add up to " +
                                  _modal.noOfSharerAllow.toString() +
                                  " sharers",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Icon(FontAwesomeIcons.check,
                                  color: Colors.green, size: 20),
                            ),
                            Text(
                              "Unlimited Sharers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "Document storage up to " +
                            ((_modal.totalStorage / 1024) / 1024)
                                .toStringAsFixed(0) +
                            " MBs",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        "Create up to 30 folders " +
                            _modal.noOfTaskPerDoc.toString() +
                            " Tasks",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        _modal.allowToShareTask == true
                            ? "Can share task"
                            : "Can't share a task",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        _modal.ads == true ? "Ads included" : "No Ads",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.check,
                            color: Colors.green, size: 20),
                      ),
                      Text(
                        _modal.support == true ? "Support" : "No Support",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _modal.price == 0
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.fromLTRB(30, 26, 26, 0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              primary: const Color(0xff00A3FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Upgrade ",
                                // to " + _modal.title,
                                style: CustomTextStyle.headingWhite,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentGateway(modal: _modal)));
                            }),
                      ),
              ],
            ),
          ),
        );
      });
    },
  );
}
