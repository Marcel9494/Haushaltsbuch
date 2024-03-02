import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: transactionTypeId)
enum TransactionType { none, income, outcome, transfer, transferFrom, transferTo, investment, investmentFrom, investmentTo }

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.none:
        return '';
      case TransactionType.income:
        return 'Einnahme';
      case TransactionType.outcome:
        return 'Ausgabe';
      case TransactionType.transfer:
        return 'Übertrag';
      case TransactionType.transferFrom:
        return 'Übertrag von ...';
      case TransactionType.transferTo:
        return 'Übertrag nach ...';
      case TransactionType.investment:
        return 'Investition';
      case TransactionType.investmentFrom:
        return 'Investition von ...';
      case TransactionType.investmentTo:
        return 'Investition nach ...';
      default:
        throw Exception('$name is not a valid Transaction.');
    }
  }

  String get pluralName {
    switch (this) {
      case TransactionType.none:
        return '';
      case TransactionType.income:
        return 'Einnahmen';
      case TransactionType.outcome:
        return 'Ausgaben';
      case TransactionType.transfer:
        return 'Überträge';
      case TransactionType.transferFrom:
        return 'Überträge von ...';
      case TransactionType.transferTo:
        return 'Überträge nach ...';
      case TransactionType.investment:
        return 'Investitionen';
      case TransactionType.investmentFrom:
        return 'Investitionen von ...';
      case TransactionType.investmentTo:
        return 'Investitionen nach ...';
      default:
        throw Exception('$name is not a valid Transaction.');
    }
  }

  static TransactionType getTransactionType(String transaction) {
    try {
      if (transaction == TransactionType.income.name) {
        return TransactionType.income;
      } else if (transaction == TransactionType.outcome.name) {
        return TransactionType.outcome;
      } else if (transaction == TransactionType.transfer.name) {
        return TransactionType.transfer;
      } else if (transaction == TransactionType.investment.name) {
        return TransactionType.investment;
      }
    } catch (e) {
      throw Exception('$transaction is not a valid Transaction.');
    }
    return TransactionType.income;
  }
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final typeId = transactionTypeId;

  @override
  TransactionType read(BinaryReader reader) {
    return TransactionType.income;
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.write(obj.name);
  }
}
