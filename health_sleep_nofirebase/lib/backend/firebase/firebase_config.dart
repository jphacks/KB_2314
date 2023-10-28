import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCKrk2WoSYLVcmIA-bZrzzrV_6CfTO-qj4",
            authDomain: "health-app-kb2023.firebaseapp.com",
            projectId: "health-app-kb2023",
            storageBucket: "health-app-kb2023.appspot.com",
            messagingSenderId: "172691698887",
            appId: "1:172691698887:web:3f760abb99dc3410b8bae2",
            measurementId: "G-9RYJZYSKP6"));
  } else {
    await Firebase.initializeApp();
  }
}
