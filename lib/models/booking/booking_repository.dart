import 'package:hive/hive.dart';

import '../account/account_repository.dart';
import '../enums/repeat_types.dart';
import '../enums/serie_edit_modes.dart';
import '../enums/transaction_types.dart';
import '../global_state/global_state_repository.dart';

import '/utils/consts/hive_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import 'booking_interface.dart';
import 'booking_model.dart';

class BookingRepository extends BookingInterface {
  AccountRepository accountRepository = AccountRepository(); // TODO geht das besser?

  @override
  void create(Booking newBooking) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    bookingBox.add(newBooking);
    executeAccountTransaction(newBooking);
  }

  @override
  void createInstance(String title, String transactionType, String date, String bookingRepeats, String amount, String categorie, String subcategorie, String fromAccount,
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
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyWeek.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day + i * 7);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyTwoWeeks.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day + i * 14);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.beginningOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i + 1, 1);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.endOfMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i + 1, 0);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyMonth.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i, DateTime.parse(templateBooking.date).day);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyThreeMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i * 3, DateTime.parse(templateBooking.date).day);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everySixMonths.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate =
            DateTime(DateTime.parse(templateBooking.date).year, DateTime.parse(templateBooking.date).month + i * 6, DateTime.parse(templateBooking.date).day);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
            templateBooking.categorie, templateBooking.subcategorie, templateBooking.fromAccount, templateBooking.toAccount, true);
      }
    } else if (templateBooking.bookingRepeats == RepeatType.everyYear.name) {
      for (int i = 0; i < 3; i++) {
        DateTime nextBookingDate = DateTime(DateTime.parse(templateBooking.date).year + i, DateTime.parse(templateBooking.date).month, DateTime.parse(templateBooking.date).day);
        createInstance(templateBooking.title, templateBooking.transactionType, nextBookingDate.toString(), templateBooking.bookingRepeats, templateBooking.amount,
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
  Future<Booking> updateBookingBookedState(Booking updatedBooking) async {
    return Booking()
      ..transactionType = updatedBooking.transactionType
      ..bookingRepeats = updatedBooking.bookingRepeats
      ..title = updatedBooking.title
      ..date = updatedBooking.date
      ..amount = updatedBooking.amount
      ..categorie = updatedBooking.categorie
      ..subcategorie = updatedBooking.subcategorie
      ..fromAccount = updatedBooking.fromAccount
      ..toAccount = updatedBooking.toAccount
      ..serieId = updatedBooking.serieId
      ..booked = true;
  }

  @override
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
      ..subcategorie = templateBooking.subcategorie
      ..fromAccount = templateBooking.fromAccount
      ..toAccount = templateBooking.toAccount
      ..serieId = templateBooking.serieId
      ..booked = booked;
  }

  @override
  void update(Booking templateBooking, Booking oldBooking, int bookingBoxIndex, SerieEditModeType serieEditMode) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (serieEditMode == SerieEditModeType.none || serieEditMode == SerieEditModeType.single) {
        // TODO hier weitermachen booking.booked passt nicht, weil bei einzelner Buchung die in der Zukunft liegt und bearbeitet wird
        // soll die Buchung ebenfalls bearbeitet werden können in zwei ifs aufteilen? booking.booked in extra if?
        if (booking.serieId == templateBooking.serieId && booking.boxIndex == bookingBoxIndex && booking.booked) {
          accountRepository.undoneAccountBooking(oldBooking);
          bookingBox.putAt(bookingBoxIndex, templateBooking);
          executeAccountTransaction(templateBooking);
        }
      } else if (serieEditMode == SerieEditModeType.onlyFuture) {
        if (booking.serieId == templateBooking.serieId && booking.boxIndex == bookingBoxIndex) {
          if (booking.booked) {
            accountRepository.undoneAccountBooking(oldBooking);
          }
          bookingBox.putAt(bookingBoxIndex, templateBooking);
          executeAccountTransaction(templateBooking);
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
      } else if (serieEditMode == SerieEditModeType.all) {
        if (booking.serieId == templateBooking.serieId && booking.boxIndex == bookingBoxIndex) {
          if (booking.booked) {
            accountRepository.undoneAccountBooking(oldBooking);
          }
          bookingBox.putAt(bookingBoxIndex, templateBooking);
          executeAccountTransaction(templateBooking);
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
  }

  // TODO subcategorie mit abhandeln oder eigene Funktion für updateBookingSubcategorie implementieren?
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
          ..fromAccount = booking.fromAccount
          ..toAccount = booking.toAccount
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(updatedBookingWithNewCategorieName.boxIndex, updatedBookingWithNewCategorieName);
      }
    }
  }

  @override
  Future<void> updateBookingAccountName(String oldAccountName, String newAccountName) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.fromAccount == oldAccountName) {
        Booking updatedBookingWithNewAccountName = Booking()
          ..transactionType = booking.transactionType
          ..bookingRepeats = booking.bookingRepeats
          ..title = booking.title
          ..date = booking.date
          ..amount = booking.amount
          ..categorie = booking.categorie
          ..subcategorie = booking.subcategorie
          ..fromAccount = newAccountName
          ..toAccount = booking.toAccount
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(updatedBookingWithNewAccountName.boxIndex, updatedBookingWithNewAccountName);
      }
      if (booking.toAccount == oldAccountName) {
        Booking updatedBookingWithNewAccountName = Booking()
          ..transactionType = booking.transactionType
          ..bookingRepeats = booking.bookingRepeats
          ..title = booking.title
          ..date = booking.date
          ..amount = booking.amount
          ..categorie = booking.categorie
          ..subcategorie = booking.subcategorie
          ..fromAccount = booking.fromAccount
          ..toAccount = newAccountName
          ..serieId = booking.serieId
          ..booked = booking.booked;
        bookingBox.putAt(updatedBookingWithNewAccountName.boxIndex, updatedBookingWithNewAccountName);
      }
    }
  }

  @override
  Future<void> delete(int bookingBoxIndex) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    Booking booking = await bookingBox.getAt(bookingBoxIndex);
    if (booking.booked) {
      accountRepository.undoneAccountBooking(booking);
    }
    bookingBox.deleteAt(bookingBoxIndex);
  }

  @override
  void deleteSerieBookings(Booking templateBooking, int bookingBoxIndex, SerieEditModeType serieEditMode) async {
    var bookingBox = await Hive.openBox(bookingsBox);
    if (serieEditMode == SerieEditModeType.none || serieEditMode == SerieEditModeType.single) {
      Booking booking = await bookingBox.getAt(bookingBoxIndex);
      if (booking.booked) {
        accountRepository.undoneAccountBooking(booking);
      }
      bookingBox.deleteAt(bookingBoxIndex);
    } else if (serieEditMode == SerieEditModeType.onlyFuture) {
      for (int i = bookingBox.length - 1; i >= 0; i--) {
        Booking booking = await bookingBox.getAt(i);
        if (booking.booked) {
          accountRepository.undoneAccountBooking(booking);
        }
        if (booking.boxIndex == bookingBoxIndex) {
          bookingBox.deleteAt(bookingBoxIndex);
        } else if (booking.serieId == templateBooking.serieId && DateTime.parse(booking.date).isAfter(DateTime.parse(templateBooking.date))) {
          bookingBox.deleteAt(i);
        }
      }
    } else if (serieEditMode == SerieEditModeType.all) {
      for (int i = bookingBox.length - 1; i >= 0; i--) {
        Booking booking = await bookingBox.getAt(i);
        if (booking.booked) {
          accountRepository.undoneAccountBooking(booking);
        }
        if (booking.serieId == templateBooking.serieId) {
          bookingBox.deleteAt(i);
        }
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
  Future<List<Booking>> loadMonthlyBookingList(int selectedMonth, int selectedYear, [String categorie = '', String account = '']) async {
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

  // TODO Funktion implementieren, ob seit letztem mal eine neue Buchung z.B. eine angelegte Serienbuchung als Abrechnung
  // TODO dazu gekommen ist. Extra Variable bei Buchungen einführen, ob Buchung bereits auf ein Konto verbucht wurde oder nicht?!
  // TODO testen bei Konto Übersichtsseite
  @override
  void checkForNewSerieBookings() async {
    BookingRepository bookingRepository = BookingRepository();
    var bookingBox = await Hive.openBox(bookingsBox);
    for (int i = 0; i < bookingBox.length; i++) {
      Booking booking = await bookingBox.getAt(i);
      if (booking.serieId != -1 && booking.booked == false) {
        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime dateToCheck = DateTime(DateTime.parse(booking.date).year, DateTime.parse(booking.date).month, DateTime.parse(booking.date).day);
        if (DateTime.parse(booking.date).isBefore(DateTime.now()) || dateToCheck == today) {
          bookingRepository.updateBookingBookedState(booking);
          bookingBox.putAt(i, booking);
        }
      }
    }
  }
}
