import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'app.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:chupachap/features/notifications/domain/repositories/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // Set up the method channel for Google Maps
  const platform = MethodChannel('com.yourapp.maps');
  try {
    final String apiKey = Platform.isIOS
        ? dotenv.env['GOOGLE_MAPS_API_KEY_IOS'] ?? ''
        : dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';

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

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize NotificationService with repository
  final notificationsRepository = NotificationsRepository();
  NotificationService.initialize(notificationsRepository);

  runApp(const App());
}
