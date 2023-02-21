import 'package:hive/hive.dart';

@HiveType(typeId: 2)
enum BookingRepeats { noRepeat, everyDay, everyWeek, everyMonth }

extension BookingRepeatsExtension on BookingRepeats {
  String get name {
    switch (this) {
      case BookingRepeats.noRepeat:
        return 'Keine Wiederholung';
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

class BookingRepeatsAdapter extends TypeAdapter<BookingRepeats> {
  @override
  final typeId = 2;

  @override
  BookingRepeats read(BinaryReader reader) {
    return BookingRepeats.everyDay;
  }

  @override
  void write(BinaryWriter writer, BookingRepeats obj) {
    writer.write(obj.name);
  }
}
