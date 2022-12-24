import 'package:flutter/material.dart';


mixin TextStyles {
  static TextStyle withColor(TextStyle style, Color color) {

    return TextStyle(
      fontSize: style.fontSize,
      fontFamily: style.fontFamily,
      fontWeight: style.fontWeight,
      color: color,
    );
  }

  static TextStyle withletterspacing (double fontSize,fontFamily,fontWeight, Color color,double spacing){
    return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      letterSpacing: spacing,
      color: color,
    );
  }
// fontweilght bold

  static const TextStyle mb10 = TextStyle(
    fontSize: 10,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb11 = TextStyle(
    fontSize: 11,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );


  static const TextStyle mb12 = TextStyle(
    fontSize: 12,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb14 = TextStyle(
    fontSize: 14,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb16 = TextStyle(
    fontSize: 16,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb18 = TextStyle(
    fontSize: 18,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb20 = TextStyle(
    fontSize: 20,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb24 = TextStyle(
    fontSize: 24,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle mb26 = TextStyle(
    fontSize: 26,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.bold,
  );


  // fontweight normal
  static const TextStyle mn10 = TextStyle(
    fontSize: 10,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn12 = TextStyle(
    fontSize: 12,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn14 = TextStyle(
    fontSize: 14,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn16 = TextStyle(
    fontSize: 16,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn18 = TextStyle(
    fontSize: 18,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn20 = TextStyle(
    fontSize: 20,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn24 = TextStyle(
    fontSize: 24,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle mn26 = TextStyle(
    fontSize: 26,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.normal,
  );

   // fontweight 300

  static const TextStyle ml12 = TextStyle(
    fontSize: 12,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle ml14 = TextStyle(
    fontSize: 14,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );
  static const TextStyle ml16 = TextStyle(
    fontSize: 16,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle ml18 = TextStyle(
    fontSize: 18,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );
  static const TextStyle ml20 = TextStyle(
    fontSize: 20,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle ml24 = TextStyle(
    fontSize: 24,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle ml26 = TextStyle(
    fontSize: 26,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );




  static const TextStyle osl14 = TextStyle(
    fontSize: 14,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn14 = TextStyle(
    fontSize: 14,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb14 = TextStyle(
    fontSize: 14,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle osl16 = TextStyle(
    fontSize: 16,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn16 = TextStyle(
    fontSize: 16,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb16 = TextStyle(
    fontSize: 16,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle osl18 = TextStyle(
    fontSize: 18,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn18 = TextStyle(
    fontSize: 18,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb18 = TextStyle(
    fontSize: 18,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle osl20 = TextStyle(
    fontSize: 20,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn20 = TextStyle(
    fontSize: 20,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb20 = TextStyle(
    fontSize: 20,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle osl24 = TextStyle(
    fontSize: 24,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn24 = TextStyle(
    fontSize: 24,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb24 = TextStyle(
    fontSize: 24,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle osl26 = TextStyle(
    fontSize: 26,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.w300,
  );

  static const TextStyle osn26 = TextStyle(
    fontSize: 26,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.normal,
  );

  static const TextStyle osb26 = TextStyle(
    fontSize: 26,
    fontFamily: "Open_Sans",
    fontWeight: FontWeight.bold,
  );
}