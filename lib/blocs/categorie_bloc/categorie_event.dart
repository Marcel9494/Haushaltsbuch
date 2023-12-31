part of 'categorie_bloc.dart';

abstract class CategorieEvents {}

class InitializeCategorieEvent extends CategorieEvents {
  final BuildContext context;
  InitializeCategorieEvent(this.context);
}

class CreateCategorieEvent extends CategorieEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  CreateCategorieEvent(this.context, this.saveButtonController);
}

class LoadCategorieEvent extends CategorieEvents {
  final BuildContext context;
  final int categorieIndex;
  LoadCategorieEvent(this.context, this.categorieIndex);
}

class UpdateCategorieEvent extends CategorieEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  final int categorieIndex;
  UpdateCategorieEvent(this.context, this.saveButtonController, this.categorieIndex);
}

class DeleteCategorieEvent extends CategorieEvents {
  final BuildContext context;
  final Categorie deleteCategorie;
  DeleteCategorieEvent(this.context, this.deleteCategorie);
}

class InitializeSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final Categorie categorie;
  InitializeSubcategorieEvent(this.context, this.categorie);
}

class CreateSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  CreateSubcategorieEvent(this.context, this.saveButtonController);
}

class LoadSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final Categorie categorie;
  final String subcategorieName;
  LoadSubcategorieEvent(this.context, this.categorie, this.subcategorieName);
}

class UpdateSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  final Categorie categorie;
  UpdateSubcategorieEvent(this.context, this.saveButtonController, this.categorie);
}

class DeleteSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final Categorie mainCategorie;
  final String deleteSubcategorie;
  DeleteSubcategorieEvent(this.context, this.mainCategorie, this.deleteSubcategorie);
}
