part of 'create_or_edit_booking_screen_bloc.dart';

abstract class CreateOrEditBookingState {}

class CreateOrEditBookingInitialState extends CreateOrEditBookingState {}

class CreateOrEditBookingLoadingState extends CreateOrEditBookingState {}

class CreateOrEditBookingSuccessState extends CreateOrEditBookingState {
  final BuildContext context;
  CreateOrEditBookingSuccessState(this.context) {
    Timer(const Duration(milliseconds: transitionInMs), () {
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
    });
  }
}

class CreateOrEditBookingFailureState extends CreateOrEditBookingState {}
