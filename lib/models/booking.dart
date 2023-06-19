import 'package:hive/hive.dart';

import '/utils/number_formatters/number_formatter.dart';
import '/utils/consts/hive_consts.dart';

import 'enums/repeat_types.dart';
import 'enums/transaction_types.dart';
import 'global_state.dart';

@HiveType(typeId: 0)
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
  late String fromAccount;
  @HiveField(7)
  late String toAccount;
  @HiveField(8)
  late int serieId;

  Future<Booking> createBookingInstance(Booking newBooking) async {
    // TODO int bookingSerieIndex = await GlobalState.getBookingSerieIndex();
    return Booking()
      ..transactionType = newBooking.transactionType
      ..bookingRepeats = newBooking.bookingRepeats
      ..title = newBooking.title
      ..date = newBooking.date
      ..amount = newBooking.amount
      ..categorie = newBooking.categorie
      ..fromAccount = newBooking.fromAccount
      ..toAccount = newBooking.toAccount
      ..serieId = newBooking.serieId;
  }

  Future<Booking> updateBookingInstance(Booking templateBooking, Booking oldBooking) async {
    return Booking()
      ..transactionType = templateBooking.transactionType
      ..bookingRepeats = templateBooking.bookingRepeats
      ..title = templateBooking.title
      ..date = oldBooking.date
      ..amount = templateBooking.amount
      ..categorie = templateBooking.categorie
      ..fromAccount = templateBooking.fromAccount
      ..toAccount = templateBooking.toAccount
      ..serieId = templateBooking.serieId;
  }

  // TODO Anzahl der Buchungen erhöhen, damit für die nächsten 10 Jahre Buchungen erstellt werden. 3 nur als Test.
  void createBooking(Booking newBooking) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    if (newBooking.bookingRepeats == RepeatType.noRepetition.name) {
      bookingBox.add(newBooking);
    } else if (newBooking.bookingRepeats == RepeatType.everyWeek.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month, bookingDate.day + (i * 7)).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.everyTwoWeeks.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month, bookingDate.day + (i * 14)).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.beginningOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month + i + 1, 1).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.endOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        int lastDayOfMonth = DateTime(bookingDate.year, bookingDate.month + i + 1, 0).day;
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month + i, lastDayOfMonth).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.everyMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month + i, bookingDate.day).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.everyThreeMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month + (i * 3), bookingDate.day).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.everySixMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year, bookingDate.month + (i * 6), bookingDate.day).toString();
        bookingBox.add(nextBooking);
      }
    } else if (newBooking.bookingRepeats == RepeatType.everyYear.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime.parse(date);
        Booking nextBooking = await createBookingInstance(newBooking);
        nextBooking.date = DateTime(bookingDate.year + i, bookingDate.month, bookingDate.day).toString();
        bookingBox.add(nextBooking);
      }
    }
  }

  void updateBooking(Booking updatedBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.putAt(bookingBoxIndex, updatedBooking);
  }

  void updateFutureBookingsFromSerie(Booking templateBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.putAt(bookingBoxIndex, templateBooking);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId && DateTime.parse(booking.date).isAfter(DateTime.parse(templateBooking.date))) {
        Booking updatedBooking = await updateBookingInstance(templateBooking, booking);
        bookingBox.putAt(i, updatedBooking);
      }
    }
  }

  void updateAllBookingsFromSerie(Booking templateBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.putAt(bookingBoxIndex, templateBooking);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId) {
        Booking updatedBooking = await updateBookingInstance(templateBooking, booking);
        bookingBox.putAt(i, updatedBooking);
      }
    }
  }

  void deleteBooking(int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.deleteAt(bookingBoxIndex);
  }

  static Future<Booking> loadBooking(int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking booking = await bookingBox.getAt(bookingBoxIndex);
    return booking;
  }

  static Future<List<Booking>> loadMonthlyBookingList(int selectedMonth, int selectedYear, [String categorie = '', String account = '']) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    List<Booking> bookingList = [];
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if ((DateTime.parse(booking.date).month == selectedMonth && DateTime.parse(booking.date).year == selectedYear && categorie == '' && account == '') ||
          (DateTime.parse(booking.date).month == selectedMonth && DateTime.parse(booking.date).year == selectedYear && categorie != '' && booking.categorie == categorie) ||
          (DateTime.parse(booking.date).month == selectedMonth && DateTime.parse(booking.date).year == selectedYear && account != '' && booking.fromAccount == account)) {
        booking.boxIndex = i;
        bookingList.add(booking);
      }
    }
    bookingList.sort((first, second) => second.date.compareTo(first.date));
    return bookingList;
  }

  static double getRevenues(List<Booking> bookingList) {
    double revenues = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.income.name) {
        revenues += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return revenues;
  }

  static double getExpenditures(List<Booking> bookingList, [String categorie = '']) {
    double expenditures = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if ((bookingList[i].transactionType == TransactionType.outcome.name && categorie == '') ||
          (bookingList[i].transactionType == TransactionType.outcome.name && bookingList[i].categorie == categorie && categorie != '')) {
        expenditures += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return expenditures;
  }

  static double getInvestments(List<Booking> bookingList) {
    double investments = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.investment.name) {
        investments += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return investments;
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
      ..toAccount = reader.read()
      ..serieId = reader.read();
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
    writer.write(obj.serieId);
  }
}
