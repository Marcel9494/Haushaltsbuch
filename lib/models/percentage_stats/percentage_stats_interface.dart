import 'dart:ui';

import '/models/percentage_stats/percentage_stats_model.dart';

abstract class PercentageStatsInterface {
  // TODO extra create Funktion ohne update implementieren für saubere Trennung der Funktionen?
  List<PercentageStats> createOrUpdate(int i, String amountString, List<PercentageStats> percentageStats, String categorieName, bool categorieStatsAreUpdated);
  List<PercentageStats> update(int i, String amountString, List<PercentageStats> percentageStats, String categorieName, Color color);
  List<PercentageStats> calculatePercentage(List<PercentageStats> percentageStats, double total);
  List<PercentageStats> showSeparatePercentages(int i, String amountString, List<PercentageStats> percentageStats, String categorieName);
}
