import '/models/categorie.dart';

import '../enums/mode_types.dart';

class CreateOrEditSubcategorieScreenArguments {
  final Categorie categorie;
  final ModeType mode;
  final int subcategorieIndex;

  CreateOrEditSubcategorieScreenArguments(
    this.categorie,
    this.mode,
    this.subcategorieIndex,
  );
}
