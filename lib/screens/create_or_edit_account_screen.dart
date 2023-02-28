import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/components/input_fields/account_type_input_field.dart';
import '/components/input_fields/money_input_field.dart';
import '/components/input_fields/text_input_field.dart';
import '/components/buttons/save_button.dart';

import '/models/account.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class CreateOrEditAccountScreen extends StatefulWidget {
  const CreateOrEditAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditAccountScreen> createState() => _CreateOrEditAccountScreenState();
}

class _CreateOrEditAccountScreenState extends State<CreateOrEditAccountScreen> {
  final TextEditingController _accountGroupTextController = TextEditingController();
  final TextEditingController _bankBalanceTextController = TextEditingController();
  final RoundedLoadingButtonController _saveButtonController = RoundedLoadingButtonController();
  String _accountName = '';
  String _accountNameErrorText = '';
  String _accountGroupErrorText = '';
  String _bankBalanceErrorText = '';

  void _createAccount() {
    if (_validAccountGroup(_accountGroupTextController.text) == false || _validAccountName(_accountName) == false || _validBankBalance(_bankBalanceTextController.text) == false) {
      _setSaveButtonAnimation(false);
    } else {
      Account account = Account();
      account.name = _accountName;
      account.accountType = _accountGroupTextController.text;
      account.bankBalance = _bankBalanceTextController.text;
      account.createAccount(account);
      _setSaveButtonAnimation(true);
      Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(2));
        }
      });
    }
  }

  bool _validAccountName(String accountNameInput) {
    if (_accountName.isEmpty) {
      setState(() {
        _accountNameErrorText = 'Bitte geben Sie einen Kontonamen ein.';
      });
      return false;
    }
    _accountNameErrorText = '';
    return true;
  }

  bool _validAccountGroup(String accountGroupInput) {
    if (_accountGroupTextController.text.isEmpty) {
      setState(() {
        _accountGroupErrorText = 'Bitte wählen Sie einen Kontotyp aus.';
      });
      return false;
    }
    _accountGroupErrorText = '';
    return true;
  }

  bool _validBankBalance(String bankBalanceInput) {
    if (_bankBalanceTextController.text.isEmpty) {
      setState(() {
        _bankBalanceErrorText = 'Bitte geben Sie einen Kontostand ein.';
      });
      return false;
    }
    _bankBalanceErrorText = '';
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

  void _setAccountNameState(String accountName) {
    setState(() {
      _accountName = accountName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0x00ffffff),
        appBar: AppBar(
          title: const Text('Konto erstellen'),
          backgroundColor: const Color(0x00ffffff),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Card(
            color: const Color(0x1fffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AccountTypeInputField(textController: _accountGroupTextController, errorText: _accountGroupErrorText),
                TextInputField(input: _accountName, inputCallback: _setAccountNameState, errorText: _accountNameErrorText, hintText: 'Name'),
                MoneyInputField(textController: _bankBalanceTextController, errorText: _bankBalanceErrorText, hintText: 'Kontostand', bottomSheetTitle: 'Kontostand eingeben:'),
                SaveButton(saveFunction: _createAccount, buttonController: _saveButtonController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
