import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'token_manager.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ApiService — Cross-platform HTTP client (GET · POST · PATCH)
///
/// Token handling:
///   1. Proactive refresh: TokenManager checks exp before every request
///   2. Reactive refresh:  On 401/403, force-refresh and retry once
///   This eliminates "You do not have permission" mid-session errors.
/// ─────────────────────────────────────────────────────────────────────────────
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const Duration _timeout = Duration(seconds: 20);

  // ── Build headers with fresh token ─────────────────────────────────────────
  Future<Map<String, String>> _headers({bool requiresAuth = false}) async {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth) {
      // Proactively refresh if token is close to expiry
      final token = await TokenManager.instance.getValidAccessToken();
      if (token != null && token.isNotEmpty) {
        h['Authorization'] = 'Bearer $token';
      }
    }
    return h;
  }

  // ── GET ────────────────────────────────────────────────────────────────────
  Future<ApiResponse> get(
    String endpoint, {
    bool requiresAuth = false,
    bool retry = false,
  }) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('🌐 GET $url');
    try {
      final res = await http
          .get(
            Uri.parse(url),
            headers: await _headers(requiresAuth: requiresAuth),
          )
          .timeout(_timeout);

      // On 401 or 403 — force refresh and retry once
      if ((res.statusCode == 401 || res.statusCode == 403) &&
          !retry &&
          requiresAuth) {
        debugPrint('⚠️  ${res.statusCode} — forcing token refresh...');
        final ok = await TokenManager.instance.forceRefresh();
        if (ok) return get(endpoint, requiresAuth: true, retry: true);
      }
      return _parse(res);
    } catch (e) {
      return _netErr(e, url);
    }
  }

  // ── POST ───────────────────────────────────────────────────────────────────
  Future<ApiResponse> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    bool retry = false,
  }) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('🌐 POST $url  $body');
    try {
      final res = await http
          .post(
            Uri.parse(url),
            headers: await _headers(requiresAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if ((res.statusCode == 401 || res.statusCode == 403) &&
          !retry &&
          requiresAuth) {
        final ok = await TokenManager.instance.forceRefresh();
        if (ok) {
          return post(endpoint, body: body, requiresAuth: true, retry: true);
        }
      }
      return _parse(res);
    } catch (e) {
      return _netErr(e, url);
    }
  }

  // ── PATCH ──────────────────────────────────────────────────────────────────
  Future<ApiResponse> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    bool retry = false,
  }) async {
    final url = '${ApiConstants.baseUrl}$endpoint';
    debugPrint('🌐 PATCH $url  $body');
    try {
      final res = await http
          .patch(
            Uri.parse(url),
            headers: await _headers(requiresAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      if ((res.statusCode == 401 || res.statusCode == 403) &&
          !retry &&
          requiresAuth) {
        final ok = await TokenManager.instance.forceRefresh();
        if (ok) {
          return patch(endpoint, body: body, requiresAuth: true, retry: true);
        }
      }
      return _parse(res);
    } catch (e) {
      return _netErr(e, url);
    }
  }

  // ── Response parser ────────────────────────────────────────────────────────
  ApiResponse _parse(http.Response r) {
    debugPrint(
      '   ← ${r.statusCode}  ${r.body.length > 300 ? r.body.substring(0, 300) : r.body}',
    );
    dynamic d;
    try {
      d = jsonDecode(r.body);
    } catch (_) {
      d = r.body;
    }
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return ApiResponse.success(d, code: r.statusCode);
    }
    return ApiResponse.error(_djErr(d, r.statusCode), code: r.statusCode);
  }

  // ── Network error handler (no dart:io) ─────────────────────────────────────
  ApiResponse _netErr(Object e, String url) {
    final s = e.toString();
    debugPrint('❌ $url → $s');
    if (kIsWeb && s.contains('Failed to fetch')) {
      return ApiResponse.error(
        'CORS Error: Add django-cors-headers + CORS_ALLOW_ALL_ORIGINS=True\n'
        'Run: pip install django-cors-headers',
        code: 0,
      );
    }
    if (s.contains('SocketException') ||
        s.contains('Connection refused') ||
        s.contains('Failed host lookup')) {
      return ApiResponse.error(
        'Cannot reach server.\nEnsure Django is running: python manage.py runserver\n'
        'URL: ${ApiConstants.baseUrl}',
        code: 0,
      );
    }
    if (e is TimeoutException) {
      return ApiResponse.error(
        'Request timed out (${_timeout.inSeconds}s)',
        code: 408,
      );
    }
    return ApiResponse.error('Connection error: $s', code: -1);
  }

  // ── Extract Django error messages ──────────────────────────────────────────
  String _djErr(dynamic d, int code) {
    if (d is Map) {
      if (d.containsKey('non_field_errors')) {
        final v = d['non_field_errors'];
        if (v is List && v.isNotEmpty) return v.first.toString();
      }
      for (final k in ['detail', 'error', 'message']) {
        if (d.containsKey(k)) return d[k].toString();
      }
      final parts = <String>[];
      d.forEach((k, v) => parts.add(v is List ? '$k: ${v.first}' : '$k: $v'));
      if (parts.isNotEmpty) return parts.join('\n');
    }
    if (d is String && d.isNotEmpty) return d;
    const m = {
      400: 'Invalid data.',
      401: 'Session expired. Please login again.',
      403:
          'Permission denied. Your session may have expired — please login again.',
      404: 'Not found.',
      405: 'Method not allowed.',
      500: 'Server error. Try again later.',
    };
    return m[code] ?? 'Request failed ($code).';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class ApiResponse {
  final bool isSuccess;
  final dynamic data;
  final String? errorMessage;
  final int statusCode;
  const ApiResponse._({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage,
  });
  factory ApiResponse.success(dynamic d, {required int code}) =>
      ApiResponse._(isSuccess: true, statusCode: code, data: d);
  factory ApiResponse.error(String m, {required int code}) =>
      ApiResponse._(isSuccess: false, statusCode: code, errorMessage: m);
}
