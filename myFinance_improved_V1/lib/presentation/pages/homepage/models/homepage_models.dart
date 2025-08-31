import 'package:myfinance_improved/domain/entities/company.dart';
import 'package:myfinance_improved/domain/entities/store.dart';
import 'package:myfinance_improved/domain/entities/feature.dart';

/// User data with companies for homepage
class UserWithCompanies {
  const UserWithCompanies({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.companyCount,
    required this.companies,
    required this.profileImage,
  });

  final String userId;
  final String userFirstName;
  final String userLastName;
  final int companyCount;
  final List<Company> companies;
  final String profileImage;

  factory UserWithCompanies.fromJson(Map<String, dynamic> json) {
    final companiesData = (json['companies'] as List<dynamic>?) ?? [];
    
    // Debug logging
    
    // Remove duplicates while parsing
    final uniqueCompanies = <String, Company>{};
    
    for (final company in companiesData) {
      final companyId = company['company_id'] as String;
      final roleData = company['role'] as Map<String, dynamic>?;
      
      // Only add if we haven't seen this company ID before
      if (!uniqueCompanies.containsKey(companyId)) {
        uniqueCompanies[companyId] = Company(
          id: companyId,
          companyName: company['company_name'] as String,
          companyCode: company['company_code'] as String? ?? '',
          role: UserRole(
            roleName: roleData?['role_name'] as String? ?? 'User',
            permissions: (roleData?['permissions'] as List<dynamic>?)?.cast<String>() ?? [],
          ),
          stores: (company['stores'] as List<dynamic>?)
              ?.map((store) => Store(
                    id: store['store_id'] as String,
                    storeName: store['store_name'] as String,
                    storeCode: store['store_code'] as String? ?? '',
                    companyId: companyId,
                  ))
              .toList() ?? [],
        );
      } else {
      }
    }
    
    final companiesList = uniqueCompanies.values.toList();
    
    return UserWithCompanies(
      userId: json['user_id'] as String,
      userFirstName: json['user_first_name'] as String? ?? '',
      userLastName: json['user_last_name'] as String? ?? '',
      companyCount: companiesList.length, // Use actual unique count
      companies: companiesList,
      profileImage: json['profile_image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_first_name': userFirstName,
      'user_last_name': userLastName,
      'company_count': companyCount,
      'profile_image': profileImage,
      'companies': companies.map((company) => {
        'company_id': company.id,
        'company_name': company.companyName,
        'company_code': company.companyCode,
        'role': {
          'role_name': company.role.roleName,
          'permissions': company.role.permissions,
        },
        'stores': company.stores.map((store) => {
          'store_id': store.id,
          'store_name': store.storeName,
          'store_code': store.storeCode,
        }).toList(),
      }).toList(),
    };
  }
}

/// Category with features for homepage grid
class CategoryWithFeatures {
  const CategoryWithFeatures({
    required this.categoryId,
    required this.categoryName,
    required this.features,
  });

  final String categoryId;
  final String categoryName;
  final List<Feature> features;

