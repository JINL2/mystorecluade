import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/session_repository.dart';
import '../datasources/session_datasource.dart';
import '../repositories/session_repository_impl.dart';

/// Provider for SessionRepository
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final datasource = ref.watch(sessionDatasourceProvider);
  return SessionRepositoryImpl(datasource);
});
