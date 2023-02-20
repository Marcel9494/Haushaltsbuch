import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/booking.dart';

import '/utils/date_formatters/date_formatter.dart';

import '/components/buttons/transaction_toggle_buttons.dart';
import '/components/input_fields/title_input_field.dart';
import '/components/input_fields/date_input_field.dart';
import '/components/input_fields/amount_input_field.dart';
import '/components/input_fields/categorie_input_field.dart';
import '/components/input_fields/account_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/enums/transaction_types.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  const CreateOrEditBookingScreen({Key? key}) : super(key: key);

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
  String _currentTransaction = '';
  String _title = '';

  @override
  void initState() {
    super.initState();
    _bookingDateTextController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
  }

  set currentTransaction(String transaction) => setState(() => _currentTransaction = transaction);

  void _setTitleState(String title) {
    setState(() {
      _title = title;
    });
  }

  void _createBooking() {
    Booking booking = Booking();
    booking.title = _title;
    // TODO hier weitermachen und Buchung erstellen
    // TODO booking.transactionType = ;
    //booking.date = _bookingDateTextController.text as DateTime;
    booking.amount = double.parse(_amountTextController.text);
    booking.categorie = _categorieTextController.text;
    booking.fromAccount = _fromAccountTextController.text;
    booking.toAccount = _toAccountTextController.text;
    print(booking);
    booking.createBooking(booking);
  }

  @override
  Widget build(BuildContext context) {
    // TODO hier weitermachen und erste Testbuchungen erstellen können, um diese in den
    // unterschiedlichen Tab Views (Kalender, Täglich & Monatlich) anzeigen lassen zu können.
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0x00ffffff),
        appBar: AppBar(
          title: const Text('Buchung erstellen'),
          backgroundColor: const Color(0x00ffffff),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            color: const Color(0x1fffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              children: [
                TransactionToggleButtons(transactionStringCallback: (transaction) => setState(() => _currentTransaction = transaction)),
                TitleInputField(
                  title: _title,
                  titleCallback: _setTitleState,
                ),
                DateInputField(textController: _bookingDateTextController),
                AmountInputField(textController: _amountTextController),
                _currentTransaction == TransactionType.transfer.name ? const SizedBox() : CategorieInputField(textController: _categorieTextController),
                _currentTransaction == TransactionType.transfer.name
                    ? AccountInputField(textController: _fromAccountTextController, hintText: 'Von')
                    : AccountInputField(textController: _fromAccountTextController),
                _currentTransaction == TransactionType.transfer.name ? AccountInputField(textController: _toAccountTextController, hintText: 'Nach') : const SizedBox(),
                SaveButton(saveFunction: _createBooking),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
