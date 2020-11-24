import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  final String message;

  const PlaceHolder({this.message = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ThemeProvider().getColor(Themes.textColor),
          fontSize: 14,
          fontFamily: fontFamilyMedium,
        ),
      ),
    );
  }
}
