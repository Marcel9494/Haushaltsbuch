import 'package:hive/hive.dart';

import '../global_state/global_state_repository.dart';

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
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (oldCategorieName == categorie.name) {
        categorieBox.putAt(i, updatedCategorie);
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
  Future<Categorie> load(int categorieIndex) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    Categorie categorie = Categorie();
    for (int i = 0; i < categorieBox.length; i++) {
      categorie = await categorieBox.getAt(i);
      if (categorie.index == categorieIndex) {
        return categorie;
      }
    }
    return categorie;
  }

  // Jeder Kategoriename darf nur einmal pro Kategorietyp (Ausgabe, Einnahme & Investition) vorkommen
  @override
  Future<bool> existsCategorieName(String categorieName, String categorieType) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie currentCategorie = await categorieBox.getAt(i);
      if (categorieName.trim().toLowerCase() == currentCategorie.name.trim().toLowerCase() && categorieType == currentCategorie.type) {
        return true;
      }
    }
    return false;
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
        break;
      }
    }
  }

  @override
  void updateSubcategorie(String mainCategorie, String oldSubcategorieName, String newSubcategorieName) async {
    var categorieBox = await Hive.openBox(categoriesBox);
    for (int i = 0; i < categorieBox.length; i++) {
      Categorie categorie = await categorieBox.getAt(i);
      if (mainCategorie == categorie.name) {
        for (int j = 0; j < categorie.subcategorieNames.length; j++) {
          if (categorie.subcategorieNames[j] == oldSubcategorieName) {
            categorie.subcategorieNames[categorie.subcategorieNames.indexWhere((element) => element == oldSubcategorieName)] = newSubcategorieName;
            categorieBox.putAt(i, categorie);
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
            return true;
          }
        }
      }
    }
    return false;
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
  void createStartCategories() async {
    var categorieBox = await Hive.openBox(categoriesBox);
    if (categorieBox.isNotEmpty) {
      return;
    }
    GlobalStateRepository globalStateRepository = GlobalStateRepository();
    int categorieIndex = await globalStateRepository.getCategorieIndex();
    // Start Ausgabe Kategorien erstellen
    List<String> outcomeCategorieNames = [
      'Lebensmittel',
      'Haushaltswaren',
      'Auto-/Fahrkosten',
      'Wohnen / Nebenkosten',
      'Restaurant / Lieferdienst',
      'Mode / Kleidung',
      'Unterhaltung',
      'Kultur',
      'Gesundheit',
      'Bildung',
      'Geschenke',
      'Möbel',
      'Technik',
      'Reisen / Urlaub',
      'Spenden',
      'Finanzverluste',
      'Sonstiges'
    ];
    List<List<String>> outcomeSubcategorieNames = [
      ['Getränke', 'Obst', 'Gemüse', 'Fleisch', 'Süßigkeiten', 'Sonstiges'],
      ['Reinigungsmittel', 'Waschmittel', 'Klopapier'],
      ['Versicherung', 'Tanken', 'Reparatur', 'Auto mieten', 'Fahrkarte'],
      ['Miete', 'Strom', 'Wasser', 'Heizung', 'Müllentsorgung', 'Immobilienkredit'],
      ['Restaurant', 'Bar', 'Kneipe'],
      ['Schuhe', 'Hose', 'T-Shirt', 'Pullover', 'Accessoire', 'Friseur', 'Sonstiges'],
      ['Streaming Abo', 'Kino', 'Konzert', 'Freibad'],
      ['Museum', 'Theater'],
      ['Fitnessstudio', 'Medikamente'],
      ['Buch', 'Weiterbildung', 'Studiengebühren'],
      ['Weihnachten', 'Geburtstag', 'Ostern', 'Hochzeit'],
      ['Schrank', 'Utensilien', 'Deko'],
      ['Handy', 'Laptop / PC', 'Zubehör'],
      ['Unterkunft', 'Flug', 'Ausflug'],
      [],
      ['ETF', 'Aktie', 'Optionshandel', 'Krypto', 'P2P'],
      [],
    ];
    for (int i = 0; i < outcomeCategorieNames.length; i++) {
      categorieIndex = await globalStateRepository.getCategorieIndex();
      Categorie categorie = Categorie()
        ..index = categorieIndex
        ..type = CategorieType.outcome.name
        ..name = outcomeCategorieNames[i]
        ..subcategorieNames = outcomeSubcategorieNames[i];
      categorieBox.add(categorie);
      globalStateRepository.increaseCategorieIndex();
    }

    // Start Einnahme Kategorien erstellen
    List<String> incomeCategorieNames = ['Gehalt', 'Bonuszahlung', 'Dividende', 'Zinsen', 'Mieteinkommen', 'Finanzgewinne', 'Bargeld Geschenk', 'Sonstiges'];
    List<List<String>> incomeSubcategorieNames = [
      [],
      ['Weihnachtsgeld', 'Urlaubsgeld', 'Prämie'],
      ['ETF', 'Aktie'],
      ['Tagesgeld', 'P2P'],
      [],
      ['ETF', 'Aktie', 'Optionshandel', 'Krypto'],
      [],
      [],
    ];
    for (int i = 0; i < incomeCategorieNames.length; i++) {
      categorieIndex = await globalStateRepository.getCategorieIndex();
      Categorie categorie = Categorie()
        ..index = categorieIndex
        ..type = CategorieType.income.name
        ..name = incomeCategorieNames[i]
        ..subcategorieNames = incomeSubcategorieNames[i];
      categorieBox.add(categorie);
      globalStateRepository.increaseCategorieIndex();
    }

    // Start Investment Kategorien erstellen
    List<String> investmentCategorieNames = ['ETF', 'Aktie', 'Fond', 'Krypto', 'Rohstoff', 'P2P', 'Immobilie', 'Sonstiges'];
    List<List<String>> investmentSubcategorieNames = [
      ['World', 'Emerging Markets', 'Europa', 'Asien', 'Branche'],
      [],
      ['World', 'Emerging Markets', 'Europa', 'Asien', 'Branche'],
      ['Bitcoin', 'Ethereum', 'Solana', 'Ripple', 'Cardano', 'Dogecoin'],
      ['Gold', 'Silber', 'Nickel', 'Kupfer', 'Rohöl', 'Sonstiges'],
      [],
      [],
      [],
    ];
    for (int i = 0; i < investmentCategorieNames.length; i++) {
      categorieIndex = await globalStateRepository.getCategorieIndex();
      Categorie categorie = Categorie()
        ..index = categorieIndex
        ..type = CategorieType.investment.name
        ..name = investmentCategorieNames[i]
        ..subcategorieNames = investmentSubcategorieNames[i];
      categorieBox.add(categorie);
      globalStateRepository.increaseCategorieIndex();
    }
  }
}
