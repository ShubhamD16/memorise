import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting with ChangeNotifier {
  TextTheme texttheme = GoogleFonts.dancingScriptTextTheme();
  Brightness brightness = Brightness.light;

  ThemeData getTheme() {
    if (brightness == Brightness.dark) {
      return ThemeData(
        brightness: brightness,
        textTheme: texttheme.apply(bodyColor: Colors.white),
        dialogTheme: const DialogTheme(backgroundColor: Colors.grey),
      );
    }
    return ThemeData(
      brightness: brightness,
      textTheme: texttheme,
      cardColor: Colors.grey[200],
    );
  }

  setfont(TextTheme theme) {
    texttheme = theme;
    notifyListeners();
  }

  setmode(Brightness mode) {
    brightness = mode;
    notifyListeners();
  }

  setfontmode(TextTheme theme, Brightness mode) {
    texttheme = theme;
    brightness = mode;
    notifyListeners();
  }
}
