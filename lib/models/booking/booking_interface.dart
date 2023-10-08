import '../enums/serie_edit_modes.dart';
import 'booking_model.dart';

abstract class BookingInterface {
  void create(Booking newBooking);
  void createInstance(String title, String transactionType, String date, String bookingRepeats, String amount, String categorie, String subcategorie, String fromAccount,
      String toAccount, bool isSerieBooking);
  void createSerie(Booking templateBooking);
  void executeAccountTransaction(Booking booking);

  void update(Booking updatedBooking, int bookingBoxIndex);
  void updateSerieBookings(Booking templateBooking, Booking oldBooking, int bookingBoxIndex, SerieEditModeType serieEditMode);
  Future<Booking> updateBookingBookedState(Booking updatedBooking);
  Future<Booking> updateBookingInstance(Booking templateBooking, Booking oldBooking);
  Future<void> updateBookingCategorieName(String oldCategorieName, String newCategorieName);
  Future<void> updateBookingAccountName(String oldAccountName, String newAccountName);

  Future<Booking> load(int bookingBoxIndex);
  Future<List<Booking>> loadMonthlyBookingList(int selectedMonth, int selectedYear, [String categorie = '', String account = '']);
  Future<List<Booking>> loadSubcategorieBookingList(List<Booking> bookingList, String subcategorie);

  Future<void> delete(int bookingBoxIndex);
  void deleteSerieBookings(Booking templateBooking, int bookingBoxIndex, SerieEditModeType serieEditMode);

  double getRevenues(List<Booking> bookingList);
  double getExpenditures(List<Booking> bookingList, [String categorie = '']);
  double getSubcategorieExpenditures(List<Booking> bookingList, String categorie, String subcategorie);
  double getInvestments(List<Booking> bookingList);

  // TODO muss noch richtig implementiert werden
  void checkForNewSerieBookings();
}
