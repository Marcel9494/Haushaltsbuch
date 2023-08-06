import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import '/models/enums/transaction_types.dart';
import 'enums/preselect_account_types.dart';

@HiveType(typeId: primaryAccountTypeId)
class PrimaryAccount extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String accountName;
  @HiveField(1)
  late String transactionType;

  void createPrimaryAccount(PrimaryAccount newPrimaryAccount) async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    primaryAccountBox.add(newPrimaryAccount);
  }

  static Future<Map<String, String>> getCurrentPrimaryAccounts() async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    Map<String, String> primaryAccounts = {};
    for (int i = 0; i < primaryAccountBox.length; i++) {
      PrimaryAccount primaryAccount = await primaryAccountBox.getAt(i);
      primaryAccounts.addAll({primaryAccount.transactionType: primaryAccount.accountName});
    }
    return primaryAccounts;
  }

  static void createStartPrimaryAccounts() async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    if (primaryAccountBox.isNotEmpty) {
      return;
    }
    PrimaryAccount incomePrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.income.name;
    incomePrimaryAccount.createPrimaryAccount(incomePrimaryAccount);
    PrimaryAccount outcomePrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.outcome.name;
    outcomePrimaryAccount.createPrimaryAccount(outcomePrimaryAccount);
    PrimaryAccount transferFromPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.transferFrom.name;
    transferFromPrimaryAccount.createPrimaryAccount(transferFromPrimaryAccount);
    PrimaryAccount transferToPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.transferTo.name;
    transferToPrimaryAccount.createPrimaryAccount(transferToPrimaryAccount);
    PrimaryAccount investmentFromPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.investmentFrom.name;
    investmentFromPrimaryAccount.createPrimaryAccount(investmentFromPrimaryAccount);
    PrimaryAccount investmentToPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = TransactionType.investmentTo.name;
    investmentToPrimaryAccount.createPrimaryAccount(investmentToPrimaryAccount);
  }
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
