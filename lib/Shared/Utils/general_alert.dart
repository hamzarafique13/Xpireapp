import 'package:Xpiree/Modules/Setting/UI/subscription_plan.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:Xpiree/Modules/Auth/UI/login.dart';
import 'package:Xpiree/Modules/Dashboard/Utils/DashboardDataHelper.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';

showAlertDialog(String title, String message, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
    ),
    content: Container(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.warmGreyColor),
      ),
    ),
    actions: [
      Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              alignment: Alignment.center,
              // width: MediaQuery.of(context).size.width * 0.35,
              color: Theme.of(context).colorScheme.textfiledColor,
              // padding: const EdgeInsets.all(2),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.textfiledColor)),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              height: 34,
              // width: MediaQuery.of(context).size.width * 0.35,
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                ),
                child: Text(
                  "Got it",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.whiteColor),
                ),
                onPressed: () {
                  gotItBtn().then((response) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          )
        ],
      ),
    ],
  );
  showDialog(context: context, builder: (_) => alertDialog);
}

showGotItDialog(String userName, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    content: SizedBox(
      height: MediaQuery.of(context).size.width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(userName + ",", style: Theme.of(context).textTheme.bodyText1),
          Text("welcome to Xpriee!",
              style: Theme.of(context).textTheme.bodyText1),
          Text("All your document in one place.",
              style: Theme.of(context).textTheme.headline6),
          Text("Create your first document by",
              style: Theme.of(context).textTheme.headline6),
          Text("clicking + Button on the bottom bar.",
              style: Theme.of(context).textTheme.headline6),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              child:
                  Text("Got it", style: Theme.of(context).textTheme.bodyText1),
              onPressed: () {
                gotItBtn().then((response) {
                  Navigator.of(context).pop();
                });
              },
            ),
          )
        ],
      ),
    ),
  );
  showDialog(
      barrierDismissible: false, context: context, builder: (_) => alertDialog);
}

showInvitationAlert(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/invitationSent.png",
              height: 80, width: 80),
          const Text("Invitation Sent", style: CustomTextStyle.topHeading)
        ],
      ),
    ),
    content: SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Container(
          alignment: Alignment.center,
          child: Column(
            children: const [
              Text("We’ve invited your friend via email to become",
                  style: CustomTextStyle.heading4, textAlign: TextAlign.center),
              Text("your Sharer. Once the invitation is accepted,",
                  style: CustomTextStyle.heading4, textAlign: TextAlign.center),
              Text("s/he will appear active in your sharer list.",
                  style: CustomTextStyle.heading4, textAlign: TextAlign.center),
            ],
          )),
    ),
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return alertDialog;
      });
}

showVerifyEmailAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(icon, height: 50, width: 50),
        Text(title, style: Theme.of(context).textTheme.headline1),
      ],
    ),
    content: Container(
        height: MediaQuery.of(context).size.width / 4,
        alignment: Alignment.center,
        child: Text(message, style: CustomTextStyle.heading3)),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        });
        return alertDialog;
      });
}

showVerifyPhoneAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(icon, height: 50, width: 50),
        Text(title),
      ],
    ),
    content: SizedBox(
        height: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            Text(message),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )),
  );
  showDialog(
      barrierDismissible: false, context: context, builder: (_) => alertDialog);
}

showDeleteSharerAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(icon, height: 50, width: 50),
        Text(title),
      ],
    ),
    content: SizedBox(
        height: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            Text(message),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )),
  );
  var data = showDialog<String>(
      barrierDismissible: false, context: context, builder: (_) => alertDialog);
  return data;
}

String showGeneralAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, height: 150, width: 150),
        Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    ),
    content: SizedBox(
        height: MediaQuery.of(context).size.width / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: Theme.of(context).textTheme.headline6),
          ],
        )),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        return alertDialog;
      });
  return "1";
}

String showInfoAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(icon, height: 50, width: 50),
          Text(title),
        ],
      ),
    ),
    content: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.06,
        padding: const EdgeInsets.all(2),
        child: Text(
          message,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        )),
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        return alertDialog;
      });
  return "1";
}

