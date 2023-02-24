import 'package:intl/intl.dart';

String formatToMoneyAmount(String moneyAmount) {
  var amountFormatter = NumberFormat.simpleCurrency(locale: 'de-DE');
  moneyAmount = amountFormatter.format(double.parse(moneyAmount.replaceAll(',', '.')));
  return moneyAmount;
}