  factory CategoryWithFeatures.fromJson(Map<String, dynamic> json) {
    return CategoryWithFeatures(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      features: (json['features'] as List<dynamic>)
          .map((feature) => Feature(
                featureId: feature['feature_id'] as String,
                featureName: feature['feature_name'] as String,
                featureRoute: feature['route'] as String,
                featureIcon: feature['icon'] as String? ?? '',
                iconKey: feature['icon_key'] as String? ?? '',
                isShowMain: feature['is_show_main'] as bool? ?? true, // Default to true if not specified
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'features': features.map((feature) => {
        'feature_id': feature.featureId,
        'feature_name': feature.featureName,
        'route': feature.featureRoute,
        'icon': feature.featureIcon,
        'icon_key': feature.iconKey,
        'is_show_main': feature.isShowMain,
      }).toList(),
    };
  }
}

// Feature class is imported from domain/entities/feature.dart

/// Homepage error states
abstract class HomepageError {
  const HomepageError();
}

class NetworkError extends HomepageError {
  const NetworkError(this.message);
  final String message;
}

class Unauthorized extends HomepageError {
  const Unauthorized();
}

class ServerError extends HomepageError {
  const ServerError(this.message);
  final String message;
}

class UnknownError extends HomepageError {
  const UnknownError(this.message);
  final String message;
}

/// Top feature from user's usage data
class TopFeature {
  const TopFeature({
    required this.featureId,
    required this.featureName,
    this.categoryId,
    required this.clickCount,
    required this.lastClicked,
    required this.icon,
    required this.route,
    this.iconKey,
    this.isShowMain = true, // Default to true for backward compatibility
  });

  final String featureId;
  final String featureName;
  final String? categoryId;
  final int clickCount;
  final DateTime lastClicked;
  final String icon;
  final String route;
  final String? iconKey;
  final bool isShowMain;

  factory TopFeature.fromJson(Map<String, dynamic> json) {
    final iconKey = json['icon_key'] as String?;
    final featureName = json['feature_name'] as String;
    
    // Handle missing last_clicked field by providing a default value
    final lastClickedStr = json['last_clicked'] as String?;
    final lastClicked = lastClickedStr != null 
        ? DateTime.parse(lastClickedStr)
        : DateTime.now().subtract(const Duration(days: 365)); // Default to a year ago
    
    // Handle click_count safely - some might be null
    final clickCountValue = json['click_count'];
    final clickCount = clickCountValue is int ? clickCountValue : 0;
    
    return TopFeature(
      featureId: json['feature_id'] as String,
      featureName: featureName,
      categoryId: json['category_id'] as String?,
      clickCount: clickCount,
      lastClicked: lastClicked,
      icon: json['icon'] as String,
      route: json['route'] as String,
      iconKey: iconKey,
      isShowMain: json['is_show_main'] as bool? ?? true, // Default to true if not specified
    );
  }
}

/// Company selection event
abstract class CompanySelectionEvent {
  const CompanySelectionEvent();
}

class CompanySelected extends CompanySelectionEvent {
  const CompanySelected(this.company);
  final Company company;
}

class StoreSelected extends CompanySelectionEvent {
  const StoreSelected(this.store);
  final Store store;
}

/// User shift overview data for salary display
class UserShiftOverview {
  const UserShiftOverview({
    required this.requestMonth,
    required this.actualWorkDays,
    required this.actualWorkHours,
    required this.estimatedSalary,
    required this.currencySymbol,
    required this.salaryAmount,
    required this.salaryType,
    required this.lateDeductionTotal,
    required this.overtimeTotal,
  });

  final String requestMonth;
  final int actualWorkDays;
  final double actualWorkHours;
  final String estimatedSalary;
  final String currencySymbol;
  final double salaryAmount;
  final String salaryType;
  final int lateDeductionTotal;
  final int overtimeTotal;

  factory UserShiftOverview.fromJson(Map<String, dynamic> json) {
    return UserShiftOverview(
      requestMonth: json['request_month'] as String? ?? '',
      actualWorkDays: json['actual_work_days'] as int? ?? 0,
      actualWorkHours: (json['actual_work_hours'] as num?)?.toDouble() ?? 0.0,
      estimatedSalary: json['estimated_salary'] as String? ?? '0',
      currencySymbol: json['currency_symbol'] as String? ?? '₩',
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
      salaryType: json['salary_type'] as String? ?? 'hourly',
      lateDeductionTotal: json['late_deduction_total'] as int? ?? 0,
      overtimeTotal: json['overtime_total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_month': requestMonth,
      'actual_work_days': actualWorkDays,
      'actual_work_hours': actualWorkHours,
      'estimated_salary': estimatedSalary,
      'currency_symbol': currencySymbol,
      'salary_amount': salaryAmount,
      'salary_type': salaryType,
      'late_deduction_total': lateDeductionTotal,
      'overtime_total': overtimeTotal,
    };
  }
}