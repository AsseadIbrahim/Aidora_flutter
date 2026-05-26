import 'package:first_flutter/services/platform_helper_stub.dart';

class ApiConstants {
  ApiConstants._();

  static const String _realDeviceIp = '';

  static String get baseUrl {
    if (_realDeviceIp.isNotEmpty) return 'http://$_realDeviceIp:8000';
    return getPlatformBaseUrl();
  }

  // ── Organizations ─────────────────────────────────────────────────────────
  static const String organizationCards = '/api/organizations/cards/';
  static String organizationFilter(String t) => '/api/organizations/filter/$t/';
  static String organizationDetail(int id) => '/api/organizations/$id/';
  static const String organizationServices = '/api/organizations/services/';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '/api/auth/login/';
  static const String registerRefugee = '/api/auth/register/refugee/';
  static const String tokenRefresh = '/api/auth/token/refresh/';
  static const String authMe = '/api/auth/me/';
  static const String logout = '/api/auth/logout/';
  static const String resendPin = '/api/auth/resend-pin/';
  static const String verifyPin = '/api/auth/verify-pin/';

  /// PATCH (requires auth) — complete/update refugee profile
  static const String completeProfile = '/api/auth/refugees/complete-profile/';

  /// GET  (requires auth) — refugee profile data
  static const String refugeeProfile = '/api/auth/profile/refugee/';

  /// POST (requires auth) — upload profile image
  static const String uploadProfileImage = '/api/auth/profile/upload-image/';

  static const String notifications = '/api/auth/notifications/';

  // ── Requests ──────────────────────────────────────────────────────────────
  static const String myRequests = '/api/requests/my-requests/';
  static const String requestList = '/api/requests/list/';

  // ── Volunteers ──────────────────────────────────────────────────────────────
  static const String volunteerPageOne = '/api/auth/volunteer/profile/';
  static const String volunteerPageTwo =
      '/api/auth/volunteer/profile/availability/';
  static const String volunteerPageThree =
      '/api/auth/volunteer/profile/skills/';
  static const String volunteerPageFour = '/api/organizations/';
  static const String volunteerPageFive = '/api/auth/org/';
  static const String volunteerStateRequest = '/api/auth/me';
  static const String numberPIN = '/api/auth/verify-pin/';
  static const String resendPIN = '/api/auth/resend-pin/';
  static const String profile = '/api/auth/volunteer/profile/view';
  static const String profileImage = '/api/auth/profile/upload-image/';
  static const String profileQR = '';
  static const String volunteersNotifications = '';
  static const String home = '/api/requests/volunteer/home/';
  static const String tasks = '/api/requests/volunteer/tasks/';
  static const String taskStatus = '/api/requests/volunteer/tasks/';
  // ── Organization Page Fore ──────────────────────────────────────────────────────────────
  static const String orgpagefore = '/api/organizations/applications/';
  static const String orgPageForeUpdateStatus =
      '/api/organizations/applications/';
}
