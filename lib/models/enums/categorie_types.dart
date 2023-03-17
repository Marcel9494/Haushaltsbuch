import 'package:hive/hive.dart';

@HiveType(typeId: 5)
enum CategorieType { income, outcome }

extension CategorieTypeExtension on CategorieType {
  String get name {
    switch (this) {
      case CategorieType.income:
        return 'Einnahme';
      case CategorieType.outcome:
        return 'Ausgabe';
      default:
        throw Exception('$name is not a valid Categorie.');
    }
  }

  CategorieType getCategorieType(String categorie) {
    try {
      if (categorie == CategorieType.income.name) {
        return CategorieType.income;
      } else if (categorie == CategorieType.outcome.name) {
        return CategorieType.outcome;
      }
    } catch (e) {
      throw Exception('$categorie is not a valid Categorie.');
    }
    return CategorieType.income;
  }
}

class CategorieTypeAdapter extends TypeAdapter<CategorieType> {
  @override
  final typeId = 5;

  @override
  CategorieType read(BinaryReader reader) {
    return CategorieType.income;
  }

  @override
  void write(BinaryWriter writer, CategorieType obj) {
    writer.write(obj.name);
  }
}
