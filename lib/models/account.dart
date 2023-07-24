import 'package:hive/hive.dart';

import '/models/enums/transaction_types.dart';
import '/models/enums/account_types.dart';

import '/utils/consts/hive_consts.dart';
import '/utils/number_formatters/number_formatter.dart';

import 'booking.dart';

@HiveType(typeId: accountTypeId)
class Account extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String accountType;
  @HiveField(2)
  late String bankBalance;

  void createAccount(Account newAccount) async {
    var accountBox = await Hive.openBox(accountsBox);
    accountBox.add(newAccount);
  }

  void updateAccount(Account updatedAccount, int accountBoxIndex) async {
    var accountBox = await Hive.openBox(accountsBox);
    accountBox.putAt(accountBoxIndex, updatedAccount);
  }

  void deleteAccount(Account deleteAccount) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (deleteAccount.name == account.name) {
        accountBox.deleteAt(i);
        break;
      }
    }
  }

  Future<bool> existsAccountName(String accountName) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (accountName.trim().toLowerCase() == account.name.toLowerCase()) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  static void calculateNewAccountBalance(String accountName, String amount, String transaction) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (accountName == account.name) {
        double bankBalance = formatMoneyAmountToDouble(account.bankBalance);
        if (transaction == TransactionType.outcome.name) {
          bankBalance -= formatMoneyAmountToDouble(amount);
        } else if (transaction == TransactionType.income.name) {
          bankBalance += formatMoneyAmountToDouble(amount);
        }
        account.bankBalance = formatToMoneyAmount(bankBalance.toString());
        accountBox.putAt(i, account);
        break;
      }
    }
  }

  static void transferMoney(String fromAccountName, String toAccountName, String amount) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (fromAccountName == account.name) {
        double bankBalance = formatMoneyAmountToDouble(account.bankBalance);
        bankBalance -= formatMoneyAmountToDouble(amount);
        account.bankBalance = formatToMoneyAmount(bankBalance.toString());
        accountBox.putAt(i, account);
      } else if (toAccountName == account.name) {
        double bankBalance = formatMoneyAmountToDouble(account.bankBalance);
        bankBalance += formatMoneyAmountToDouble(amount);
        account.bankBalance = formatToMoneyAmount(bankBalance.toString());
        accountBox.putAt(i, account);
      }
    }
  }

  static void undoneAccountBooking(Booking loadedBooking) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account fromAccount = await accountBox.getAt(i);
      if (loadedBooking.fromAccount == fromAccount.name) {
        double amount = formatMoneyAmountToDouble(loadedBooking.amount);
        double bankBalance = formatMoneyAmountToDouble(fromAccount.bankBalance);
        if (loadedBooking.transactionType == TransactionType.outcome.name) {
          bankBalance += amount;
        } else if (loadedBooking.transactionType == TransactionType.income.name) {
          bankBalance -= amount;
        } else if (loadedBooking.transactionType == TransactionType.transfer.name || loadedBooking.transactionType == TransactionType.investment.name) {
          for (int j = 0; j < accountBox.length; j++) {
            Account toAccount = await accountBox.getAt(j);
            if (loadedBooking.toAccount == toAccount.name) {
              double bankBalanceToAccount = formatMoneyAmountToDouble(toAccount.bankBalance);
              bankBalance += amount;
              bankBalanceToAccount -= amount;
              toAccount.bankBalance = formatToMoneyAmount(bankBalanceToAccount.toString());
              accountBox.putAt(toAccount.boxIndex, toAccount);
              break;
            }
          }
        }
        fromAccount.bankBalance = formatToMoneyAmount(bankBalance.toString());
        accountBox.putAt(fromAccount.boxIndex, fromAccount);
        break;
      }
    }
  }

  static void undoneSerieAccountBooking(Booking oldBooking) async {
    var accountBox = await Hive.openBox(accountsBox);
    for (int i = 0; i < accountBox.length; i++) {
      Account fromAccount = await accountBox.getAt(i);
      if (oldBooking.fromAccount == fromAccount.name) {
        double oldAmount = formatMoneyAmountToDouble(oldBooking.amount);
        double bankBalance = formatMoneyAmountToDouble(fromAccount.bankBalance);
        double newBankBalance = bankBalance - oldAmount;
        fromAccount.bankBalance = formatToMoneyAmount(newBankBalance.toString());
        accountBox.putAt(fromAccount.boxIndex, fromAccount);
        break;
      }
    }
  }

  static Future<Account> loadAccount(int accountBoxIndex) async {
    var accountBox = await Hive.openBox(accountsBox);
    Account account = await accountBox.getAt(accountBoxIndex);
    return account;
  }

  static Future<List<Account>> loadAccounts() async {
    var accountBox = await Hive.openBox(accountsBox);
    List<Account> accountList = [];
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      account.boxIndex = i;
      accountList.add(account);
    }
    accountList.sort((first, second) => first.accountType.compareTo(second.accountType));
    return accountList;
  }

  static Future<List<Account>> loadAssetAccounts() async {
    var accountBox = await Hive.openBox(accountsBox);
    List<Account> accountList = [];
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if ((account.accountType == AccountType.account.name ||
              account.accountType == AccountType.capitalInvestments.name ||
              account.accountType == AccountType.cash.name ||
              account.accountType == AccountType.credit.name ||
              account.accountType == AccountType.insurance.name ||
              account.accountType == AccountType.other.name) &&
          formatMoneyAmountToDouble(account.bankBalance) >= 0.0) {
        account.boxIndex = i;
        accountList.add(account);
      }
    }
    accountList.sort((first, second) => first.accountType.compareTo(second.accountType));
    return accountList;
  }

  static Future<List<Account>> loadLiabilityAccounts() async {
    var accountBox = await Hive.openBox(accountsBox);
    List<Account> accountList = [];
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (account.accountType == AccountType.credit.name || formatMoneyAmountToDouble(account.bankBalance) < 0.0) {
        account.boxIndex = i;
        accountList.add(account);
      }
    }
    accountList.sort((first, second) => first.accountType.compareTo(second.accountType));
    return accountList;
  }

  static Future<List<String>> loadAccountNames() async {
    var accountBox = await Hive.openBox(accountsBox);
    List<String> accountNameList = [];
    for (int i = 0; i < accountBox.length; i++) {
      String accountName = await accountBox.getAt(i).name;
      accountNameList.add(accountName);
    }
    return accountNameList;
  }

  static Future<double> getAssetValue() async {
    var accountBox = await Hive.openBox(accountsBox);
    double assetValue = 0.0;
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if ((account.accountType == AccountType.account.name ||
              account.accountType == AccountType.capitalInvestments.name ||
              account.accountType == AccountType.cash.name ||
              account.accountType == AccountType.credit.name ||
              account.accountType == AccountType.insurance.name ||
              account.accountType == AccountType.other.name) &&
          formatMoneyAmountToDouble(account.bankBalance) >= 0.0) {
        assetValue += double.parse(account.bankBalance.substring(0, account.bankBalance.length - 2).replaceAll('.', '').replaceAll(',', '.'));
      }
    }
    return assetValue;
  }

  static Future<double> getLiabilityValue() async {
    var accountBox = await Hive.openBox(accountsBox);
    double liabilityValue = 0.0;
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      if (account.accountType == AccountType.credit.name || formatMoneyAmountToDouble(account.bankBalance) < 0.0) {
        liabilityValue += double.parse(account.bankBalance.substring(0, account.bankBalance.length - 2).replaceAll('.', '').replaceAll(',', '.'));
      }
    }
    return liabilityValue.abs();
  }

  static Future<Map<String, double>> getAccountTypeBalance(List<Account> accountList) async {
    late final Map<String, double> accountTypeBalanceMap = {};
    for (int i = 0; i < accountList.length; i++) {
      if (accountTypeBalanceMap.containsKey(accountList[i].accountType) == false) {
        accountTypeBalanceMap[accountList[i].accountType] = formatMoneyAmountToDouble(accountList[i].bankBalance);
      } else {
        double? amount = accountTypeBalanceMap[accountList[i].accountType];
        amount = amount! + formatMoneyAmountToDouble(accountList[i].bankBalance);
        accountTypeBalanceMap[accountList[i].accountType] = amount;
      }
    }
    return accountTypeBalanceMap;
  }

  static void createStartAccounts() async {
    var accountBox = await Hive.openBox(accountsBox);
    if (accountBox.isNotEmpty) {
      return;
    }
    Account cashAccount = Account()
      ..name = 'Geldbeutel'
      ..bankBalance = '0 €'
      ..accountType = AccountType.cash.name;
    cashAccount.createAccount(cashAccount);
    Account giroAccount = Account()
      ..name = 'Girokonto'
      ..bankBalance = '0 €'
      ..accountType = AccountType.account.name;
    giroAccount.createAccount(giroAccount);
    Account billingAccount = Account()
      ..name = 'Verechnungskonto'
      ..bankBalance = '0 €'
      ..accountType = AccountType.account.name;
    billingAccount.createAccount(billingAccount);
    Account capitalInvestmentAccount = Account()
      ..name = 'Aktiendepot'
      ..bankBalance = '0 €'
      ..accountType = AccountType.capitalInvestments.name;
    capitalInvestmentAccount.createAccount(capitalInvestmentAccount);
  }
}

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final typeId = accountTypeId;

  @override
  Account read(BinaryReader reader) {
    return Account()
      ..name = reader.read()
      ..accountType = reader.read()
      ..bankBalance = reader.read();
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer.write(obj.name);
    writer.write(obj.accountType);
    writer.write(obj.bankBalance);
  }
}
