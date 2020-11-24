import 'package:expends/database/data/expends_model.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/addexpense/add_expend.dart';
import 'package:expends/ui/addexpense/edit_expend.dart';
import 'package:expends/ui/month_wise_expenses/bloc/month_wise_expenses_bloc.dart';
import 'package:expends/ui/month_wise_expenses/support/daily_expense_chart.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:expends/ui/widgets/placeholder.dart';
import 'package:expends/ui/widgets/show_expense.dart';
import 'package:expends/ui/widgets/show_progress.dart';
import 'package:expends/utils/app_singleton.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class MonthWiseExpenses extends StatefulWidget {
  @override
  _MonthWiseExpensesState createState() => _MonthWiseExpensesState();
}

class _MonthWiseExpensesState extends State<MonthWiseExpenses>
    with TickerProviderStateMixin {
  final _bloc = MonthWiseExpensesBloc();
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  Color backgroundColor = Colors.grey[900];
  List<Tab> _tabsList = [];
  TabController _tabController;

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bloc.getAllMonths(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          print("Error while fetching months: " + snapshot.error);
          return PlaceHolder(
              message: 'You don\'t have any expense yet, \n Please add some.');
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              return _prepareBody(snapshot.data);
          }
        }
      },
    );
  }

  Widget _prepareBody(List<dynamic> months) {
    _tabsList.clear();

    if (months.isNotEmpty) {
      this._tabsList = months.map((month) {
        return Tab(
          text: month,
        );
      }).toList();

      _tabController = TabController(vsync: this, length: _tabsList.length);
      if (_tabsList.length > 1) {
        _tabController.animateTo(_tabsList.length - 1);
      }

      return DefaultTabController(
        length: _tabsList.length,
        child: _parentView(),
      );
    } else {
      return _parentView();
    }
  }

  Widget _parentView() {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      appBar: _appBar(),
      key: _scaffold,
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _awaitReturnValueFromAddExpend(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
        title: CustomAppbarTitle(title: 'Expenses'),
        elevation: 0,
        centerTitle: true,
        bottom: _tabsList.isNotEmpty
            ? TabBar(
                controller: _tabController,
                tabs: _tabsList,
                isScrollable: true,
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size(0, 0),
              ));
  }

  Widget _body() {
    if (_tabsList.length == 0) {
      return PlaceHolder(
          message: 'You don\'t have any expense yet, \n Please add some.');
    } else {
      return TabBarView(
        children: _tabsList.map((Tab tab) {
          return _loadExpends(tab.text);
        }).toList(),
        controller: _tabController,
      );
    }
  }

  Widget monthlyChange(String month) {
    return Card(
      elevation: 0,
      color: ThemeProvider().getColor(Themes.cardBGColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Monthly Change',
                  style: TextStyle(
                      color: ThemeProvider().getColor(Themes.titleColor),
                      fontSize: 16,
                      fontFamily: fontFamilyBold),
                ),
              ),
              FutureBuilder(
                future: _bloc.getTotalExpenseOfMonth(month),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return ShowExpense(expense: 0);
                      default:
                        return ShowExpense(expense: snapshot.data);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadExpends(String selectedMonth) {
    return Container(
      child: Column(
        children: <Widget>[
          monthlyChange(selectedMonth),
          Expanded(
            child: FutureBuilder(
              future: _bloc.getAllDates(selectedMonth),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  print(
                      "Error while fetching dates of month: " + snapshot.error);
                  return Container();
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      return _showDates(snapshot.data, selectedMonth);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showDates(List<dynamic> dateList, String selectedMonth) {
    if (dateList == null || dateList.length == 0) {
      return PlaceHolder(
        message: 'You don\'t have any expense yet, \n Please add some.',
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DailyExpenseChart(month: selectedMonth),
            ListView.separated(
              separatorBuilder: (_, index) {
                return SizedBox(height: 10.0);
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var date = dateList[index];
                return Container(
                  color: ThemeProvider()
                      .getColor(Themes.cardBGColor)
                      .withOpacity(0.4),
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                date.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontFamily: fontFamilyBold,
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future:
                                  _bloc.getTotalExpenseOfDate(date.toString()),
                              builder: (_, snapshot) {
                                if (snapshot.hasError) {
                                  print(
                                      "Error while fetching totalExpenseOf date: " +
                                          snapshot.error);
                                  return Container();
                                } else {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return _showTotalExpend(0, null);
                                    default:
                                      return Text(
                                        " - " +
                                            CurrencyFormatUtil.instance.getFormat()
                                                    .format(snapshot.data) ??
                                            "",
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                            fontFamily: fontFamilyBold),
                                      );
                                  }
                                }
                              },
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(5),
                      ),
                      _fetchExpends(date),
                    ],
                  ),
                );
              },
              itemCount: dateList.length,
            ),
            SizedBox(height: 100.0)
          ],
        ),
      );
    }
  }

  Widget _showTotalExpend(double expend, String color) {
    return Text(
      " - " + CurrencyFormatUtil.instance.getFormat().format(expend) ?? "",
      textAlign: TextAlign.end,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: color == null
            ? Theme.of(context).accentColor
            : Color(int.parse(color)),
        fontSize: 14,
      ),
    );
  }

  Widget _fetchExpends(String date) {
    return FutureBuilder(
      future: _bloc.getExpensesInGroup(date),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return PlaceHolder(message: snapshot.error);
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return ShowProgress();
            default:
              return _showExpends(snapshot.data);
          }
        }
      },
    );
  }

  Widget _showExpends(List<ExpendsModel> expendsList) {
    if (expendsList.length == 0) {
      return PlaceHolder(
        message: 'You don\'t have any expense yet, \n Please add some.',
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var expends = expendsList[index];
          return GestureDetector(
            onTap: () {
              _awaitReturnValueFromEditExpend(context, expends.id);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: Color(
                        int.parse(expends.color),
                      ),
                    ),
                    height: 45,
                    width: 45,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Image(
                        image: AssetImage(expends.getIcon()),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  expends.categoryName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ThemeProvider()
                                          .getColor(Themes.textColor),
                                      fontSize: 15,
                                      fontFamily: fontFamilyMedium),
                                ),
                              ),
                            ),
                            Container(
                              child: _showTotalExpend(
                                  expends.expends, expends.color),
                            ),
                          ],
                        ),
                        _otherDetailWidget(
                          expends.description,
                          Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        _otherDetailWidget(
                          expends.place,
                          Icon(
                            Icons.pin_drop,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: expendsList.length,
      );
    }
  }

  Widget _otherDetailWidget(String value, Icon icon) {
    double width = MediaQuery.of(context).size.width * 0.60;

    if (value == null || value.isEmpty) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            icon,
            Container(
              width: width,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                value,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _awaitReturnValueFromAddExpend(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddExpend()));

    if (result != null) {
      // after the SecondScreen result comes back update the Text widget with it
      AppSingleton.instance.showMessage(result);
    }
  }

  void _awaitReturnValueFromEditExpend(
      BuildContext context, int expendsId) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpend(
          expendId: expendsId,
        ),
      ),
    );

    if (result != null) {
      // after the SecondScreen result comes back update the Text widget with it
      setState(() {
        AppSingleton.instance.showMessage(result);
      });
    }
  }
}
