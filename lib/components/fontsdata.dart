import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetFont {
  Map<String, Map<String, dynamic>> fontDataMap = {
    "dancingScript": {
      "theme": GoogleFonts.dancingScriptTextTheme(),
      "textStyle": GoogleFonts.dancingScript(),
    },
    "openSans": {
      "theme": GoogleFonts.openSansTextTheme(),
      "textStyle": GoogleFonts.openSans(),
    },
    "roboto": {
      "theme": GoogleFonts.robotoTextTheme(),
      "textStyle": GoogleFonts.roboto(),
    },
  };

  getheme(String font) {
    return fontDataMap[font]!["theme"];
  }

  getStyle(String font) {
    return fontDataMap[font]!["textStyle"];
  }
}
