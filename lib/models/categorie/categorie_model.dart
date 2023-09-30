import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: categoryTypeId)
class Categorie extends HiveObject {
  @HiveField(0)
  String? type;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late List<String> subcategorieNames;
}

class CategorieAdapter extends TypeAdapter<Categorie> {
  @override
  final typeId = categoryTypeId;

  @override
  Categorie read(BinaryReader reader) {
    return Categorie()
      ..name = reader.read()
      ..type = reader.read()
      ..subcategorieNames = reader.read();
  }

  @override
  void write(BinaryWriter writer, Categorie obj) {
    writer.write(obj.name);
    writer.write(obj.type);
    writer.write(obj.subcategorieNames);
  }
}
