import '../enums/serie_edit_modes.dart';

class CreateOrEditBookingScreenArguments {
  final int bookingBoxIndex;
  final SerieEditModeType serieEditMode;

  CreateOrEditBookingScreenArguments(
    this.bookingBoxIndex,
    this.serieEditMode,
  );
}
