import 'dart:ui';

import 'booking.dart';

import '/utils/number_formatters/number_formatter.dart';

class CategorieStats {
  late String categorieName;
  late String amount;
  late double percentage;
  late Color statColor;

  static List<CategorieStats> createOrUpdateCategorieStats(
      int i, List<Booking> bookingList, List<CategorieStats> categorieStats, String categorieName, bool categorieStatsAreUpdated, Color color) {
    if (i == 0) {
      CategorieStats newCategorieStats = CategorieStats()
        ..categorieName = categorieName
        ..amount = bookingList[i].amount
        ..percentage = 0.0
        ..statColor = const Color.fromRGBO(0, 200, 200, 0.8);
      categorieStats.add(newCategorieStats);
    } else {
      for (int j = 0; j < categorieStats.length; j++) {
        if (categorieStats[j].categorieName.contains(categorieName)) {
          double amount = formatMoneyAmountToDouble(categorieStats[j].amount);
          amount += formatMoneyAmountToDouble(bookingList[i].amount);
          categorieStats[j].amount = formatToMoneyAmount(amount.toString());
          categorieStatsAreUpdated = true;
          break;
        }
      }
      if (categorieStatsAreUpdated == false) {
        CategorieStats newCategorieStats = CategorieStats()
          ..categorieName = categorieName
          ..amount = bookingList[i].amount
          ..percentage = 0.0
          ..statColor = color;
        categorieStats.add(newCategorieStats);
      }
    }
    return categorieStats;
  }

  static List<CategorieStats> calculateCategoriePercentage(List<CategorieStats> categorieStats, double totalExpenditures) {
    for (int i = 0; i < categorieStats.length; i++) {
      categorieStats[i].percentage = (formatMoneyAmountToDouble(categorieStats[i].amount) * 100) / totalExpenditures;
    }
    return categorieStats;
  }

  static List<CategorieStats> showSeparateInvestments(int i, List<Booking> bookingList, List<CategorieStats> categorieStats, String categorieName, Color color) {
    CategorieStats newCategorieStats = CategorieStats()
      ..categorieName = categorieName
      ..amount = bookingList[i].amount
      ..percentage = 0.0
      ..statColor = color;
    categorieStats.add(newCategorieStats);
    return categorieStats;
  }
}
