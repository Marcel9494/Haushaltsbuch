import 'package:hive/hive.dart';

@HiveType(typeId: 1)
enum TransactionType { income, outcome, transfer, investment }

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.income:
        return 'Einnahme';
      case TransactionType.outcome:
        return 'Ausgabe';
      case TransactionType.transfer:
        return 'Übertrag';
      case TransactionType.investment:
        return 'Investition';
      default:
        throw Exception('$name is not a valid Transaction.');
    }
  }

  TransactionType getTransactionType(String transaction) {
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
  final typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    return TransactionType.income;
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.write(obj.name);
  }
}
