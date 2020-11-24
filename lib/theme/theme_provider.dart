import 'dart:async';
import 'dart:convert';

import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_colors.dart';

class ThemeProvider {
  static final String _currentTheme = 'current_theme';
  static final String _themes = 'themes';
  static final ThemeProvider _application = ThemeProvider._internal();
  StreamController _themeChangeListener =
      StreamController<ThemeData>.broadcast();

  factory ThemeProvider() {
    return _application;
  }

  ThemeProvider._internal();

  Map<String, dynamic> _themeColors;
  String _currentThemeName;

  addThemes(Map<String, ThemeColors> theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> newThemes = new List();
    newThemes
        .addAll(prefs.getStringList(_themes) ?? List()); // add previous themes

    theme.forEach((themeName, themeColors) {
      newThemes.add(themeName);
      prefs.setString(themeName, json.encode(themeColors));
    });

    prefs.setStringList(_themes, newThemes);

    changeTheme(prefs.getString(_currentTheme) ?? null);
  }

  removeTheme(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allThemes = prefs.getStringList(_themes);
    if (allThemes.contains(themeName)) {
      prefs.remove(themeName);
      allThemes.remove(themeName);

      prefs.setStringList(_themes, allThemes);
    }
  }

  changeTheme(String themeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (themeName == null) {
      List<String> allThemes = prefs.getStringList(_themes);
      themeName = allThemes[0];
    }
    prefs.setString(_currentTheme, themeName);
    themeName = prefs.getString(_currentTheme);

    ThemeColors themeColors =
        ThemeColors.fromJson(json.decode(prefs.getString(themeName)));
    var themeData = ThemeData(
        primaryColor: Color(themeColors.primaryColor),
        primaryColorDark: Color(themeColors.primaryColorDark),
        accentColor: Color(themeColors.accentColor),
        fontFamily: fontFamilyRegular);

    _themeColors = themeColors.colors;
    _currentThemeName = themeName;

    _themeChangeListener?.add(themeData);
  }

  Stream getTheme() {
    return _themeChangeListener?.stream;
  }

  Color getColor(String colorFor) {
    if (_themeColors != null) {
      return Color(_themeColors[colorFor]);
    }

    return Colors.transparent;
  }

  String getThemeName() {
    return _currentThemeName;
  }
}
