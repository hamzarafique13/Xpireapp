import 'dart:io';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:Xpiree/Shared/Model/shared_model.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Shared/Utils/GeneralFuncation.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/CommonConfig.dart';
import 'package:Xpiree/Shared/Utils/ddlLists.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  var maskMobileFormatter = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();

  UserInfo modal = UserInfo();
  XFile? previewImage;
  String userShortName = "";
  List<TblCountry> listofCountry = [];
  late String? phoneCode;
  var myFormat = DateFormat('MM/dd/yyyy');
  void _takeCameraImage() async {
    Navigator.pop(context);
    final _picker = ImagePicker();

    var _pickedImage = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (_pickedImage != null) {
        previewImage = _pickedImage;
        modal.uploadPic = _pickedImage;
      }
    });
  }

  void _uploadImage() async {
    Navigator.pop(context);
    final _picker = ImagePicker();
    var _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      previewImage = _pickedImage!;
      modal.uploadPic = _pickedImage;
    });
  }

  @override
  void initState() {
    fetchCountry().then((response) {
      EasyLoading.addStatusCallback((status) {});
      EasyLoading.show(status: 'loading...');
      setState(() {
        listofCountry = response!;
      });
      EasyLoading.dismiss();
    });
    getUserInfo().then((reponse) {
      EasyLoading.addStatusCallback((status) {});
      EasyLoading.show(status: 'loading...');
      setState(() {
        modal.id = reponse!.id;
        modal.name = reponse.name;
        modal.userName = reponse.userName;
        modal.email = reponse.email;
        modal.profilePic = reponse.profilePic;
        modal.uploadPic = reponse.uploadPic;
        modal.countryCode = reponse.countryCode;
        phoneCode = modal.countryCode!;
        modal.phoneNumber = reponse.phoneNumber;
        phoneController.text = modal.phoneNumber;
        if (reponse.countryId!.isNotEmpty) {
          modal.countryId = reponse.countryId;
        }
        var data = reponse.name.split(" ");
        for (int i = 0; i < 2; i++) {
          userShortName = userShortName + data[i][0];
        }
      });
      EasyLoading.dismiss();
    });

    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
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
            "Edit Profile",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.backgroundColor,
                        height: MediaQuery.of(context).size.width * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    // color: Color(0xff4FC2F8).withOpacity(0.1),
                                    // color: Theme.of(context)
                                    //     .colorScheme
                                    //     .backgroundColor,
                                    padding: const EdgeInsets.all(20),
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: modal.profilePic.isEmpty &&
                                              previewImage == null
                                          ? CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              child: Text(
                                                userShortName.toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                              radius: 50,
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              backgroundImage: previewImage !=
                                                      null
                                                  ? Image.file(File(
                                                          previewImage!.path))
                                                      .image
                                                  : modal.profilePic.isEmpty ||
                                                          modal.profilePic == ""
                                                      ? null
                                                      : CachedNetworkImageProvider(
                                                          imageUrl +
                                                              modal.profilePic),
                                              radius: 50,
                                            ),
                                      onTap: () {
                                        showAttachemnts(context);
                                      },
                                    )),
                                Positioned(
                                  top: 75,
                                  left:
                                      MediaQuery.of(context).size.width * 0.56,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 17,
                                    child: IconButton(
                                        icon: Icon(
                                          modal.profilePic.isEmpty &&
                                                  previewImage == null
                                              ? Icons.edit
                                              : Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          showAttachemnts(context);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Text(
                                  modal.name
                                      .split(" ")
                                      .map((str) => capitalize(str))
                                      .join(" "),
                                  style: Theme.of(context).textTheme.headline1,
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Text(modal.email,
                                    style:
                                        CustomTextStyle.heading5withoutBold)),
                          ],
                        ),
                      ),
                      // Container(
                      //   color: Theme.of(context).colorScheme.backgroundColor,
                      //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.only(bottom: 10),
                      //               child: Text(
                      //                 "Country Code",
                      //                 style:
                      //                     Theme.of(context).textTheme.headline6,
                      //               ),
                      //             ),
                      //             modal.countryCode == null
                      //                 ? Container(
                      //                     padding: const EdgeInsets.only(
                      //                         top: 3, bottom: 3),
                      //                     width: MediaQuery.of(context)
                      //                             .size
                      //                             .width *
                      //                         0.40,
                      //                     decoration: BoxDecoration(
                      //                         color: Theme.of(context)
                      //                             .colorScheme
                      //                             .textfiledColor,
                      //                         borderRadius:
                      //                             const BorderRadius.all(
                      //                                 Radius.circular(6))),
                      //                     child: CountryListPick(
                      //                       useUiOverlay: true,
                      //                       useSafeArea: false,
                      //                       theme: CountryTheme(
                      //                         isShowFlag: true,
                      //                         isShowTitle: false,
                      //                         isShowCode: true,
                      //                         isDownIcon: true,
                      //                         showEnglishName: false,
                      //                       ),
                      //                       initialSelection: 'US',
                      //                       onChanged: (CountryCode? code) {
                      //                         setState(() {
                      //                           phoneCode = code!.code!;
                      //                           modal.countryCode = code.code!;
                      //                         });
                      //                       },
                      //                     ),
                      //                   )
                      //                 : Container(),
                      //             modal.countryCode != null
                      //                 ? Container(
                      //                     padding: const EdgeInsets.only(
                      //                         top: 3, bottom: 3),
                      //                     width: MediaQuery.of(context)
                      //                             .size
                      //                             .width *
                      //                         0.44,
                      //                     decoration: const BoxDecoration(
                      //                         borderRadius: BorderRadius.all(
                      //                             Radius.circular(6))),
                      //                     child: CountryListPick(
                      //                       useUiOverlay: true,
                      //                       useSafeArea: false,
                      //                       theme: CountryTheme(
                      //                         isShowFlag: true,
                      //                         isShowTitle: false,
                      //                         isShowCode: true,
                      //                         isDownIcon: true,
                      //                         showEnglishName: false,
                      //                       ),
                      //                       initialSelection: phoneCode,
                      //                       onChanged: (CountryCode? code) {
                      //                         setState(() {
                      //                           modal.countryCode = code!.code!;
                      //                         });
                      //                       },
                      //                     ),
                      //                   )
                      //                 : Container()
                      //           ],
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Padding(
                      //               padding: const EdgeInsets.only(bottom: 10),
                      //               child: Text(
                      //                 "Phone",
                      //                 style:
                      //                     Theme.of(context).textTheme.headline6,
                      //               ),
                      //             ),
                      //             Container(
                      //               padding: const EdgeInsets.only(
                      //                   top: 3, bottom: 3),
                      //               width:
                      //                   MediaQuery.of(context).size.width * 0.5,
                      //               child: TextFormField(
                      //                 controller: phoneController,
                      //                 style: CustomTextStyle.textBoxStyle,
                      //                 keyboardType: TextInputType.number,
                      //                 inputFormatters: [maskMobileFormatter],
                      //                 validator: (value) {
                      //                   if (value!.isEmpty) {
                      //                     return 'Phone no is required';
                      //                   }
                      //                   return null;
                      //                 },
                      //                 onChanged: (value) {
                      //                   setState(() {
                      //                     modal.phoneNumber =
                      //                         value.replaceAll("-", "");
                      //                   });
                      //                 },
                      //                 decoration: InputDecoration(
                      //                     filled: true,
                      //                     fillColor: Theme.of(context)
                      //                         .colorScheme
                      //                         .textfiledColor,
                      //                     border: OutlineInputBorder(
                      //                         borderSide: BorderSide.none,
                      //                         borderRadius:
                      //                             BorderRadius.circular(6)),
                      //                     focusedBorder: OutlineInputBorder(
                      //                         borderSide: BorderSide.none,
                      //                         borderRadius:
                      //                             BorderRadius.circular(6.0)),
                      //                     hintText: 'Enter number',
                      //                     hintStyle: TextStyle(
                      //                         color: Theme.of(context)
                      //                             .colorScheme
                      //                             .fadeGrayColor)),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                          color: Theme.of(context).colorScheme.backgroundColor,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Country",
                                  style: Theme.of(context).textTheme.headline4),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                iconEnabledColor:
                                    Theme.of(context).iconTheme.color,
                                value: modal.countryId,
                                hint: Text("Select One",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fadeGrayColor)),
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
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Country is required';
                                  }
                                  return null;
                                },
                                items: listofCountry.map((TblCountry obj) {
                                  return DropdownMenuItem<String>(
                                    child: Text(
                                      obj.name,
                                    ),
                                    value: obj.name,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    modal.countryId = value as String;
                                  });
                                },
                              ),
                            ],
                          )),
                      // const SizedBox(
                      //   height: 220,
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // padding: const EdgeInsets.all(5),
                                        primary: Color(0xff00A3FF),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          "update ",
                                          style: CustomTextStyle.headingWhite
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      // Container(
                                      //     ,
                                      //     // alignment: Alignment.bottomCenter,
                                      //     color: Theme.of(context).colorScheme.backgroundColor,
                                      //     padding: const EdgeInsets.all(15),
                                      //     width: MediaQuery.of(context).size.width,
                                      //     child: ElevatedButton(
                                      //         style: ElevatedButton.styleFrom(
                                      //           padding: const EdgeInsets.all(0.0),
                                      //           elevation: 0,
                                      //           primary: Theme.of(context).primaryColor,
                                      //           shape: RoundedRectangleBorder(
                                      //               borderRadius: BorderRadius.circular(6)),
                                      //         ),
                                      //         child: Container(
                                      //           width: MediaQuery.of(context).size.width,
                                      //           // height: 50,
                                      //           // height: MediaQuery.of(context).size.width,
                                      //           decoration: BoxDecoration(
                                      //               color: Theme.of(context)
                                      //                   .colorScheme
                                      //                   .backgroundColor,
                                      //               borderRadius: const BorderRadius.all(
                                      //                   Radius.circular(6))),
                                      //           child: Center(
                                      //             child: Text(
                                      //               'Update',
                                      //               style:
                                      //                   Theme.of(context).textTheme.headline3,
                                      //             ),
                                      //           ),
                                      //         ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          EasyLoading.addStatusCallback(
                                              (status) {});
                                          EasyLoading.show(
                                              status: 'loading...');
                                          editProfile(modal).then((response) {
                                            if (response == "1") {
                                              SessionMangement _sm =
                                                  SessionMangement();
                                              setState(() {
                                                _sm.getUserName();
                                                _sm
                                                    .removeProfilePic()
                                                    .then((response) {
                                                  getUserInfo().then((value) {
                                                    _sm
                                                        .setUserName(
                                                            value!.name)
                                                        .then((response) {});
                                                    _sm
                                                        .setProfilePic(
                                                            value.profilePic)
                                                        .then((response) {});
                                                  });
                                                });
                                              });
                                              EasyLoading.dismiss();
                                              String _msg =
                                                  "Your profile has been updated.";
                                              String title = "";
                                              String _icon =
                                                  "assets/images/Success.json";
                                              var response = showInfoAlert(
                                                  title, _msg, _icon, context);
                                            }
                                          });
                                        }
                                      })),
                            ),
                          ],
                        ),
                      )
                    ],
                  )))
        ]));
  }

  Future<dynamic> showAttachemnts(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      barrierColor: Theme.of(context).colorScheme.whiteColor.withOpacity(0.1),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).colorScheme.profileEditColor,
          height: MediaQuery.of(context).size.height * 0.2,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _takeCameraImage,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).colorScheme.whiteColor,
                    child: Image.asset("assets/Icons/camera.png",
                        width: 25, height: 25),
                  ),
                ),
                const Text("Camera",
                    style: CustomTextStyle.heading5withoutBold),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _uploadImage,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).colorScheme.whiteColor,
                    child: Image.asset("assets/Icons/collections.png",
                        width: 25, height: 25),
                  ),
                ),
                const Text("Gallery",
                    style: CustomTextStyle.heading5withoutBold),
              ],
            ),
          ]),
        );
      },
    );
  }
}
