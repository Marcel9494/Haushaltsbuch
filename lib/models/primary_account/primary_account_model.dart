import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: primaryAccountTypeId)
class PrimaryAccount extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String accountName;
  @HiveField(1)
  late String transactionType;
}

class PrimaryAccountAdapter extends TypeAdapter<PrimaryAccount> {
  @override
  final typeId = primaryAccountTypeId;

  @override
  PrimaryAccount read(BinaryReader reader) {
    return PrimaryAccount()
      ..accountName = reader.read()
      ..transactionType = reader.read();
  }

  @override
  void write(BinaryWriter writer, PrimaryAccount obj) {
    writer.write(obj.accountName);
    writer.write(obj.transactionType);
  }
}
