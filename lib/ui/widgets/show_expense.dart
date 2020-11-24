import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class ShowExpense extends StatelessWidget {
  final double expense;

  const ShowExpense({this.expense = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '- ${CurrencyFormatUtil.instance.getFormat().format(expense) ?? ''}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ThemeProvider().getColor(Themes.debitMoneyColor),
          fontSize: 18,
          fontFamily: fontFamilyBold,
        ),
      ),
    );
  }
}
