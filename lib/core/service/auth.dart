import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantFirestoreService {
  static FirebaseApp? _merchantApp;
  static FirebaseFirestore? _merchantFirestore;

  static Future<void> initializeMerchantApp() async {
    _merchantApp ??= await Firebase.initializeApp(
      name: 'MerchantApp',
      options: const FirebaseOptions(
        apiKey: '<merchant-api-key>',
        appId: '<merchant-app-id>',
        messagingSenderId: '<merchant-messaging-sender-id>',
        projectId: '<merchant-project-id>',
        storageBucket: '<merchant-storage-bucket>',
      ),
    );

    _merchantFirestore = FirebaseFirestore.instanceFor(app: _merchantApp!);
  }

  static FirebaseFirestore get firestore => _merchantFirestore!;
}

