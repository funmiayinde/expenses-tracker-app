import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/month_wise_expenses/bloc/month_wise_expenses_bloc.dart';
import 'package:expends/ui/widgets/expanded_section.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DailyExpenseChart extends StatefulWidget {
  final String month;

  const DailyExpenseChart({@required this.month});

  @override
  _DailyExpenseChartState createState() => _DailyExpenseChartState();
}

class _DailyExpenseChartState extends State<DailyExpenseChart>
    with SingleTickerProviderStateMixin {
  final _bloc = MonthWiseExpensesBloc();

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedIconButton(
          size: 25,
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          duration: Duration(milliseconds: 400),
          endIcon: Icon(
            Icons.close,
            color: Theme.of(context).accentColor,
          ),
          startIcon: Icon(
            Icons.show_chart,
            color: Theme.of(context).accentColor,
          ),
        ),
        ExpandedSection(
          expand: isExpanded,
          child: _chartWidget(),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _chartWidget() {
    return Card(
      elevation: 0,
      color: ThemeProvider().getColor(Themes.cardBGColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.all(10),
      child: Container(
        height: 180.0,
        padding: EdgeInsets.all(5.0),
        child: FutureBuilder(
          key: Key(widget.month),
          future: _bloc.getDailyExpenseChartData(widget.month),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              List<charts.Series<Map, String>> chartDataList = snapshot.data;
              if (chartDataList.isEmpty ||
                  (chartDataList?.first?.data ?? []).length == 0) {
                return Container();
              }
              return new charts.BarChart(
                chartDataList,
                animate: true,
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
