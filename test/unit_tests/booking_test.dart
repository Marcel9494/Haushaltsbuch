import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_rovider;
import 'package:flutter_test/flutter_test.dart';
import 'package:haushaltsbuch/models/booking/booking_model.dart';
import 'package:haushaltsbuch/models/booking/booking_repository.dart';
import 'package:haushaltsbuch/models/enums/amount_types.dart';
import 'package:haushaltsbuch/models/enums/repeat_types.dart';
import 'package:haushaltsbuch/models/enums/transaction_types.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  //var path = Directory.current.path;
  //Hive.init(path + '/test/hive_testing_path');
  test('Einzelbuchung erstellen', () async {
    //final appDocumentDirectory = await path_rovider.getApplicationDocumentsDirectory();
    //Hive.registerAdapter(BookingAdapter());
    Booking booking = Booking()
      ..boxIndex = 1
      ..transactionType = TransactionType.outcome.name
      ..bookingRepeats = RepeatType.noRepetition.name
      ..title = "Einzelbuchung Test"
      ..date = DateTime.now().toString()
      ..amount = "10,00 €"
      ..amountType = AmountType.variableCost.name
      ..categorie = "Lebensmittel"
      ..subcategorie = ""
      ..fromAccount = "Geldbeutel"
      ..toAccount = ""
      ..serieId = -1
      ..booked = true;
    BookingRepository bookingRepository = BookingRepository();

    bookingRepository.create(booking);

    expect(booking.amount, "10,00 €");
  });
}