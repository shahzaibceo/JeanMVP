import 'package:attention_anchor/common/common_widget/custom_button.dart';
import 'package:attention_anchor/common/common_widget/custom_conrtainer.dart';
import 'package:attention_anchor/common/common_widget/custom_snackbar_widget.dart';
import 'package:attention_anchor/common/common_widget/custom_text.dart';
import 'package:attention_anchor/common/common_widget/main_background.dart';
import 'package:attention_anchor/common/extensions/gesture_detector.dart';
import 'package:attention_anchor/common/extensions/sized_box.dart';
import 'package:attention_anchor/common/utils/responsive_helper/responsive_helper.dart';
import 'package:attention_anchor/feature/bottom_nav/cubit/bottom_cubit.dart';
import 'package:attention_anchor/feature/localization/translation/app_translation.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_cubit.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/feature/urge_log/cubit/urge_log_cubit.dart';
import 'package:attention_anchor/feature/urge_log/widget/step_indicator_widget.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/back_to_you_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/breathing_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/choose_action_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/feelings_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/immediate_action_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/intervention_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/log_urge_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/notes_step.dart';
import 'package:attention_anchor/feature/urge_log/widget/steps/select_trigger_step.dart';
import 'package:attention_anchor/theme/app_colors.dart';
import 'package:attention_anchor/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the 9-step urge logging flow.
///
/// The screen is self-contained: it provides its own [UrgeLogCubit]
/// (so persisted history works even if `main.dart` doesn't register one
/// globally) and a route-scoped [UrgeFlowCubit] (so the session resets
/// every time the user opens the screen). Decoupling means the
/// [UrgeFlowCubit] no longer needs to look up [UrgeLogCubit] at
/// construction — the leaf widgets do that at button-tap time.
///
/// The screen itself is a thin shell: an app bar, the step indicator,
/// the active step's content (provided by the appropriate `*_step.dart`
/// widget), and a sticky Next / Complete button.
class UrgeLogScreen extends StatelessWidget {
  const UrgeLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // UrgeLogCubit is also registered locally so the screen works
        // even if a global registration is missing or hasn't been
        // hot-restarted in. If a global one exists this local one
        // shadows it within this subtree — both share the same
        // HydratedBloc storage so entries persist either way.
        BlocProvider(create: (_) => UrgeLogCubit()),
        BlocProvider(create: (_) => UrgeFlowCubit()),
      ],
      child: const _UrgeLogView(),
    );
  }
}

class _UrgeLogView extends StatelessWidget {
  const _UrgeLogView();

  /// Resolves the title displayed in the app bar for each step.
  String _titleKey(int step) {
    switch (step) {
      case 1:
        return 'log_urge_title';
      case 2:
        return 'select_trigger_title';
      case 3:
        return 'feelings_title';
      case 4:
        return 'notes_title';
      case 5:
        return 'back_to_you_title';
      case 6:
        return 'choose_action_title';
      case 7:
        return 'intervention_title';
      case 8:
        return 'breathing_title';
      case 9:
        return 'immediate_title';
      default:
        return 'log_urge_title';
    }
  }

