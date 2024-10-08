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
        return macos;
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
    apiKey: 'AIzaSyDxx2Tcwv0aWVeYPnmNrONtJTSkx5rQ7WI',
    appId: '1:107866540864:web:4f4de0f3a2c975bd9788a5',
    messagingSenderId: '107866540864',
    projectId: 'cbsbeta01',
    authDomain: 'cbsbeta01.firebaseapp.com',
    storageBucket: 'cbsbeta01.appspot.com',
    measurementId: 'G-GB9ZYJ6W48',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlf6Mg0Zf4BJUfq6AdsNJZZKlVU2C_fY4',
    appId: '1:107866540864:android:09562f942e829ebe9788a5',
    messagingSenderId: '107866540864',
    projectId: 'cbsbeta01',
    storageBucket: 'cbsbeta01.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAu9mv-24La9K-efSXVxifkmqD6ZqQ3FHQ',
    appId: '1:107866540864:ios:481e83f1e2846fbc9788a5',
    messagingSenderId: '107866540864',
    projectId: 'cbsbeta01',
    storageBucket: 'cbsbeta01.appspot.com',
    iosClientId: '107866540864-vqucer5qb1hofrrnrj60a7def0679psf.apps.googleusercontent.com',
    iosBundleId: 'com.example.cbsbeta01',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAu9mv-24La9K-efSXVxifkmqD6ZqQ3FHQ',
    appId: '1:107866540864:ios:481e83f1e2846fbc9788a5',
    messagingSenderId: '107866540864',
    projectId: 'cbsbeta01',
    storageBucket: 'cbsbeta01.appspot.com',
    iosClientId: '107866540864-vqucer5qb1hofrrnrj60a7def0679psf.apps.googleusercontent.com',
    iosBundleId: 'com.example.cbsbeta01',
  );
}
