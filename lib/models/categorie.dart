import 'package:hive/hive.dart';

import 'booking.dart';
import 'enums/categorie_types.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: categoryTypeId)
class Categorie extends HiveObject {
  @HiveField(0)
  String? type;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late List<String> subcategorieNames;

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
        Booking.updateBookingCategorieName(oldCategorieName, updatedCategorie.name);
        break;
      }
    }
  }

  void addSubcategorie(Categorie updatedCategorie, String newSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (updatedCategorie.name == categorie.name) {
        categorie.subcategorieNames.add(newSubcategorie);
        categorieBox.putAt(i, categorie);
        // TODO Booking.updateBookingCategorieName(oldCategorieName, updatedCategorie.name);
        break;
      }
    }
  }

  void updateSubcategorie(Categorie updatedCategorie, String oldSubcategorie, String newSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (updatedCategorie.name == categorie.name) {
        for (int j = 0; j < categorie.subcategorieNames.length; j++) {
          if (categorie.subcategorieNames[j] == oldSubcategorie) {
            categorie.subcategorieNames[categorie.subcategorieNames.indexWhere((element) => element == oldSubcategorie)] = newSubcategorie;
            categorieBox.putAt(i, categorie);
            // TODO Booking.updateBookingCategorieName(oldCategorieName, updatedCategorie.name);
            break;
          }
        }
      }
    }
  }

  void deleteCategorie(Categorie deleteCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (deleteCategorie.name == currentCategorie.name && deleteCategorie.type == currentCategorie.type) {
        categorieBox.deleteAt(i);
        break;
      }
    }
  }

  void deleteSubcategorie(Categorie categorie, String deleteSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (categorie.name == currentCategorie.name) {
        for (int j = 0; j < categorie.subcategorieNames.length; j++) {
          if (categorie.subcategorieNames[j] == deleteSubcategorie) {
            categorie.subcategorieNames.removeAt(j);
            categorieBox.putAt(i, categorie);
            break;
          }
        }
        break;
      }
    }
  }

  Future<bool> existsCategorieName(Categorie categorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (categorie.name.trim().toLowerCase() == currentCategorie.name.trim().toLowerCase() && categorie.type == currentCategorie.type) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  Future<bool> existsSubcategorieName(Categorie categorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      for (int j = 0; j < currentCategorie.subcategorieNames.length; j++) {
        for (int k = 0; k < currentCategorie.subcategorieNames.length; k++) {
          if (categorie.subcategorieNames[j] == currentCategorie.subcategorieNames[k] && categorie.type == currentCategorie.type) {
            return Future.value(true);
          }
        }
      }
    }
    return Future.value(false);
  }

  static Future<List<Categorie>> loadCategories(CategorieType categorieType) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<Categorie> categorieList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorie.type == categorieType.name) {
        categorieList.add(categorie);
      }
    }
    categorieList.sort((first, second) => first.name.compareTo(second.name));
    return categorieList;
  }

  static Future<List<String>> loadCategorieNames(String transactionType) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<String> categorieNameList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (transactionType == categorie.type) {
        categorieNameList.add(categorie.name);
      }
    }
    return categorieNameList;
  }

  static Future<List<String>> loadSubcategorieNames(String mainCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (mainCategorie.trim() == categorie.name.trim()) {
        return categorie.subcategorieNames;
      }
    }
    return [];
  }

  static Future<bool> checkIfCategoriesExists() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    if (categorieBox.isEmpty) {
      return false;
    }
    return true;
  }

  static void createStartExpenditureCategories() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorie.type == CategorieType.outcome.name) {
        return;
      }
    }
    List<String> categorieNames = [
      'Lebensmittel',
      'Haushaltswaren',
      'Transport',
      'Wohnen + Nebenkosten',
      'Restaurant / Lieferdienst',
      'Unterhaltung',
      'Kultur',
      'Mode / Schönheitspflege',
      'Gesundheit',
      'Bildung',
      'Geschenke',
      'Technik',
      'Finanzverluste',
      'Sonstiges'
    ];
    for (int i = 0; i < categorieNames.length; i++) {
      Categorie categorie = Categorie()
        ..type = CategorieType.outcome.name
        ..name = categorieNames[i]
        ..subcategorieNames = [];
      categorie.createCategorie(categorie);
    }
  }

  static void createStartRevenueCategories() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorie.type == CategorieType.income.name) {
        return;
      }
    }
    List<String> categorieNames = ['Gehalt', 'Bonuszahlung', 'Bargeld Geschenk', 'Dividende', 'Zinsen', 'Mieteinkommen', 'Finanzgewinne', 'Sonstiges'];
    for (int i = 0; i < categorieNames.length; i++) {
      Categorie categorie = Categorie()
        ..type = CategorieType.income.name
        ..name = categorieNames[i]
        ..subcategorieNames = [];
      categorie.createCategorie(categorie);
    }
  }

  static void createStartInvestmentCategories() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorie.type == CategorieType.investment.name) {
        return;
      }
    }
    List<String> categorieNames = ['ETF', 'Aktie', 'Fond', 'Krypto', 'Rohstoff', 'P2P', 'Sonstiges'];
    for (int i = 0; i < categorieNames.length; i++) {
      Categorie categorie = Categorie()
        ..type = CategorieType.investment.name
        ..name = categorieNames[i]
        ..subcategorieNames = [];
      categorie.createCategorie(categorie);
    }
  }
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
