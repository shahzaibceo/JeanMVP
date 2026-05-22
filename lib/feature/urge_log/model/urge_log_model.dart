/// A completed urge logging entry stored in history.
///
/// Captures the user's emotional snapshot before and after working through
/// the intervention flow: how strong the urge was, what triggered it, what
/// they felt, optional notes, what action they chose, and the post-rating.
class UrgeLogModel {
  /// Epoch ms when the log was created.
  final int createdAt;

  /// Initial urge rating from step 1 (1–10).
  final int urgeRating;

  /// Selected trigger key (e.g. `social_media`, `stress`) or custom text.
  final String trigger;

  /// One or more selected feeling keys (e.g. `frustrated`, `bored`).
  final List<String> feelings;

  /// Free-form note written by the user (max 300 chars).
  final String notes;

  /// Post-reflection urge rating from step 5 (1–10), null if skipped.
  final int? urgeRatingAfter;

  /// Action chosen on step 6 (`breathing`, `immediate`, or `none`).
  final String actionChosen;

  const UrgeLogModel({
    required this.createdAt,
    required this.urgeRating,
    required this.trigger,
    required this.feelings,
    required this.notes,
    required this.actionChosen,
    this.urgeRatingAfter,
  });

  UrgeLogModel copyWith({
    int? createdAt,
    int? urgeRating,
    String? trigger,
    List<String>? feelings,
    String? notes,
    int? urgeRatingAfter,
    String? actionChosen,
  }) {
    return UrgeLogModel(
      createdAt: createdAt ?? this.createdAt,
      urgeRating: urgeRating ?? this.urgeRating,
      trigger: trigger ?? this.trigger,
      feelings: feelings ?? this.feelings,
      notes: notes ?? this.notes,
      urgeRatingAfter: urgeRatingAfter ?? this.urgeRatingAfter,
      actionChosen: actionChosen ?? this.actionChosen,
    );
  }

  Map<String, dynamic> toMap() => {
        'createdAt': createdAt,
        'urgeRating': urgeRating,
        'trigger': trigger,
        'feelings': feelings,
        'notes': notes,
        'urgeRatingAfter': urgeRatingAfter,
        'actionChosen': actionChosen,
      };

  factory UrgeLogModel.fromMap(Map<String, dynamic> map) => UrgeLogModel(
        createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
        urgeRating: map['urgeRating'] ?? 1,
        trigger: map['trigger'] ?? '',
        feelings: List<String>.from(map['feelings'] ?? const []),
        notes: map['notes'] ?? '',
        urgeRatingAfter: map['urgeRatingAfter'],
        actionChosen: map['actionChosen'] ?? 'none',
      );
}
