import 'package:attention_anchor/feature/urge_log/cubit/urge_log_state.dart';
import 'package:attention_anchor/feature/urge_log/model/urge_log_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Owns the persisted list of urge logs.
///
/// Mirrors the [HabitCubit] pattern: a [HydratedCubit] with a minimal,
/// list-shaped state and small, intention-revealing mutators. Ephemeral
/// per-session state (current step, draft values, breathing timer) lives
/// in [UrgeFlowCubit] so this class never juggles two lifetimes.
class UrgeLogCubit extends HydratedCubit<UrgeLogState> {
  UrgeLogCubit() : super(const UrgeLogState());

  /// Append a completed log. Newest entries land at the front so history
  /// screens can render them in reverse-chronological order without sorting.
  void addEntry(UrgeLogModel entry) {
    emit(state.copyWith(entries: [entry, ...state.entries]));
  }

  /// Remove a single entry by its index in [UrgeLogState.entries].
  /// No-ops on out-of-range indices to keep callers safe.
  void deleteEntry(int index) {
    if (index < 0 || index >= state.entries.length) return;
    final updated = List<UrgeLogModel>.from(state.entries)..removeAt(index);
    emit(state.copyWith(entries: updated));
  }

  /// Clear every saved entry. Useful for a future "Reset history" setting.
  void clearAll() => emit(const UrgeLogState());

  @override
  UrgeLogState? fromJson(Map<String, dynamic> json) {
    try {
      return UrgeLogState.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UrgeLogState state) => state.toMap();
}
