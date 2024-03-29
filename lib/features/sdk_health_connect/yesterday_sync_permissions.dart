import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:logging/logging.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/scrollable_scaffold.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

const String yesterdaySyncPermissionsRoute =
    '/android/yesterday-sync-permissions';

class YesterdaySyncPermissions extends StatefulWidget {
  const YesterdaySyncPermissions({super.key});

  @override
  State<YesterdaySyncPermissions> createState() =>
      _YesterdaySyncPermissionsState();
}

class _YesterdaySyncPermissionsState extends State<YesterdaySyncPermissions> {
  final Logger logger = Logger('YesterdaySyncPermissions');

  final rookHealthPermissionsManager = HCRookHealthPermissionsManager();

  bool androidPermissionsChecked = false;
  bool healthConnectPermissionsChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      name: 'Yesterday Sync Permissions',
      alignment: Alignment.topCenter,
      child: FocusDetector(
        onFocusGained: checkPermissions,
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text("Android permissions"),
              subtitle: const Text(
                "POST_NOTIFICATIONS, FOREGROUND_SERVICE, FOREGROUND_SERVICE_HEALTH, ACTIVITY_RECOGNITION",
              ),
              value: androidPermissionsChecked,
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            const FilledButton(
              onPressed:
                  HCRookYesterdaySyncPermissions.requestAndroidPermissions,
              child: Text("Request Permissions"),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text("Health Connect permissions"),
              subtitle: const Text("SLEEP, PHYSICAL, BODY"),
              value: healthConnectPermissionsChecked,
              onChanged: (value) {},
            ),
            const SizedBox(height: 10),
            const FilledButton(
              onPressed: HCRookYesterdaySyncPermissions
                  .requestHealthConnectPermissions,
              child: Text("Request Permissions"),
            ),
            FilledButton(
              onPressed: openHealthConnect,
              child: const Text("Open Health Connect"),
            ),
          ],
        ),
      ),
    );
  }

  void checkPermissions() {
    HCRookYesterdaySyncPermissions.hasAndroidPermissions()
        .then((hasAndroidPermissions) {
      setState(() => androidPermissionsChecked = hasAndroidPermissions);
    }).catchError((error) {
      logger.severe("hasAndroidPermissions - error: $error");
    });

    HCRookYesterdaySyncPermissions.hasHealthConnectPermissions()
        .then((hasHealthConnectPermissions) {
      setState(
          () => healthConnectPermissionsChecked = hasHealthConnectPermissions);
    }).catchError((error) {
      logger.severe("hasHealthConnectPermissions - error: $error");
    });
  }

  void openHealthConnect() {
    logger.info('Opening Health Connect...');

    rookHealthPermissionsManager.openHealthConnectSettings().then((_) {
      logger.info('Health Connect was opened');
    }).catchError((exception) {
      final error = switch (exception) {
        (SDKNotInitializedException it) =>
          'SDKNotInitializedException: ${it.message}',
        (UserNotInitializedException it) =>
          'UserNotInitializedException: ${it.message}',
        (HealthConnectNotInstalledException it) =>
          'HealthConnectNotInstalledException: ${it.message}',
        (DeviceNotSupportedException it) =>
          'DeviceNotSupportedException: ${it.message}',
        _ => exception.toString(),
      };

      logger.info('Error opening Health Connect:');
      logger.info(error);
    });
  }
}
