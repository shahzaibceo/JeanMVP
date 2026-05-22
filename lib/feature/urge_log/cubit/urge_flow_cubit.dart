import 'dart:async';

import 'package:attention_anchor/feature/urge_log/cubit/urge_flow_state.dart';
import 'package:attention_anchor/feature/urge_log/model/urge_log_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives one pass through the 9-step urge-log flow.
///
/// Held only for the lifetime of the [UrgeLogScreen] route. Cleaning up
/// the breathing [Timer] is the only resource concern — handled in
/// [close]. The cubit is deliberately small: navigation, form mutators,
/// and a breathing tick loop. It has no dependency on persistence —
/// the host screen reads [buildLogEntry] at completion time and hands
/// the resulting [UrgeLogModel] to whichever [UrgeLogCubit] is in scope.
class UrgeFlowCubit extends Cubit<UrgeFlowState> {
  UrgeFlowCubit() : super(const UrgeFlowState());

  /// Total seconds for one breathing session on step 8.
  /// 120s ÷ 12s per cycle = 10 inhale/hold/exhale cycles.
  static const int breathingTotalSeconds = 120;

  /// Seconds per phase (inhale/hold/exhale).
  static const int breathingPhaseSeconds = 4;

  Timer? _breathingTicker;

  // ───────────────────────── Navigation ─────────────────────────

  /// Advance to the next logical step.
  ///
  /// Step 6 branches on the chosen action and (for high urges) routes
  /// through the intervention screen. Step 7 routes based on the action
  /// the user chose on step 6.
  void nextStep() {
    final s = state;
    if (!s.canAdvance()) return;

    int next;
    switch (s.currentStep) {
      case 6:
        // High urge always sees the intervention. Otherwise jump
        // straight to the action-specific screen.
        if (s.isHighUrge) {
          next = 7;
        } else if (s.actionChosen == UrgeAction.breathing) {
          next = 8;
        } else {
          next = 9;
        }
        break;
      case 7:
        // After the intervention, honour the user's earlier choice.
        next = s.actionChosen == UrgeAction.immediate ? 9 : 8;
        break;
      default:
        next = s.currentStep + 1;
    }
    if (next > 9) return;
    emit(s.copyWith(currentStep: next));
  }

  /// Go back one step. Mirrors [nextStep]'s branching so back-navigation
  /// reverses the same path the user took forward.
  void previousStep() {
    final s = state;
    int prev;
    switch (s.currentStep) {
      case 9:
      case 8:
        // Came from 7 if high urge, otherwise from 6.
        prev = s.isHighUrge ? 7 : 6;
        break;
      case 7:
        prev = 6;
        break;
      default:
        prev = s.currentStep - 1;
    }
    if (prev < 1) return;
    _stopBreathing();
    emit(s.copyWith(currentStep: prev));
  }

  // ─────────────────────── Form mutators ───────────────────────

  void setUrgeRating(int rating) =>
      emit(state.copyWith(urgeRating: rating.clamp(1, 10)));

  void selectTrigger(String triggerKey) =>
      emit(state.copyWith(selectedTrigger: triggerKey, customTrigger: ''));

  void setCustomTrigger(String text) =>
      emit(state.copyWith(customTrigger: text, selectedTrigger: ''));

  /// Toggle a feeling on/off in [UrgeFlowState.selectedFeelings].
  void toggleFeeling(String feelingKey) {
    final feelings = List<String>.from(state.selectedFeelings);
    feelings.contains(feelingKey)
        ? feelings.remove(feelingKey)
        : feelings.add(feelingKey);
    emit(state.copyWith(selectedFeelings: feelings));
  }

  void setNotes(String text) => emit(state.copyWith(notes: text));

  void setUrgeRatingAfter(int rating) =>
      emit(state.copyWith(urgeRatingAfter: rating.clamp(1, 10)));

  void selectAction(UrgeAction action) =>
      emit(state.copyWith(actionChosen: action));

  // ───────────────────── Breathing timer ─────────────────────

  /// Start (or resume) the breathing session. Idempotent: calling while
  /// already running is a no-op.
  void startBreathing() {
    if (state.breathingIsRunning) return;
    emit(state.copyWith(breathingIsRunning: true));
    _breathingTicker?.cancel();
    _breathingTicker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Pause the timer without resetting progress. Resume by calling
  /// [startBreathing] again.
  void pauseBreathing() {
    _breathingTicker?.cancel();
    _breathingTicker = null;
    emit(state.copyWith(breathingIsRunning: false));
  }

  /// Reset to the start of the inhale phase with elapsed=0.
  void resetBreathing() {
    _stopBreathing();
    emit(state.copyWith(
      breathingElapsedSeconds: 0,
      breathingPhaseRemaining: breathingPhaseSeconds,
      breathingPhase: BreathingPhase.inhale,
    ));
  }

  void _stopBreathing() {
    _breathingTicker?.cancel();
    _breathingTicker = null;
    if (state.breathingIsRunning) {
      emit(state.copyWith(breathingIsRunning: false));
    }
  }

  /// Advance the breathing state by one second.
  ///
  /// Decrements the per-phase countdown; on zero, rotates to the next
  /// phase. Terminates the session when total elapsed reaches
  /// [breathingTotalSeconds].
  void _tick() {
    final s = state;
    final newElapsed = s.breathingElapsedSeconds + 1;

    if (newElapsed >= breathingTotalSeconds) {
      _stopBreathing();
      emit(s.copyWith(
        breathingElapsedSeconds: breathingTotalSeconds,
        breathingPhaseRemaining: 0,
      ));
      return;
    }

    final remaining = s.breathingPhaseRemaining - 1;
    if (remaining > 0) {
      emit(s.copyWith(
        breathingPhaseRemaining: remaining,
        breathingElapsedSeconds: newElapsed,
      ));
      return;
    }

    // Phase finished — rotate inhale → hold → exhale → inhale ...
    final nextPhase = BreathingPhase
        .values[(s.breathingPhase.index + 1) % BreathingPhase.values.length];
    emit(s.copyWith(
      breathingPhase: nextPhase,
      breathingPhaseRemaining: breathingPhaseSeconds,
      breathingElapsedSeconds: newElapsed,
    ));
  }

  // ──────────────────────── Completion ────────────────────────

  /// Build an [UrgeLogModel] snapshot from the current state.
  ///
  /// Pure — does not persist. The host screen reads this at the
  /// "Complete Log" tap and hands the model to whichever [UrgeLogCubit]
  /// is in the surrounding tree. Decoupling persistence from this
  /// cubit means the flow can be tested without a storage layer and
  /// avoids parent-lookup issues at construction time.
  UrgeLogModel buildLogEntry() {
    final s = state;
    return UrgeLogModel(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      urgeRating: s.urgeRating,
      trigger: s.effectiveTrigger,
      feelings: s.selectedFeelings,
      notes: s.notes,
      urgeRatingAfter: s.urgeRatingAfter,
      actionChosen: s.actionChosen.name,
    );
  }

  /// Stop the breathing ticker on the way out of the flow.
  void stopBreathingIfNeeded() => _stopBreathing();

  /// Reset the entire state to the initial state.
  void reset() {
    _stopBreathing();
    emit(const UrgeFlowState());
  }

  @override
  Future<void> close() {
    _breathingTicker?.cancel();
    return super.close();
  }
}
