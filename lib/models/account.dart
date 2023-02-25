import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: 3)
class Account extends HiveObject {
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

  static Future<List<Account>> loadAccounts() async {
    var accountBox = await Hive.openBox(accountsBox);
    List<Account> accountList = [];
    for (int i = 0; i < accountBox.length; i++) {
      Account account = await accountBox.getAt(i);
      accountList.add(account);
    }
    accountList.sort((first, second) => first.accountType.compareTo(second.accountType));
    return accountList;
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
