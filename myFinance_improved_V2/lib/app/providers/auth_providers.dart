// lib/app/providers/auth_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth State Provider
///
/// Provides authentication state for the app.
/// Listens to Supabase auth state changes.
///
/// **State Includes**:
/// - Current authenticated user (User?)
/// - Authentication status (isAuthenticated)
/// - User ID (currentUserId)
///
/// **Usage**:
/// ```dart
/// // Watch auth state
/// final authState = ref.watch(authStateProvider);
///
/// // Check if authenticated
/// final isAuth = ref.watch(isAuthenticatedProvider);
///
/// // Get current user
/// final user = ref.watch(currentUserProvider);
/// ```
///
/// **Lifecycle**: App-wide (persists throughout app lifetime)
///
/// **Dependencies**: Supabase Auth Stream

/// Current auth state (user)
///
/// This provider listens to Supabase auth state changes.
///
/// **2025 Best Practice**: 이벤트 타입별로 적절한 처리를 수행합니다.
/// - signedIn, tokenRefreshed: 세션의 user 반환
/// - signedOut: 현재 세션이 정말 무효한지 확인 후 처리 (다른 기기 로그인으로 인한 false positive 방지)
/// - 기타 이벤트: 현재 세션 상태 기준
///
/// 참고: https://github.com/supabase/auth/issues/2036
final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.auth.onAuthStateChange.map((data) {
    final event = data.event;
    final sessionUser = data.session?.user;

    // signedIn, tokenRefreshed: 세션의 user 반환
    if (event == AuthChangeEvent.signedIn ||
        event == AuthChangeEvent.tokenRefreshed) {
      return sessionUser;
    }

    // signedOut: 현재 세션이 정말 없는지 확인
    // (다른 기기 로그인/로그아웃으로 인한 false positive 방지)
    if (event == AuthChangeEvent.signedOut) {
      final currentSession = supabase.auth.currentSession;
      // 세션이 여전히 유효하면 user 유지
      if (currentSession != null && !currentSession.isExpired) {
        return currentSession.user;
      }
      // 세션이 정말 없으면 null 반환 (실제 로그아웃)
      return null;
    }

    // 기타 이벤트 (initialSession, passwordRecovery, userUpdated 등):
    // 현재 세션 상태 기준으로 처리
    final currentSession = supabase.auth.currentSession;
    return currentSession?.user ?? sessionUser;
  });
});

/// Check if user is authenticated
///
/// Derived from authStateProvider
/// IMPORTANT: During loading, check existing session to prevent premature redirect
/// IMPORTANT: On error, maintain existing session if valid (network errors shouldn't log out)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user != null,
    // During loading, check if there's an existing session
    // This prevents redirect to login while checking stored session
    loading: () {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        return session != null;
      } catch (_) {
        return false;
      }
    },
    // ✅ 에러 발생 시에도 유효한 세션이 있으면 유지 (네트워크 에러로 로그아웃 방지)
    error: (error, __) {
      try {
        final session = Supabase.instance.client.auth.currentSession;
        // 세션이 있고 만료되지 않았으면 인증 상태 유지
        if (session != null && !session.isExpired) {
          return true;
        }
        return false;
      } catch (_) {
        return false;
      }
    },
  );
});

/// Get current user
///
/// Derived from authStateProvider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Get current user ID
///
/// Derived from currentUserProvider
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});
