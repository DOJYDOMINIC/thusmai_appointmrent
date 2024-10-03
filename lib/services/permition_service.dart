import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // List of permissions to request
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,            // For POST_NOTIFICATIONS
    Permission.audio,                   // For RECORD_AUDIO and MODIFY_AUDIO_SETTINGS
    Permission.storage,                 // For WRITE_EXTERNAL_STORAGE
    Permission.contacts,                // For READ_CONTACTS and WRITE_CONTACTS
    Permission.phone,                   // For READ_PHONE_STATE
    Permission.sms,                     // For RECEIVE_SMS and READ_SMS
    Permission.scheduleExactAlarm,      // For SCHEDULE_EXACT_ALARM
    Permission.ignoreBatteryOptimizations, // For WAKE_LOCK
  ].request();

  // Check and handle permission statuses
  statuses.forEach((permission, status) {
    if (status.isGranted) {
      print('${permission.toString()} is granted');
    } else if (status.isDenied) {
      print('${permission.toString()} is denied');
    } else if (status.isPermanentlyDenied) {
      print('${permission.toString()} is permanently denied. Please enable it from app settings.');
    }
  });

  // Check for RECEIVE_BOOT_COMPLETED - no runtime permission is needed, it's a manifest-only permission.
}

