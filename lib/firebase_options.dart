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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDu4oW_-27QiWHRwn7oRLpWZ9q6mtrrGdg',
    appId: '1:846424822630:android:497d7256ea805d7dac2ea7',
    messagingSenderId: '846424822630',
    projectId: 'fir-practice-22b97',
    databaseURL: 'https://fir-practice-22b97-default-rtdb.firebaseio.com',
    storageBucket: 'fir-practice-22b97.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVSDLthVCKU4nW0LjQmKI600KhxAzfohI',
    appId: '1:846424822630:ios:2959e9a636792d19ac2ea7',
    messagingSenderId: '846424822630',
    projectId: 'fir-practice-22b97',
    databaseURL: 'https://fir-practice-22b97-default-rtdb.firebaseio.com',
    storageBucket: 'fir-practice-22b97.appspot.com',
    androidClientId: '846424822630-ufp5h8ipiui46k07l79bic01vth9lm09.apps.googleusercontent.com',
    iosClientId: '846424822630-2bm37dqb2u804lq87iqd0fh5meqjvc3e.apps.googleusercontent.com',
    iosBundleId: 'com.example.learnFirebase',
  );
}