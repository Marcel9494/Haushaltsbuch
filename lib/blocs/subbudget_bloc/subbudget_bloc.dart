import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'subbudget_event.dart';
part 'subbudget_state.dart';

class SubbudgetBloc extends Bloc<SubbudgetEvent, SubbudgetState> {
  SubbudgetBloc() : super(SubbudgetInitial()) {
    on<SubbudgetEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
