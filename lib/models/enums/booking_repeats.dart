enum BookingRepeats { everyDay, everyWeek, everyMonth }

extension BookingRepeatsExtension on BookingRepeats {
  String get name {
    switch (this) {
      case BookingRepeats.everyDay:
        return 'Jeden Tag';
      case BookingRepeats.everyWeek:
        return 'Jede Woche';
      case BookingRepeats.everyMonth:
        return 'Jeden Monat';
      default:
        return '';
    }
  }
}
