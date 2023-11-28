import 'booking_model.dart';

abstract class BookingInterface {
  // Erstellungsmethoden
  void create(Booking newBooking);
  void createSerie(Booking templateBooking);

  // Bearbeitungsmethoden
  void updateSingleBooking(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateOnlyFutureBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateAllBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateBookingCategorieName(String oldCategorieName, String newCategorieName);
  void updateBookingAccountName(String oldAccountName, String newAccountName);

  // Löschen Funktionen
  void deleteSingleBooking(int bookingBoxIndex);
  void deleteOnlyFutureBookingsFromSerie(Booking templateBooking, int bookingBoxIndex);
  void deleteAllBookingsFromSerie(Booking templateBooking, int bookingBoxIndex);

  // Laden Funktionen
  Future<Booking> load(int bookingBoxIndex);
  Future<List<Booking>> loadMonthlyBookingList(int selectedMonth, int selectedYear, [String categorie = '', String account = '']);
  Future<List<Booking>> loadSubcategorieBookingList(List<Booking> bookingList, String subcategorie);

  // Getter Funktionen
  double getRevenues(List<Booking> bookingList);
  double getExpenditures(List<Booking> bookingList, [String categorie = '']);
  double getSubcategorieExpenditures(List<Booking> bookingList, String categorie, String subcategorie);
  double getInvestments(List<Booking> bookingList);

  // Weitere Funktionen
  void executeAccountTransaction(Booking booking);
  // TODO muss noch richtig implementiert werden
  void checkForNewSerieBookings();
}
