import 'package:equatable/equatable.dart';

/// Action chosen on step 6 ("Choose Your Action").
///
/// [none] models "not yet chosen" so the state always has a value and we
/// never need a nullable field for the choice.
enum UrgeAction { none, breathing, immediate }

/// Phase of the breathing cycle on step 8.
///
/// Cycles inhale → hold → exhale at a fixed cadence; see [UrgeFlowCubit]
/// for the per-phase duration.
enum BreathingPhase { inhale, hold, exhale }

/// All ephemeral state for one pass through the 9-step urge-log flow.
///
/// Plain [Cubit]-backed state — does not persist across app launches.
/// On completion the relevant fields are folded into an [UrgeLogModel]
/// and handed to [UrgeLogCubit].
class UrgeFlowState extends Equatable {
  /// 1-indexed step the user is currently viewing (1..9).
  final int currentStep;

  /// Initial urge intensity from step 1 (1..10). Defaults to 5 so the
  /// gauge starts at a neutral midpoint.
  final int urgeRating;

  /// Selected trigger key (translation key) from the predefined list,
  /// or empty if a custom value was entered instead.
  final String selectedTrigger;

  /// User-typed custom trigger (when the predefined list isn't enough).
  /// Empty unless the user opened the custom-trigger input.
  final String customTrigger;

  /// Multi-select of feeling keys from step 3.
  final List<String> selectedFeelings;

  /// Optional notes from step 4 (capped at 300 chars by the UI).
  final String notes;

  /// Post-reflection rating from step 5 (1..10), or null if not yet rated.
  final int? urgeRatingAfter;

  /// Action picked on step 6.
  final UrgeAction actionChosen;

  /// Whether the breathing timer on step 8 is currently ticking.
  final bool breathingIsRunning;

  /// Seconds remaining in the current breathing phase (counts down 4 → 0).
  final int breathingPhaseRemaining;

  /// Total seconds elapsed in the breathing session (used for the outer
  /// ring progress and to detect session completion).
  final int breathingElapsedSeconds;

  /// Current phase of the breathing cycle.
  final BreathingPhase breathingPhase;

  const UrgeFlowState({
    this.currentStep = 1,
    this.urgeRating = 5,
    this.selectedTrigger = '',
    this.customTrigger = '',
    this.selectedFeelings = const [],
    this.notes = '',
    this.urgeRatingAfter,
    this.actionChosen = UrgeAction.none,
    this.breathingIsRunning = false,
    this.breathingPhaseRemaining = 4,
    this.breathingElapsedSeconds = 0,
    this.breathingPhase = BreathingPhase.inhale,
  });

  /// True when the initial rating crosses the "needs intervention" line.
  /// Used to decide whether step 7 (intervention) is shown after step 6.
  bool get isHighUrge => (urgeRatingAfter ?? urgeRating) >= 6;

  /// Resolves the trigger that should be saved with the entry, preferring
  /// any custom text the user typed.
  String get effectiveTrigger =>
      customTrigger.trim().isNotEmpty ? customTrigger.trim() : selectedTrigger;

  /// Step 1 always advances. Step 2 needs a trigger. Step 3 needs at
  /// least one feeling. Step 4 is optional. Step 5 needs a post-rating.
  /// Step 6 needs an action. Subsequent steps gate themselves via their
  /// own buttons, so they always pass here.
  bool canAdvance() {
    switch (currentStep) {
      case 2:
        return effectiveTrigger.isNotEmpty;
      case 3:
        return selectedFeelings.isNotEmpty;
      case 5:
        return urgeRatingAfter != null;
      case 6:
        return actionChosen != UrgeAction.none;
      default:
        return true;
    }
  }

  UrgeFlowState copyWith({
    int? currentStep,
    int? urgeRating,
    String? selectedTrigger,
    String? customTrigger,
    List<String>? selectedFeelings,
    String? notes,
    int? urgeRatingAfter,
    bool clearUrgeRatingAfter = false,
    UrgeAction? actionChosen,
    bool? breathingIsRunning,
    int? breathingPhaseRemaining,
    int? breathingElapsedSeconds,
    BreathingPhase? breathingPhase,
  }) {
    return UrgeFlowState(
      currentStep: currentStep ?? this.currentStep,
      urgeRating: urgeRating ?? this.urgeRating,
      selectedTrigger: selectedTrigger ?? this.selectedTrigger,
      customTrigger: customTrigger ?? this.customTrigger,
      selectedFeelings: selectedFeelings ?? this.selectedFeelings,
      notes: notes ?? this.notes,
      urgeRatingAfter:
          clearUrgeRatingAfter ? null : (urgeRatingAfter ?? this.urgeRatingAfter),
      actionChosen: actionChosen ?? this.actionChosen,
      breathingIsRunning: breathingIsRunning ?? this.breathingIsRunning,
      breathingPhaseRemaining:
          breathingPhaseRemaining ?? this.breathingPhaseRemaining,
      breathingElapsedSeconds:
          breathingElapsedSeconds ?? this.breathingElapsedSeconds,
      breathingPhase: breathingPhase ?? this.breathingPhase,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        urgeRating,
        selectedTrigger,
        customTrigger,
        selectedFeelings,
        notes,
        urgeRatingAfter,
        actionChosen,
        breathingIsRunning,
        breathingPhaseRemaining,
        breathingElapsedSeconds,
        breathingPhase,
      ];
}
