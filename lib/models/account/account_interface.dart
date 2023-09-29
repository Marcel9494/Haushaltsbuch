import 'account_model.dart';

import '../booking.dart';

abstract class AccountInterface {
  void create(Account newAccount);
  void update(Account updatedAccount, int accountBoxIndex, String oldAccountName);
  void delete(Account deleteAccount);
  Future<Account> load(int accountBoxIndex);
  Future<bool> existsAccountName(String accountName);
  void calculateNewAccountBalance(String accountName, String amount, String transaction);
  void transferMoney(String fromAccountName, String toAccountName, String amount);
  void undoneAccountBooking(Booking loadedBooking);
  void undoneSerieAccountBooking(Booking oldBooking);
  Future<double> getAssetValue();
  Future<double> getLiabilityValue();
  Future<Map<String, double>> getAccountTypeBalance(List<Account> accountList);

  Future<List<Account>> loadAccounts();
  Future<List<Account>> loadAssetAccounts();
  Future<List<Account>> loadLiabilityAccounts();
  Future<List<String>> loadAccountNameList();

  void createStartAccounts();
}
