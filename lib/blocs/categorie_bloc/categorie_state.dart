part of 'categorie_bloc.dart';

@immutable
abstract class CategorieState {}

class CategorieInitial extends CategorieState {}

class CategorieLoadingState extends CategorieState {
  CategorieLoadingState();
}

class CategorieLoadedState extends CategorieState {
  final BuildContext context;
  final int categorieIndex;
  CategorieLoadedState(this.context, this.categorieIndex);
}

class SubcategorieLoadingState extends CategorieState {
  SubcategorieLoadingState();
}

class SubcategorieLoadedState extends CategorieState {
  final BuildContext context;
  final int categorieIndex;
  final Categorie categorie;
  SubcategorieLoadedState(this.context, this.categorieIndex, this.categorie);
}
