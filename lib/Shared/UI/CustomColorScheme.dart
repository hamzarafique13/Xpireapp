// ignore_for_file: file_names

import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get iconThemeGray => const Color(0xFFCECECE);
  Color get primaryGradientColor => const Color(0xFFCC67AC);
  // Color get backgroundColor => const Color(0xfff2f3f7);
  Color get backgroundColor => const Color(0xffFFFFFF);
  Color get dashboardbackGround => const Color(0xffF2F3F7);
  Color get textBoxFillColor => const Color(0xFFFFFFFF);
  Color get lightPinkColor => const Color(0xFFDFB8D7);

  Color get darkGrayColor => const Color(0xFF707070);
  Color get successColor => const Color(0xFF4BB543);
  Color get redColor => const Color(0xFFFF0000);
/* Expiree color */
  Color get darkredColor => const Color(0xFF990000);

  Color get expiredColor => const Color(0xFFF44336);
  Color get expiringColor => const Color(0xFFFFA500);
  Color get activeColor => const Color(0xFF3FBD63);
  Color get primryColor => const Color(0xFF00A3FF);
  Color get dartYellowColor => const Color(0xFF45350a);
// Color get dartYellowColor => const Color(0xFF45350a);
  Color get editDocumentColor => const Color(0xFFfbcb9c);

/* Expiree color accordingly doc*/
  Color get iceBlueColor => const Color(0xFFe5f7ff);
  Color get marineColor => const Color(0xFF003e5b);
  Color get blueyGreyColor => const Color(0xFF95a8b1);

  Color get azureColor => const Color(0xFF019ce4);
  Color get whiteColor => const Color(0xFFffffff);
  Color get paleSkyBlueColor => const Color(0xFFbeeaff);
  Color get paleGreyColor => const Color(0xFFebecee);

/* New tsyle*/
  Color get textBoxBorderColor => const Color(0xFFC9C9C9);
  Color get disableBtnColor => const Color(0xFFDADADA);
  Color get labelColor => const Color(0xFFC9C9C9);
  Color get linkTextColor => const Color(0xFF4FC3F7);
  Color get blackColor => const Color(0xFF323232);
  Color get lightBlackColor => const Color(0xFF475467);
  Color get warmGreyColor => const Color(0xFF777777);
  Color get pinkColor => const Color(0xFFFCEDE9);
  Color get yellowColor => const Color(0xFFFCF6CD);
  Color get lightGreenColor => const Color(0xFFEAF7EE);
  Color get lightPurpleColor => const Color(0xFFFBF0FF);
  Color get purpleColor => const Color(0xFFAD32E1);
  Color get navBarColor => const Color(0xFFF8F7FF);
  Color get fadeGrayColor => const Color(0xFFCACACA);
  Color get iconColor => const Color(0xFF323232);
  Color get iconBackColor => const Color(0xFFD9D9D9);
  Color get cardShadowColor => const Color(0xFF9AAACF);
  Color get sharerColor => const Color(0xFFF1DAFB);
  Color get sharerIconColor => const Color(0xFF808080);

  Color get profileEditColor => const Color(0xFFD3F2FF);
  Color get remnderColor => const Color(0xFFF8F9FB);
  Color get tabBorderColor => const Color(0xFFB9B9B9);
  Color get packageLinkColor => const Color(0xFFFFF6EE);
  Color get textfiledColor => const Color(0xFFf4f8fb);
  Color get lightgrey => const Color(0xffA7A8BB);
  // Color get buttonbackColor => Colors.grey[200];
}

class CustomTextStyle {
  static const TextStyle heading1 =
      TextStyle(fontSize: 14, color: Color(0xFFA4A3A3));
  static const TextStyle heading4 = TextStyle(
      fontSize: 14, color: Color(0xFFA4A3A3), fontWeight: FontWeight.normal);
  static const TextStyle heading44 = TextStyle(
      fontSize: 14, color: Color(0xFF323232), fontWeight: FontWeight.normal);

  static const TextStyle heading2Bold = TextStyle(
      fontSize: 18,
      color: Color(0xFF323232),
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline);
  static const TextStyle heading2BlueBold = TextStyle(
    fontSize: 18, color: Color(0xFF4FC3F7), fontWeight: FontWeight.bold,
    //decoration: TextDecoration.underline
  );
  static const TextStyle heading2NOunderLIne = TextStyle(
    fontSize: 18,
    color: Color(0xFF323232),
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading2 = TextStyle(
      fontSize: 18, color: Color(0xFFA4A3A3), fontWeight: FontWeight.normal);
  static const TextStyle heading3 =
      TextStyle(fontSize: 18, color: Color(0xFFA4A3A3));
  static const TextStyle heading10 = TextStyle(
      fontSize: 14, color: Color(0xFFA4A3A3), fontWeight: FontWeight.normal);
  static const TextStyle heading11 = TextStyle(
      fontSize: 16, color: Color(0xFF323232), fontWeight: FontWeight.w600);

  static const TextStyle headline5 = TextStyle(
      fontSize: 16,
      color: Color(0xFF808080),
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.lineThrough,
      decorationThickness: 3);

  static const TextStyle topHeading = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF323232));
  static const TextStyle blueText = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4FC3F7));
  static const TextStyle simpleText = TextStyle(
      fontSize: 13, color: Color(0xFF323232), fontWeight: FontWeight.normal);
  static const TextStyle simple12Text = TextStyle(
      fontSize: 12, color: Color(0xFF323232), fontWeight: FontWeight.normal);

  static const TextStyle heading5 = TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF323232));
  static const TextStyle headingSize5 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF323232));
  static const TextStyle heading5withoutBold = TextStyle(
      fontSize: 15, color: Color(0xFF323232), fontWeight: FontWeight.normal);

  static const TextStyle heading12 =
      TextStyle(fontSize: 18, color: Color(0xFFA4A3A3));
  static const TextStyle heading6WithBlue =
      TextStyle(fontSize: 14, color: Color(0xFF4FC3F7));
  static const TextStyle headingWhite = TextStyle(
      fontSize: 14, color: Color(0xFFffffff), fontWeight: FontWeight.normal);
  static const TextStyle headline6 = TextStyle(
      fontSize: 14,
      color: Color(0xFFA4A3A3),
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.lineThrough,
      decorationThickness: 3);

  static const TextStyle heading3White = TextStyle(
      fontSize: 14, color: Color(0xFFffffff), fontWeight: FontWeight.bold);
  static const TextStyle textBoxStyle =
      TextStyle(fontSize: 14, color: Color(0xFF323232));

  static const TextStyle packageTxtStyle = TextStyle(
      fontSize: 14, color: Color(0xFFC39245), fontWeight: FontWeight.normal);
  static const TextStyle heading43 = TextStyle(
      fontSize: 14,
      color: Color(0xFF323232),
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline,
      decorationThickness: 1);
}
