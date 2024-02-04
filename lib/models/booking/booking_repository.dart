import 'package:hive/hive.dart';

import '../account/account_repository.dart';
import '../enums/repeat_types.dart';
import '../enums/transaction_types.dart';
import '../global_state/global_state_repository.dart';

import '/utils/consts/hive_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import 'booking_interface.dart';
import 'booking_model.dart';

class BookingRepository extends BookingInterface {
  AccountRepository accountRepository = AccountRepository();

  @override
  void create(Booking newBooking) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.add(newBooking);
    executeAccountTransaction(newBooking);
  }

  void _createInstance(String title, String transactionType, String date, String bookingRepeats, String amount, String categorie, String subcategorie, String fromAccount,
      String toAccount, bool isSerieBooking) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    GlobalStateRepository globalStateRepository = GlobalStateRepository();
    Booking bookingInstance = Booking()
      ..transactionType = transactionType
      ..bookingRepeats = bookingRepeats
      ..title = title
      ..date = date
      ..amount = amount
      ..categorie = categorie
      ..subcategorie = subcategorie
      ..fromAccount = fromAccount
      ..toAccount = toAccount
      ..serieId = isSerieBooking ? await globalStateRepository.getBookingSerieIndex() : -1
      ..booked = DateTime.parse(date).isAfter(DateTime.now()) ? false : true;
    bookingBox.add(bookingInstance);
    executeAccountTransaction(bookingInstance);
  }

  // TODO Serie auf 10 Jahre erhöhen (3 => 120 Monate), für danach muss sich noch etwas überlegt werden
  /* Für die übergebene Start Buchung wird je nach ausgewählter Buchungswiederholung
  * die gleiche Buchung automatisch wieder erstellt nur mit anderem Buchungsdatum.
  * Außerdem wird geprüft, ob die Buchung in der Zukunft liegt, wenn ja wird diese
  * als noch nicht gebucht angezeigt und erst wenn das Buchungsdatum erreicht ist als gebucht
  * vermerkt und von dem ausgewählten Konto abgezogen.
  * Beispiel: Buchungswiederholung Am Monatsanfang es werden wiederholt Buchungen erstellt
  * zum Monatsanfang 01.10.23, 01.11.23, 01.12.23,...
  */
  @override
  void createSerie(Booking templateBooking) async {
    if (templateBooking.bookingRepeats == RepeatType.everyDay.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day + i);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyWeek.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day + i * 7);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyTwoWeeks.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day + i * 14);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.beginningOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i + 1, 1);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.endOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i + 1, 0);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i, DateTime.parse(templateBooking.date).day);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyThreeMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i * 3, DateTime.parse(templateBooking.date).day);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everySixMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i * 6, DateTime.parse(templateBooking.date).day);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyYear.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year + i, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day);
        _createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    }
  }

  @override
  void executeAccountTransaction(Booking booking) {
    if (booking.booked) {
      if (booking.transactionType == TransactionType.transfer.name || booking.transactionType == TransactionType.investment.name) {
        accountRepository.transferMoney(booking.fromAccount, booking.toAccount, booking.amount);
      } else {
        accountRepository.calculateNewAccountBalance(booking.fromAccount, booking.amount, booking.transactionType);
      }
    } else {
      print('Die Buchung liegt in der Zukunft und wird deshalb nicht auf ein Konto verbucht.');
      // TODO Logging einbauen
    }
  }

  @override
  void updateSingleBooking(Booking updatedBooking, Booking oldBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.putAt(bookingBoxIndex, updatedBooking);
    if (updatedBooking.booked) {
      accountRepository.undoneAccountBooking(oldBooking);
      executeAccountTransaction(updatedBooking);
    }
  }

  @override
  void updateOnlyFutureBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId && booking.boxIndex == bookingBoxIndex) {
        bookingBox.putAt(bookingBoxIndex, templateBooking);
        if (booking.booked) {
          accountRepository.undoneAccountBooking(oldBooking);
          executeAccountTransaction(templateBooking);
        }
      } else if (booking.serieId == templateBooking.serieId && DateTime.parse(booking.date).isAfter(DateTime.parse(templateBooking.date))) {
        if (booking.booked) {
          accountRepository.undoneAccountBooking(booking);
        }
        bool booked = true;
        if (DateTime.parse(booking.date).isAfter(DateTime.now())) {
          booked = false;
        }
        Booking newBooking = Booking()
          ..transactionType = templateBooking.transactionType
          ..bookingRepeats = templateBooking.bookingRepeats
          ..title = templateBooking.title
          ..date = booking.date
          ..amount = templateBooking.amount
          ..categorie = templateBooking.categorie
          ..subcategorie = templateBooking.subcategorie
          ..fromAccount = templateBooking.fromAccount
          ..toAccount = templateBooking.toAccount
          ..serieId = templateBooking.serieId
          ..booked = booked;
        bookingBox.putAt(booking.boxIndex, newBooking);
        executeAccountTransaction(newBooking);
      }
    }
  }

  @override
  void updateAllBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId && booking.boxIndex == bookingBoxIndex) {
        bookingBox.putAt(bookingBoxIndex, templateBooking);
        if (booking.booked) {
          accountRepository.undoneAccountBooking(oldBooking);
          executeAccountTransaction(templateBooking);
        }
      } else if (booking.serieId == templateBooking.serieId) {
        if (booking.booked) {
          accountRepository.undoneAccountBooking(booking);
        }
        bool booked = true;
        if (DateTime.parse(booking.date).isAfter(DateTime.now())) {
          booked = false;
        }
        Booking newBooking = Booking()
          ..transactionType = templateBooking.transactionType
          ..bookingRepeats = templateBooking.bookingRepeats
          ..title = templateBooking.title
          ..date = booking.date
          ..amount = templateBooking.amount
          ..categorie = templateBooking.categorie
          ..subcategorie = templateBooking.subcategorie
          ..fromAccount = templateBooking.fromAccount
          ..toAccount = templateBooking.toAccount
          ..serieId = templateBooking.serieId
          ..booked = booked;
        bookingBox.putAt(booking.boxIndex, newBooking);
        executeAccountTransaction(newBooking);
      }
    }
  }

  @override
  Future<void> updateBookingCategorieName(String oldCategorieName, String newCategorieName) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.categorie == oldCategorieName) {
        Booking updatedBookingWithNewCategorieName = Booking()
          ..boxIndex = i
          ..transactionType = booking.transactionType
          ..bookingRepeats = booking.bookingRepeats
          ..title = booking.title
          ..date = booking.date
          ..amount = booking.amount
          ..categorie = newCategorieName
          ..subcategorie = booking.subcategorie
          ..fromAccount = booking.fromAccount
          ..toAccount = booking.toAccount
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(i, updatedBookingWithNewCategorieName);
      }
    }
  }

  @override
  Future<void> updateBookingSubcategorieName(String oldSubcategorieName, String newSubcategorieName) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.subcategorie.contains(oldSubcategorieName)) {
        Booking updatedBookingWithNewCategorieName = Booking()
          ..boxIndex = i
          ..transactionType = booking.transactionType
          ..bookingRepeats = booking.bookingRepeats
          ..title = booking.title
          ..date = booking.date
          ..amount = booking.amount
          ..categorie = booking.categorie
          ..subcategorie = newSubcategorieName
          ..fromAccount = booking.fromAccount
          ..toAccount = booking.toAccount
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(i, updatedBookingWithNewCategorieName);
      }
    }
  }

  @override
  Future<void> updateBookingAccountName(String oldAccountName, String newAccountName) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      // if für Performanceverbesserung => nur betroffene Buchungen werden geupdatet
      if (booking.fromAccount == oldAccountName || booking.toAccount == oldAccountName) {
        Booking updatedBookingWithNewAccountName = Booking()
          ..transactionType = booking.transactionType
          ..bookingRepeats = booking.bookingRepeats
          ..title = booking.title
          ..date = booking.date
          ..amount = booking.amount
          ..categorie = booking.categorie
          ..subcategorie = booking.subcategorie
          ..fromAccount = booking.fromAccount == oldAccountName ? newAccountName : oldAccountName
          ..toAccount = booking.toAccount == oldAccountName ? newAccountName : oldAccountName
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(i, updatedBookingWithNewAccountName);
      }
    }
  }

  @override
  void deleteSingleBooking(int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking booking = await bookingBox.getAt(bookingBoxIndex);
    if (booking.booked) {
      accountRepository.undoneAccountBooking(booking);
    }
    bookingBox.deleteAt(bookingBoxIndex);
  }

  @override
  void deleteOnlyFutureBookingsFromSerie(Booking templateBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = bookingBox.length - 1; i >= 0; i--) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId && booking.booked) {
        accountRepository.undoneAccountBooking(booking);
      }
      if (i == bookingBoxIndex) {
        bookingBox.deleteAt(bookingBoxIndex);
      } else if (booking.serieId == templateBooking.serieId && DateTime.parse(booking.date).isAfter(DateTime.parse(templateBooking.date))) {
        bookingBox.deleteAt(i);
      }
    }
  }

  @override
  void deleteAllBookingsFromSerie(Booking templateBooking, int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = bookingBox.length - 1; i >= 0; i--) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId == templateBooking.serieId && booking.booked) {
        accountRepository.undoneAccountBooking(booking);
      }
      if (booking.serieId == templateBooking.serieId) {
        bookingBox.deleteAt(i);
      }
    }
  }

  @override
  Future<Booking> load(int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking booking = await bookingBox.getAt(bookingBoxIndex);
    return booking;
  }

  @override
  Future<List<Booking>> loadMonthlyBookingList(int selectedMonth, int selectedYear, [String categorie = '', String account = '', String transactionType = '']) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    List<Booking> bookingList = [];
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      // TODO Code verbessern?!
      if (transactionType == TransactionType.income.pluralName) {
        transactionType = TransactionType.income.name;
      } else if (transactionType == TransactionType.outcome.pluralName) {
        transactionType = TransactionType.outcome.name;
      }
      if (DateTime.parse(booking.date).month == selectedMonth && DateTime.parse(booking.date).year == selectedYear) {
        if (categorie == '' && account == '' && transactionType == '') {
          booking.boxIndex = i;
          bookingList.add(booking);
          continue;
        }
        if (transactionType != '' && booking.transactionType == transactionType && categorie != '' && booking.categorie == categorie) {
          booking.boxIndex = i;
          bookingList.add(booking);
          continue;
        }
        if (account != '' && booking.fromAccount == account) {
          booking.boxIndex = i;
          bookingList.add(booking);
          continue;
        }
      }
    }
    bookingList.sort((first, second) => second.date.compareTo(first.date));
    return bookingList;
  }

  @override
  Future<List<Booking>> loadSubcategorieBookingList(List<Booking> bookingList, String subcategorie) async {
    List<Booking> subcategorieBookingList = [];
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].subcategorie == subcategorie) {
        subcategorieBookingList.add(bookingList[i]);
      }
    }
    return subcategorieBookingList;
  }

  @override
  double getRevenues(List<Booking> bookingList) {
    double revenues = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.income.name) {
        revenues += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return revenues;
  }

  @override
  double getExpenditures(List<Booking> bookingList, [String categorie = '']) {
    double expenditures = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if ((bookingList[i].transactionType == TransactionType.outcome.name && categorie == '') ||
          (bookingList[i].transactionType == TransactionType.outcome.name && bookingList[i].categorie == categorie && categorie != '')) {
        expenditures += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return expenditures;
  }

  @override
  double getSubcategorieExpenditures(List<Booking> bookingList, String categorie, String subcategorie) {
    double subcategorieExpenditures = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if ((bookingList[i].transactionType == TransactionType.outcome.name && categorie == bookingList[i].categorie && subcategorie == bookingList[i].subcategorie)) {
        subcategorieExpenditures += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return subcategorieExpenditures;
  }

  @override
  double getInvestments(List<Booking> bookingList) {
    double investments = 0.0;
    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].transactionType == TransactionType.investment.name) {
        investments += formatMoneyAmountToDouble(bookingList[i].amount);
      }
    }
    return investments;
  }

  // TODO Funktion implementieren, ob seit letztem mal eine neue Buchung z.B. eine angelegte Serienbuchung als Abrechnung dazu gekommen ist
  @override
  void checkForNewSerieBookings() async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId != -1 && booking.booked == false) {
        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime dateToCheck = DateTime(DateTime.parse(booking.date).year, DateTime.parse(booking.date).month, DateTime.parse(booking.date).day);
        if (DateTime.parse(booking.date).isBefore(DateTime.now()) || dateToCheck == today) {
          Booking()
            ..transactionType = booking.transactionType
            ..bookingRepeats = booking.bookingRepeats
            ..title = booking.title
            ..date = booking.date
            ..amount = booking.amount
            ..categorie = booking.categorie
            ..subcategorie = booking.subcategorie
            ..fromAccount = booking.fromAccount
            ..toAccount = booking.toAccount
            ..serieId = booking.serieId
            ..booked = true;
          bookingBox.putAt(i, booking);
        }
      }
    }
  }
}
