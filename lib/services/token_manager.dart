import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_storage.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// TokenManager
/// Proactive JWT refresh: decodes exp from the access token and refreshes
/// it automatically 60 seconds before expiry.
/// This prevents 403/401 "You do not have permission" errors mid-session.
/// ─────────────────────────────────────────────────────────────────────────────
class TokenManager {
  TokenManager._();
  static final TokenManager instance = TokenManager._();

  bool _refreshing = false;

  /// Call before every authenticated request.
  /// Returns the valid access token, refreshing if needed.
  Future<String?> getValidAccessToken() async {
    final access = AuthStorage.getAccessToken();
    if (access == null || access.isEmpty) return null;

    // Check if token is close to expiry (< 60s remaining)
    if (_isExpiringSoon(access)) {
      if (!_refreshing) {
        await _doRefresh();
      }
    }
    return AuthStorage.getAccessToken();
  }

  /// Decode JWT payload and check exp claim.
  bool _isExpiringSoon(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      // Base64 decode payload
      var payload = parts[1];
      // Pad to valid base64 length
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = jsonDecode(utf8.decode(base64Url.decode(payload)));
      final exp = decoded['exp'] as int?;
      if (exp == null) return false;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final remaining = expiresAt.difference(DateTime.now());
      final expiring = remaining.inSeconds < 60;
      if (expiring)
        debugPrint(
          '⏰ Token expires in ${remaining.inSeconds}s — refreshing...',
        );
      return expiring;
    } catch (_) {
      return false;
    }
  }

  /// POST /api/auth/token/refresh/
  Future<bool> _doRefresh() async {
    _refreshing = true;
    try {
      final refresh = AuthStorage.getRefreshToken();
      if (refresh == null || refresh.isEmpty) return false;

      final res = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.tokenRefresh}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = body['access'] as String?;
        if (newAccess != null && newAccess.isNotEmpty) {
          await AuthStorage.updateAccessToken(newAccess);
          debugPrint('✅ Token proactively refreshed');
          return true;
        }
      }
      debugPrint('❌ Proactive refresh failed (${res.statusCode})');
      return false;
    } catch (e) {
      debugPrint('❌ Proactive refresh error: $e');
      return false;
    } finally {
      _refreshing = false;
    }
  }

  /// Force refresh now (call after 403 response).
  Future<bool> forceRefresh() => _doRefresh();
}
