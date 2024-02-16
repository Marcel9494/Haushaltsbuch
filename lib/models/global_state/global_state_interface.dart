abstract class GlobalStateInterface {
  void create();

  Future<int> getBookingSerieIndex();
  void increaseBookingSerieIndex();

  Future<int> getCategorieIndex();
  void increaseCategorieIndex();

  Future<int> getDefaultBudgetIndex();
  void increaseDefaultBudgetIndex();
}
