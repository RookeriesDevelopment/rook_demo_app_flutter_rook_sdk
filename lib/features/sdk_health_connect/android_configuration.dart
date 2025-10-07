import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rook_sdk_demo_app_flutter/common/console_output.dart';
import 'package:rook_sdk_demo_app_flutter/common/environments.dart';
import 'package:rook_sdk_demo_app_flutter/common/preferences.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/scrollable_scaffold.dart';
import 'package:rook_sdk_demo_app_flutter/common/widget/section_title.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_background_steps.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_background_sync.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_continuous_upload.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_data_sources.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_permissions.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_sync.dart';
import 'package:rook_sdk_demo_app_flutter/features/sdk_health_connect/android_user_management.dart';
import 'package:rook_sdk_demo_app_flutter/secrets.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';
import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';

const String androidConfigurationRoute = '/android/configuration';

class AndroidConfiguration extends StatefulWidget {
  const AndroidConfiguration({super.key});

  @override
  State<AndroidConfiguration> createState() => _AndroidConfigurationState();
}

class _AndroidConfigurationState extends State<AndroidConfiguration> {
  final Logger logger = Logger('AndroidConfiguration');

  final ConsoleOutput configurationOutput = ConsoleOutput();
  final ConsoleOutput initializeOutput = ConsoleOutput();
  final ConsoleOutput updateUserOutput = ConsoleOutput();

  bool enableNavigation = false;

  final _formKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return ScrollableScaffold(
      name: 'SDK Configuration',
      child: Column(
        children: [
          const SectionTitle('1. Configure SDK'),
          Text(configurationOutput.current),
          FilledButton(
            onPressed: setConfiguration,
            child: const Text('setConfiguration'),
          ),
          const SectionTitle('2. Initialize SDK'),
          Text(initializeOutput.current),
          FilledButton(
            onPressed: initialize,
            child: const Text('initRook'),
          ),
          const SectionTitle('3. Update user ID'),
          TextFormField(
            key: _formKey,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User ID',
            ),
            validator: validate,
            onSaved: updateUserID,
          ),
          Text(updateUserOutput.current),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                _formKey.currentState?.save();
              }
            },
            child: const Text('updateUserID'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidBackgroundStepsRoute,
                    )
                : null,
            child: const Text('Background steps'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidUserManagementRoute,
                    )
                : null,
            child: const Text('User management'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidDataSourcesRoute,
                    )
                : null,
            child: const Text('Data sources'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidPermissionsRoute,
                    )
                : null,
            child: const Text('Permissions'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidSyncRoute,
                    )
                : null,
            child: const Text('Manually sync health data'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
                      androidContinuousUploadRoute,
                    )
                : null,
            child: const Text('Continuous upload'),
          ),
          FilledButton(
            onPressed: enableNavigation
                ? () => Navigator.of(context).pushNamed(
              androidBackgroundSyncRoute,
            )
                : null,
            child: const Text('Background sync'),
          ),
        ],
      ),
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  void setConfiguration() async {
    final autoSyncAcceptation = await AppPreferences().getAutoSyncAcceptation();

    final rookConfiguration = RookConfiguration(
      clientUUID: Secrets.clientUUID,
      secretKey: Secrets.secretKey,
      environment: rookEnvironment,
      // This should be based on user choice: autoSyncAcceptation
      enableBackgroundSync: true,
    );

    configurationOutput.clear();

    configurationOutput.append('Using configuration:');
    configurationOutput.append('$rookConfiguration');

    if (isDebug) {
      HCRookConfigurationManager.enableNativeLogs();
    }

    HCRookConfigurationManager.setConfiguration(rookConfiguration);

    setState(() {
      configurationOutput.append('Configuration set successfully');
    });
  }

  void initialize() {
    RookSamsung.getUserID().then((user) {
      logger.info("Found userID: $user");
    }).catchError((error) {
      logger.severe("Error with user: $error");
    });

    initializeOutput.clear();

    setState(() {
      initializeOutput.append('Initializing...');
    });

    HCRookConfigurationManager.initRook().then((_) {
      setState(() {
        initializeOutput.append('SDK initialized successfully');
      });
      checkUserIDRegistered();
    }).catchError((error) {
      setState(() {
        initializeOutput.append('Error initializing SDK: $error');
      });
    });
  }

  void checkUserIDRegistered() {
    updateUserOutput.clear();

    HCRookConfigurationManager.getUserID().then((userID) {
      if (userID != null) {
        setState(() {
          updateUserOutput
              .append('Found local userID $userID, you can skip step 3');
          enableNavigation = true;
        });
      } else {
        setState(() {
          updateUserOutput
              .append('Local userID not found, please set a userID');
        });
      }
    });
  }

  void updateUserID(String? userID) {
    updateUserOutput.clear();

    setState(() {
      updateUserOutput.append('Updating userID...');
    });

    HCRookConfigurationManager.updateUserID(userID!).then((_) {
      setState(() {
        updateUserOutput.append('userID updated successfully');
        enableNavigation = true;
      });
    }).catchError((error) {
      setState(() {
        updateUserOutput.append('Error updating userID: $error');
      });
    });
  }
}
