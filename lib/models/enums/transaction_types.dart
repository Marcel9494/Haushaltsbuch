enum TransactionType { income, outcome, transfer }

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.income:
        return 'Einnahme';
      case TransactionType.outcome:
        return 'Ausgabe';
      case TransactionType.transfer:
        return 'Übertrag';
      default:
        return '';
    }
  }
}
