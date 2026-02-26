import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {    
  OnboardingCubit() : super(1);

  void selectOption(int index) => emit(index);
}