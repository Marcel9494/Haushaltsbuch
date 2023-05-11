enum OutcomeStatisticType { outcome, savingrate, investmentrate }

extension OutcomeStatisticTypeExtension on OutcomeStatisticType {
  String get name {
    switch (this) {
      case OutcomeStatisticType.outcome:
        return 'Nur Ausgaben';
      case OutcomeStatisticType.savingrate:
        return 'Sparquote';
      case OutcomeStatisticType.investmentrate:
        return 'Investitionsquote';
      default:
        throw Exception('$name is not a valid Outcome Statistic.');
    }
  }
}
