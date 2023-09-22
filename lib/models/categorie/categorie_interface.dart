import 'categorie_model.dart';

import '../enums/categorie_types.dart';

abstract class CategorieInterface {
  void create(Categorie newCategorie);
  void update(Categorie updatedCategorie, String oldCategorieName);
  void delete(Categorie deleteCategorie);
  Future<bool> existsCategorieName(Categorie categorie);
  // TODO werden beide Funktionen noch benötigt oder reicht loadCategorieList?
  Future<List<String>> loadCategorieNames(CategorieType categorieType);
  Future<List<Categorie>> loadCategorieList(CategorieType categorieType);

  void createSubcategorie(Categorie updatedCategorie, String newSubcategorie);
  void updateSubcategorie(Categorie updatedCategorie, String oldSubcategorie, String newSubcategorie);
  void deleteSubcategorie(Categorie categorie, String deleteSubcategorie);
  Future<bool> existsSubcategorieName(Categorie categorie);
  Future<List<String>> loadSubcategorieNames(String mainCategorie);

  void createStartExpenditureCategories();
  void createStartRevenueCategories();
  void createStartInvestmentCategories();
}
