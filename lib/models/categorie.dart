import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: 4)
class Categorie extends HiveObject {
  @HiveField(0)
  late String name;

  static Future<List<Categorie>> loadCategories() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<Categorie> categorieList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      categorieList.add(categorie);
    }
    categorieList.sort((first, second) => first.name.compareTo(second.name));
    return categorieList;
  }
}

class CategorieAdapter extends TypeAdapter<Categorie> {
  @override
  final typeId = 4;

  @override
  Categorie read(BinaryReader reader) {
    return Categorie()..name = reader.read();
  }

  @override
  void write(BinaryWriter writer, Categorie obj) {
    writer.write(obj.name);
  }
}
