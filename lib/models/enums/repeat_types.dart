enum RepeatType { never, everyWeek, everyTwoWeeks, everyMonth, everyThreeMonths, everySixMonths, everyYear }

extension RepeatTypeExtension on RepeatType {
  String get name {
    switch (this) {
      case RepeatType.never:
        return 'Nie';
      case RepeatType.everyWeek:
        return 'Jede Woche';
      case RepeatType.everyTwoWeeks:
        return 'Alle zwei Wochen';
      case RepeatType.everyMonth:
        return 'Jeden Monat';
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
