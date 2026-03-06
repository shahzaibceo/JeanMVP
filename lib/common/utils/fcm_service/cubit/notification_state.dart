import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool isNotificationOn;

  const NotificationState({this.isNotificationOn = false});

  @override
  List<Object?> get props => [isNotificationOn];

  Map<String, dynamic> toJson() => {'isNotificationOn': isNotificationOn};

  factory NotificationState.fromJson(Map<String, dynamic> json) {
    return NotificationState(
      isNotificationOn: json['isNotificationOn'] ?? false,
    );
  }

  NotificationState copyWith({bool? isNotificationOn}) {
    return NotificationState(
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
    );
  }
}
