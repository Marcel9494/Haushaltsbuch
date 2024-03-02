import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../button_blocs/transaction_stats_toggle_buttons_bloc/transaction_stats_toggle_buttons_cubit.dart';
import '../input_field_blocs/date_input_field_bloc/date_input_field_cubit.dart';
import '../input_field_blocs/account_input_field_bloc/from_account_input_field_cubit.dart';
import '../input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import '../input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import '../input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';
import '../input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import '../input_field_blocs/account_input_field_bloc/to_account_input_field_cubit.dart';

import '/models/enums/repeat_types.dart';
import '/models/booking/booking_model.dart';
import '/models/enums/serie_edit_modes.dart';
import '/models/enums/transaction_types.dart';
import '/models/booking/booking_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';
import '/utils/consts/global_consts.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvents, BookingState> {
  BookingRepository bookingRepository = BookingRepository();
  late Booking savedBooking = Booking();

  BookingBloc() : super(BookingInitialState()) {
    on<CreateOrLoadBookingEvent>((event, emit) async {
      emit(BookingLoadingState());
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

      if (event.bookingBoxIndex != -1) {
        Booking loadedBooking = await bookingRepository.load(event.bookingBoxIndex);
        transactionStatsToggleButtonsCubit.updateTransactionType(loadedBooking.transactionType);
        dateInputFieldCubit.updateBookingDate(loadedBooking.date);
        dateInputFieldCubit.updateBookingRepeat(loadedBooking.bookingRepeats);
        titleInputFieldCubit.updateValue(loadedBooking.title);
        moneyInputFieldCubit.updateAmount(loadedBooking.amount);
        moneyInputFieldCubit.updateAmountType(loadedBooking.amountType);
        categorieInputFieldCubit.updateValue(loadedBooking.categorie);
        fromAccountInputFieldCubit.updateValue(loadedBooking.fromAccount);
        toAccountInputFieldCubit.updateValue(loadedBooking.toAccount);
        subcategorieInputFieldCubit.updateValue(loadedBooking.subcategorie);

        // Alte Buchungswerte speichern, damit bereits gebuchte Buchungen rückgängig gemacht werden können.
        savedBooking.boxIndex = event.bookingBoxIndex;
        savedBooking.title = loadedBooking.title;
        savedBooking.transactionType = loadedBooking.transactionType;
        savedBooking.bookingRepeats = loadedBooking.bookingRepeats;
        savedBooking.date = loadedBooking.date;
        savedBooking.fromAccount = loadedBooking.fromAccount;
        savedBooking.toAccount = loadedBooking.toAccount;
        savedBooking.categorie = loadedBooking.categorie;
        savedBooking.subcategorie = loadedBooking.subcategorie;
        savedBooking.amount = loadedBooking.amount;
        savedBooking.amountType = loadedBooking.amountType;
        savedBooking.booked = loadedBooking.booked;
        savedBooking.serieId = loadedBooking.serieId;
      }
      Navigator.pushNamed(event.context, createOrEditBookingRoute);
      emit(BookingLoadedState(event.context, event.bookingBoxIndex, event.serieEditModeType));
    });

    on<CreateOrUpdateBookingEvent>((event, emit) async {
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
          ..amountType = moneyInputFieldCubit.state.amountType
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
      } else {
        Booking oldBooking = Booking()
          ..boxIndex = savedBooking.boxIndex
          ..transactionType = savedBooking.transactionType
          ..bookingRepeats = savedBooking.bookingRepeats
          ..title = savedBooking.title
          ..date = savedBooking.date
          ..amount = savedBooking.amount
          ..amountType = savedBooking.amountType
          ..categorie = savedBooking.categorie
          ..subcategorie = savedBooking.subcategorie
          ..fromAccount = savedBooking.fromAccount
          ..toAccount = savedBooking.toAccount
          ..serieId = savedBooking.serieId
          ..booked = savedBooking.booked;
        Booking updatedBooking = Booking()
          ..boxIndex = savedBooking.boxIndex
          ..transactionType = transactionStatsToggleButtonsCubit.state.transactionName
          ..bookingRepeats = dateInputFieldCubit.state.bookingRepeat
          ..title = titleInputFieldCubit.state.text
          ..date = dateInputFieldCubit.state.bookingDate
          ..amount = moneyInputFieldCubit.state.amount
          ..amountType = moneyInputFieldCubit.state.amountType
          ..categorie = categorieInputFieldCubit.state.categorie
          ..subcategorie = subcategorieInputFieldCubit.state
          ..fromAccount = fromAccountInputFieldCubit.state.fromAccount
          ..toAccount = toAccountInputFieldCubit.state.toAccount
          ..serieId = savedBooking.serieId
          ..booked = DateTime.parse(dateInputFieldCubit.state.bookingDate).isAfter(DateTime.now()) ? false : true;
        if (event.serieEditModeType == SerieEditModeType.none || event.serieEditModeType == SerieEditModeType.single) {
          bookingRepository.updateSingle(updatedBooking, oldBooking, event.bookingBoxIndex);
        } else if (event.serieEditModeType == SerieEditModeType.onlyFuture) {
          bookingRepository.updateOnlyFutureBookingsFromSerie(updatedBooking, oldBooking, event.bookingBoxIndex);
        } else if (event.serieEditModeType == SerieEditModeType.all) {
          bookingRepository.updateAllBookingsFromSerie(updatedBooking, oldBooking, event.bookingBoxIndex);
        }
      }
      event.saveButtonController.success();
      await Future.delayed(const Duration(milliseconds: transitionInMs));
      Navigator.pop(event.context);
      Navigator.popAndPushNamed(event.context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
    });

    on<DeleteBookingEvent>((event, emit) async {
      if (event.serieEditMode == SerieEditModeType.none || event.serieEditMode == SerieEditModeType.single) {
        bookingRepository.deleteSingle(event.bookingBoxIndex);
      } else if (event.serieEditMode == SerieEditModeType.onlyFuture) {
        Booking booking = await bookingRepository.load(event.bookingBoxIndex);
        bookingRepository.deleteOnlyFutureBookingsFromSerie(booking, event.bookingBoxIndex);
      } else if (event.serieEditMode == SerieEditModeType.all) {
        Booking booking = await bookingRepository.load(event.bookingBoxIndex);
        bookingRepository.deleteAllBookingsFromSerie(booking, event.bookingBoxIndex);
      }
    });
  }
}
