import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import '/models/enums/preselect_account_types.dart';

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

  static Future<List<PrimaryAccount>> loadPrimaryAccountList() async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    List<PrimaryAccount> primaryAccountList = [];
    for (int i = 0; i < primaryAccountBox.length; i++) {
      PrimaryAccount primaryAccount = await primaryAccountBox.getAt(i);
      primaryAccount.boxIndex = i;
      primaryAccountList.add(primaryAccount);
    }
    return primaryAccountList;
  }

  static Future<List<PrimaryAccount>> loadFilteredPrimaryAccountList(String accountName) async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    List<PrimaryAccount> primaryAccountList = [];
    for (int i = 0; i < primaryAccountBox.length; i++) {
      PrimaryAccount primaryAccount = await primaryAccountBox.getAt(i);
      if (primaryAccount.accountName == accountName) {
        primaryAccount.boxIndex = i;
        primaryAccountList.add(primaryAccount);
      }
    }
    return primaryAccountList;
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

  static void setPrimaryAccountNames(String transactionTypes, String accountName) async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    List<String> transactionTypeList = transactionTypes.split(', ');
    for (int i = 0; i < primaryAccountBox.length; i++) {
      PrimaryAccount primaryAccount = await primaryAccountBox.getAt(i);
      if (primaryAccount.accountName == accountName.trim()) {
        PrimaryAccount updatedPrimaryAccount = PrimaryAccount()
          ..accountName = ''
          ..transactionType = primaryAccount.transactionType;
        primaryAccountBox.putAt(i, updatedPrimaryAccount);
      }
    }
    for (int i = 0; i < transactionTypeList.length; i++) {
      PrimaryAccount updatedPrimaryAccount;
      if (transactionTypeList[i] == PreselectAccountType.income.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.income.name;
        primaryAccountBox.putAt(0, updatedPrimaryAccount);
      } else if (transactionTypeList[i] == PreselectAccountType.outcome.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.outcome.name;
        primaryAccountBox.putAt(1, updatedPrimaryAccount);
      } else if (transactionTypeList[i] == PreselectAccountType.transferFrom.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.transferFrom.name;
        primaryAccountBox.putAt(2, updatedPrimaryAccount);
      } else if (transactionTypeList[i] == PreselectAccountType.transferTo.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.transferTo.name;
        primaryAccountBox.putAt(3, updatedPrimaryAccount);
      } else if (transactionTypeList[i] == PreselectAccountType.investmentFrom.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.investmentFrom.name;
        primaryAccountBox.putAt(4, updatedPrimaryAccount);
      } else if (transactionTypeList[i] == PreselectAccountType.investmentTo.name) {
        updatedPrimaryAccount = PrimaryAccount()
          ..accountName = accountName.trim()
          ..transactionType = PreselectAccountType.investmentTo.name;
        primaryAccountBox.putAt(5, updatedPrimaryAccount);
      }
    }
  }

  static void createStartPrimaryAccounts() async {
    var primaryAccountBox = await Hive.openBox(primaryAccountsBox);
    if (primaryAccountBox.isNotEmpty) {
      return;
    }
    PrimaryAccount incomePrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.income.name;
    incomePrimaryAccount.createPrimaryAccount(incomePrimaryAccount);
    PrimaryAccount outcomePrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.outcome.name;
    outcomePrimaryAccount.createPrimaryAccount(outcomePrimaryAccount);
    PrimaryAccount transferFromPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.transferFrom.name;
    transferFromPrimaryAccount.createPrimaryAccount(transferFromPrimaryAccount);
    PrimaryAccount transferToPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.transferTo.name;
    transferToPrimaryAccount.createPrimaryAccount(transferToPrimaryAccount);
    PrimaryAccount investmentFromPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.investmentFrom.name;
    investmentFromPrimaryAccount.createPrimaryAccount(investmentFromPrimaryAccount);
    PrimaryAccount investmentToPrimaryAccount = PrimaryAccount()
      ..accountName = ''
      ..transactionType = PreselectAccountType.investmentTo.name;
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
