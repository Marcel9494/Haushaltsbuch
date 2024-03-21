import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/booking_bloc/booking_bloc.dart';
import '/blocs/input_field_blocs/account_input_field_bloc/to_account_input_field_cubit.dart';
import '/blocs/input_field_blocs/date_input_field_bloc/date_input_field_cubit.dart';
import '/blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '/blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '/blocs/input_field_blocs/account_input_field_bloc/from_account_input_field_cubit.dart';
import '/blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '/blocs/input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';
import '/blocs/button_blocs/transaction_stats_toggle_buttons_bloc/transaction_stats_toggle_buttons_cubit.dart';

import '/components/input_fields/subcategorie_input_field.dart';
import '/components/buttons/transaction_toggle_buttons.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/input_fields/date_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/to_account_input_field.dart';
import '/components/input_fields/from_account_input_field.dart';
import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';

import '/models/enums/categorie_types.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  const CreateOrEditBookingScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditBookingScreen> createState() => _CreateOrEditBookingScreenState();

  static _CreateOrEditBookingScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditBookingScreenState>();
}

class _CreateOrEditBookingScreenState extends State<CreateOrEditBookingScreen> {
  late final BookingBloc bookingBloc;
  late final TransactionStatsToggleButtonsCubit transactionStatsToggleButtonsCubit;
  late final DateInputFieldCubit dateInputFieldCubit;
  late final TextInputFieldCubit titleInputFieldCubit;
  late final MoneyInputFieldCubit moneyInputFieldCubit;
  late final CategorieInputFieldCubit categorieInputFieldCubit;
  late final FromAccountInputFieldCubit fromAccountInputFieldCubit;
  late final ToAccountInputFieldCubit toAccountInputFieldCubit;
  late final SubcategorieInputFieldCubit subcategorieInputFieldCubit;
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();

  UniqueKey titleFieldUniqueKey = UniqueKey();

