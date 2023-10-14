part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitialState extends BookingState {}

class BookingLoadingState extends BookingState {}

class BookingSuccessState extends BookingState {
  final BuildContext context;
  BookingSuccessState(this.context) {
    Timer(const Duration(milliseconds: transitionInMs), () {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
    });
  }
}

class BookingFailureState extends BookingState {}

class BookingInitial extends BookingState {}
