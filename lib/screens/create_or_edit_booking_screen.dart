import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/input_fields_bloc/to_account_input_field_cubit.dart';
import '/blocs/input_fields_bloc/date_input_field_cubit.dart';
import '/blocs/booking_bloc/booking_bloc.dart';
import '/blocs/input_fields_bloc/text_input_field_cubit.dart';
import '/blocs/input_fields_bloc/money_input_field_cubit.dart';
import '/blocs/input_fields_bloc/from_account_input_field_cubit.dart';
import '/blocs/input_fields_bloc/categorie_input_field_cubit.dart';
import '/blocs/input_fields_bloc/subcategorie_input_field_cubit.dart';
import '/blocs/button_bloc/transaction_stats_toggle_buttons_cubit.dart';

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

import '/models/booking/booking_model.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';

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

  late Booking _loadedBooking;
  int boxIndex = 0;

  UniqueKey titleFieldUniqueKey = UniqueKey();

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
          } else if (bookingState is BookingSuccessState) {
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
                            // TODO SerieEditModeType.single dynamisch machen
                            bookingBloc.add(DeleteBookingEvent(context, _loadedBooking, boxIndex, SerieEditModeType.single));
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
                          BlocBuilder<DateInputFieldCubit, DateInputFieldState>(
                            builder: (context, state) {
                              return DateInputField(cubit: dateInputFieldCubit);
                            },
                          ),
                          BlocBuilder<TextInputFieldCubit, TextInputFieldModel>(
                            builder: (context, state) {
                              return TextInputField(fieldKey: titleFieldUniqueKey, focusNode: titleFocusNode, textCubit: titleInputFieldCubit, hintText: 'Titel');
                            },
                          ),
                          BlocBuilder<MoneyInputFieldCubit, MoneyInputFieldModel>(
                            builder: (context, state) {
                              return MoneyInputField(cubit: moneyInputFieldCubit, focusNode: amountFocusNode, hintText: 'Betrag', bottomSheetTitle: 'Betrag eingeben:');
                            },
                          ),
                          Column(
                            children: [
                              BlocBuilder<FromAccountInputFieldCubit, FromAccountInputFieldModel>(
                                builder: (context, state) {
                                  return FromAccountInputField(cubit: fromAccountInputFieldCubit, focusNode: fromAccountFocusNode, hintText: 'Von');
                                },
                              ),
                              BlocBuilder<ToAccountInputFieldCubit, ToAccountInputFieldModel>(
                                builder: (context, state) {
                                  if (transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.transfer.name ||
                                      transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.investment.name) {
                                    return ToAccountInputField(cubit: toAccountInputFieldCubit, focusNode: toAccountFocusNode, hintText: 'Nach');
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
                                        categorieType: CategorieTypeExtension.getCategorieType(transactionStatsToggleButtonsCubit.state.transactionName));
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
                              saveFunction: () => bookingBloc.add(CreateOrUpdateBookingEvent(context, bookingState.bookingBoxIndex, _saveButtonController)),
                              buttonController: _saveButtonController),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Text("Unbekannter Fehler");
          }
        },
      ),
    );
  }
}
