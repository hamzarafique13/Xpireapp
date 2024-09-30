import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Xpiree/Modules/Auth/Model/AuthModel.dart';
import 'package:Xpiree/Modules/Auth/UI/create_account.dart';
import 'package:Xpiree/Modules/Auth/UI/reset_password.dart';
import 'package:Xpiree/Modules/Auth/UI/verify_email.dart';
import 'package:Xpiree/Modules/Auth/Utils/authDataHelper.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/SessionMangement.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isShowPassword = false;
  SignIn modal = SignIn();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  ExternalAuthDto externalModal = ExternalAuthDto();
  final SessionMangement _sm = SessionMangement();

  @override
  void initState() {
    super.initState();
    setState(() {
      modal.rememberMe = false;
      userNameController.text = "";
      passwordController.text = "";
      _sm.getRememberMe().then((response) {
        setState(() {
          if (response == null) {
            modal.rememberMe = false;
            userNameController.text = "";
            passwordController.text = "";
          } else {
            modal.rememberMe = response;
            _sm.getEmail().then((response) {
              setState(() {
                userNameController.text = response!;
              });
            });
            _sm.getPassword().then((response) {
              setState(() {
                passwordController.text = response!;
              });
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: const Text(
                              "Log in to your account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  // color: Theme.of(context).primaryColor,
                                  fontSize: 24),
                            )),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 25),
                            child: const Text(
                              "Welcome to Xpiree!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  // color: Theme.of(context)
                                  //     .colorScheme
                                  //     .fadeGrayColor,
                                  fontSize: 16),
                            )),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          padding: const EdgeInsets.all(15),
                          primary: Theme.of(context).colorScheme.whiteColor,
                          onPrimary: Theme.of(context).colorScheme.marineColor,
                          side: BorderSide(
                              width: 1.5,
                              color:
                                  Theme.of(context).colorScheme.fadeGrayColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
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
                              child: Text(
                                "Log in with Google",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .blackColor,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          GoogleSignInAccount? googleSignInAccount =
                              await _googleSignIn.signIn();
                          externalModal.id = googleSignInAccount!.id;
                          externalModal.email = googleSignInAccount.email;
                          externalModal.name = googleSignInAccount.displayName!;
                          externalLogin(externalModal).then((response) {
                            if (response.accessToken.isNotEmpty &&
                                response.userName.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard(
                                          indexTab: 0,
                                        )),
                              );
                            }
                          });
                        }),
                    const SizedBox(
                      height: 50,
                    ),

                    Text("Email", style: Theme.of(context).textTheme.headline6),

                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        controller: userNameController,
                        style: CustomTextStyle.textBoxStyle,
                        validator: (value) {
                          String pattern =
                              r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp regex = RegExp(pattern);

                          if (value!.isEmpty) {
                            return 'Email Address is required';
                          } else if (value.length > 35) {
                            return 'Maximum up 35 characters';
                          } else if (!regex.hasMatch(value)) {
                            return 'Invalid email';
                          }
                          return null;
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
                            //     fillColor:
                            //         Theme.of(context).colorScheme.textfiledColor,
                            //     border: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //         borderRadius: BorderRadius.circular(6)),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide.none,
                            //         borderRadius: BorderRadius.circular(6.0)),
                            hintText: 'example@Xpiree.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.blackColor,
                            ),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .fadeGrayColor)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text("Password",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        obscureText: !isShowPassword,
                        style: CustomTextStyle.textBoxStyle,
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        // decoration: InputDecoration(
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
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.fadeGrayColor,
                                fontSize: 12),
                            // filled: true,
                            // fillColor:
                            //     Theme.of(context).colorScheme.textfiledColor,
                            // border: OutlineInputBorder(
                            //     borderSide: BorderSide.none,
                            //     borderRadius: BorderRadius.circular(6)),
                            // focusedBorder: OutlineInputBorder(
                            //     borderSide: BorderSide.none,
                            //     borderRadius: BorderRadius.circular(6.0)),
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
                                }),
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.blackColor,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  activeColor: Theme.of(context).primaryColor,
                                  value: modal.rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      modal.rememberMe = value!;
                                    });
                                  }),
                              Text(
                                " Remember Me",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 8,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        child: Center(
                          child: Text(
                            'Log in',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          EasyLoading.show(
                              status: 'Checking Authentication...');

                          login(userNameController.text,
                                  passwordController.text, modal.rememberMe)
                              .then((reponse) {
                            EasyLoading.dismiss();

                            if (reponse!.responseApi == "-1") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyEmail(
                                        email: userNameController.text)),
                              );
                            } else if (reponse.responseApi == "-2") {
                              showInfoAlert(
                                  "Oops!",
                                  "Incorrect email or password.",
                                  "assets/images/alert.json",
                                  context);
                            } else if (reponse.accessToken.isNotEmpty &&
                                reponse.userName.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard(
                                          indexTab: 0,
                                        )),
                              );
                              /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NavigationBottom(
                                    selectedIndex: 0, dashboardTabIndex: 0)),
                          ); */
                            }
                          });
                        }
                      },
                    ),
                    Center(
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                          // visualDensity: const VisualDensity(
                          //     horizontal: -4, vertical: -4),
                        ),
                        child: Text('Reset Password',
                            style:
                                //  modal.rememberMe == true
                                // ? CustomTextStyle.heading6WithBlue
                                // :
                                Theme.of(context).textTheme.headline6),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ));
                        },
                      ),
                    ),
                    // Container(
                    //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    //     child: Divider(
                    //         thickness: 1,
                    //         color: Theme.of(context)
                    //             .colorScheme
                    //
                    //           .textBoxBorderColor)),

                    // Center(
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     height: 50,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color:
                    //             Theme.of(context).colorScheme.textBoxFillColor,
                    //         borderRadius: BorderRadius.circular(25)),
                    //     child: Image.asset(
                    //       'assets/Icons/google.png',
                    //       height: 25,
                    //       width: 25,
                    //     ),
                    //   ),
                    // ),

                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account?",
                                    style:
                                        Theme.of(context).textTheme.headline2),
                                TextButton(
                                  child: const Text('Create new',
                                      style: CustomTextStyle.heading2BlueBold),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateAccount()),
                                    );
                                  },
                                )
                              ],
                            )))
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
