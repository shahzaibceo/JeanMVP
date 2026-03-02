import 'package:flutter_bloc/flutter_bloc.dart';

class SetupProgressState {
  final int step;
  const SetupProgressState(this.step);
}

class SetupProgressCubit extends Cubit<SetupProgressState> {
  SetupProgressCubit() : super(const SetupProgressState(1));

  static const totalSteps = 3;

  void next() {
    if (state.step < totalSteps) {
      emit(SetupProgressState(state.step + 1));
    }
  }

  void previous() {
    if (state.step > 1) {
      emit(SetupProgressState(state.step - 1));
    }
  }

  void setStep(int step) {
    if (step >= 1 && step <= totalSteps) {
      emit(SetupProgressState(step));
    }
  }
}