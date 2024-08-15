// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyD2e2852B5lJhnz9FdPYwjzDpQysKY6vxc',
    appId: '1:390129730315:web:a255ca64aff1575483980e',
    messagingSenderId: '390129730315',
    projectId: 'gymapp-46fe3',
    authDomain: 'gymapp-46fe3.firebaseapp.com',
    storageBucket: 'gymapp-46fe3.appspot.com',
    measurementId: 'G-9FMEMLGEVZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAShhy1Ccc77Nt-LM5tpUYSIrSj_CEFfng',
    appId: '1:390129730315:android:f7f07e0147a1cebb83980e',
    messagingSenderId: '390129730315',
    projectId: 'gymapp-46fe3',
    storageBucket: 'gymapp-46fe3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOgGHZTRoLnn_0aNE5NGdeiK8VBJKKcwA',
    appId: '1:390129730315:ios:b50ab071651133d183980e',
    messagingSenderId: '390129730315',
    projectId: 'gymapp-46fe3',
    storageBucket: 'gymapp-46fe3.appspot.com',
    iosBundleId: 'com.example.gymapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOgGHZTRoLnn_0aNE5NGdeiK8VBJKKcwA',
    appId: '1:390129730315:ios:b50ab071651133d183980e',
    messagingSenderId: '390129730315',
    projectId: 'gymapp-46fe3',
    storageBucket: 'gymapp-46fe3.appspot.com',
    iosBundleId: 'com.example.gymapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2e2852B5lJhnz9FdPYwjzDpQysKY6vxc',
    appId: '1:390129730315:web:36e27a629972e39f83980e',
    messagingSenderId: '390129730315',
    projectId: 'gymapp-46fe3',
    authDomain: 'gymapp-46fe3.firebaseapp.com',
    storageBucket: 'gymapp-46fe3.appspot.com',
    measurementId: 'G-BY5ZH7P0Q7',
  );
}
