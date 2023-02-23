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

  BookingRepeats getBookingRepeats(String bookingRepeats) {
    try {
      if (bookingRepeats == BookingRepeats.noRepeat.name) {
        return BookingRepeats.noRepeat;
      } else if (bookingRepeats == BookingRepeats.everyDay.name) {
        return BookingRepeats.everyDay;
      } else if (bookingRepeats == BookingRepeats.everyWeek.name) {
        return BookingRepeats.everyWeek;
      } else if (bookingRepeats == BookingRepeats.everyMonth.name) {
        return BookingRepeats.everyMonth;
      }
    } catch (e) {
      throw Exception('$bookingRepeats is not a valid BookingRepeat.');
    }
    return BookingRepeats.noRepeat;
  }
}

class BookingRepeatsAdapter extends TypeAdapter<BookingRepeats> {
  @override
  final typeId = 2;

  @override
  BookingRepeats read(BinaryReader reader) {
    return BookingRepeats.noRepeat;
  }

  @override
  void write(BinaryWriter writer, BookingRepeats obj) {
    writer.write(obj.name);
  }
}
