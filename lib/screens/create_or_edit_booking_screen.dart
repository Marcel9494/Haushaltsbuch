import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/booking_bloc/booking_bloc.dart';
import '/blocs/booking_bloc/booking_cubit.dart';
import '/blocs/input_fields_bloc/text_input_field_cubit.dart';
import '/blocs/input_fields_bloc/money_input_field_cubit.dart';
import '/blocs/input_fields_bloc/categorie_input_field_cubit.dart';
import '/blocs/input_fields_bloc/subcategorie_input_field_cubit.dart';

import '/utils/date_formatters/date_formatter.dart';

import '/components/input_fields/subcategorie_input_field.dart';
import '/components/buttons/transaction_toggle_buttons.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/input_fields/date_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/account_input_field.dart';
import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';

import '/models/booking/booking_repository.dart';
import '/models/booking/booking_model.dart';
import '/models/enums/categorie_types.dart';
import '/models/enums/repeat_types.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/enums/preselect_account_types.dart';
import '/models/primary_account/primary_account_repository.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  const CreateOrEditBookingScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditBookingScreen> createState() => _CreateOrEditBookingScreenState();

  static _CreateOrEditBookingScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditBookingScreenState>();
}

class _CreateOrEditBookingScreenState extends State<CreateOrEditBookingScreen> {
  final TextEditingController _bookingDateTextController = TextEditingController();
  final TextEditingController _fromAccountTextController = TextEditingController();
  final TextEditingController _toAccountTextController = TextEditingController();

  //final TextEditingController _categorieTextController = TextEditingController();
  //final TextEditingController _subcategorieTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  late final BookingBloc bookingBloc;
  late final BookingCubit bookingCubit;
  late final TextInputFieldCubit titleInputFieldCubit;
  late final MoneyInputFieldCubit moneyInputFieldCubit;
  late final CategorieInputFieldCubit categorieInputFieldCubit;
  late final SubcategorieInputFieldCubit subcategorieInputFieldCubit;
  final BookingRepository bookingRepository = BookingRepository();
  bool _isBookingEdited = false;
  bool _isPreselectedAccountsLoaded = false;
  String _currentTransaction = '';
  String _amountErrorText = '';
  String _bookingNameErrorText = '';
  String _categorieErrorText = '';
  String _fromAccountErrorText = '';
  String _toAccountErrorText = '';
  String _bookingRepeat = '';
  DateTime _parsedBookingDate = DateTime.now();
  Map<String, String> _primaryAccounts = {};
  late Booking _loadedBooking;
  int boxIndex = 0;

  final UniqueKey titleFieldUniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    titleInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(context);
    moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(context);
    categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(context);
    subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(context);
    bookingBloc = BlocProvider.of<BookingBloc>(context);
    bookingCubit = BlocProvider.of<BookingCubit>(context);

    Map<Booking, int> map = bookingCubit.state;
    final Booking booking = map.keys.first;
    boxIndex = map.values.first;

