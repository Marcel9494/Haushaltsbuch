import 'package:intl/intl.dart';

// Beispiel:
// Input moneyAmount: 8.6
// return 8,60 €
String formatToMoneyAmount(String moneyAmount) {
  var amountFormatter = NumberFormat.simpleCurrency(locale: 'de-DE');
  moneyAmount = amountFormatter.format(double.parse(moneyAmount.replaceAll(',', '.')));
  return moneyAmount;
}

// Beispiel:
// Input moneyAmount: 8.6 oder 8,6
// return 8 €
String formatToMoneyAmountWithoutCent(String moneyAmount) {
  var amountFormatter = NumberFormat.simpleCurrency(locale: 'de-DE', decimalDigits: 0);
  List<String> splittedMoneyAmount = moneyAmount.replaceAll(',', '.').split('.');
  moneyAmount = amountFormatter.format(double.parse(splittedMoneyAmount[0]));
  return moneyAmount;
}

// Beispiel:
// Input moneyAmount: 8.6 oder 8,6
// return 8
String formatToMoneyAmountWithoutCentAndSymbol(String moneyAmount) {
  var amountFormatter = NumberFormat.currency(locale: 'de-DE', decimalDigits: 0, symbol: '');
  List<String> splittedMoneyAmount = moneyAmount.replaceAll(',', '.').split('.');
  moneyAmount = amountFormatter.format(double.parse(splittedMoneyAmount[0]));
  return moneyAmount;
}

// Beispiel:
// Input amount: 8,60 €
// return 8.6
double formatMoneyAmountToDouble(String amount) {
  return double.parse(amount.substring(0, amount.length - 2).replaceAll('.', '').replaceAll(',', '.'));
}
