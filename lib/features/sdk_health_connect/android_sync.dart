import 'package:flutter/material.dart';
import 'package:rook_sdk_demo_app_flutter/common/console_output.dart';
import 'package:rook_sdk_demo_app_flutter/common/environments.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/scrollable_scaffold.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/section_title.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

const String androidSyncRoute = '/android/sync';

class AndroidSync extends StatefulWidget {
  const AndroidSync({super.key});

  @override
  State<AndroidSync> createState() => _AndroidSyncState();
}

class _AndroidSyncState extends State<AndroidSync> {
  TextEditingController syncSummariesDate = TextEditingController();
  TextEditingController syncSingleSummaryDate = TextEditingController();
  TextEditingController syncSingleEventDate = TextEditingController();

  HCSummarySyncType summarySyncType = HCSummarySyncType.sleep;
  HCEventSyncType eventSyncType = HCEventSyncType.activity;

  final ConsoleOutput syncSummariesHistoricOutput = ConsoleOutput();
  final ConsoleOutput syncSummariesOutput = ConsoleOutput();
  final ConsoleOutput syncSingleSummaryOutput = ConsoleOutput();
  final ConsoleOutput syncSingleEventOutput = ConsoleOutput();
  final ConsoleOutput getTodayStepsOutput = ConsoleOutput();
  final ConsoleOutput getTodayCaloriesOutput = ConsoleOutput();

