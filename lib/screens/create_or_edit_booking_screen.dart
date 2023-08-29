import 'dart:async';

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../components/input_fields/subcategorie_input_field.dart';
import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';
import '/utils/date_formatters/date_formatter.dart';

import '/components/buttons/transaction_toggle_buttons.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/input_fields/date_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/account_input_field.dart';
import '/components/buttons/save_button.dart';
import '/components/deco/loading_indicator.dart';

import '/models/booking.dart';
import '/models/primary_account.dart';
import '/models/enums/repeat_types.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/enums/preselect_account_types.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;

  const CreateOrEditBookingScreen({
    Key? key,
    required this.bookingBoxIndex,
    required this.serieEditMode,
  }) : super(key: key);

  @override
  State<CreateOrEditBookingScreen> createState() => _CreateOrEditBookingScreenState();

  static _CreateOrEditBookingScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditBookingScreenState>();
}

class _CreateOrEditBookingScreenState extends State<CreateOrEditBookingScreen> {
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _bookingNameController = TextEditingController();
  final TextEditingController _bookingDateTextController = TextEditingController();
  final TextEditingController _fromAccountTextController = TextEditingController();
  final TextEditingController _toAccountTextController = TextEditingController();
  final TextEditingController _categorieTextController = TextEditingController();
  // TODO hier weitermachen und _subcategorieTextController.text überall einbauen, dabei an _categorieTextController.text orientieren
  // müssten die gleichen Stellen sein. Buchung Datenstruktur um Unterkategorie Eintrag erweitern.
  final TextEditingController _subcategorieTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
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

  @override
  void initState() {
    super.initState();
    if (widget.bookingBoxIndex == -1) {
      _currentTransaction = TransactionType.outcome.name;
      _bookingRepeat = RepeatType.noRepetition.name;
      _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
    } else {
      _loadBooking();
    }
  }

