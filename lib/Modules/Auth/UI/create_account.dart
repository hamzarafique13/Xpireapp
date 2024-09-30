import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Auth/UI/login.dart';
import 'package:Xpiree/Modules/Auth/UI/verify_email.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  SignUp obj = SignUp();
  bool isShowPassword = false;
  bool isRememberMe = false;
  bool isAceptTerm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  ExternalAuthDto externalModal = ExternalAuthDto();
  bool? passlength;
  bool? passNumber;
  bool? passSpecial;
  bool? capitalAlpha;
  bool? smallAlpha;
  late int validationColor1 = 0xFFA4A3A3;
  late int validationColor2 = 0xFFA4A3A3;
  late int validationColor3 = 0xFFA4A3A3;
  late int validationColor4 = 0xFFA4A3A3;
  late int validationColor5 = 0xFFA4A3A3;
  bool isErrorListActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.backgroundColor,
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: const Text(
                              "Create account",
                              style: TextStyle(
                                  // color: Theme.of(context).primaryColor,
                                  fontSize: 34),
                            )),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                            child: Text("Get started by creating your account.",
                                style: Theme.of(context).textTheme.headline4)),
                        // Container(
                        //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                        //     child: Text(
                        //       "penalties again.",
                        //       style: TextStyle(
                        //           color: Theme.of(context).primaryColor,
                        //           fontSize: 26),
                        //     )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              padding: const EdgeInsets.all(15),
                              primary: Theme.of(context).colorScheme.whiteColor,
                              onPrimary:
                                  Theme.of(context).colorScheme.marineColor,
                              side: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fadeGrayColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Icons/google.png',
                                  height: 20,
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text("Sign up with Google",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .blackColor,
                                          fontSize: 18)),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              GoogleSignInAccount? googleSignInAccount =
                                  await _googleSignIn.signIn();
                              externalModal.id = googleSignInAccount!.id;
                              externalModal.email = googleSignInAccount.email;
                              externalModal.name =
                                  googleSignInAccount.displayName!;
                              externalLogin(externalModal).then((response) {
                                if (response.accessToken.isNotEmpty &&
                                    response.userName.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Dashboard(
                                              indexTab: 1,
                                            )),
                                  );
                                }
                              });
                            }),
                        const SizedBox(
                          height: 50,
                        ),
                        Text("Name*",
                            style: Theme.of(context).textTheme.headline6),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: CustomTextStyle.textBoxStyle,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                                  allow: true)
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              } else if (value.length > 35) {
                                return 'Maximum up 35 characters';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                obj.name = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                // decoration: InputDecoration(
                                //     filled: true,
                                //     fillColor: Theme.of(context)
                                //         .colorScheme
                                //         .textfiledColor,
                                //     border: OutlineInputBorder(
                                //         borderSide: BorderSide.none,
                                //         borderRadius: BorderRadius.circular(6)),
                                //     focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide.none,
                                //         borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Leslie Alexander',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text("Email*",
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            controller: emailController,
                            style: CustomTextStyle.textBoxStyle,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              String pattern =
                                  r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                              RegExp regex = RegExp(pattern);

                              if (value!.isEmpty) {
                                return 'Email is required';
                              } else if (value.length > 35) {
                                return 'Maximum up 35 characters';
                              } else if (!regex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                obj.email = value;
                              });
                            },
                            decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                hintText: 'example@Xpiree.com',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text("Password*",
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            obscureText: !isShowPassword,
                            controller: passwordController,
                            style: CustomTextStyle.textBoxStyle,
                            validator: (value) {
                              // String  pattern =r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,}$';
                              String lengthChar = r'^.{8,}$';
                              String numberPattern = r'^(?=.*?[0-9])';
                              String specialPattern = r'^(?=.*?[!@#\$&*~-])';
                              String oneUpperPattern = r'^(?=.*[A-Z])';
                              String oneLowerPattern = r'^(?=.*[a-z])';
                              RegExp regex1 = RegExp(lengthChar);
                              RegExp regex2 = RegExp(numberPattern);
                              RegExp regex3 = RegExp(specialPattern);
                              RegExp regex4 = RegExp(oneUpperPattern);
                              RegExp regex5 = RegExp(oneLowerPattern);
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              if (!regex1.hasMatch(value)) {
                                setState(() {
                                  passlength = false;
                                  validationColor1 = 0xFFFF0000;
                                });
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                                return '';
                              } else {
                                setState(() {
                                  passlength = true;
                                  validationColor1 = 0xFF4BB543;
                                });
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex2.hasMatch(value)) {
                                setState(() {
                                  passNumber = false;
                                  validationColor2 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                                return '';
                              } else {
                                setState(() {
                                  passNumber = true;
                                  validationColor2 = 0xFF4BB543;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex3.hasMatch(value)) {
                                setState(() {
                                  passSpecial = false;
                                  validationColor3 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                                return '';
                              }
                              if (!regex4.hasMatch(value)) {
                                setState(() {
                                  capitalAlpha = false;
                                  validationColor4 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                                return '';
                              }
                              if (!regex5.hasMatch(value)) {
                                setState(() {
                                  capitalAlpha = false;
                                  validationColor4 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }

                                return '';
                              } else {
                                setState(() {
                                  passSpecial = true;
                                  validationColor3 = 0xFF4BB543;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                obj.password = value;
                                isErrorListActive = true;
                              });
                              String lengthChar = r'^.{8,}$';
                              String numberPattern = r'^(?=.*?[0-9])';
                              String specialPattern = r'^(?=.*?[!@#\$&*~-])';
                              String oneUpperPattern = r'^(?=.*[A-Z])';
                              String oneLowerPattern = r'^(?=.*[a-z])';
                              RegExp regex1 = RegExp(lengthChar);
                              RegExp regex2 = RegExp(numberPattern);
                              RegExp regex3 = RegExp(specialPattern);
                              RegExp regex4 = RegExp(oneUpperPattern);
                              RegExp regex5 = RegExp(oneLowerPattern);

                              if (!regex1.hasMatch(value)) {
                                setState(() {
                                  passlength = false;
                                  validationColor1 = 0xFFFF0000;
                                });
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              } else {
                                setState(() {
                                  passlength = true;
                                  validationColor1 = 0xFF4BB543;
                                });
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex2.hasMatch(value)) {
                                setState(() {
                                  passNumber = false;
                                  validationColor2 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              } else {
                                setState(() {
                                  passNumber = true;
                                  validationColor2 = 0xFF4BB543;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex3.hasMatch(value)) {
                                setState(() {
                                  passSpecial = false;
                                  validationColor3 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex4.hasMatch(value)) {
                                setState(() {
                                  capitalAlpha = false;
                                  validationColor4 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              }
                              if (!regex5.hasMatch(value)) {
                                setState(() {
                                  capitalAlpha = false;
                                  validationColor4 = 0xFFFF0000;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                              } else {
                                setState(() {
                                  passSpecial = true;
                                  validationColor3 = 0xFF4BB543;
                                });
                                if (!regex1.hasMatch(value)) {
                                  setState(() {
                                    passlength = false;
                                    validationColor1 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passlength = true;
                                    validationColor1 = 0xFF4BB543;
                                  });
                                }
                                if (!regex2.hasMatch(value)) {
                                  setState(() {
                                    passNumber = false;
                                    validationColor2 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passNumber = true;
                                    validationColor2 = 0xFF4BB543;
                                  });
                                }
                                if (!regex3.hasMatch(value)) {
                                  setState(() {
                                    passSpecial = false;
                                    validationColor3 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    passSpecial = true;
                                    validationColor3 = 0xFF4BB543;
                                  });
                                }
                                if (!regex4.hasMatch(value)) {
                                  setState(() {
                                    capitalAlpha = false;
                                    validationColor4 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    capitalAlpha = true;
                                    validationColor4 = 0xFF4BB543;
                                  });
                                }
                                if (!regex5.hasMatch(value)) {
                                  setState(() {
                                    smallAlpha = false;
                                    validationColor5 = 0xFFFF0000;
                                  });
                                } else {
                                  setState(() {
                                    smallAlpha = true;
                                    validationColor5 = 0xFF4BB543;
                                  });
                                }
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Create a password',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                        isShowPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 20),
                                    onPressed: () {
                                      setState(() {
                                        isShowPassword = !isShowPassword;
                                      });
                                    })),
                          ),
                        ),
                        isErrorListActive == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  passlength == null
                                      ? Text("should be atleast 8 characters",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(validationColor1)))
                                      : Row(
                                          children: [
                                            passlength == true
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        Color(validationColor1),
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color:
                                                        Color(validationColor1),
                                                    size: 15,
                                                  ),
                                            Text(
                                                "should be atleast 8 characters",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        validationColor1))),
                                          ],
                                        ),
                                  passNumber == null
                                      ? Text("must contain one number",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(validationColor2)))
                                      : Row(
                                          children: [
                                            passNumber == true
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        Color(validationColor2),
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color:
                                                        Color(validationColor2),
                                                    size: 15,
                                                  ),
                                            Text("must contain one number",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        validationColor2))),
                                          ],
                                        ),
                                  passSpecial == null
                                      ? Text("one special character",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(validationColor3)))
                                      : Row(
                                          children: [
                                            passSpecial == true
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        Color(validationColor3),
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color:
                                                        Color(validationColor3),
                                                    size: 15,
                                                  ),
                                            Text("one special character",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        validationColor3))),
                                          ],
                                        ),
                                  capitalAlpha == null
                                      ? Text("one capital alphabet",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(validationColor4)))
                                      : Row(
                                          children: [
                                            capitalAlpha == true
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        Color(validationColor4),
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color:
                                                        Color(validationColor4),
                                                    size: 15,
                                                  ),
                                            Text("one capital alphabet",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        validationColor4))),
                                          ],
                                        ),
                                  capitalAlpha == null
                                      ? Text("one small alphabet",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(validationColor4)))
                                      : Row(
                                          children: [
                                            smallAlpha == true
                                                ? Icon(
                                                    Icons.check,
                                                    color:
                                                        Color(validationColor5),
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color:
                                                        Color(validationColor5),
                                                    size: 15,
                                                  ),
                                            Text("one small alphabet",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        validationColor5))),
                                          ],
                                        ),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Confirm password*",
                            style: Theme.of(context).textTheme.headline6),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: CustomTextStyle.textBoxStyle,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                                  allow: true)
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              } else if (value.length > 35) {
                                return 'Maximum up 35 characters';
                              }
                              return null;
                            },
                            // onChanged: (value) {
                            //   setState(() {
                            //     obj.name = value;
                            //   });
                            // },
                            decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .expiredColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textBoxBorderColor),
                                    borderRadius: BorderRadius.circular(5.0)),
                                // decoration: InputDecoration(
                                //     filled: true,
                                //     fillColor: Theme.of(context)
                                //         .colorScheme
                                //         .textfiledColor,
                                //     border: OutlineInputBorder(
                                //         borderSide: BorderSide.none,
                                //         borderRadius: BorderRadius.circular(6)),
                                //     focusedBorder: OutlineInputBorder(
                                //         borderSide: BorderSide.none,
                                //         borderRadius: BorderRadius.circular(6.0)),
                                hintText: 'Confirm password',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isAceptTerm,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    isAceptTerm = value!;
                                  });
                                },
                              ),
                              const Text(
                                " I agree with ",
                                style: CustomTextStyle.heading4,
                              ),
                              GestureDetector(
                                child: const Text(
                                  "Terms & Privacy Policy. ",
                                  style: CustomTextStyle.heading1,
                                ),
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      'https://xpiree.com/termsprivacypolicy'));
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              elevation: 0,
                              primary: isAceptTerm == true
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .textfiledColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Center(
                              child: Text(
                                'Create',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            onPressed: isAceptTerm == true
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      EasyLoading.show(status: 'Saving...');
                                      signUp(obj).then((reponse) {
                                        EasyLoading.dismiss();
                                        if (reponse == "1") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerifyEmail(
                                                        email: emailController
                                                            .text)),
                                          );
                                        } else if (reponse == "-3") {
                                          String _msg =
                                              "This email is already in use.";
                                          EasyLoading.dismiss();
                                          String title = "";
                                          String _icon =
                                              "assets/images/alert.json";
                                          var response2 = showInfoAlert(
                                              title, _msg, _icon, context);
                                        } else if (reponse == "-1") {
                                          String _msg =
                                              "An error has occurred in sending this email. Please try again.";
                                          EasyLoading.dismiss();
                                          String title = "";
                                          String _icon =
                                              "assets/images/alert.json";
                                          var response2 = showInfoAlert(
                                              title, _msg, _icon, context);
                                        }
                                      });
                                    }
                                  }
                                : null,
                          ),
                        ),
                        // Container(
                        // height: 50,
                        // alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     border: Border.all(
                        //         width: 1.5,
                        //         color: Theme.of(context)
                        //             .colorScheme
                        //             .fadeGrayColor)),
                        // child:

                        // ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Already have an account?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                    TextButton(
                                      child: const Text('Log in',
                                          style:
                                              CustomTextStyle.heading2BlueBold),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                        );
                                      },
                                    )
                                  ],
                                )))
                      ],
                    ),
                  )))
        ]));
  }
}
