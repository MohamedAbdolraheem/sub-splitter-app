import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration service
/// Handles loading and accessing environment variables
class EnvConfig {
  static bool _isInitialized = false;

  /// Initialize environment variables
  static Future<void> init() async {
    if (!_isInitialized) {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
    }
  }

  /// Firebase Configuration
  static String get firebaseApiKey => 
      dotenv.env['FIREBASE_API_KEY'] ?? '';
  
  static String get firebaseAppId => 
      dotenv.env['FIREBASE_APP_ID'] ?? '';
  
  static String get firebaseProjectId => 
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  
  static String get firebaseMessagingSenderId => 
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  
  static String get firebaseStorageBucket => 
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  /// Supabase Configuration
  static String get supabaseUrl => 
      dotenv.env['SUPABASE_URL'] ?? '';
  
  static String get supabaseAnonKey => 
      dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Other API Keys
  static String get googleMapsApiKey => 
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  /// Validation
  static bool get isFirebaseConfigured => 
      firebaseApiKey.isNotEmpty && 
      firebaseAppId.isNotEmpty && 
      firebaseProjectId.isNotEmpty;

  static bool get isSupabaseConfigured => 
      supabaseUrl.isNotEmpty && 
      supabaseAnonKey.isNotEmpty;
}