  Future<void> _loadBooking() async {
    _loadedBooking = await Booking.loadBooking(widget.bookingBoxIndex);
    _currentTransaction = _loadedBooking.transactionType;
    _bookingNameController.text = _loadedBooking.title;
    _parsedBookingDate = DateTime.parse(_loadedBooking.date);
    _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.parse(_loadedBooking.date));
    _bookingRepeat = _loadedBooking.bookingRepeats;
    _amountTextController.text = _loadedBooking.amount;
    _bookingNameController.text = _loadedBooking.title;
    _categorieTextController.text = _loadedBooking.categorie;
    _subcategorieTextController.text = _loadedBooking.subcategorie;
    _fromAccountTextController.text = _loadedBooking.fromAccount;
    _toAccountTextController.text = _loadedBooking.toAccount;
    _isBookingEdited = true;
  }

  void _createOrUpdateBooking() async {
    if (_validBookingName(_bookingNameController.text) == false ||
        _validBookingAmount(_amountTextController.text) == false ||
        _validCategorie(_categorieTextController.text) == false ||
        _validFromAccount(_fromAccountTextController.text) == false ||
        _validToAccount(_toAccountTextController.text) == false) {
      _setSaveButtonAnimation(false);
      return;
    }
    if (widget.bookingBoxIndex == -1) {
      Booking booking = Booking();
      if (_bookingRepeat == RepeatType.noRepetition.name) {
        // TODO Code verbessern und nur komplettes Booking Objekt übergeben
        booking.createBooking(_bookingNameController.text, _currentTransaction, _parsedBookingDate.toString(), _bookingRepeat, _amountTextController.text,
            _categorieTextController.text, _subcategorieTextController.text, _fromAccountTextController.text, _toAccountTextController.text);
      } else if (_bookingRepeat != RepeatType.noRepetition.name) {
        // TODO Code verbessern und nur komplettes Booking Objekt übergeben
        booking.createBookingSerie(_bookingNameController.text, _currentTransaction, _parsedBookingDate.toString(), _bookingRepeat, _amountTextController.text,
            _categorieTextController.text, _subcategorieTextController.text, _fromAccountTextController.text, _toAccountTextController.text);
      }
    } else {
      Booking currentBooking = Booking()
        ..transactionType = _currentTransaction
        ..bookingRepeats = _bookingRepeat
        ..title = _bookingNameController.text
        ..date = _parsedBookingDate.toString()
        ..amount = _amountTextController.text
        ..categorie = _categorieTextController.text
        ..subcategorie = _subcategorieTextController.text
        ..fromAccount = _fromAccountTextController.text
        ..toAccount = _toAccountTextController.text
        ..serieId = _loadedBooking.serieId
        ..booked = _loadedBooking.booked;
      Booking.updateSerieBookings(currentBooking, _loadedBooking, widget.bookingBoxIndex, widget.serieEditMode);
    }
    _setSaveButtonAnimation(true);
    Timer(const Duration(milliseconds: transitionInMs), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
      }
    });
  }

  bool _validBookingName(String bookingName) {
    if (_bookingNameController.text.isEmpty) {
      setState(() {
        _bookingNameErrorText = "Bitte geben Sie eine Beschreibung für die Buchung ein.";
      });
      return false;
    }
    _bookingNameErrorText = '';
    return true;
  }

  bool _validBookingAmount(String amountInput) {
    if (_amountTextController.text.isEmpty) {
      setState(() {
        _amountErrorText = 'Bitte geben Sie einen Betrag ein.';
      });
      return false;
    }
    _amountErrorText = '';
    return true;
  }

  bool _validCategorie(String categorieInput) {
    if ((_currentTransaction != TransactionType.transfer.name && _currentTransaction != TransactionType.investment.name) && _categorieTextController.text.isEmpty) {
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

  set currentTransaction(String transaction) => setState(() => {_currentTransaction = transaction, _categorieTextController.text = '', _subcategorieTextController.text = ''});
  set currentBookingDate(DateTime bookingDate) => _parsedBookingDate = bookingDate;

  void _deleteBooking(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.serieEditMode == SerieEditModeType.none || widget.serieEditMode == SerieEditModeType.single ? 'Buchung löschen?' : 'Buchungen löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Nein',
                style: TextStyle(
                  color: Colors.cyanAccent,
                ),
              ),
              onPressed: () => _noPressed(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.cyanAccent,
              ),
              onPressed: () => {
                _yesPressed(index),
                Flushbar(
                  title:
                      widget.serieEditMode == SerieEditModeType.none || widget.serieEditMode == SerieEditModeType.single ? 'Buchung wurde gelöscht' : 'Buchungen wurden gelöscht',
                  message: widget.serieEditMode == SerieEditModeType.none || widget.serieEditMode == SerieEditModeType.single
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
              child: const Text('Ja'),
            ),
          ],
        );
      },
    );
  }

  void _yesPressed(int index) {
    if (widget.serieEditMode == SerieEditModeType.none) {
      setState(() {
        _loadedBooking.deleteBooking(widget.bookingBoxIndex);
      });
    } else {
      setState(() {
        Booking currentBooking = Booking()
          ..transactionType = _currentTransaction
          ..bookingRepeats = _bookingRepeat
          ..title = _bookingNameController.text
          ..date = _parsedBookingDate.toString()
          ..amount = _amountTextController.text
          ..categorie = _categorieTextController.text
          ..subcategorie = _subcategorieTextController.text
          ..fromAccount = _fromAccountTextController.text
          ..toAccount = _toAccountTextController.text
          ..serieId = _loadedBooking.serieId
          ..booked = _loadedBooking.booked;
        Booking.deleteSerieBookings(currentBooking, widget.bookingBoxIndex, widget.serieEditMode);
      });
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
    FocusScope.of(context).unfocus();
  }

  void _noPressed() {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
  }

  Future<void> _loadPreselectedAccounts() async {
    _primaryAccounts = await PrimaryAccount.getCurrentPrimaryAccounts();
    _isPreselectedAccountsLoaded = true;
  }

  // TODO Funktion einfacher und übersichtlicher implementieren
  Widget _getAccountInputField() {
    if (widget.bookingBoxIndex == -1 && _fromAccountTextController.text.isEmpty && _toAccountTextController.text.isEmpty) {
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
          title: widget.bookingBoxIndex == -1 ? const Text('Buchung erstellen') : const Text('Buchung bearbeiten'),
          actions: [
            widget.bookingBoxIndex == -1
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.delete_forever_rounded),
                    onPressed: () {
                      _deleteBooking(widget.bookingBoxIndex);
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
              future: widget.bookingBoxIndex == -1
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
                            bookingDateCallback: (bookingDate) => _parsedBookingDate = bookingDate,
                            repeat: _bookingRepeat,
                            repeatCallback: (repeat) => setState(() => _bookingRepeat = repeat)),
                        TextInputField(textEditingController: _bookingNameController, errorText: _bookingNameErrorText, hintText: 'Titel'),
                        MoneyInputField(textController: _amountTextController, errorText: _amountErrorText, hintText: 'Betrag', bottomSheetTitle: 'Betrag eingeben:'),
                        _getAccountInputField(),
                        _currentTransaction == TransactionType.transfer.name
                            ? const SizedBox()
                            : CategorieInputField(
                                textController: _categorieTextController,
                                errorText: _categorieErrorText,
                                transactionType: _currentTransaction,
                                categorieStringCallback: (categorie) => setState(() => {_categorieTextController.text = categorie, _subcategorieTextController.text = ''})),
                        _currentTransaction == TransactionType.transfer.name
                            ? const SizedBox()
                            : SubcategorieInputField(textController: _subcategorieTextController, categorieName: _categorieTextController.text),
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
