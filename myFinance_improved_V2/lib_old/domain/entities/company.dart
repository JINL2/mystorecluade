import 'store.dart';

class Company {
  const Company({
    required this.id,
    required this.companyName,
    required this.companyCode,
    required this.role,
    required this.stores,
  });

  final String id;
  final String companyName;
  final String companyCode;
  final UserRole role;
  final List<Store> stores;
}

class UserRole {
  const UserRole({
    required this.roleName,
    required this.permissions,
  });

  final String roleName;
  final List<String> permissions;
}