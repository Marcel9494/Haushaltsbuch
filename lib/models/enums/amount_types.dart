enum AmountType { notDefined, fixCost, variableCost, activeIncome, passiveIncome }

extension AmountTypeExtension on AmountType {
  String get name {
    switch (this) {
      case AmountType.notDefined:
        return 'Nicht definiert';
      case AmountType.fixCost:
        return 'Fix';
      case AmountType.variableCost:
        return 'Variabel';
      case AmountType.activeIncome:
        return 'Aktiv';
      case AmountType.passiveIncome:
        return 'Passiv';
      default:
        throw Exception('$name is not a valid Amount type.');
    }
  }
}
