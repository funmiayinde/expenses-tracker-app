import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

import '../../../../database/data/categories.dart';

class ChartCategoriesList extends StatelessWidget {
  final List<Map> categoriesList;

  const ChartCategoriesList({@required this.categoriesList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Categories category = categoriesList[index]['category'];
        int transactions = int.parse(categoriesList[index]['transaction']);
        double expend = double.parse(categoriesList[index]['expend']);
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Color(
                    int.parse(category.color),
                  ),
                ),
                height: 45,
                width: 45,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Image(
                    image: AssetImage(category.getIcon()),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        category.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: ThemeProvider().getColor(Themes.textColor),
                            fontSize: 15,
                            fontFamily: fontFamilyBold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        transactions.toString() +
                            (transactions == 1
                                ? ' transaction'
                                : ' transactions'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 12,
                          fontFamily: fontFamilyMedium,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                " - " + CurrencyFormatUtil.instance.getFormat().format(expend) ?? "",
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: ThemeProvider().getColor(Themes.debitMoneyColor),
                  fontSize: 14,
                  fontFamily: fontFamilyBold,
                ),
              )
            ],
          ),
        );
      },
      itemCount: categoriesList.length,
    );
  }
}
