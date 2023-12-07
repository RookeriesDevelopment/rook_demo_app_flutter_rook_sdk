# Rook SDK demo app flutter

Demo app for ROOK SDK packages:

* [rook_sdk_core](https://pub.dev/packages/rook_sdk_core)
* [rook_sdk_apple_health](https://pub.dev/packages/rook_sdk_apple_health)
* [rook_sdk_health_connect](https://pub.dev/packages/rook_sdk_health_connect)

## Configure & Run

1. In the lib folder create a secrets.dart file with a Secrets class and add the following
   constants:

```dart
class Secrets {
  static String clientUUID = 'clientUUID';
  static String secretKey = 'secretKey';
}
```

2. Run `flutter pub get`
3. In the ios folder, ensure that your Podfile is targeted to ios 13+ (`platform :ios, '13.0'`)
4. In the ios folder, run `pod install`
