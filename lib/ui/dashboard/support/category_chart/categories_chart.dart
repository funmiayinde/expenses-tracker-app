import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/dashboard/bloc/dashboard_bloc.dart';
import 'package:expends/ui/widgets/circularPieChart.dart';
import 'package:expends/ui/widgets/placeholder.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

import 'chart_categories_list.dart';

class CategoriesChart extends StatefulWidget {
  final String month;

  const CategoriesChart({@required this.month});

  @override
  _CategoriesChartState createState() => _CategoriesChartState();
}

class _CategoriesChartState extends State<CategoriesChart> {
  final _bloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bloc.getCategoryWiseExpense(month: widget.month),
      builder: (_, snapshot) {
        List<dynamic> chartDataList = snapshot?.data ?? [];
        if (snapshot.hasError ||
            (chartDataList != null && chartDataList.isEmpty)) {
          return PlaceHolder(
              message: 'Chart data not available\nPlease add your expense');
        }
        return Card(
          elevation: 0,
          color: ThemeProvider().getColor(Themes.cardBGColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: ThemeProvider().getColor(Themes.titleColor),
                          fontSize: 18,
                          fontFamily: fontFamilyBold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircularPieChart(chartDataList),
                ),
                ChartCategoriesList(categoriesList: chartDataList)
              ],
            ),
          ),
        );
      },
    );
  }
}
