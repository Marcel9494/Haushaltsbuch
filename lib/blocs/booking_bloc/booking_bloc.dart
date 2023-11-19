import 'dart:async';

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/blocs/input_fields_bloc/date_input_field_cubit.dart';

import '../button_bloc/transaction_stats_toggle_buttons_cubit.dart';
import '../input_fields_bloc/from_account_input_field_cubit.dart';
import '../input_fields_bloc/categorie_input_field_cubit.dart';
import '../input_fields_bloc/money_input_field_cubit.dart';
import '../input_fields_bloc/subcategorie_input_field_cubit.dart';
import '../input_fields_bloc/text_input_field_cubit.dart';
import '../input_fields_bloc/to_account_input_field_cubit.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

import '/models/enums/repeat_types.dart';
import '/models/booking/booking_model.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/booking/booking_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_cubit.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvents, BookingState> {
  BookingRepository bookingRepository = BookingRepository();
  late Booking savedBooking = Booking();

  BookingBloc() : super(BookingInitialState()) {
    on<CreateOrLoadBookingEvent>((event, emit) async {
      emit(BookingLoadingState(event.bookingBoxIndex));
      TransactionStatsToggleButtonsCubit transactionStatsToggleButtonsCubit = BlocProvider.of<TransactionStatsToggleButtonsCubit>(event.context);
      DateInputFieldCubit dateInputFieldCubit = BlocProvider.of<DateInputFieldCubit>(event.context);
      TextInputFieldCubit titleInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
      MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
      CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
      FromAccountInputFieldCubit fromAccountInputFieldCubit = BlocProvider.of<FromAccountInputFieldCubit>(event.context);
      ToAccountInputFieldCubit toAccountInputFieldCubit = BlocProvider.of<ToAccountInputFieldCubit>(event.context);
      SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);

      transactionStatsToggleButtonsCubit.initTransaction();
      dateInputFieldCubit.resetValue();
      titleInputFieldCubit.resetValue();
      moneyInputFieldCubit.resetValue();
      categorieInputFieldCubit.resetValue();
      fromAccountInputFieldCubit.resetValue();
      toAccountInputFieldCubit.resetValue();
      subcategorieInputFieldCubit.resetValue();

      if (event.bookingBoxIndex == -1) {
        Navigator.pushNamed(event.context, createOrEditBookingRoute);
        emit(BookingSuccessState(event.context, event.bookingBoxIndex, '', () => {}));
      } else {
        try {
          Booking booking = await bookingRepository.load(event.bookingBoxIndex);
          transactionStatsToggleButtonsCubit.updateTransactionType(booking.transactionType);
          dateInputFieldCubit.updateBookingDate(booking.date);
          dateInputFieldCubit.updateBookingRepeat(booking.bookingRepeats);
          titleInputFieldCubit.updateValue(booking.title);
          moneyInputFieldCubit.updateValue(booking.amount);
          categorieInputFieldCubit.updateValue(booking.categorie);
          fromAccountInputFieldCubit.updateValue(booking.fromAccount);
          toAccountInputFieldCubit.updateValue(booking.toAccount);
          subcategorieInputFieldCubit.updateValue(booking.subcategorie);

          savedBooking.boxIndex = booking.boxIndex;
          savedBooking.title = booking.title;
          savedBooking.transactionType = booking.transactionType;
          savedBooking.bookingRepeats = booking.bookingRepeats;
          savedBooking.date = booking.date;
          savedBooking.fromAccount = booking.fromAccount;
          savedBooking.toAccount = booking.toAccount;
          savedBooking.categorie = booking.categorie;
          savedBooking.subcategorie = booking.subcategorie;
          savedBooking.amount = booking.amount;
          savedBooking.booked = booking.booked;
          savedBooking.serieId = booking.serieId;
          emit(BookingSuccessState(event.context, event.bookingBoxIndex, '', () => {}));
        } catch (error) {
          //emit(BookingFailureState());
        } finally {
          Navigator.pushNamed(event.context, createOrEditBookingRoute);
        }
      }
      /*try {
        if (event.booking.bookingRepeats == RepeatType.noRepetition.name) {
          bookingRepository.create(event.booking);
        } else {
          bookingRepository.createSerie(event.booking);
          GlobalStateRepository globalStateRepository = GlobalStateRepository();
          globalStateRepository.increaseBookingSerieIndex();
        }
        emit(BookingSuccessState(event.context));
      } catch (error) {
        emit(BookingFailureState());
      }*/
    });

    on<CreateOrUpdateBookingEvent>((event, emit) async {
      try {
        TransactionStatsToggleButtonsCubit transactionStatsToggleButtonsCubit = BlocProvider.of<TransactionStatsToggleButtonsCubit>(event.context);
        DateInputFieldCubit dateInputFieldCubit = BlocProvider.of<DateInputFieldCubit>(event.context);
        TextInputFieldCubit titleInputFieldCubit = BlocProvider.of<TextInputFieldCubit>(event.context);
        MoneyInputFieldCubit moneyInputFieldCubit = BlocProvider.of<MoneyInputFieldCubit>(event.context);
        CategorieInputFieldCubit categorieInputFieldCubit = BlocProvider.of<CategorieInputFieldCubit>(event.context);
        FromAccountInputFieldCubit fromAccountInputFieldCubit = BlocProvider.of<FromAccountInputFieldCubit>(event.context);
        ToAccountInputFieldCubit toAccountInputFieldCubit = BlocProvider.of<ToAccountInputFieldCubit>(event.context);
        SubcategorieInputFieldCubit subcategorieInputFieldCubit = BlocProvider.of<SubcategorieInputFieldCubit>(event.context);
        if ((transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.income.name ||
            transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.outcome.name)) {
          if (titleInputFieldCubit.validateValue(titleInputFieldCubit.state.text) == false ||
              moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false ||
              fromAccountInputFieldCubit.validateValue(fromAccountInputFieldCubit.state.fromAccount) == false ||
              categorieInputFieldCubit.validateValue(categorieInputFieldCubit.state.categorie) == false) {
            event.saveButtonController.error();
            Timer(const Duration(milliseconds: transitionInMs), () {
              event.saveButtonController.reset();
            });
            return;
          }
        } else if (transactionStatsToggleButtonsCubit.state.transactionName == TransactionType.transfer.name) {
          if (titleInputFieldCubit.validateValue(titleInputFieldCubit.state.text) == false ||
              moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false ||
              fromAccountInputFieldCubit.validateValue(fromAccountInputFieldCubit.state.fromAccount) == false ||
              toAccountInputFieldCubit.validateValue(toAccountInputFieldCubit.state.toAccount) == false) {
            event.saveButtonController.error();
            Timer(const Duration(milliseconds: transitionInMs), () {
              event.saveButtonController.reset();
            });
            return;
          }
        } else {
          if (titleInputFieldCubit.validateValue(titleInputFieldCubit.state.text) == false ||
              moneyInputFieldCubit.validateValue(moneyInputFieldCubit.state.amount) == false ||
              fromAccountInputFieldCubit.validateValue(fromAccountInputFieldCubit.state.fromAccount) == false ||
              toAccountInputFieldCubit.validateValue(toAccountInputFieldCubit.state.toAccount) == false ||
              categorieInputFieldCubit.validateValue(categorieInputFieldCubit.state.categorie) == false) {
            event.saveButtonController.error();
            Timer(const Duration(milliseconds: transitionInMs), () {
              event.saveButtonController.reset();
            });
            return;
          }
        }
        if (event.bookingBoxIndex == -1) {
          GlobalStateRepository globalStateRepository = GlobalStateRepository();
          Booking newBooking = Booking()
            ..transactionType = transactionStatsToggleButtonsCubit.state.transactionName
            ..bookingRepeats = dateInputFieldCubit.state.bookingRepeat
            ..title = titleInputFieldCubit.state.text
            ..date = dateInputFieldCubit.state.bookingDate
            ..amount = moneyInputFieldCubit.state.amount
            ..categorie = categorieInputFieldCubit.state.categorie
            ..subcategorie = subcategorieInputFieldCubit.state
            ..fromAccount = fromAccountInputFieldCubit.state.fromAccount
            ..toAccount = toAccountInputFieldCubit.state.toAccount
            ..serieId = dateInputFieldCubit.state.bookingRepeat == RepeatType.noRepetition.name ? -1 : await globalStateRepository.getBookingSerieIndex()
            ..booked = DateTime.parse(dateInputFieldCubit.state.bookingDate).isAfter(DateTime.now()) ? false : true;
          if (dateInputFieldCubit.state.bookingRepeat == RepeatType.noRepetition.name) {
            bookingRepository.create(newBooking);
          } else {
            bookingRepository.createSerie(newBooking);
            globalStateRepository.increaseBookingSerieIndex();
          }
          event.saveButtonController.success();
          await Future.delayed(const Duration(milliseconds: transitionInMs));
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
        } else {
          Booking oldBooking = Booking()
            ..boxIndex = savedBooking.boxIndex
            ..transactionType = savedBooking.transactionType
            ..bookingRepeats = savedBooking.bookingRepeats
            ..title = savedBooking.title
            ..date = savedBooking.date
            ..amount = savedBooking.amount
            ..categorie = savedBooking.categorie
            ..subcategorie = savedBooking.subcategorie
            ..fromAccount = savedBooking.fromAccount
            ..toAccount = savedBooking.toAccount
            ..serieId = savedBooking.serieId // TODO -1 dynamisch machen. Alter Code: boxIndex == -1 ? -1 : _loadedBooking.serieId
            ..booked = savedBooking.booked; // DateTime.parse(dateInputFieldCubit.state.bookingDate).isAfter(DateTime.now()) ? false : true;
          Booking booking = Booking()
            ..transactionType = transactionStatsToggleButtonsCubit.state.transactionName
            ..bookingRepeats = dateInputFieldCubit.state.bookingRepeat
            ..title = titleInputFieldCubit.state.text
            ..date = dateInputFieldCubit.state.bookingDate
            ..amount = moneyInputFieldCubit.state.amount
            ..categorie = categorieInputFieldCubit.state.categorie
            ..subcategorie = subcategorieInputFieldCubit.state
            ..fromAccount = fromAccountInputFieldCubit.state.fromAccount
            ..toAccount = toAccountInputFieldCubit.state.toAccount
            ..serieId = -1 // TODO -1 dynamisch machen. Alter Code: boxIndex == -1 ? -1 : _loadedBooking.serieId
            ..booked = DateTime.parse(dateInputFieldCubit.state.bookingDate).isAfter(DateTime.now()) ? false : true;
          bookingRepository.update(booking, oldBooking, event.bookingBoxIndex, SerieEditModeType.single); // TODO SerieEditModeType dynamisch machen
          event.saveButtonController.success();
          await Future.delayed(const Duration(milliseconds: transitionInMs));
          Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
        }
      } catch (error) {
        print(error);
      }
    });

    on<LoadBookingEvent>((event, emit) async {
      BlocProvider.of<BookingCubit>(event.context).loadExistingBooking(event.bookingBoxIndex);
      Navigator.pushNamed(event.context, createOrEditBookingRoute);
    });

    on<DeleteBookingEvent>((event, emit) async {
      void _yesPressed(int index) async {
        if (event.serieEditMode == SerieEditModeType.none) {
          bookingRepository.delete(event.bookingBoxIndex);
        } else {
          Booking booking = await bookingRepository.load(event.bookingBoxIndex);
          bookingRepository.deleteSerieBookings(booking, event.bookingBoxIndex, event.serieEditMode);
        }
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
        FocusScope.of(event.context).unfocus();
      }

      showDialog(
        context: event.context,
        builder: (context) {
          return AlertDialog(
            title: Text(event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single ? 'Buchung löschen?' : 'Buchungen löschen?'),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.cyanAccent,
                ),
                onPressed: () => {
                  _yesPressed(event.bookingBoxIndex),
                  Flushbar(
                    title:
                        event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single ? 'Buchung wurde gelöscht' : 'Buchungen wurden gelöscht',
                    message: event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single
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
    });
  }
}
