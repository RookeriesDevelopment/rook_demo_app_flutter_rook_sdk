import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rook_sdk_apple_health/rook_sdk_apple_health.dart';
import 'package:rook_sdk_demo_app_flutter/common/console_output.dart';
import 'package:rook_sdk_demo_app_flutter/common/environments.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/scrollable_scaffold.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/section_title.dart';
import 'package:rook_sdk_demo_app_flutter/secrets.dart';

const String sdkAppleHealthPlaygroundRoute = '/sdk-apple-health/playground';

class SdkAppleHealthPlayground extends StatefulWidget {
  const SdkAppleHealthPlayground({super.key});

  @override
  State<SdkAppleHealthPlayground> createState() =>
      _SdkAppleHealthPlaygroundState();
}

class _SdkAppleHealthPlaygroundState extends State<SdkAppleHealthPlayground> {
  final Logger logger = Logger('SdkAppleHealthPlayground');

  final ConsoleOutput syncOutput = ConsoleOutput();
  final ConsoleOutput syncPendingSummariesOutput = ConsoleOutput();
  final ConsoleOutput syncPendingEventsOutput = ConsoleOutput();

  bool enableNavigation = false;

  @override
  void initState() {
    enableContinuousUpload();
    enableBackground();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      name: 'SDK Apple Health',
      child: Column(
        children: [
          const SectionTitle('5. Sync health data'),
          Text(syncOutput.current),
          FilledButton(
            onPressed: syncHealthData,
            child: const Text('Sync health data'),
          ),
          const SectionTitle('Sync pending summaries (optional)'),
          Text(syncPendingSummariesOutput.current),
          FilledButton(
            onPressed: syncPendingSummaries,
            child: const Text('Sync pending summaries'),
          ),
          const SectionTitle('Sync pending events (optional)'),
          Text(syncPendingEventsOutput.current),
          FilledButton(
            onPressed: syncPendingEvents,
            child: const Text('Sync pending events'),
          ),
        ],
      ),
    );
  }

  void syncHealthData() async {
    syncOutput.clear();

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    setState(() => syncOutput.append('Syncing health data...'));

    setState(
          () => syncOutput
          .append('Syncing Sleep summary of yesterday: $yesterday...'),
    );
    await syncSleepSummary(yesterday);

    setState(
          () => syncOutput
          .append('Syncing Physical summary of yesterday: $yesterday...'),
    );
    await syncPhysicalSummary(yesterday);

    setState(
          () =>
          syncOutput.append('Syncing Body summary of yesterday: $yesterday...'),
    );
    await syncBodySummary(yesterday);

    setState(
          () => syncOutput.append('Syncing Physical events of today: $today...'),
    );
    await syncPhysicalEvents(today);

    setState(
          () =>
          syncOutput.append('Syncing BloodGlucose events of today: $today...'),
    );
    await syncBloodGlucoseEvents(today);

    setState(
          () =>
          syncOutput.append('Syncing BloodPressure events of today: $today...'),
    );
    await syncBloodPressureEvents(today);

    setState(
          () => syncOutput.append('Syncing BodyMetrics events of today: $today...'),
    );
    await syncBodyMetricsEvents(today);

    setState(
          () =>
          syncOutput.append('Syncing BodyHeartRate events of today: $today...'),
    );
    await syncBodyHeartRateEvents(today);

    setState(
          () => syncOutput
          .append('Syncing PhysicalHeartRate events of today: $today...'),
    );
    await syncPhysicalHeartRateEvents(today);

    setState(
          () => syncOutput
          .append('Syncing BodyOxygenation events of today: $today...'),
    );
    await syncBodyOxygenationEvents(today);

    setState(
          () => syncOutput
          .append('Syncing PhysicalOxygenation events of today: $today...'),
    );
    await syncPhysicalOxygenationEvents(today);

    setState(
          () => syncOutput.append('Syncing Temperature events of today: $today...'),
    );
    await syncTemperatureEvents(today);

    setState(
          () => syncOutput.append('Syncing Steps events of today: $today...'),
    );
    await syncStepsEvents();
  }

  Future<void> syncSleepSummary(DateTime yesterday) async {
    try {
      await AHRookSummaryManager.syncSleepSummary(yesterday);

      setState(() => syncOutput.append('Sleep summary synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Sleep summary:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncPhysicalSummary(DateTime yesterday) async {
    try {
      await AHRookSummaryManager.syncPhysicalSummary(yesterday);

      setState(() => syncOutput.append('Physical summary synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Physical summary:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBodySummary(DateTime yesterday) async {
    try {
      await AHRookSummaryManager.syncBodySummary(yesterday);

      setState(() => syncOutput.append('Body summary synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Body summary:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncPhysicalEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncPhysicalEvents(today);

      setState(() => syncOutput.append('Physical events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Physical events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBloodGlucoseEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncBloodGlucoseEvents(today);

      setState(
              () => syncOutput.append('BloodGlucose events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing BloodGlucose events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBloodPressureEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncBloodPressureEvents(today);

      setState(
              () => syncOutput.append('BloodPressure events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing BloodPressure events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBodyMetricsEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncBodyMetricsEvents(today);

      setState(
              () => syncOutput.append('BodyMetrics events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing BodyMetrics events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBodyHeartRateEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncBodyHeartRateEvents(today);

      setState(
              () => syncOutput.append('BodyHeartRate events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing BodyHeartRate events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncPhysicalHeartRateEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncPhysicalHeartRateEvents(today);

      setState(() =>
          syncOutput.append('PhysicalHeartRate events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing PhysicalHeartRate events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncBodyOxygenationEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncBodyOxygenationEvents(today);

      setState(() =>
          syncOutput.append('BodyOxygenation events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing BodyOxygenation events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncPhysicalOxygenationEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncPhysicalOxygenationEvents(today);

      setState(() =>
          syncOutput.append('PhysicalOxygenation events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing PhysicalOxygenation events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncTemperatureEvents(DateTime today) async {
    try {
      await AHRookEventManager.syncTemperatureEvents(today);

      setState(
              () => syncOutput.append('Temperature events synced successfully'));
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Temperature events:');
      setState(() => syncOutput.append(error));
    }
  }

  Future<void> syncStepsEvents() async {
    try {
      final steps = await AHRookEventManager.syncTodayAppleHealthStepsCount();

      setState(
            () => syncOutput.append('$steps steps synced successfully'),
      );
    } catch (exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncOutput.append('Error syncing Steps events:');
      setState(() => syncOutput.append(error));
    }
  }

  void syncPendingSummaries() {
    syncPendingSummariesOutput.clear();

    setState(() =>
        syncPendingSummariesOutput.append('Syncing pending summaries...'));

    AHRookSummaryManager.syncPendingSummaries().then((_) {
      setState(() => syncPendingSummariesOutput
          .append('Pending summaries synced successfully'));
    }).catchError((exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncPendingSummariesOutput.append('Error syncing pending summaries:');
      setState(() => syncPendingSummariesOutput.append(error));
    });
  }

  void syncPendingEvents() {
    syncPendingEventsOutput.clear();

    setState(() => syncPendingEventsOutput.append('Syncing pending events...'));

    AHRookEventManager.syncPendingEvents().then((_) {
      setState(() =>
          syncPendingEventsOutput.append('Pending events synced successfully'));
    }).catchError((exception) {
      final error = switch (exception) {
        _ => exception.toString(),
      };

      syncPendingEventsOutput.append('Error syncing pending events:');
      setState(() => syncPendingEventsOutput.append(error));
    });
  }

  void enableContinuousUpload() async {
    try {
      await AHRookContinuousUpload.enableContinuousUpload(
        enableNativeLogs: isDebug,
        clientUUID: Secrets.clientUUID,
        secretKey: Secrets.secretKey,
        environment: rookEnvironment,
      );

      logger.info('Continuous upload enabled successfully');
    } catch (exception) {
      logger.severe('enableContinuousUpload error: $exception');
    }
  }

  void enableBackground() async {
    try {
      await AHRookBackgroundSync.enableBackground(
        enableNativeLogs: isDebug,
        clientUUID: Secrets.clientUUID,
        secretKey: Secrets.secretKey,
        environment: rookEnvironment,
      );

      logger.info('Background enabled successfully');
    } catch (exception) {
      logger.severe('enableBackGroundForSummaries error: $exception');
    }
  }
}
