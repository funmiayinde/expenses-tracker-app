import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/dashboard/support/monthly_average_expense.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class StatementDetail extends StatefulWidget {
  final String month;

  const StatementDetail({@required this.month});

  @override
  _StatementDetailState createState() => _StatementDetailState();
}

class _StatementDetailState extends State<StatementDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      appBar: AppBar(
        title: CustomAppbarTitle(title: widget.month),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MonthlyAverageExpense(expenseForMonth: widget.month),
        ),
      ),
    );
  }
}