  /// Returns the step body widget for the current step.
  Widget _stepBody(int step, ThemeCubit themeCubit) {
    switch (step) {
      case 1:
        return LogUrgeStep(themeCubit: themeCubit);
      case 2:
        return SelectTriggerStep(themeCubit: themeCubit);
      case 3:
        return FeelingsStep(themeCubit: themeCubit);
      case 4:
        return NotesStep(themeCubit: themeCubit);
      case 5:
        return BackToYouStep(themeCubit: themeCubit);
      case 6:
        return ChooseActionStep(themeCubit: themeCubit);
      case 7:
        return InterventionStep(themeCubit: themeCubit);
      case 8:
        return BreathingStep(themeCubit: themeCubit);
      case 9:
        return ImmediateActionStep(themeCubit: themeCubit);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Validation gate that prevents Next when the current step's
  /// requirement is unmet, surfacing a snackbar with a per-step hint.
  void _onNextPressed(BuildContext context) {
    final cubit = context.read<UrgeFlowCubit>();
    final state = cubit.state;
    if (!state.canAdvance()) {
      CustomSnackBar.show(context, message: _validationMsg(state).tr());
      return;
    }
    cubit.nextStep();
  }

  String _validationMsg(UrgeFlowState s) {
    switch (s.currentStep) {
      case 2:
        return 'select_trigger_validation';
      case 3:
        return 'select_feeling_validation';
      case 5:
        return 'rate_again_validation';
      case 6:
        return 'choose_action_validation';
      default:
        return 'select_trigger_validation';
    }
  }

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    final themeCubit = context.watch<ThemeCubit>();

    return BlocBuilder<UrgeFlowCubit, UrgeFlowState>(
      buildWhen: (a, b) =>
          a.currentStep != b.currentStep ||
          a.actionChosen != b.actionChosen ||
          a.breathingElapsedSeconds != b.breathingElapsedSeconds,
      builder: (context, state) {
        final isFirstStep = state.currentStep == 1;
        final isTerminalStep = state.currentStep == 8 || state.currentStep == 9;

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            if (isFirstStep) {
              context.read<UrgeFlowCubit>().reset();
              context.read<BottomBarCubit>().changeTab(0);
            } else {
              context.read<UrgeFlowCubit>().previousStep();
            }
          },
          child: MainBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    isFirstStep: isFirstStep,
                    currentStep: state.currentStep,
                    titleKey: _titleKey(state.currentStep),
                    themeCubit: themeCubit,
                    onBack: () {
                      if (isFirstStep) {
                        context.read<UrgeFlowCubit>().reset();
                        context.read<BottomBarCubit>().changeTab(0);
                      } else {
                        context.read<UrgeFlowCubit>().previousStep();
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: resp.wp(16)),
                    child: StepIndicatorWidget(
                      currentStep: state.currentStep,
                      themeCubit: themeCubit,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        resp.wp(16),
                        resp.hp(8),
                        resp.wp(16),
                        resp.hp(20),
                      ),
                      child: _stepBody(state.currentStep, themeCubit),
                    ),
                  ),
                  // Step 8 and 9 manage their own bottom CTA (Pause /
                  // Complete Log) and intervention has its own pair of
                  // CTAs, so the sticky Next button is hidden there.
                  if (!isTerminalStep && state.currentStep != 7)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        resp.wp(16),
                        0,
                        resp.wp(16),
                        resp.hp(16),
                      ),
                      child: CustomButton(
                        text: 'next'.tr(),
                        onTap: () => _onNextPressed(context),
                        borderRadius: resp.radius(14),
                        height: resp.hp(52),
                        textSize: resp.fontSize(16),
                      ),
                    ),

                    15.sbh(context),                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Title row with back chevron, screen title, and per-step subtitle ("Step X of 9").
class _TopBar extends StatelessWidget {
  final bool isFirstStep;
  final int currentStep;
  final String titleKey;
  final ThemeCubit themeCubit;
  final VoidCallback onBack;

  const _TopBar({
    required this.isFirstStep,
    required this.currentStep,
    required this.titleKey,
    required this.themeCubit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final resp = ResponsiveHelper(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(resp.wp(10), resp.hp(8), resp.wp(10), resp.hp(8)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CustomContainer(
              width: resp.wp(44),
              height: resp.wp(44),
              borderRadius: resp.radius(12),
              color: AppColors.primary.withValues(alpha: 0.15),
              alignment: Alignment.center,
              child: Icon(
                Icons.chevron_left,
                color: themeCubit.textColor,
                size: resp.fontSize(24),
              ),
            ).onTap(onBack),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: titleKey.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: themeCubit.textColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
