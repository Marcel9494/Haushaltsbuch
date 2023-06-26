import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import 'account.dart';
import 'enums/repeat_types.dart';
import 'enums/serie_edit_modes.dart';
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
  @HiveField(9)
  late bool booked;

  void createBooking(String title, String transactionType, String date, String bookingRepeats, String amount, String categorie, String fromAccount, String toAccount,
      [int serieId = -1, bool booked = true]) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking newBooking = Booking()
      ..transactionType = transactionType
      ..bookingRepeats = bookingRepeats
      ..title = title
      ..date = date
      ..amount = amount
      ..categorie = categorie
      ..fromAccount = fromAccount
      ..toAccount = toAccount
      ..serieId = serieId
      ..booked = booked;
    bookingBox.add(newBooking);
  }

  Future<Booking> updateBookingBookedState(Booking updatedBooking) async {
    return Booking()
      ..transactionType = updatedBooking.transactionType
      ..bookingRepeats = updatedBooking.bookingRepeats
      ..title = updatedBooking.title
      ..date = updatedBooking.date
      ..amount = updatedBooking.amount
      ..categorie = updatedBooking.categorie
      ..fromAccount = updatedBooking.fromAccount
      ..toAccount = updatedBooking.toAccount
      ..serieId = updatedBooking.serieId
      ..booked = true;
  }

  Future<Booking> updateBookingInstance(Booking templateBooking, Booking oldBooking) async {
    bool booked = true;
    if (DateTime.parse(oldBooking.date).isAfter(DateTime.now())) {
      booked = false;
    }
    return Booking()
      ..transactionType = templateBooking.transactionType
      ..bookingRepeats = templateBooking.bookingRepeats
      ..title = templateBooking.title
      ..date = oldBooking.date
      ..amount = templateBooking.amount
      ..categorie = templateBooking.categorie
      ..fromAccount = templateBooking.fromAccount
      ..toAccount = templateBooking.toAccount
      ..serieId = templateBooking.serieId
      ..booked = booked;
  }

  // TODO Serie auf 10 Jahre erhöhen (3 => 120 Monate), für danach muss sich noch etwas überlegt werden
  void createBookingSerie(String title, String transactionType, String date, String bookingRepeats, String amount, String categorie, String fromAccount, String toAccount,
      [int serieId = -1, bool booked = true]) async {
    if (bookingRepeats == RepeatType.everyDay.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day + i);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        print(GlobalState.getBookingSerieIndex());
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everyWeek.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day + i * 7);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everyTwoWeeks.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month, DateTime.parse(date).day + i * 14);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.beginningOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month + i + 1, 1);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.endOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month + i + 1, 0);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everyMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month + i, DateTime.parse(date).day);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everyThreeMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month + i * 3, DateTime.parse(date).day);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everySixMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year, DateTime.parse(date).month + i * 6, DateTime.parse(date).day);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    } else if (bookingRepeats == RepeatType.everyYear.name) {
      for (int i = 0; i < 3; i++) {
        DateTime bookingDate = DateTime(DateTime.parse(date).year + i, DateTime.parse(date).month, DateTime.parse(date).day);
        bool booked = true;
        if (bookingDate.isAfter(DateTime.now())) {
          booked = false;
        }
        createBooking(title, transactionType, bookingDate.toString(), bookingRepeats, amount, categorie, fromAccount, toAccount, await GlobalState.getBookingSerieIndex(), booked);
      }
    }
    GlobalState.increaseBookingSerieIndex();
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

  void updateSerieBookings(Booking templateBooking, Booking oldBooking, int bookingBoxIndex, SerieEditModeType serieEditMode) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.putAt(bookingBoxIndex, templateBooking);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (serieEditMode == SerieEditModeType.onlyFuture) {
        if (booking.serieId == templateBooking.serieId && DateTime.parse(booking.date).isAfter(DateTime.parse(templateBooking.date))) {
          Booking updatedBooking = await updateBookingInstance(templateBooking, booking);
          bookingBox.putAt(i, updatedBooking);
          if (booking.booked) {
            // TODO hier weitermachen Kontostand wird noch nicht richtig zurückgesetzt und neu berechnet, wenn eine Serienbuchung bearbeitet wird
            Account.undoneAccountBooking(booking);
            if (booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name) {
              Account.transferMoney(booking.fromAccount, booking.toAccount, booking.amount);
            } else {
              Account.calculateNewAccountBalance(booking.fromAccount, booking.amount, booking.transactionType);
            }
          }
        }
      } else if (serieEditMode == SerieEditModeType.all) {
        if (booking.serieId == templateBooking.serieId) {
          Booking updatedBooking = await updateBookingInstance(templateBooking, booking);
          bookingBox.putAt(i, updatedBooking);
          if (booking.booked) {
            Account.undoneAccountBooking(booking);
            if (booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name) {
              Account.transferMoney(booking.fromAccount, booking.toAccount, booking.amount);
            } else {
              Account.calculateNewAccountBalance(booking.fromAccount, booking.amount, booking.transactionType);
            }
          }
        }
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

  // TODO Funktion implementieren, ob seit letztem mal eine neue Buchung z.B. eine angelegte Serienbuchung als Abrechnung
  // TODO dazu gekommen ist. Extra Variable bei Buchungen einführen, ob Buchung bereits auf ein Konto verbucht wurde oder nicht?!
  // TODO testen bei Konto Übersichtsseite
  static void checkForNewSerieBookings() async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId != -1 && booking.booked == false) {
        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime dateToCheck = DateTime(DateTime.parse(booking.date).year, DateTime.parse(booking.date).month, DateTime.parse(booking.date).day);
        if (DateTime.parse(booking.date).isBefore(DateTime.now()) || dateToCheck == today) {
          booking.updateBookingBookedState(booking);
          bookingBox.putAt(i, booking);
        }
      }
    }
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
      ..serieId = reader.read()
      ..booked = reader.read();
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
    writer.write(obj.booked);
  }
}
