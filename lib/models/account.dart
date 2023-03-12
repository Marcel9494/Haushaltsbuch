import 'package:haushaltsbuch/models/enums/transaction_types.dart';
import 'package:haushaltsbuch/utils/number_formatters/number_formatter.dart';
import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: 3)
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
      if (account.accountType == 'Konto' ||
          account.accountType == 'Kapitalanlage' ||
          account.accountType == 'Bargeld' ||
          account.accountType == 'Karte' ||
          account.accountType == 'Versicherung' ||
          account.accountType == 'Sonstiges') {
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
      if (account.accountType == 'Kredit') {
        liabilityValue += double.parse(account.bankBalance.substring(0, account.bankBalance.length - 2).replaceAll('.', '').replaceAll(',', '.'));
      }
    }
    return liabilityValue;
  }
}

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final typeId = 3;

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
