import 'package:attention_anchor/feature/urge_log/model/urge_log_model.dart';

/// State holding the persisted list of past urge logs.
///
/// Kept intentionally small — only the history list. The active 9-step
/// flow lives in [UrgeFlowState] so this cubit can stay focused on
/// long-lived persistence concerns.
class UrgeLogState {
  final List<UrgeLogModel> entries;

  const UrgeLogState({this.entries = const []});

  UrgeLogState copyWith({List<UrgeLogModel>? entries}) =>
      UrgeLogState(entries: entries ?? this.entries);

  Map<String, dynamic> toMap() => {
        'entries': entries.map((e) => e.toMap()).toList(),
      };

  factory UrgeLogState.fromMap(Map<String, dynamic> map) => UrgeLogState(
        entries: (map['entries'] as List?)
                ?.map((e) => UrgeLogModel.fromMap(Map<String, dynamic>.from(e)))
                .toList() ??
            const [],
      );
}
