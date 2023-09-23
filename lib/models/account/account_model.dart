import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: accountTypeId)
class Account extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String accountType;
  @HiveField(2)
  late String bankBalance;
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
