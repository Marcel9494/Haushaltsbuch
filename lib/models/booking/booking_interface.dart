import 'booking_model.dart';

abstract class BookingInterface {
  // Erstellungsmethoden
  void create(Booking newBooking);
  void createSerie(Booking templateBooking);

  // Bearbeitungsmethoden
  void updateSingle(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateOnlyFutureBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateAllBookingsFromSerie(Booking templateBooking, Booking oldBooking, int bookingBoxIndex);
  void updateCategorieName(String oldCategorieName, String newCategorieName);
  void updateSubcategorieName(String oldSubcategorieName, String newSubcategorieName);
  void updateAccountName(String oldAccountName, String newAccountName);

  // Löschen Funktionen
  void deleteSingle(int bookingBoxIndex);
  void deleteOnlyFutureBookingsFromSerie(Booking templateBooking, int bookingBoxIndex);
  void deleteAllBookingsFromSerie(Booking templateBooking, int bookingBoxIndex);

  // Laden Funktionen
  Future<Booking> load(int bookingBoxIndex);
  Future<List<Booking>> loadMonthlyBookings(int selectedMonth, int selectedYear);
  Future<List<Booking>> loadMonthlyBookingsForCategorie(int selectedMonth, int selectedYear, String categorie);
  Future<List<Booking>> loadMonthlyBookingsForAccount(int selectedMonth, int selectedYear, String account);
  Future<List<Booking>> loadMonthlyBookingsForCategorieAndTransactionType(int selectedMonth, int selectedYear, String categorie, String transactionType);
  Future<List<Booking>> loadSubcategorieBookings(List<Booking> bookingList, String subcategorie);

  // Getter Funktionen
  double getRevenues(List<Booking> bookingList);
  double getExpenditures(List<Booking> bookingList, [String categorie = '']);
  double getSubcategorieExpenditures(List<Booking> bookingList, String categorie, String subcategorie);
  double getInvestments(List<Booking> bookingList);

  // Weitere Funktionen
  void executeAccountTransaction(Booking booking);
  void checkForNewBookings();
}
