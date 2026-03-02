import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends HydratedCubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void selectOption(int index) => emit(state.copyWith(selectedOption: index));

  void completeOnboarding() => emit(state.copyWith(isCompleted: true));

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) => OnboardingState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(OnboardingState state) => state.toJson();
}