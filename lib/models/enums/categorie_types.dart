import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: categoryTypeTypeId)
enum CategorieType { income, outcome, investment }

extension CategorieTypeExtension on CategorieType {
  String get name {
    switch (this) {
      case CategorieType.income:
        return 'Einnahme';
      case CategorieType.outcome:
        return 'Ausgabe';
      case CategorieType.investment:
        return 'Investition';
      default:
        throw Exception('$name is not a valid Categorie.');
    }
  }

  String get pluralName {
    switch (this) {
      case CategorieType.income:
        return 'Einnahmen';
      case CategorieType.outcome:
        return 'Ausgaben';
      case CategorieType.investment:
        return 'Investitionen';
      default:
        throw Exception('$name is not a valid Categorie.');
    }
  }

  static CategorieType getCategorieType(String categorie) {
    try {
      if (categorie == CategorieType.income.name) {
        return CategorieType.income;
      } else if (categorie == CategorieType.outcome.name) {
        return CategorieType.outcome;
      } else if (categorie == CategorieType.investment.name) {
        return CategorieType.investment;
      }
    } catch (e) {
      throw Exception('$categorie is not a valid Categorie.');
    }
    return CategorieType.income;
  }
}

class CategorieTypeAdapter extends TypeAdapter<CategorieType> {
  @override
  final typeId = categoryTypeTypeId;

  @override
  CategorieType read(BinaryReader reader) {
    return CategorieType.income;
  }

  @override
  void write(BinaryWriter writer, CategorieType obj) {
    writer.write(obj.name);
  }
}
