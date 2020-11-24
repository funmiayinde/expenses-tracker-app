import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

import 'currency_options.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  String themeName;

  void initState() {
    super.initState();
    themeName = ThemeProvider().getThemeName();
    _prepareAnimationController();
  }

  void _prepareAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ThemeProvider().getTheme(),
      builder: (context, snapshot) {
        bool isDarkTheme = ThemeProvider().getThemeName() == Themes.dark;

        if (themeName != ThemeProvider().getThemeName()) {
          _prepareAnimationController();
          themeName = ThemeProvider().getThemeName();
        }

        return FadeTransition(
          opacity: animation,
          child: Scaffold(
            backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: CustomAppbarTitle(title: 'Settings'),
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Enable Dark Theme',
                          style: TextStyle(
                            fontFamily: fontFamilyMedium,
                            fontSize: 16,
                            color: ThemeProvider().getColor(Themes.textColor),
                          ),
                        ),
                        Switch(
                          onChanged: (value) {
                            isDarkTheme = value;
                            if (isDarkTheme) {
                              ThemeProvider().changeTheme(Themes.dark);
                            } else {
                              ThemeProvider().changeTheme(Themes.light);
                            }
                          },
                          value: isDarkTheme,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
}
