import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file (make sure it's placed at the root of your Flutter project)
  await dotenv.load(fileName: ".env");

  // Set up the method channel for Google Maps
  const platform = MethodChannel('com.yourapp.maps');
  try {
    final String apiKey = Platform.isIOS
        ? dotenv.env['GOOGLE_MAPS_API_KEY_IOS'] ?? ''
        : dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';

    // If the API key is empty, it's a good idea to print a warning or handle the error
    if (apiKey.isEmpty) {
      print('Google Maps API key is not set in the .env file');
    } else {
      await platform.invokeMethod('setApiKey', {
        'apiKey': apiKey,
      });
    }
  } catch (e) {
    print('Failed to set API key: $e');
  }

  // Initialize Firebase with the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
