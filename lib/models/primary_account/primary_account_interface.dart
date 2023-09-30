import '/models/primary_account/primary_account_model.dart';

abstract class PrimaryAccountInterface {
  void create(PrimaryAccount newPrimaryAccount);
  // TODO nächste 3 Funktionen noch zusammenlegen zu einer oder zwei Funktionen?
  Future<List<PrimaryAccount>> loadPrimaryAccountList();
  Future<List<PrimaryAccount>> loadFilteredPrimaryAccountList(String accountName);
  Future<Map<String, String>> getCurrentPrimaryAccounts();
  void setPrimaryAccountNames(String transactionTypes, String accountName);
  void createStartPrimaryAccounts();
}
