enum StatisticType { assetDevelopment, assetAllocation }

extension StatisticTypeExtension on StatisticType {
  String get name {
    switch (this) {
      case StatisticType.assetDevelopment:
        return 'Vermögensentwicklung';
      case StatisticType.assetAllocation:
        return 'Vermögensaufteilung';
      default:
        throw Exception('$name is not a valid Statistic type.');
    }
  }
}
