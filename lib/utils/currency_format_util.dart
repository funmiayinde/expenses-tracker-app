import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyFormatUtil {
  CurrencyFormatUtil._privateConstructor();

  static const String PREF_CURRENCY = 'pref_currency';

  static final CurrencyFormatUtil instance =
      CurrencyFormatUtil._privateConstructor();

  static const NGN_CURR_CODE = 566; // NAIRA
  static const USD_CURR_CODE = 36; // USD

  int currencyCode = NGN_CURR_CODE; // NAIRA default

  SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isCurrencySelected() {
    return _prefs?.getInt(PREF_CURRENCY) == null ? false : true;
  }

  void setCurrency(int selectedCurr) {
    _prefs?.setInt(PREF_CURRENCY, selectedCurr);
    currencyCode = _prefs?.getInt(PREF_CURRENCY) ?? NGN_CURR_CODE;
  }

  NumberFormat getFormat() {
    currencyCode = _prefs?.getInt(PREF_CURRENCY) ?? NGN_CURR_CODE;
    return NumberFormat.currency(
        symbol: String.fromCharCode(currencyCode), decimalDigits: 2);
  }
}
