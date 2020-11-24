import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class CustomAppbarTitle extends StatelessWidget {
  final String title;

  const CustomAppbarTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeProvider().getColor(Themes.titleColor),
        fontFamily: fontFamilyBold,
      ),
    );
  }
}
