import 'dart:io';

/// Network utility class for checking connectivity
class NetworkUtils {
  /// Check if device has internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Try multiple reliable servers for better connectivity check
      final List<String> hosts = [
        'google.com',
        'cloudflare.com',
        '1.1.1.1', // Cloudflare DNS
        '8.8.8.8', // Google DNS
      ];

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(
            host,
          ).timeout(const Duration(seconds: 5));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next host if this one fails
          continue;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if Supabase domain is reachable
  static Future<bool> canReachSupabase() async {
    try {
      final result = await InternetAddress.lookup(
        'nyvqdcstlktnamkystcz.supabase.co',
      ).timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if backend API is reachable
  static Future<bool> canReachBackend() async {
    try {
      final result = await InternetAddress.lookup(
        '172.20.10.2',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
