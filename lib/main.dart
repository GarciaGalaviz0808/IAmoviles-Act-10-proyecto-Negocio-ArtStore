import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  try {
    if (kIsWeb) {
      // Para Web necesitas configurar esto con tus datos de Firebase Console
      // Ve a Firebase Console > Project Settings > General > Your Apps > Web App
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyA2-WxL_F658N1Cy_pflYXO_p3qSTuUKPw", // Reemplazar con tu Web API Key
          appId: "1:577164647579:android:605f7df6cef603c9bbfa3e",   // Reemplazar con tu Web App ID
          messagingSenderId: "577164647579",
          projectId: "crudtiendadearte",
          storageBucket: "crudtiendadearte.firebasestorage.app",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    firebaseInitialized = true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(ArtStoreApp(firebaseInitialized: firebaseInitialized));
}

class ArtStoreApp extends StatelessWidget {
  final bool firebaseInitialized;
  const ArtStoreApp({super.key, required this.firebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: firebaseInitialized 
        ? const SplashScreen()
        : Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 80, color: Colors.red),
                    const SizedBox(height: 20),
                    const Text(
                      'Falta Configuración de Firebase',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Para la versión Web, necesitas agregar tu apiKey y appId en main.dart.\n\n'
                      'Si estás en Android, asegúrate de que google-services.json esté en android/app/.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => main(), // Reintentar
                      child: const Text('REINTENTAR'),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
