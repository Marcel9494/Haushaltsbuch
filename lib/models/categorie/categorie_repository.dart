import 'package:hive/hive.dart';

import '../booking/booking_repository.dart';
import 'categorie_model.dart';

import '../enums/categorie_types.dart';

import '/models/categorie/categorie_interface.dart';

import '/utils/consts/hive_consts.dart';

class CategorieRepository extends CategorieInterface {
  @override
  void create(Categorie newCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    categorieBox.add(newCategorie);
  }

  @override
  void update(Categorie updatedCategorie, String oldCategorieName) async {
    BookingRepository bookingRepository = BookingRepository();
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (oldCategorieName == categorie.name) {
        categorieBox.putAt(i, updatedCategorie);
        bookingRepository.updateBookingCategorieName(oldCategorieName, updatedCategorie.name);
        break;
      }
    }
  }

  // Anmerkung: Es wird die Hauptkategorie und alle untergeordneten Subkategorien gelöscht
  @override
  void delete(Categorie deleteCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (deleteCategorie.name == currentCategorie.name && deleteCategorie.type == currentCategorie.type) {
        categorieBox.deleteAt(i);
        break;
      }
    }
  }

  @override
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

  @override
  Future<List<Categorie>> loadCategorieList(CategorieType categorieType) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<Categorie> categorieList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorieType.name == categorie.type) {
        categorieList.add(categorie);
      }
    }
    categorieList.sort((first, second) => first.name.compareTo(second.name));
    return categorieList;
  }

  @override
  Future<List<String>> loadCategorieNameList(CategorieType categorieType) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    List<String> categorieNameList = [];
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (categorieType.name == categorie.type) {
        categorieNameList.add(categorie.name);
      }
    }
    return categorieNameList;
  }

  @override
  void createSubcategorie(String mainCategorie, String newSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (mainCategorie == categorie.name) {
        categorie.subcategorieNames.add(newSubcategorie);
        categorieBox.putAt(i, categorie);
        // TODO Booking.updateBookingCategorieName(oldCategorieName, updatedCategorie.name);
        break;
      }
    }
  }

  @override
  void updateSubcategorie(String mainCategorie, String oldSubcategorie, String newSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (mainCategorie == categorie.name) {
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

  @override
  void deleteSubcategorie(Categorie categorie, String deleteSubcategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (categorie.name == currentCategorie.name) {
        for (int j = 0; j < categorie.subcategorieNames.length; j++) {
          if (categorie.subcategorieNames[j] == deleteSubcategorie) {
            categorie.subcategorieNames.removeAt(j);
            categorieBox.putAt(i, categorie);
            return;
          }
        }
      }
    }
  }

  @override
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

  @override
  Future<List<String>> loadSubcategorieNameList(String mainCategorie) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (mainCategorie.trim() == categorie.name.trim()) {
        return categorie.subcategorieNames;
      }
    }
    return [];
  }

  @override
  void createStartExpenditureCategories() async {
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
      categorieBox.add(categorie);
    }
  }

  @override
  void createStartRevenueCategories() async {
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
      categorieBox.add(categorie);
    }
  }

  @override
  void createStartInvestmentCategories() async {
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
      categorieBox.add(categorie);
    }
  }
}
