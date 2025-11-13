import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/currency.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/join_result.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/store.dart';

/// Test fixture data for homepage feature
///
/// These are reusable test data objects used across multiple tests.

// Company fixtures
const tCompany = Company(
  id: 'comp-test-123',
  name: 'Test Company',
  code: 'COMP12345',
  companyTypeId: 'type-123',
  baseCurrencyId: 'usd',
);

// Store fixtures
const tStore = Store(
  id: 'store-test-123',
  name: 'Test Store',
  code: 'STORE12345',
  companyId: 'comp-test-123',
);

// CompanyType fixtures
const tCompanyType = CompanyType(
  id: 'type-123',
  typeName: 'Retail',
);

const tCompanyTypeList = [
  CompanyType(id: 'type-1', typeName: 'Retail'),
  CompanyType(id: 'type-2', typeName: 'Restaurant'),
  CompanyType(id: 'type-3', typeName: 'Service'),
];

// Currency fixtures
const tCurrency = Currency(
  id: 'usd',
  name: 'US Dollar',
  code: 'USD',
  symbol: '\$',
);

const tCurrencyList = [
  Currency(id: 'usd', name: 'US Dollar', code: 'USD', symbol: '\$'),
  Currency(id: 'krw', name: 'Korean Won', code: 'KRW', symbol: '₩'),
  Currency(id: 'eur', name: 'Euro', code: 'EUR', symbol: '€'),
];

// JoinResult fixtures
const tJoinResultCompany = JoinResult(
  success: true,
  companyId: 'comp-test-123',
  companyName: 'Test Company',
  roleAssigned: 'Member',
);

const tJoinResultStore = JoinResult(
  success: true,
  companyId: 'comp-test-123',
  companyName: 'Test Company',
  storeId: 'store-test-123',
  storeName: 'Test Store',
  roleAssigned: 'Employee',
);