  FocusNode dateFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();
  FocusNode fromAccountFocusNode = FocusNode();
  FocusNode toAccountFocusNode = FocusNode();
  FocusNode categorieFocusNode = FocusNode();
  FocusNode subcategorieFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bookingBloc = BlocProvider.of<BookingBloc>(context);
    transactionStatsToggleButtonsCubit = BlocProvider.of<TransactionStatsToggleButtonsCubit>(context);
    dateInputFieldCubit = BlocProvider.of<DateInputFieldCubit>(context);
    titleInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
    categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(context);
    fromAccountInputFieldCubit = BlocProvider.of<FromAccountInputFieldCubit>(context);
    toAccountInputFieldCubit = BlocProvider.of<ToAccountInputFieldCubit>(context);
    subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingLoadingState) {
            return const LoadingIndicator();
          } else if (bookingState is BookingLoadedState) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: bookingState.bookingBoxIndex == -1 ? const Text('Buchung erstellen') : const Text('Buchung bearbeiten'),
                actions: [
                  bookingState.bookingBoxIndex == -1
                      ? const SizedBox()
                      : IconButton(
                          icon: const Icon(Icons.delete_forever_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(bookingState.serieEditModeType == SerieEditModeType.none || bookingState.serieEditModeType == SerieEditModeType.single
                                      ? 'Buchung löschen?'
                                      : 'Buchungen löschen?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'Nein',
                                        style: TextStyle(
                                          color: Colors.cyanAccent,
                                        ),
                                      ),
                                      onPressed: () => {
                                        Navigator.pop(context),
                                        FocusScope.of(context).unfocus(),
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () => {
                                        bookingBloc.add(DeleteBookingEvent(context, bookingState.bookingBoxIndex, bookingState.serieEditModeType)),
                                        Navigator.pop(context),
                                        Navigator.pop(context),
                                        Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0)),
                                        Flushbar(
                                          title: bookingState.serieEditModeType == SerieEditModeType.none || bookingState.serieEditModeType == SerieEditModeType.single
                                              ? 'Buchung wurde gelöscht'
                                              : 'Buchungen wurden gelöscht',
                                          message: bookingState.serieEditModeType == SerieEditModeType.none || bookingState.serieEditModeType == SerieEditModeType.single
                                              ? 'Buchung wurde erfolgreich gelöscht.'
                                              : 'Buchungen wurden erfolgreich gelöscht',
                                          icon: const Icon(
                                            Icons.info_outline,
                                            size: 28.0,
                                            color: Colors.cyanAccent,
                                          ),
                                          duration: const Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.cyanAccent,
                                        )..show(context),
                                      },
                                      child: const Text(
                                        'Ja',
                                        style: TextStyle(
                                          color: Colors.cyanAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                child: Card(
                  color: const Color(0xff1c2b30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: BlocBuilder<TransactionStatsToggleButtonsCubit, TransactionStatsToggleButtonsModel>(
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransactionToggleButtons(cubit: transactionStatsToggleButtonsCubit),
                          BlocBuilder<DateInputFieldCubit, DateInputFieldModel>(
                            builder: (context, state) {
                              return DateInputField(cubit: dateInputFieldCubit, focusNode: dateFocusNode, enabled: bookingState.serieEditModeType == SerieEditModeType.onlyFuture || bookingState.serieEditModeType == SerieEditModeType.all ? false : true);
                            },
                          ),
                          BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                            builder: (context, state) {
                              return TextInputField(fieldKey: titleFieldUniqueKey, focusNode: titleFocusNode, textCubit: titleInputFieldCubit, hintText: 'Titel', maxLength: 100);
                            },
                          ),
                          BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                            builder: (context, state) {
                              return MoneyInputField(
                                cubit: moneyInputFieldCubit,
                                focusNode: amountFocusNode,
                                hintText: 'Betrag',
                                bottomSheetTitle: 'Betrag eingeben:',
                                transactionType: TransactionTypeExtension.getTransactionType(transactionStatsToggleButtonsCubit.state.transactionName),
                              );
                            },
                          ),
                          Column(
                            children: [
                              BlocBuilder<FromAccountInputFieldCubit, FromAccountInputFieldModel>(
                                builder: (context, state) {
                                  return FromAccountInputField(
                                      cubit: fromAccountInputFieldCubit,
                                      focusNode: fromAccountFocusNode,
                                      hintText: transactionStatsToggleButtonsCubit.state.selectedTransaction[0] == true ? 'Konto' : 'Abbuchungskonto');
                                },
                              ),
                              BlocBuilder<ToAccountInputFieldCubit, ToAccountInputFieldModel>(
                                builder: (context, state) {
                                  if (transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.transfer.name ||
                                      transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.investment.name) {
                                    return ToAccountInputField(cubit: toAccountInputFieldCubit, focusNode: toAccountFocusNode, hintText: 'Zielkonto');
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                          transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.transfer.name
                              ? const SizedBox()
                              : BlocBuilder<CategorieInputFieldCubit, CategorieInputFieldModel>(
                                  builder: (context, state) {
                                    return CategorieInputField(
                                      cubit: categorieInputFieldCubit,
                                      focusNode: categorieFocusNode,
                                      categorieType: CategorieTypeExtension.getCategorieType(transactionStatsToggleButtonsCubit.state.transactionName),
                                    );
                                  },
                                ),
                          transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.transfer.name
                              ? const SizedBox()
                              : BlocBuilder<SubcategorieInputFieldCubit, String>(
                                  builder: (context, state) {
                                    return SubcategorieInputField(cubit: subcategorieInputFieldCubit, focusNode: subcategorieFocusNode);
                                  },
                                ),
                          SaveButton(
                              saveFunction: () => bookingBloc.add(
                                    CreateOrUpdateBookingEvent(
                                      context,
                                      bookingState.bookingBoxIndex,
                                      bookingState.serieEditModeType,
                                      _saveButtonController,
                                    ),
                                  ),
                              buttonController: _saveButtonController),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Text("Fehler bei Buchungsseite");
          }
        },
      ),
    );
  }
}
