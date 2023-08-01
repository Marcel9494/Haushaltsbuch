enum PreselectAccountType { income, outcome, transferFrom, transferTo, investmentFrom, investmentTo }

extension PreselectAccountTypeExtension on PreselectAccountType {
  String get name {
    switch (this) {
      case PreselectAccountType.income:
        return 'Einnahme';
      case PreselectAccountType.outcome:
        return 'Ausgabe';
      case PreselectAccountType.transferFrom:
        return 'Übertrag von ...';
      case PreselectAccountType.transferTo:
        return 'Übertrag nach ...';
      case PreselectAccountType.investmentFrom:
        return 'Investition von ...';
      case PreselectAccountType.investmentTo:
        return 'Investition nach ...';
      default:
        throw Exception('$name is not a valid preselect Account type.');
    }
  }
}
