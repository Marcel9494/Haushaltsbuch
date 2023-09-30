abstract class GlobalStateInterface {
  void create();
  Future<int> getBookingSerieIndex();
  void increaseBookingSerieIndex();
}
