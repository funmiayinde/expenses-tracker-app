import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/dashboard/dashboard.dart';
import 'package:expends/utils/currency_format_util.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class CurrencyOptions extends StatefulWidget {
  @override
  _CurrencyOptionsState createState() => _CurrencyOptionsState();
}

class _CurrencyOptionsState extends State<CurrencyOptions> {
  int selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Select Currency',
                style: TextStyle(
                  fontFamily: fontFamilyBold,
                  fontSize: 24.0,
                  color: ThemeProvider().getColor(Themes.textColor),
                ),
              ),
              SizedBox(height: 20.0),
              currencyList(),
              Spacer(),
              if (selectedCurrency != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      CurrencyFormatUtil.instance.setCurrency(selectedCurrency);

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: fontFamilyBold,
                        color: ThemeProvider().getColor(Themes.textColor),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 50.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget currencyList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          color: Colors.white30,
          child: ListTile(
            onTap: () {
              setState(() {
                selectedCurrency = CurrencyFormatUtil.NGN_CURR_CODE;
              });
            },
            title: Text(
              'NGN',
              style: TextStyle(
                color: getTextColor(CurrencyFormatUtil.NGN_CURR_CODE),
                fontFamily: fontFamilyBold,
              ),
            ),
            trailing: Text(
              'N',
              // String.fromCharCode(356),
              style: TextStyle(
                fontSize: 24.0,
                color: getTextColor(CurrencyFormatUtil.NGN_CURR_CODE),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          color: Colors.white30,
          child: ListTile(
            onTap: () {
              setState(() {
                selectedCurrency = CurrencyFormatUtil.USD_CURR_CODE;
              });
            },
            title: Text(
              'USD',
              style: TextStyle(
                  color: getTextColor(CurrencyFormatUtil.USD_CURR_CODE),
                  fontFamily: fontFamilyBold),
            ),
            trailing: Text(
              String.fromCharCode(36),
              style: TextStyle(
                fontSize: 24.0,
                color: getTextColor(CurrencyFormatUtil.USD_CURR_CODE),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color getTextColor(int currency) {
    return selectedCurrency == currency
        ? Theme.of(context).accentColor
        : ThemeProvider().getColor(Themes.textColor);
  }
}
