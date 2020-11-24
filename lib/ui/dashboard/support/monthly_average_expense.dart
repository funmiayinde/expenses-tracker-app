import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_util/date_util.dart';

import 'category_chart/categories_chart.dart';
import '../../widgets/show_expense.dart';

class MonthlyAverageExpense extends StatefulWidget {
  final String expenseForMonth;

  const MonthlyAverageExpense({this.expenseForMonth});

  @override
  _MonthlyAverageExpenseState createState() => _MonthlyAverageExpenseState();
}

class _MonthlyAverageExpenseState extends State<MonthlyAverageExpense> {
  final _bloc = DashboardBloc();
  int currentDay = int.parse(DateFormat.d().format(DateTime.now().toLocal()));

  var dateUtility = new DateUtil();

  @override
  Widget build(BuildContext context) {
    if (widget.expenseForMonth != null &&
        widget.expenseForMonth != _bloc.currentMonth) {
      // get total days for months, if not current month
      var currTime = DateFormat.yMMM().parse(widget.expenseForMonth).toLocal();
      currentDay = dateUtility.daysInMonth(currTime.month, currTime.year);
    }

    return Column(
      children: <Widget>[
        monthlyExpenseOverview(),
        SizedBox(height: 10.0),
        CategoriesChart(
          month: widget.expenseForMonth,
        ),
      ],
    );
  }

  Widget monthlyExpenseOverview() {
    return Card(
      elevation: 0,
      color: ThemeProvider().getColor(Themes.cardBGColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Monthly Average',
                    style: TextStyle(
                        color: ThemeProvider().getColor(Themes.titleColor),
                        fontSize: 18,
                        fontFamily: fontFamilyBold),
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Text(
                            'Daily Expense',
                            style: TextStyle(
                              color:
                                  ThemeProvider().getColor(Themes.titleColor),
                              fontSize: 14,
                              fontFamily: fontFamilyBold,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      FutureBuilder(
                        future: _bloc.getTotalExpenseOfMonth(
                            month: widget.expenseForMonth),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: Text(
                                "- " +
                                    CurrencyFormatUtil.instance.getFormat().format(
                                            snapshot.data / currentDay) ??
                                    "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ThemeProvider()
                                        .getColor(Themes.debitMoneyColor),
                                    fontSize: 18,
                                    fontFamily: fontFamilyBold),
                              ),
                            );
                          } else {
                            return ShowExpense();
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Text(
                            'Monthly Case Flow',
                            style: TextStyle(
                              color:
                                  ThemeProvider().getColor(Themes.titleColor),
                              fontSize: 14,
                              fontFamily: fontFamilyBold,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      FutureBuilder(
                        future: _bloc.getTotalExpenseOfMonth(
                            month: widget.expenseForMonth),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return ShowExpense(expense: snapshot.data);
                          } else {
                            return ShowExpense();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
