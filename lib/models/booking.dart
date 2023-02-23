import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import '/models/enums/transaction_types.dart';
import '/models/enums/booking_repeats.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late TransactionType transactionType;
  @HiveField(2)
  late String date;
  @HiveField(3)
  late BookingRepeats bookingRepeats;
  @HiveField(4)
  late String amount;
  @HiveField(5)
  late String categorie;
  @HiveField(6)
  late String fromAccount;
  @HiveField(7)
  late String toAccount;

  void createBooking(Booking newBooking) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.add(newBooking);
  }

  static Future<Booking> loadBooking() async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking booking = bookingBox.getAt(0);
    return booking;
  }
}

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final typeId = 0;

  @override
  Booking read(BinaryReader reader) {
    return Booking()
      ..title = reader.read()
      ..transactionType = reader.read()
      ..date = reader.read()
      ..bookingRepeats = reader.read()
      ..amount = reader.read()
      ..categorie = reader.read()
      ..fromAccount = reader.read()
      ..toAccount = reader.read();
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer.write(obj.title);
    writer.write(obj.transactionType);
    writer.write(obj.date);
    writer.write(obj.bookingRepeats);
    writer.write(obj.amount);
    writer.write(obj.categorie);
    writer.write(obj.fromAccount);
    writer.write(obj.toAccount);
  }
}
