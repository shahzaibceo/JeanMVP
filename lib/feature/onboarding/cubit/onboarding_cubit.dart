import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends HydratedCubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void selectOption(int index) => emit(state.copyWith(selectedOption: index));

  void completeOnboarding() => emit(state.copyWith(isCompleted: true));

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    final state = OnboardingState.fromJson(json);
    return state.copyWith(selectedOption: 0);
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) => state.toJson();
}