import 'package:mocktail/mocktail.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/company_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/join_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/homepage_repository.dart';

/// Mock repositories for homepage feature tests
class MockCompanyRepository extends Mock implements CompanyRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockJoinRepository extends Mock implements JoinRepository {}

class MockHomepageRepository extends Mock implements HomepageRepository {}
