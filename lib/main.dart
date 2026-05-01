import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyA2-WxL_F658N1Cy_pflYXO_p3qSTuUKPw",
          appId: "1:577164647579:android:605f7df6cef603c9bbfa3e", 
          messagingSenderId: "577164647579",
          projectId: "crudtiendadearte",
          storageBucket: "crudtiendadearte.firebasestorage.app",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase Error: $e');
  }

  runApp(const ArtStoreApp());
}

class ArtStoreApp extends StatelessWidget {
  const ArtStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
