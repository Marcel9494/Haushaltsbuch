import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: 4)
class Categorie extends HiveObject {
  @HiveField(0)
  late String name;

  void createCategorie(Categorie newCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    categorieBox.add(newCategorie);
  }

  void updateCategorie(Categorie updatedCategorie, String oldCategorieName) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (oldCategorieName == categorie.name) {
        categorieBox.putAt(i, updatedCategorie);
        break;
      }
    }
  }

  void deleteCategorie(Categorie deleteCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (deleteCategorie.name == categorie.name) {
        categorieBox.deleteAt(i);
        break;
      }
    }
  }

  Future<bool> existsCategorieName(String categorieName) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorieName.trim().toLowerCase() == categorie.name.toLowerCase()) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

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

  static Future<List<String>> loadCategorieNames() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<String> categorieNameList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      String categorieName = await categorieBox.getAt(i).name;
      categorieNameList.add(categorieName);
    }
    return categorieNameList;
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
