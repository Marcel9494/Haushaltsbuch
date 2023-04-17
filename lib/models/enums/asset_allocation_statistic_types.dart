enum AssetAllocationStatisticType { individualAccounts, individualAccountTypes, capitalOrRiskFreeInvestments }

extension AssetAllocationStatisticTypeExtension on AssetAllocationStatisticType {
  String get name {
    switch (this) {
      case AssetAllocationStatisticType.individualAccounts:
        return 'Einzelne Konten';
      case AssetAllocationStatisticType.individualAccountTypes:
        return 'Einzelne Kontotypen';
      case AssetAllocationStatisticType.capitalOrRiskFreeInvestments:
        return 'Kapitalanlagen vs. risikolose Anlagen';
      default:
        throw Exception('$name is not a valid Asset Allocation Statistic type.');
    }
  }
}
