import 'api_constants.dart';
import 'api_service.dart';
import 'auth_storage.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AuthService
/// Login / Register → save tokens → navigate to MainScreen.
/// profile_completed check is done ONLY when user taps "Request Help" or "+"
/// NOT after login/register (that was causing confusion).
/// ─────────────────────────────────────────────────────────────────────────────
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final ApiService _api = ApiService.instance;

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final r = await _api.post(
      ApiConstants.login,
      body: {'email': email.trim(), 'password': password},
    );
    if (!r.isSuccess) {
      return AuthResult.error(r.errorMessage ?? 'Login failed.');
    }
    return _storeTokens(r.data, email);
  }

  // ── Register refugee ───────────────────────────────────────────────────────
  Future<AuthResult> registerRefugee({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    final r = await _api.post(
      ApiConstants.registerRefugee,
      body: {
        'full_name': fullName.trim(),
        'phone_number': phoneNumber.trim(),
        'email': email.trim(),
        'password': password,
        'confirm_password': confirmPassword,
        'accept_terms': acceptTerms,
      },
    );
    if (!r.isSuccess) {
      return AuthResult.error(r.errorMessage ?? 'Registration failed.');
    }
    // {"message": "Refugee account created"} → auto-login
    return login(email: email, password: password);
  }

  // ── Store tokens (no /me check — profile check happens on Request Help) ────
  Future<AuthResult> _storeTokens(dynamic data, String email) async {
    try {
      final map = data as Map<String, dynamic>;
      final access = map['access'] as String;
      final refresh = map['refresh'] as String;
      final role = map['role'] as String? ?? 'refugee';
      await AuthStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
        role: role,
        email: email.trim(),
      );
      return AuthResult.success(role: role);
    } catch (e) {
      return AuthResult.error('Unexpected response: $e');
    }
  }

  Future<void> logout() async => AuthStorage.clear();
}

class AuthResult {
  final bool isSuccess;
  final String role;
  final String? errorMessage;
  const AuthResult._({
    required this.isSuccess,
    this.role = '',
    this.errorMessage,
  });
  factory AuthResult.success({required String role}) =>
      AuthResult._(isSuccess: true, role: role);
  factory AuthResult.error(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}
