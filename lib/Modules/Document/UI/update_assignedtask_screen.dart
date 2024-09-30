import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UpdateAssignedTaskScreen extends StatefulWidget {
  const UpdateAssignedTaskScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAssignedTaskScreen> createState() =>
      _UpdateAssignedTaskScreenState();
}

class _UpdateAssignedTaskScreenState extends State<UpdateAssignedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final lightgreycolor = Theme.of(context).colorScheme.lightgrey;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.dashboardbackGround,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back,
                            size: 20, color: Color(0xffA7A8BB)
                            // color: lightgreycolor,
                            ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Get car inspection done',
                            style: CustomTextStyle.simpleText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.blackColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isDismissible: true,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  elevation: 0,
                                                  primary: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                ),
                                                child: Text(
                                                  "Edit Details",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3,
                                                ),
                                                onPressed: () {}),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  elevation: 0,
                                                  primary: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      "Delete Task",
                                                      style: CustomTextStyle
                                                          .simpleText
                                                          .copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {}),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: lightgreycolor,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Travel Docs",
                        style: CustomTextStyle.simpleText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffB5B5C3),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  DottedBorder(
                                    radius: const Radius.circular(12),
                                    borderType: BorderType.RRect,
                                    color: const Color(0xffB5B5C3),
                                    strokeWidth: .5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      child: Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        // margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Feb 6,2023',
                                                style: CustomTextStyle
                                                    .simpleText
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .blackColor,
                                                ),
                                              ),
                                              Text(
                                                "Created",
                                                style: CustomTextStyle
                                                    .simpleText
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffB5B5C3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Your existing container
                                  DottedBorder(
                                    radius: const Radius.circular(12),
                                    borderType: BorderType.RRect,
                                    color: const Color(0xffB5B5C3),
                                    strokeWidth: .5,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                      child: Container(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        // margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 26,
                                                width: 26,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Text(
                                                  'S',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                "Assigned",
                                                style: CustomTextStyle
                                                    .simpleText
                                                    .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffB5B5C3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                DottedBorder(
                                  radius: const Radius.circular(12),
                                  borderType: BorderType.RRect,
                                  color: const Color(0xffB5B5C3),
                                  strokeWidth: .5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                    child: Container(
                                      height: 70,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      // margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFFFFF),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Oct 12,2024',
                                              style: CustomTextStyle.simpleText
                                                  .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              "Due Date",
                                              style: CustomTextStyle.simpleText
                                                  .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xffB5B5C3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 361,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: CustomTextStyle.simpleText.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffB5B5C3),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Text(
                                "Call Andre +001 650 4585633 to schedule an inspection whenever possible in the next few weeks.",
                                style: CustomTextStyle.simpleText.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Container(
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                            child: Center(
                              child: Text(
                                'Mark as Completed',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: Container(
                                        height: 410,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/happy_music.png',
                                              scale: 3,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            const Text(
                                              "Are you sure?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                              "Tasks are critical for document renewalso we’d like you to be sure",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .warmGreyColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      elevation: 0,
                                                      primary: Theme.of(context)
                                                          .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                    ),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff00A3FF),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          6))),
                                                      child: Center(
                                                        child: Text(
                                                          'Mark as Completed',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                padding: const EdgeInsets.only(
                                                    bottom: 25),
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      elevation: 0,
                                                      primary: Colors.white,
                                                      // primary: Theme.of(context)
                                                      //     .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                    ),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              // color:
                                                              //     Theme.of(context)
                                                              //         .primaryColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          6))),
                                                      child: Center(
                                                        child: Text(
                                                          'Not yet, take me back',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline3!
                                                              .copyWith(
                                                                  color:
                                                                      lightgreycolor),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }))
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                        ),
                      )
                    ]),
              )),
        ));
  }
}
