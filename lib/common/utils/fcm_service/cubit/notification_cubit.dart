import 'package:attention_anchor/common/utils/fcm_service/fcm_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends HydratedCubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    // Initial sync if already ON
    if (state.isNotificationOn) {
      FCMService.initialize();
    }
  }

  Future<void> toggleNotification(bool value) async {
    if (value) {
      final success = await FCMService.initialize();
      if (success) {
        emit(state.copyWith(isNotificationOn: true));
      }
    } else {
      await FCMService.deleteToken();
      emit(state.copyWith(isNotificationOn: false));
    }
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    return NotificationState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    return state.toJson();
  }
}
