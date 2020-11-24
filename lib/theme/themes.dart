import 'package:flutter/material.dart';

import 'theme_colors.dart';

class Themes {
  static final String dark = 'dark';
  static final String light = 'light';

  static final String titleColor = 'title_color';
  static final String textColor = 'text_color';
  static final String iconColor = 'icon_color';
  static final String drawerItemColor = 'drawer_item_color';
  static final String drawerSelectedBGColor = 'drawer_selected_bg_color';
  static final String backgroundColor = 'background_color';
  static final String toastBackgroundColor = 'toast_background_color';
  static final String toastTextColor = 'toast_text_color';
  static final String cardBGColor = 'card_bg_color';
  static final String debitMoneyColor = 'debit_money_color';

  static ThemeColors darkThemeColors() {
    Map<String, dynamic> colors = new Map();
    colors[titleColor] = Colors.white.value;
    colors[textColor] = Colors.white.value;
    colors[iconColor] = Colors.white.value;
    colors[drawerItemColor] = Colors.white.value;
    colors[drawerSelectedBGColor] = Color(0xff6fda44).value;
    colors[backgroundColor] = Colors.black.value;
    colors[toastBackgroundColor] = Colors.white.value;
    colors[toastTextColor] = Colors.black.value;
    colors[cardBGColor] = Color(0xff494949).value;
    colors[debitMoneyColor] = Colors.red.value;

    return ThemeColors(
        primaryColor: Colors.black.value,
        primaryColorDark: Colors.black.value,
        accentColor: Color(0xff6fda44).value,
        colors: colors);
  }

  static ThemeColors lightThemeColors() {
    Map<String, int> colors = new Map();
    colors[titleColor] = Colors.black.value;
    colors[textColor] = Colors.black.value;
    colors[iconColor] = Colors.black.value;
    colors[drawerItemColor] = Colors.black.value;
    colors[drawerSelectedBGColor] = Color(0xff6fda44).value;
    colors[backgroundColor] = Colors.white.value;
    colors[toastBackgroundColor] = Colors.black.value;
    colors[toastTextColor] = Colors.white.value;
    colors[cardBGColor] = Color(0xffeeeeee).value;
    colors[debitMoneyColor] = Colors.red.value;

    return ThemeColors(
        primaryColor: Colors.white.value,
        primaryColorDark: Colors.white.value,
        accentColor: Color(0xff6fda44).value,
        colors: colors);
  }
}
