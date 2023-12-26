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

class InitializeSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final String categorieName;
  InitializeSubcategorieEvent(this.context, this.categorieName);
}

class CreateSubcategorieEvent extends CategorieEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  CreateSubcategorieEvent(this.context, this.saveButtonController);
}
