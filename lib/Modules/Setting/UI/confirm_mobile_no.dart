import 'package:flutter/material.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:flutter/gestures.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';



class ConfirmMobileNo extends StatefulWidget {
 final  String? code;
 final  String phoneNo;
  const ConfirmMobileNo({Key? key,required this.code,required this.phoneNo}) : super(key: key);

  @override
  ConfirmMobileNoState createState() => ConfirmMobileNoState();
}

class ConfirmMobileNoState extends State<ConfirmMobileNo> {
  
  late String? code;
  late String phoneNo;
  late String verifyMobileCode;

  bool showError=false;

  @override
  void initState() {
    super.initState();
    code=widget.code;
    phoneNo=widget.phoneNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
        icon: Icon(FontAwesomeIcons.xmark,color: Theme.of(context).colorScheme.blackColor,),
        onPressed: () => Navigator.of(context).pop(),
      ),
        title: const Text(
          "Confirm Your Number",
          textAlign: TextAlign.left,
         style: CustomTextStyle.topHeading,
        ),
      ),
      body: 
           Container(
             padding: const EdgeInsets.all(35),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(top: 20),
                   child: Text("Enter the 4-digit code sent to " + code.toString()+phoneNo.toString(),
                    style: Theme.of(context).textTheme.headline6,
                   ),
                 ),
                Container(
                    alignment: Alignment.center,
                    padding:const EdgeInsets.fromLTRB(15, 50, 20, 20) ,
                     
                  child: VerificationCode(
                    textStyle: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.primryColor),
                    keyboardType: TextInputType.number,
                    underlineColor: Theme.of(context).primaryColor,
                    length: 4,
                    fullBorder :true,
                    onCompleted: (String value) {
                      setState(() {
                        
                      verifyMobileCode=value;
                        
                      });
                    },
                    onEditing: (bool value) {
                      
                    },
          ),
                ),
               
           showError==true?
                 Container(
                   padding:  const EdgeInsets.only(top: 20),
                   child: const Text("We are not able to verify the code.Make sure you enter the right mobile number and verification code.",style: TextStyle(fontSize: 14,color: Colors.red),)
                   ):Container(),

                  Container(
                    padding: const EdgeInsets.only(top:45),
                    child: RichText(text: 
                     TextSpan(children: [
                        TextSpan(
                            text: "Didn't get the code?  ",
                           style: Theme.of(context).textTheme.headline6,
                          
                            ),
                          
                        TextSpan(
                          text: "Resend",
                          style: Theme.of(context).textTheme.headline4,
                          recognizer: TapGestureRecognizer()
                              ..onTap = () {

                                  EasyLoading.addStatusCallback((status) {});
                                  EasyLoading.show(status: 'loading...');
                                editPhoneNumber(code!,phoneNo).then((value) {
                                    EasyLoading.dismiss();
                                });
                              },
                        ),
                      ])),
                  )
              ,
              Expanded(
                
                child:  Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                        
                          
                        style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(0.0),
                                        elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35)),

                                    ),
                         child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width / 7,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(5))
                                          ),
                                      child: Center(
                                        child: Text(
                                          'VERIFY',
                                          style: Theme.of(context).textTheme.headline3,
                                        ),
                                      ),
                                    ),
                        onPressed: (){
                           EasyLoading.addStatusCallback((status) {});
                            EasyLoading.show(status: 'loading...');
                            verifyPhoneNumber(verifyMobileCode).then((response){
                            
                              
                              if(response=="1")
                              { 
                                String _msg="Your phone number has been added successfully.";
                                  String title="";
                                  String _icon="assets/images/Success.json";
                                  showVerifyPhoneAlert(title,_msg,_icon,context); 
                              }
                              if(response=="-1")
                              { 
                                setState(() {
                                showError=true;
                                }); 
                                  setState(() {
                                    String _msg="Please enter the code again or resend.";
                                    String title="Invalid Verification Code";
                                    String _icon="assets/images/alert.json";
                                    showVerifyPhoneAlert(title,_msg,_icon,context); 
                                  });  
                              }
                              EasyLoading.dismiss();

                            }); 
                                
                     
                        },
                        
                        
                      ),
                ),
                )
                 ],
             ),
           )
          
     );
  }
}