    if (boxIndex == -1) {
      _currentTransaction = TransactionType.outcome.name;
      _bookingRepeat = RepeatType.noRepetition.name;
      _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
    } else {
      titleInputFieldCubit.updateValue(booking.title);
      moneyInputFieldCubit.updateValue(booking.amount);
      categorieInputFieldCubit.updateValue(booking.categorie);
      //_loadBooking();
    }
  }

  Future<void> _loadBooking() async {
    _loadedBooking = await bookingRepository.load(boxIndex);
    _currentTransaction = _loadedBooking.transactionType;
    //_bookingNameController.text = _loadedBooking.title;
    _parsedBookingDate = DateTime.parse(_loadedBooking.date);
    _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.parse(_loadedBooking.date));
    _bookingRepeat = _loadedBooking.bookingRepeats;
    //_amountTextController.text = _loadedBooking.amount;
    //_bookingNameController.text = _loadedBooking.title;
    //_categorieTextController.text = _loadedBooking.categorie;
    //_subcategorieTextController.text = _loadedBooking.subcategorie;
    _fromAccountTextController.text = _loadedBooking.fromAccount;
    _toAccountTextController.text = _loadedBooking.toAccount;
    _isBookingEdited = true;
  }

  void _createOrUpdateBooking() async {
    if (_validBookingTitle() == false ||
        _validBookingAmount() == false ||
        _validCategorie() == false ||
        _validFromAccount(_fromAccountTextController.text) == false ||
        _validToAccount(_toAccountTextController.text) == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    Booking booking = Booking()
      ..transactionType = _currentTransaction
      ..bookingRepeats = _bookingRepeat
      ..title = titleInputFieldCubit.state
      ..date = _parsedBookingDate.toString()
      ..amount = moneyInputFieldCubit.state
      ..categorie = categorieInputFieldCubit.state
      ..subcategorie = subcategorieInputFieldCubit.state
      ..fromAccount = _fromAccountTextController.text
      ..toAccount = _toAccountTextController.text
      ..serieId = boxIndex == -1 ? -1 : _loadedBooking.serieId
      ..booked = _parsedBookingDate.isAfter(DateTime.now()) ? false : true;
    if (boxIndex == -1) {
      bookingBloc.add(CreateBookingEvent(context, booking));
    } else {
      // TODO SerieEditModeType.single dynamisch machen
      bookingBloc.add(UpdateBookingEvent(context, _loadedBooking, booking, boxIndex, SerieEditModeType.single));
    }
    _setSaveButtonAnimation(true);
  }

  bool _validBookingTitle() {
    if (titleInputFieldCubit.state.isEmpty) {
      setState(() {
        _bookingNameErrorText = "Bitte geben Sie eine Beschreibung für die Buchung ein.";
      });
      return false;
    }
    _bookingNameErrorText = '';
    return true;
  }

  bool _validBookingAmount() {
    if (moneyInputFieldCubit.state.isEmpty) {
      setState(() {
        _amountErrorText = 'Bitte geben Sie einen Betrag ein.';
      });
      return false;
    }
    _amountErrorText = '';
    return true;
  }

  bool _validCategorie() {
    if ((_currentTransaction != TransactionType.transfer.name && _currentTransaction != TransactionType.investment.name) && categorieInputFieldCubit.state.isEmpty) {
      setState(() {
        _categorieErrorText = 'Bitte wählen Sie eine Kategorie aus.';
      });
      return false;
    }
    _categorieErrorText = '';
    return true;
  }

  bool _validFromAccount(String fromAccountInput) {
    if (_fromAccountTextController.text.isEmpty) {
      setState(() {
        _fromAccountErrorText = 'Bitte wählen Sie ein Konto aus.';
      });
      return false;
    }
    _fromAccountErrorText = '';
    return true;
  }

  bool _validToAccount(String toAccountInput) {
    if ((_currentTransaction == TransactionType.transfer.name && _currentTransaction != TransactionType.investment.name) && _toAccountTextController.text.isEmpty) {
      setState(() {
        _toAccountErrorText = 'Bitte wählen Sie ein Konto aus.';
      });
      return false;
    }
    _toAccountErrorText = '';
    return true;
  }

  void _setSaveButtonAnimation(bool successful) {
    successful ? _saveButtonController.success() : _saveButtonController.error();
    if (successful == false) {
      Timer(const Duration(seconds: 1), () {
        _saveButtonController.reset();
      });
    }
  }

  set currentTransaction(String transaction) =>
      setState(() => {_currentTransaction = transaction, categorieInputFieldCubit.resetValue(), subcategorieInputFieldCubit.resetValue()});

  set currentBookingDate(DateTime bookingDate) => _parsedBookingDate = bookingDate;

  Future<void> _loadPreselectedAccounts() async {
    PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
    _primaryAccounts = await primaryAccountRepository.getCurrentPrimaryAccounts();
    _isPreselectedAccountsLoaded = true;
  }

  // TODO Funktion einfacher und übersichtlicher implementieren
  Widget _getAccountInputField() {
    if (boxIndex == -1 && _fromAccountTextController.text.isEmpty && _toAccountTextController.text.isEmpty) {
      if (_currentTransaction == TransactionType.income.name) {
        _fromAccountTextController.text = _primaryAccounts[PreselectAccountType.income.name] ?? '';
        return AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText);
      } else if (_currentTransaction == TransactionType.outcome.name) {
        _fromAccountTextController.text = _primaryAccounts[PreselectAccountType.outcome.name] ?? '';
        return AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText);
      } else if (_currentTransaction == TransactionType.transfer.name) {
        _fromAccountTextController.text = _primaryAccounts[PreselectAccountType.transferFrom.name] ?? '';
        _toAccountTextController.text = _primaryAccounts[PreselectAccountType.transferTo.name] ?? '';
        return Column(
          children: [
            AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText, hintText: 'Von'),
            AccountInputField(textController: _toAccountTextController, errorText: _toAccountErrorText, hintText: 'Nach')
          ],
        );
      } else if (_currentTransaction == TransactionType.investment.name) {
        _fromAccountTextController.text = _primaryAccounts[PreselectAccountType.investmentFrom.name] ?? '';
        _toAccountTextController.text = _primaryAccounts[PreselectAccountType.investmentTo.name] ?? '';
        return Column(
          children: [
            AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText, hintText: 'Von'),
            AccountInputField(textController: _toAccountTextController, errorText: _toAccountErrorText, hintText: 'Nach'),
          ],
        );
      }
    } else if (_fromAccountTextController.text.isNotEmpty || _toAccountTextController.text.isNotEmpty) {
      if (_currentTransaction == TransactionType.income.name) {
        return AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText);
      } else if (_currentTransaction == TransactionType.outcome.name) {
        return AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText);
      } else if (_currentTransaction == TransactionType.transfer.name) {
        return Column(
          children: [
            AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText, hintText: 'Von'),
            AccountInputField(textController: _toAccountTextController, errorText: _toAccountErrorText, hintText: 'Nach')
          ],
        );
      }
    } else {
      if (_currentTransaction == TransactionType.income.name || _currentTransaction == TransactionType.outcome.name) {
        _fromAccountTextController.text = _loadedBooking.fromAccount;
        return AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText);
      } else {
        _fromAccountTextController.text = _loadedBooking.fromAccount;
        _toAccountTextController.text = _loadedBooking.toAccount;
        return Column(
          children: [
            AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText, hintText: 'Von'),
            AccountInputField(textController: _toAccountTextController, errorText: _toAccountErrorText, hintText: 'Nach'),
          ],
        );
      }
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: boxIndex == -1 ? const Text('Buchung erstellen') : const Text('Buchung bearbeiten'),
          actions: [
            boxIndex == -1
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
            child: FutureBuilder(
              future: boxIndex == -1
                  ? _isPreselectedAccountsLoaded
                      ? null
                      : _loadPreselectedAccounts()
                  : _isBookingEdited
                      ? null
                      : _loadBooking(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingIndicator();
                  default:
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TransactionToggleButtons(
                            currentTransaction: _currentTransaction, transactionStringCallback: (transaction) => setState(() => _currentTransaction = transaction)),
                        DateInputField(
                            currentDate: _parsedBookingDate,
                            textController: _bookingDateTextController,
                            repeat: _bookingRepeat,
                            repeatCallback: (repeat) => setState(() => _bookingRepeat = repeat)),
                        BlocBuilder<TextInputFieldCubit, String>(
                          builder: (context, state) {
                            return TextInputField(fieldKey: titleFieldUniqueKey, textCubit: titleInputFieldCubit, errorText: _bookingNameErrorText, hintText: 'Titel');
                          },
                        ),
                        BlocBuilder<MoneyInputFieldCubit, String>(
                          builder: (context, state) {
                            return MoneyInputField(cubit: moneyInputFieldCubit, errorText: _amountErrorText, hintText: 'Betrag', bottomSheetTitle: 'Betrag eingeben:');
                          },
                        ),
                        _getAccountInputField(),
                        _currentTransaction == TransactionType.transfer.name
                            ? const SizedBox()
                            : BlocBuilder<CategorieInputFieldCubit, String>(
                                builder: (context, state) {
                                  return CategorieInputField(
                                      cubit: categorieInputFieldCubit, errorText: _categorieErrorText, categorieType: CategorieTypeExtension.getCategorieType(_currentTransaction));
                                },
                              ),
                        _currentTransaction == TransactionType.transfer.name
                            ? const SizedBox()
                            : BlocBuilder<SubcategorieInputFieldCubit, String>(
                                builder: (context, state) {
                                  return SubcategorieInputField(cubit: subcategorieInputFieldCubit);
                                },
                              ),
                        SaveButton(saveFunction: _createOrUpdateBooking, buttonController: _saveButtonController),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
