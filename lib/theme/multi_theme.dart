import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'theme_colors.dart';
import 'theme_provider.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

class MultiTheme extends StatefulWidget {
  final ThemedWidgetBuilder themedWidgetBuilder;
  final Map<String, ThemeColors> themes;

  const MultiTheme({this.themedWidgetBuilder, this.themes});

  @override
  _MultiThemeState createState() => _MultiThemeState();
}

class _MultiThemeState extends State<MultiTheme> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider().addThemes(widget.themes);

    return StreamBuilder<ThemeData>(
      stream: ThemeProvider().getTheme(),
      builder: (context, snapshot) {
        return widget.themedWidgetBuilder(context, snapshot.data);
      },
    );
  }
}
