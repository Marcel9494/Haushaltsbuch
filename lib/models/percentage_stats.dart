import 'dart:ui';

import '/utils/number_formatters/number_formatter.dart';

class PercentageStats {
  late String name;
  late String amount;
  late double percentage;
  late Color statColor;

  static List<PercentageStats> createOrUpdatePercentageStats(
      int i, String amountString, List<PercentageStats> percentageStats, String categorieName, bool categorieStatsAreUpdated, Color color) {
    print(amountString);
    if (i == 0) {
      PercentageStats newCategorieStats = PercentageStats()
        ..name = categorieName
        ..amount = amountString
        ..percentage = 0.0
        ..statColor = const Color.fromRGBO(0, 200, 200, 0.8);
      percentageStats.add(newCategorieStats);
    } else {
      for (int j = 0; j < percentageStats.length; j++) {
        if (percentageStats[j].name.contains(categorieName)) {
          double amount = formatMoneyAmountToDouble(percentageStats[j].amount);
          amount += formatMoneyAmountToDouble(amountString);
          percentageStats[j].amount = formatToMoneyAmount(amount.toString());
          categorieStatsAreUpdated = true;
          break;
        }
      }
      if (categorieStatsAreUpdated == false) {
        PercentageStats newCategorieStats = PercentageStats()
          ..name = categorieName
          ..amount = amountString
          ..percentage = 0.0
          ..statColor = color;
        percentageStats.add(newCategorieStats);
      }
    }
    return percentageStats;
  }

  static List<PercentageStats> calculatePercentage(List<PercentageStats> percentageStats, double totalExpenditures) {
    for (int i = 0; i < percentageStats.length; i++) {
      percentageStats[i].percentage = (formatMoneyAmountToDouble(percentageStats[i].amount) * 100) / totalExpenditures;
    }
    return percentageStats;
  }

  static List<PercentageStats> showSeparatePercentages(int i, String amountString, List<PercentageStats> percentageStats, String categorieName, Color color) {
    PercentageStats newCategorieStats = PercentageStats()
      ..name = categorieName
      ..amount = amountString
      ..percentage = 0.0
      ..statColor = color;
    percentageStats.add(newCategorieStats);
    return percentageStats;
  }
}
