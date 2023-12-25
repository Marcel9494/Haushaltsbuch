part of 'categorie_bloc.dart';

@immutable
abstract class CategorieState {}

class CategorieInitial extends CategorieState {}

class CategorieLoadingState extends CategorieState {
  CategorieLoadingState();
}

class CategorieLoadedState extends CategorieState {
  final BuildContext context;
  final int categorieBoxIndex;
  CategorieLoadedState(this.context, this.categorieBoxIndex);
}
