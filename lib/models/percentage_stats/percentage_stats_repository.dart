import 'dart:ui';

import '/utils/number_formatters/number_formatter.dart';
import '/utils/color_palettes/charts_color_palette.dart';

import '/models/percentage_stats/percentage_stats_model.dart';
import '/models/percentage_stats/percentage_stats_interface.dart';

class PercentageStatsRepository extends PercentageStatsInterface {
  @override
  List<PercentageStats> createOrUpdate(int i, String amountString, List<PercentageStats> percentageStats, String categorieName, bool categorieStatsAreUpdated) {
    if (i == 0) {
      PercentageStats newCategorieStats = PercentageStats()
        ..name = categorieName
        ..amount = amountString
        ..percentage = 0.0
        ..statColor = chartColorPalette[i];
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
          ..statColor = chartColorPalette[i % chartColorPalette.length];
        percentageStats.add(newCategorieStats);
      }
    }
    return percentageStats;
  }

  @override
  List<PercentageStats> update(int i, String amountString, List<PercentageStats> percentageStats, String categorieName, Color color) {
    for (int j = 0; j < percentageStats.length; j++) {
      if (percentageStats[j].name.contains(categorieName)) {
        double amount = formatMoneyAmountToDouble(percentageStats[j].amount);
        amount += formatMoneyAmountToDouble(amountString);
        percentageStats[j].amount = formatToMoneyAmount(amount.toString());
        break;
      }
    }
    return percentageStats;
  }

  @override
  List<PercentageStats> calculatePercentage(List<PercentageStats> percentageStats, double total) {
    for (int i = 0; i < percentageStats.length; i++) {
      if (total <= 0.0) {
        percentageStats[i].percentage = 0.0;
        continue;
      }
      percentageStats[i].percentage = (formatMoneyAmountToDouble(percentageStats[i].amount) * 100) / total;
    }
    return percentageStats;
  }

  @override
  List<PercentageStats> showSeparatePercentages(int i, String amountString, List<PercentageStats> percentageStats, String categorieName) {
    PercentageStats newCategorieStats = PercentageStats()
      ..name = categorieName
      ..amount = amountString
      ..percentage = 0.0
      ..statColor = chartColorPalette[i % chartColorPalette.length];
    percentageStats.add(newCategorieStats);
    return percentageStats;
  }
}