  @override
  void initState() {
    final now = DateTime.now();
    final today = now.subtract(
      Duration(hours: now.hour, minutes: now.minute, seconds: now.second),
    );
    final yesterday = today.subtract(const Duration(days: 1));

    syncSummariesDate.text = yesterday.toIso8601String().split("T").first;
    syncSingleSummaryDate.text = yesterday.toIso8601String().split("T").first;
    syncSingleEventDate.text = today.toIso8601String().split("T").first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      name: 'Manually sync health data',
      child: Column(
        children: [
          const SectionTitle('Sync summaries historic'),
          Text(syncSummariesHistoricOutput.current),
          FilledButton(
            onPressed: syncSummariesHistoric,
            child: const Text('Sync summaries historic'),
          ),
          const SectionTitle('Sync summaries'),
          TextField(
            controller: syncSummariesDate,
            decoration: const InputDecoration(
              helperText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
            ),
          ),
          Text(syncSummariesOutput.current),
          FilledButton(
            onPressed: syncSummaries,
            child: const Text('Sync summaries'),
          ),
          const SectionTitle('Sync single summary'),
          TextField(
            controller: syncSingleSummaryDate,
            decoration: const InputDecoration(
              helperText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
            ),
          ),
          DropdownMenu(
            onSelected: (selection) {
              summarySyncType = selection ?? HCSummarySyncType.sleep;
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: HCSummarySyncType.sleep,
                label: "Sleep",
              ),
              DropdownMenuEntry(
                value: HCSummarySyncType.physical,
                label: "Physical",
              ),
              DropdownMenuEntry(
                value: HCSummarySyncType.body,
                label: "Body",
              ),
            ],
          ),
          Text(syncSingleSummaryOutput.current),
          FilledButton(
            onPressed: syncSingleSummary,
            child: const Text('Sync single summary'),
          ),
          const SectionTitle('Sync single event'),
          TextField(
            controller: syncSingleEventDate,
            decoration: const InputDecoration(
              helperText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
            ),
          ),
          DropdownMenu(
            onSelected: (selection) {
              eventSyncType = selection ?? HCEventSyncType.activity;
            },
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: HCEventSyncType.activity,
                label: "Activity",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.bloodGlucose,
                label: "Blood glucose",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.bloodPressure,
                label: "Blood pressure",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.bodyMetrics,
                label: "Body metrics",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.heartRate,
                label: "Heart rate",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.hydration,
                label: "Hydration",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.nutrition,
                label: "Nutrition",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.oxygenation,
                label: "Oxygenation",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.temperature,
                label: "Temperature",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.steps,
                label: "Steps",
              ),
              DropdownMenuEntry(
                value: HCEventSyncType.calories,
                label: "Calories",
              ),
            ],
          ),
          Text(syncSingleEventOutput.current),
          FilledButton(
            onPressed: syncSingleEvent,
            child: const Text('Sync single event'),
          ),
          const SectionTitle('Get today steps'),
          Text(getTodayStepsOutput.current),
          FilledButton(
            onPressed: getTodaySteps,
            child: const Text('Get today steps'),
          ),
          const SectionTitle('Get today calories'),
          Text(getTodayCaloriesOutput.current),
          FilledButton(
            onPressed: getTodayCalories,
            child: const Text('Get today calories'),
          ),
        ],
      ),
    );
  }

  void syncSummariesHistoric() async {
    syncSummariesHistoricOutput.clear();

    setState(() {
      syncSummariesHistoricOutput.append("Syncing historic summaries...");
    });

    try {
      await HCRookSyncManager.sync(enableLogs: isDebug);

      setState(() {
        syncSummariesHistoricOutput.append("Historic summaries sync started");
      });
    } catch (error) {
      setState(() {
        syncSummariesHistoricOutput.append(
          "Error syncing historic summaries: $error",
        );
      });
    }
  }

  void syncSummaries() async {
    syncSummariesOutput.clear();

    final dateString = syncSummariesDate.text;
    final date = DateTime.parse(dateString);

    setState(() {
      syncSummariesOutput.append("Syncing $date summaries...");
    });

    try {
      await HCRookSyncManager.sync(date: date);

      setState(() {
        syncSummariesOutput.append("$date summaries synced successfully");
      });
    } catch (error) {
      setState(() {
        syncSummariesOutput.append("Error syncing $date summaries: $error");
      });
    }
  }

  void syncSingleSummary() async {
    syncSingleSummaryOutput.clear();

    final dateString = syncSingleSummaryDate.text;
    final date = DateTime.parse(dateString);

    setState(() {
      syncSingleSummaryOutput.append("Syncing $date $summarySyncType...");
    });

    try {
      await HCRookSyncManager.sync(date: date, summary: summarySyncType);

      setState(() {
        syncSingleSummaryOutput.append(
          "$date $summarySyncType synced successfully",
        );
      });
    } catch (error) {
      setState(() {
        syncSingleSummaryOutput.append(
          "Error syncing $date $summarySyncType: $error",
        );
      });
    }
  }

  void syncSingleEvent() async {
    syncSingleEventOutput.clear();

    final dateString = syncSingleEventDate.text;
    final date = DateTime.parse(dateString);

    setState(() {
      syncSingleEventOutput.append("Syncing $date $eventSyncType...");
    });

    try {
      await HCRookSyncManager.syncEvents(date, eventSyncType);

      setState(() {
        syncSingleEventOutput.append(
          "$date $eventSyncType synced successfully",
        );
      });
    } catch (error) {
      setState(() {
        syncSingleEventOutput.append(
          "Error syncing $date $eventSyncType: $error",
        );
      });
    }
  }

  void getTodaySteps() async {
    getTodayStepsOutput.clear();

    setState(
      () => getTodayStepsOutput.append('Syncing steps events of today...'),
    );

    try {
      final syncStatusWithData = await HCRookSyncManager.getTodayStepsCount();

      switch (syncStatusWithData) {
        case Synced(data: final steps):
          setState(
            () =>
                getTodayStepsOutput.append('$steps steps synced successfully'),
          );
          break;
        case RecordsNotFound():
          setState(
            () => getTodayStepsOutput.append('Steps events not found'),
          );
          break;
      }
    } catch (error) {
      setState(
        () => getTodayStepsOutput.append('Error syncing Steps events: $error'),
      );
    }
  }

  void getTodayCalories() async {
    getTodayCaloriesOutput.clear();

    setState(
      () => getTodayCaloriesOutput.append(
        'Syncing calories events of today...',
      ),
    );

    try {
      final syncStatusWithData =
          await HCRookSyncManager.getTodayCaloriesCount();

      switch (syncStatusWithData) {
        case Synced(data: final calories):
          setState(
            () => getTodayCaloriesOutput.append(
              '$calories synced successfully',
            ),
          );
          break;
        case RecordsNotFound():
          setState(
            () => getTodayCaloriesOutput.append('Calories events not found'),
          );
          break;
      }
    } catch (error) {
      setState(
        () => getTodayCaloriesOutput.append(
          'Error syncing Calories events: $error',
        ),
      );
    }
  }
}
