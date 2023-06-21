enum RepeatType { noRepetition, everyDay, everyWeek, everyTwoWeeks, everyMonth, beginningOfMonth, endOfMonth, everyThreeMonths, everySixMonths, everyYear }

extension RepeatTypeExtension on RepeatType {
  String get name {
    switch (this) {
      case RepeatType.noRepetition:
        return 'Keine Wiederholung';
      case RepeatType.everyDay:
        return 'Jeden Tag';
      case RepeatType.everyWeek:
        return 'Jede Woche';
      case RepeatType.everyTwoWeeks:
        return 'Alle zwei Wochen';
      case RepeatType.everyMonth:
        return 'Jeden Monat';
      case RepeatType.beginningOfMonth:
        return 'Am Monatsanfang';
      case RepeatType.endOfMonth:
        return 'Am Monatsende';
      case RepeatType.everyThreeMonths:
        return 'Alle drei Monate';
      case RepeatType.everySixMonths:
        return 'Alle sechs Monate';
      case RepeatType.everyYear:
        return 'Jedes Jahr';
      default:
        throw Exception('$name is not a valid Account type.');
    }
  }
}
