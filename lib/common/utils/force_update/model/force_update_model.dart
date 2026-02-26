class ForceUpdateRemoteConfigModel {
  final String minVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String playStoreUrl;

  ForceUpdateRemoteConfigModel({
    required this.minVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.playStoreUrl,
  });

  factory ForceUpdateRemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return ForceUpdateRemoteConfigModel(
      minVersion: json['min_version'] as String? ?? '',
      latestVersion: json['latest_version'] as String? ?? '',
      forceUpdate: json['force_update'] as bool? ?? false,
      playStoreUrl: json['playstore_url'] as String? ?? '',
    );
  }

  factory ForceUpdateRemoteConfigModel.fromAndroidConfig(
    Map<String, dynamic> json,
  ) {
    // Handles nested structure with "android" key
    final androidConfig = json['android'] as Map<String, dynamic>? ?? {};
    return ForceUpdateRemoteConfigModel(
      minVersion: androidConfig['min_version'] as String? ?? '',
      latestVersion: androidConfig['latest_version'] as String? ?? '',
      forceUpdate: androidConfig['force_update'] as bool? ?? false,
      playStoreUrl: androidConfig['playstore_url'] as String? ?? '',
    );
  }
}
