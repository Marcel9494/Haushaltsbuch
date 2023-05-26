enum StatisticType { assets, debts }

extension StatisticTypeExtension on StatisticType {
  String get name {
    switch (this) {
      case StatisticType.assets:
        return 'Vermögen';
      case StatisticType.debts:
        return 'Schulden';
      default:
        throw Exception('$name is not a valid Statistic type.');
    }
  }
}
