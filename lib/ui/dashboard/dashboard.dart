import 'dart:async';

import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/addexpense/add_expend.dart';
import 'package:expends/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:expends/ui/dashboard/support/drawer/navigation_drawer.dart';
import 'package:expends/ui/month_wise_expenses/month_wise_expenses.dart';
import 'package:expends/ui/statements/statements.dart';
import 'package:expends/utils/app_singleton.dart';
import 'package:expends/utils/categoryManager.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

import 'support/monthly_average_expense.dart';
import '../widgets/show_expense.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _bloc = DashboardBloc();

  StreamController<bool> notifyChange = StreamController.broadcast();

  void initState() {
    super.initState();
    //insert categories if not available
    CategoryManager.instance.insertCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: fontFamilyBold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: notifyChange?.stream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    navigateToExpenses();
                  },
                  child: Card(
                    elevation: 0,
                    color: ThemeProvider().getColor(Themes.cardBGColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Text(
                                'Overview',
                                style: TextStyle(
                                    color: ThemeProvider()
                                        .getColor(Themes.titleColor),
                                    fontSize: 18,
                                    fontFamily: fontFamilyBold),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Icon(
                                Icons.navigate_next,
                                color:
                                    ThemeProvider().getColor(Themes.iconColor),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text(
                                    'Total Expense',
                                    style: TextStyle(
                                        color: ThemeProvider()
                                            .getColor(Themes.titleColor),
                                        fontSize: 14,
                                        fontFamily: fontFamilyBold),
                                  ),
                                ),
                                padding: EdgeInsets.only(bottom: 5),
                              ),
                              FutureBuilder(
                                future: _bloc.getTotalExpense(),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    return ShowExpense(expense: snapshot.data);
                                  } else {
                                    return ShowExpense();
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _bloc.currentMonth,
                        style: TextStyle(
                          fontFamily: fontFamilyBold,
                          fontSize: 16.0,
                          color: ThemeProvider().getColor(Themes.textColor),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Statements(),
                            ),
                          );
                        },
                        child: Text(
                          'All Months',
                          style: TextStyle(
                            fontFamily: fontFamilyBold,
                            fontSize: 16.0,
                            color: ThemeProvider().getColor(Themes.textColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                MonthlyAverageExpense(),
                SizedBox(height: 100)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddExpense();
        },
        child: Icon(Icons.add),
      ),
      drawer: NavigationDrawer(),
    );
  }

  void navigateToAddExpense() async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddExpend()));

    if (result != null) {
      // after the SecondScreen result comes back update the Text widget with it
      AppSingleton.instance.showMessage(result);
      notifyChange?.add(true);
    }
  }

  void navigateToExpenses() async {
    // start the SecondScreen and wait for it to finish with a result
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MonthWiseExpenses()));

    notifyChange?.add(true);
  }

  @override
  void dispose() {
    super.dispose();
    notifyChange?.close();
  }
}
