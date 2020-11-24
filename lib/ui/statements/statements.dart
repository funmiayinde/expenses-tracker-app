import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/statements/bloc/statements_bloc.dart';
import 'package:expends/ui/statements/statement_detail.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:expends/ui/widgets/placeholder.dart';
import 'package:expends/ui/widgets/show_expense.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class Statements extends StatefulWidget {
  @override
  _StatementsState createState() => _StatementsState();
}

class _StatementsState extends State<Statements> {
  final _bloc = StatementsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      appBar: AppBar(
        title: CustomAppbarTitle(title: 'Statements'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _bloc.getAllMonths(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return PlaceHolder(
                  message:
                      'You don\'t have any expense yet, \n Please add some.');
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container();
                default:
                  return _prepareBody(snapshot.data);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _prepareBody(List<dynamic> months) {
    if (months.isEmpty) {
      return PlaceHolder(message: 'No Statements,\nPlease add your expenses');
    }
    return ListView.separated(
      separatorBuilder: (_, position) {
        return SizedBox(height: 10.0);
      },
      itemCount: months.length,
      itemBuilder: (_, position) {
        String month = months[position];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatementDetail(month: month),
              ),
            );
          },
          child: Container(
            color: ThemeProvider().getColor(Themes.cardBGColor),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontFamily: fontFamilyBold,
                    fontSize: 18.0,
                    color: ThemeProvider().getColor(Themes.textColor),
                  ),
                ),
                Spacer(),
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
                ),
                SizedBox(width: 10.0),
                Icon(
                  Icons.navigate_next,
                  color: ThemeProvider().getColor(Themes.iconColor),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
