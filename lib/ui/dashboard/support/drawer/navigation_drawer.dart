import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/dashboard/dashboard.dart';
import 'package:expends/ui/month_wise_expenses/month_wise_expenses.dart';
import 'package:expends/ui/settings/settings.dart';
import 'package:expends/ui/statements/statements.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:expends/utils/icons_constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../../categories/category_list.dart';
import 'drawer_item.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int _selectedIndex = 0;

  List<DrawerItem> _drawerItems = [
    DrawerItem('Dashboard', Icons.dashboard, Dashboard()),
    DrawerItem('Expenses', kMoneyIcon, MonthWiseExpenses()),
    // DrawerItem('Statements', Icons.import_export, Statements()),
    DrawerItem('Categories', Icons.category, CategoryList()),
    // DrawerItem('Settings', Icons.settings, Settings())
  ];

  _onSelectItem(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _drawerItems[_selectedIndex].widget,
      ),
    ); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5.0,
      child: Container(
        color: ThemeProvider().getColor(Themes.backgroundColor),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 75.0,
                            width: 75.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(37.5),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Image.asset(
                                kMoneyIcon,
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              'Expense Manager',
                              style: TextStyle(
                                  color: ThemeProvider()
                                      .getColor(Themes.drawerItemColor),
                                  fontSize: 20.0,
                                  fontFamily: fontFamilyBold),
                            ),
                          ),
                          // FutureBuilder(
                          //   future: PackageInfo.fromPlatform(),
                          //   builder: (_, snapshot) {
                          //     PackageInfo info = snapshot?.data ?? null;
                          //     return Container(
                          //       padding: EdgeInsets.all(10.0),
                          //       child: Text(
                          //         '(v ${info?.version}-${info?.buildNumber})',
                          //         style: TextStyle(
                          //             color: ThemeProvider()
                          //                 .getColor(Themes.drawerItemColor),
                          //             fontSize: 12.0,
                          //             fontFamily: fontFamilyBold),
                          //       ),
                          //     );
                          //   },
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              _drawerItem(0),
              _drawerItem(1),
              _drawerItem(2),
              // _drawerItem(3),
              Divider(color: Colors.grey),
              // _drawerItem(4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(int position) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: position == _selectedIndex
            ? ThemeProvider().getColor(Themes.drawerSelectedBGColor)
            : Colors.transparent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: ListTile(
        leading: position == 1
            ? Image.asset(_drawerItems[position].icon,
                height: 24.0,
                width: 24.0,
                color: position == _selectedIndex
                    ? ThemeProvider().getColor(Themes.drawerItemColor)
                    : Colors.grey)
            : Icon(_drawerItems[position].icon,
                color: position == _selectedIndex
                    ? ThemeProvider().getColor(Themes.drawerItemColor)
                    : Colors.grey),
        title: Text(
          _drawerItems[position].title,
          style: TextStyle(
              color: position == _selectedIndex
                  ? ThemeProvider().getColor(Themes.drawerItemColor)
                  : Colors.grey),
        ),
        selected: position == _selectedIndex,
        onTap: () {
          _onSelectItem(position);
        },
      ),
    );
  }
}
