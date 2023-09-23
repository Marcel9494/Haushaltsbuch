import 'categorie_model.dart';

import '../enums/categorie_types.dart';

abstract class CategorieInterface {
  void create(Categorie newCategorie);
  void update(Categorie updatedCategorie, String oldCategorieName);
  void delete(Categorie deleteCategorie);
  Future<bool> existsCategorieName(Categorie categorie);
  Future<List<Categorie>> loadCategorieList(CategorieType categorieType);
  Future<List<String>> loadCategorieNameList(CategorieType categorieType);

  void createSubcategorie(String mainCategorie, String newSubcategorie);
  void updateSubcategorie(String mainCategorie, String oldSubcategorie, String newSubcategorie);
  void deleteSubcategorie(Categorie categorie, String deleteSubcategorie);
  Future<bool> existsSubcategorieName(Categorie categorie);
  Future<List<String>> loadSubcategorieNameList(String mainCategorie);

  void createStartExpenditureCategories();
  void createStartRevenueCategories();
  void createStartInvestmentCategories();
}
