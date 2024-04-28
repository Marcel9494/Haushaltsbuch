import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/categorie_bloc/categorie_bloc.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';
import '/components/input_fields/text_input_field.dart';

class CreateOrEditSubcategorieScreen extends StatefulWidget {
  const CreateOrEditSubcategorieScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditSubcategorieScreen> createState() => _CreateOrEditSubcategorieScreenState();

  static _CreateOrEditSubcategorieScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditSubcategorieScreenState>();
}

class _CreateOrEditSubcategorieScreenState extends State<CreateOrEditSubcategorieScreen> {
  late final CategorieBloc categorieBloc;
  late final TextInputFieldCubit subcategorieNameInputFieldCubit;
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();

  UniqueKey textInputFieldUniqueKey = UniqueKey();

  FocusNode subcategorieNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    categorieBloc = BlocProvider.of<CategorieBloc>(context);
    subcategorieNameInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CategorieBloc, CategorieState>(
        builder: (context, subcategorieState) {
          if (subcategorieState is SubcategorieLoadingState) {
            return const LoadingIndicator();
          } else if (subcategorieState is SubcategorieLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: subcategorieState.categorieIndex == -1 ? const Text('Unterkategorie erstellen') : const Text('Unterkategorie bearbeiten'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                        builder: (context, state) {
                          return TextInputField(
                            uniqueKey: textInputFieldUniqueKey,
                            focusNode: subcategorieNameFocusNode,
                            textCubit: subcategorieNameInputFieldCubit,
                            hintText: 'Unterkategoriename',
                            maxLength: 60,
                          );
                        },
                      ),
                      SaveButton(
                          saveFunction: () => categorieBloc.add(subcategorieState.categorieIndex == -1
                              ? CreateSubcategorieEvent(context, _saveButtonController)
                              : UpdateSubcategorieEvent(context, _saveButtonController, subcategorieState.categorie)),
                          buttonController: _saveButtonController),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Unterkategorieseite");
          }
        },
      ),
    );
  }
}