String showUpgradePackageAlert(
    String title, String message, String icon, BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    title: Lottie.asset(icon, height: 50, width: 50),
    content: Container(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.warmGreyColor),
      ),
    ),
    actions: [
      Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(10),
        child: TextButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.warmGreyColor)),
          ),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(10),
        child: TextButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
          ),
          child: Text(
            "Upgrade",
            style: TextStyle(color: Theme.of(context).colorScheme.whiteColor),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SubscriptionPlan()),
            );
          },
        ),
      )
    ],
  );
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        /*  Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });*/
        return alertDialog;
      });
  return "1";
}

showSliderAlert(String userName, BuildContext context) {
  bool _appWorkType = false;
  CarouselController btnCarouselCt = CarouselController();
  int activeIndex = 0;

  List<SliderList> sliderList = SliderList.getList();

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(8),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.zero,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CarouselSlider.builder(
                      carouselController: btnCarouselCt,
                      itemCount: sliderList.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Container(
                        padding: const EdgeInsets.all(5),
                        child: ListView(
                          children: [
                            itemIndex == 0
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 35),
                                    child: Text(
                                      "Hey, " +
                                          userName
                                              .split(" ")
                                              .map((str) => capitalize(str))
                                              .join(" "),
                                      style: CustomTextStyle.headingSize5,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Image.asset(sliderList[itemIndex].image,
                                    height: 150, width: 150),
                            Text(
                              sliderList[itemIndex].textStr,
                              style: CustomTextStyle.heading44,
                              textAlign: TextAlign.center,
                            ),
                            itemIndex == 0
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.only(top: 28),

                                    /// alignment: Alignment.center,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          primary:
                                              Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: Text(
                                          itemIndex == 4 ? "Finish" : "Next",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                        onPressed: () {
                                          if (itemIndex == 4) {
                                            gotItBtn().then((response) {
                                              Navigator.of(context).pop();
                                            });
                                          } else {
                                            btnCarouselCt.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear);
                                          }
                                        }),
                                  ),
                            itemIndex == 0
                                ? Container(
                                    padding: const EdgeInsets.only(top: 25),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          primary: Theme.of(context)
                                              .colorScheme
                                              .whiteColor,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .textBoxBorderColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /* Image.asset(
                                                "assets/Icons/personal.png"), */
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                "Personal",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .blackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          setAppWorkType(1).then((response) {
                                            _appWorkType = true;
                                          });
                                          btnCarouselCt.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.linear);
                                        }),
                                  )
                                : Container(),
                            itemIndex == 0
                                ? Container(
                                    padding: const EdgeInsets.only(top: 8),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          primary: Theme.of(context)
                                              .colorScheme
                                              .whiteColor,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .textBoxBorderColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /*    Image.asset("assets/Icons/work.png",
                                                width: 20, height: 20), */
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text("Work",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .blackColor,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          setAppWorkType(2).then((response) {
                                            _appWorkType = true;
                                          });
                                          btnCarouselCt.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.linear);
                                        }),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.45,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        viewportFraction: 1,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        pageSnapping: false,
                        onPageChanged: (index, reason) {
                          if (index > activeIndex) {
                            if (_appWorkType = true) {
                              setState(() {
                                activeIndex = index;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: sliderList.length,
                    onDotClicked: (index) => btnCarouselCt.nextPage(),
                    effect: WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: Theme.of(context).primaryColor,
                        dotColor:
                            Theme.of(context).colorScheme.textBoxBorderColor),
                  )
                ],
              ),
            ),
          );
        });
      });
}

Future<dynamic> confirmExitApp(BuildContext context) {
  return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Container(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Are you sure you want to exit the app?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.warmGreyColor),
              ),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .warmGreyColor)),
                      ),
                      child: Text(
                        "Return",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    padding: const EdgeInsets.all(10),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.whiteColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  )
                ],
              ),
            ],
          ));
}
