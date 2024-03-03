import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: bookingTypeId)
class Booking extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String transactionType;
  @HiveField(2)
  late String date;
  @HiveField(3)
  late String bookingRepeats;
  @HiveField(4)
  late String amount; // Format: 8,30 €
  @HiveField(5)
  late String categorie;
  @HiveField(6)
  late String subcategorie;
  @HiveField(7)
  late String fromAccount;
  @HiveField(8)
  late String toAccount;
  @HiveField(9)
  late int serieId;
  @HiveField(10)
  late bool booked;
  @HiveField(11)
  late String amountType;

  // TODO hier weitermachen siehe: https://www.dhiwise.com/post/mastering-the-dart-copywith-method-a-comprehensive-guide
  // Variablen final machen nicht vergessen
  // Anschließend: https://stackoverflow.com/questions/72548100/iam-having-a-problem-with-adding-fields-in-a-hive-model-in-flutter
  //Booking({required this.boxIndex, this.title, this.transactionType});

  /*Booking copyWith({int? boxIndex, String? title, String? transactionType}) => Booking(
        boxIndex: boxIndex ?? this.boxIndex,
        title: title ?? this.title,
        transactionType: transactionType ?? this.transactionType,
      );*/

  /*Booking copyWith({
    final int? boxIndex,
  }) {
    return Booking(
      boxIndex: boxIndex ?? this.boxIndex,
    );
  }*/
}

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final typeId = bookingTypeId;

  @override
  Booking read(BinaryReader reader) {
    return Booking()
      ..title = reader.read()
      ..transactionType = reader.read()
      ..date = reader.read()
      ..bookingRepeats = reader.read()
      ..amount = reader.read()
      ..categorie = reader.read()
      ..subcategorie = reader.read()
      ..fromAccount = reader.read()
      ..toAccount = reader.read()
      ..serieId = reader.read()
      ..booked = reader.read()
      ..amountType = reader.read();
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer.write(obj.title);
    writer.write(obj.transactionType);
    writer.write(obj.date);
    writer.write(obj.bookingRepeats);
    writer.write(obj.amount);
    writer.write(obj.categorie);
    writer.write(obj.subcategorie);
    writer.write(obj.fromAccount);
    writer.write(obj.toAccount);
    writer.write(obj.serieId);
    writer.write(obj.booked);
    writer.write(obj.amountType);
  }
}
