import 'package:Xpiree/Modules/Setting/Model/SettingModel.dart';
import 'package:Xpiree/Modules/Setting/Utils/SettingDataHelper.dart';
import 'package:Xpiree/Shared/UI/CustomColorScheme.dart';
import 'package:Xpiree/Shared/Utils/general_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentGateway extends StatefulWidget {
  final TblPackage modal;
  const PaymentGateway({Key? key, required this.modal}) : super(key: key);

  @override
  PaymentGatewayState createState() => PaymentGatewayState(modal);
}

class PaymentGatewayState extends State<PaymentGateway> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController expiryMonthController = TextEditingController();
  TextEditingController expiryYearController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  AddStripeCustomer modal = AddStripeCustomer();
  AddStripeCard subModal = AddStripeCard();
  AddStripePayment paymentModal = AddStripePayment();
  final _formKey = GlobalKey<FormState>();
  final TblPackage _package;
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  PaymentGatewayState(this._package);
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
            icon: Icon(Icons.arrow_back, color: Color(0xffA7A8BB)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Payment information",
            textAlign: TextAlign.left,
            style: CustomTextStyle.topHeading
                .copyWith(color: Theme.of(context).primaryColor),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          color: Theme.of(context).colorScheme.textfiledColor,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.textfiledColor,
                            width: 2,
                          )),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .paleSkyBlueColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Icon(FontAwesomeIcons.circleExclamation),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Verify the information before proceeding",
                                    style: CustomTextStyle.heading44,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Subscription",
                                  style: CustomTextStyle.heading44,
                                ),
                                Text(
                                  _package.title,
                                  style: CustomTextStyle.heading6WithBlue,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Amount",
                                  style: CustomTextStyle.heading44,
                                ),
                                Text(
                                  "\$ " + _package.price.toString(),
                                  style: CustomTextStyle.heading6WithBlue,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Subtotal",
                                  style: CustomTextStyle.heading44,
                                ),
                                Text(
                                  "\$ " + _package.price.toString(),
                                  style: CustomTextStyle.heading6WithBlue,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[0-9]"),
                            allow: true)
                      ],
                      maxLength: 16,
                      style: CustomTextStyle.textBoxStyle,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Card Number is required';
                        } else if (value.length > 35) {
                          return 'Maximum up 16 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          subModal.cardNumber = value;
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
                          hintText: 'Card Number',
                          counterText: "",
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.fadeGrayColor)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: cardNameController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[a-zA-Z ]"),
                            allow: true)
                      ],
                      style: CustomTextStyle.textBoxStyle,
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
                          subModal.name = value;
                          modal.name = value;
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
                          hintText: 'Name on card',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.fadeGrayColor)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
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
                          modal.email = value;
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
                          hintText: 'write Email here',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.fadeGrayColor)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiryMonthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[0-9]"),
                                  allow: true)
                            ],
                            style: CustomTextStyle.textBoxStyle,
                            maxLength: 2,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Month is required';
                              } else if (value.length > 2) {
                                return 'Maximum up 2 numbers';
                              } else if (int.parse(value) > 12 ||
                                  int.parse(value) < 1) {
                                return 'Month upto 1-12';
                              } else if (int.parse(value) < currentMonth &&
                                  int.parse(value) == currentYear) {
                                return 'Expired month entered';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                subModal.expirationMonth = value;
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
                                hintText: 'Expiry Month',
                                counterText: "",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: expiryYearController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp("[0-9]"),
                                  allow: true)
                            ],
                            style: CustomTextStyle.textBoxStyle,
                            maxLength: 4,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Year is required';
                              } else if (value.length > 4) {
                                return 'Maximum up 4 numbers';
                              } else if (int.parse(value) < currentYear) {
                                return 'Expired year entered';
                              } else if (int.parse(subModal.expirationMonth) <
                                      currentMonth &&
                                  int.parse(value) == currentYear) {
                                return 'Expired month entered';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                subModal.expirationYear = value;
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
                                hintText: 'Expiry Year',
                                counterText: "",
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fadeGrayColor)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: cvcController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[0-9]"),
                            allow: true)
                      ],
                      style: CustomTextStyle.textBoxStyle,
                      maxLength: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'CVC is required';
                        } else if (value.length > 3) {
                          return 'Maximum up 3 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          subModal.cvc = value;
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
                          hintText: 'Security code (CVC)',
                          counterText: "",
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.fadeGrayColor)),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          primary: Color(0xff00A3FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Pay & proceed ",
                            style: CustomTextStyle.headingWhite,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            EasyLoading.addStatusCallback((status) {});
                            EasyLoading.show(status: 'loading...');
                            modal.creditCard = subModal;
                            addStripeCustomerData(modal).then((response) {
                              EasyLoading.dismiss();
                              paymentModal.amount = _package.price;
                              paymentModal.currency = "USD";
                              paymentModal.customerId = response!;
                              paymentModal.description = "";
                              paymentModal.receiptEmail = modal.email;
                              paymentModal.packageId = _package.id;
                              addStripePayment(paymentModal).then((response) {
                                EasyLoading.dismiss();
                                if (response!.isNotEmpty) {
                                  EasyLoading.dismiss();
                                  String _msg = "Your plan has been updated!";
                                  String title = "";
                                  String _icon = "assets/images/Success.json";
                                  var response = showInfoAlert(
                                      title, _msg, _icon, context);
                                }
                              });
                            });
                          }
                        }),
                  ),
                ],
              ),
            )));
  }
}
