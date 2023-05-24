// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9cB1nx-FgKOkuoilfTi3jZeEfXe9AC5M',
    appId: '1:158249674468:web:14984e10d4f667a7eaeef1',
    messagingSenderId: '158249674468',
    projectId: 'instagram-9d656',
    authDomain: 'instagram-9d656.firebaseapp.com',
    storageBucket: 'instagram-9d656.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPWY4I7SiJeIGh9MSDzb4NiHTqEvB3Vjc',
    appId: '1:158249674468:android:1cc4532864ae606eeaeef1',
    messagingSenderId: '158249674468',
    projectId: 'instagram-9d656',
    storageBucket: 'instagram-9d656.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_XjS-R9fRpI-1EOMsgXIcbp0uMK_22Kc',
    appId: '1:158249674468:ios:6b54587c8077d232eaeef1',
    messagingSenderId: '158249674468',
    projectId: 'instagram-9d656',
    storageBucket: 'instagram-9d656.appspot.com',
    iosClientId: '158249674468-n8i4kqvrr9jdkleig21c9icukbqfd9j3.apps.googleusercontent.com',
    iosBundleId: 'com.tjlee.testagram',
  );
}