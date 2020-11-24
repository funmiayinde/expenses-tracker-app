import 'package:expends/theme/theme_provider.dart';
import 'package:expends/ui/base/base_view.dart';
import 'package:expends/ui/dashboard/dashboard.dart';
import 'package:expends/database/app_database_info.dart';
import 'package:expends/database/db_helper.dart';
import 'package:expends/ui/settings/currency_options.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:flutter/material.dart';

import 'theme/multi_theme.dart';
import 'theme/theme_colors.dart';
import 'theme/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CurrencyFormatUtil.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Map<String, ThemeColors> map = new Map();
    map[Themes.light] = Themes.lightThemeColors();
    map[Themes.dark] = Themes.darkThemeColors();

    return MultiTheme(
      themes: map,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements BaseView {
  @override
  void initState() {
    super.initState();
    DBHelper.dbHelper.openDB(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void createTables() {
    DBHelper.dbHelper.init(AppDatabaseInfo()).then((value) {
      if (CurrencyFormatUtil.instance.isCurrencySelected()) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CurrencyOptions()));
      }
    }).catchError((error) {
      print('error while creating tables: ' + error.toString());
    });
  }

  @override
  void onDBCreated() {
    createTables();
  }
}
