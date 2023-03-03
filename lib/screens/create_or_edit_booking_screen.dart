import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/utils/consts/route_consts.dart';
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
import '/models/account.dart';
import '/models/enums/transaction_types.dart';
import '/models/enums/booking_repeats.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  final int bookingBoxIndex;

  const CreateOrEditBookingScreen({
    Key? key,
    required this.bookingBoxIndex,
  }) : super(key: key);

  @override
  State<CreateOrEditBookingScreen> createState() => _CreateOrEditBookingScreenState();

  static _CreateOrEditBookingScreenState? of(BuildContext context) => context.findAncestorStateOfType<_CreateOrEditBookingScreenState>();
}

class _CreateOrEditBookingScreenState extends State<CreateOrEditBookingScreen> {
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _bookingDateTextController = TextEditingController();
  final TextEditingController _fromAccountTextController = TextEditingController();
  final TextEditingController _toAccountTextController = TextEditingController();
  final TextEditingController _categorieTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  bool _isBookingEdited = false;
  String _currentTransaction = '';
  String _title = '';
  String _amountErrorText = '';
  String _categorieErrorText = '';
  String _fromAccountErrorText = '';
  String _toAccountErrorText = '';
  DateTime? _parsedBookingDate;
  late Booking loadedBooking;

  @override
  void initState() {
    super.initState();
    if (widget.bookingBoxIndex != -1) {
      _loadBooking();
    } else {
      _currentTransaction = TransactionType.outcome.name;
      _parsedBookingDate = DateTime.now();
      _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
    }
  }

  Future<void> _loadBooking() async {
    loadedBooking = await Booking.loadBooking(widget.bookingBoxIndex);
    _currentTransaction = loadedBooking.transactionType;
    _title = loadedBooking.title;
    _parsedBookingDate = DateTime.parse(loadedBooking.date);
    _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.parse(loadedBooking.date));
    _amountTextController.text = loadedBooking.amount;
    _categorieTextController.text = loadedBooking.categorie;
    _fromAccountTextController.text = loadedBooking.fromAccount;
    _toAccountTextController.text = loadedBooking.toAccount;
    _isBookingEdited = true;
  }

  void _createBooking() {
    if (_validBookingAmount(_amountTextController.text) == false ||
        _validCategorie(_categorieTextController.text) == false ||
        _validFromAccount(_fromAccountTextController.text) == false ||
        _validToAccount(_toAccountTextController.text) == false) {
      _setSaveButtonAnimation(false);
    } else {
      Booking booking = Booking()
        ..transactionType = _currentTransaction
        ..bookingRepeats = BookingRepeats.noRepeat.name // TODO dynamisch machen, wenn Wiederholungen implementiert wurden
        ..title = _title
        ..date = _parsedBookingDate.toString()
        ..amount = _amountTextController.text
        ..categorie = _categorieTextController.text
        ..fromAccount = _fromAccountTextController.text
        ..toAccount = _toAccountTextController.text;
      if (_currentTransaction == TransactionType.transfer.name) {
        Account.transferMoney(_fromAccountTextController.text, _toAccountTextController.text, _amountTextController.text);
      } else {
        Account.calculateNewAccountBalance(_fromAccountTextController.text, _amountTextController.text, _currentTransaction);
      }
      if (widget.bookingBoxIndex == -1) {
        booking.createBooking(booking);
      } else {
        booking.updateBooking(booking, widget.bookingBoxIndex);
      }
      _setSaveButtonAnimation(true);
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
        }
      });
    }
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
    if (_currentTransaction != TransactionType.transfer.name && _categorieTextController.text.isEmpty) {
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
    if (_currentTransaction == TransactionType.transfer.name && _toAccountTextController.text.isEmpty) {
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

  set currentTransaction(String transaction) => setState(() => _currentTransaction = transaction);
  set currentBookingDate(DateTime bookingDate) => setState(() => _parsedBookingDate = bookingDate);

  void _setTitleState(String title) {
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0x00ffffff),
        appBar: AppBar(
          title: const Text('Buchung erstellen'),
          backgroundColor: const Color(0x00ffffff),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0x1fffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: FutureBuilder(
              future: widget.bookingBoxIndex == -1
                  ? null
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
                        TextInputField(input: _title, inputCallback: _setTitleState, hintText: 'Titel'),
                        DateInputField(textController: _bookingDateTextController, bookingDateCallback: (bookingDate) => setState(() => _parsedBookingDate = bookingDate)),
                        MoneyInputField(textController: _amountTextController, errorText: _amountErrorText, hintText: 'Betrag', bottomSheetTitle: 'Betrag eingeben:'),
                        _currentTransaction == TransactionType.transfer.name
                            ? const SizedBox()
                            : CategorieInputField(textController: _categorieTextController, errorText: _categorieErrorText),
                        _currentTransaction == TransactionType.transfer.name
                            ? AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText, hintText: 'Von')
                            : AccountInputField(textController: _fromAccountTextController, errorText: _fromAccountErrorText),
                        _currentTransaction == TransactionType.transfer.name
                            ? AccountInputField(textController: _toAccountTextController, errorText: _toAccountErrorText, hintText: 'Nach')
                            : const SizedBox(),
                        SaveButton(saveFunction: _createBooking, buttonController: _saveButtonController),
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
