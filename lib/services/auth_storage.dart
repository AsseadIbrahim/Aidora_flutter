import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AuthStorage — Persistent token store using SharedPreferences.
///
/// Works on Android, iOS, Web, Desktop — all Flutter platforms.
/// Tokens survive app restarts. Call [init] once at app startup.
/// ─────────────────────────────────────────────────────────────────────────────
class AuthStorage {
  AuthStorage._();

  static const _kAccess = 'auth_access_token';
  static const _kRefresh = 'auth_refresh_token';
  static const _kRole = 'auth_role';
  static const _kEmail = 'auth_email';

  static SharedPreferences? _prefs;

  // ── Must call once in main() before runApp ────────────────────────────────
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint(
      '🔑 AuthStorage initialized — '
      'loggedIn: $isLoggedIn  role: ${getRole()}',
    );
  }

  static SharedPreferences get _p {
    assert(_prefs != null, 'AuthStorage.init() must be called before use.');
    return _prefs!;
  }

  // ── Save (called after login or register) ─────────────────────────────────
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String role,
    String? email,
  }) async {
    await _p.setString(_kAccess, accessToken);
    await _p.setString(_kRefresh, refreshToken);
    await _p.setString(_kRole, role);
    if (email != null) await _p.setString(_kEmail, email);
    debugPrint('🔑 Tokens saved — role: $role');
  }

  // ── Update access token only (called after token refresh) ─────────────────
  static Future<void> updateAccessToken(String newAccessToken) async {
    await _p.setString(_kAccess, newAccessToken);
    debugPrint('🔑 Access token refreshed');
  }

  // ── Getters ───────────────────────────────────────────────────────────────
  static String? getAccessToken() => _p.getString(_kAccess);
  static String? getRefreshToken() => _p.getString(_kRefresh);
  static String? getRole() => _p.getString(_kRole);
  static String? getUserEmail() => _p.getString(_kEmail);

  static bool get isLoggedIn {
    final t = getAccessToken();
    return t != null && t.isNotEmpty;
  }

  // ── Clear (logout) ────────────────────────────────────────────────────────
  static Future<void> clear() async {
    await Future.wait([
      _p.remove(_kAccess),
      _p.remove(_kRefresh),
      _p.remove(_kRole),
      _p.remove(_kEmail),
    ]);
    debugPrint('🔑 Tokens cleared (logout)');
  }
}
