import 'package:equatable/equatable.dart';

/// Value object representing transaction business context
/// 
/// Encapsulates the business environment and organizational context
/// in which a transaction occurs. This is an immutable value object.
class TransactionContext extends Equatable {
  final String companyId;
  final String storeId;
  final String? departmentId;
  final String? projectId;
  final String? costCenterId;

  const TransactionContext({
    required this.companyId,
    required this.storeId,
    this.departmentId,
    this.projectId,
    this.costCenterId,
  });

  /// Factory constructor for creating minimal context
  factory TransactionContext.minimal({
    required String companyId,
    required String storeId,
  }) {
    return TransactionContext(
      companyId: companyId,
      storeId: storeId,
    );
  }

  /// Factory constructor for creating full context
  factory TransactionContext.full({
    required String companyId,
    required String storeId,
    String? departmentId,
    String? projectId,
    String? costCenterId,
  }) {
    return TransactionContext(
      companyId: companyId,
      storeId: storeId,
      departmentId: departmentId,
      projectId: projectId,
      costCenterId: costCenterId,
    );
  }

  /// Checks if context has department information
  bool get hasDepartment => departmentId != null && departmentId!.isNotEmpty;

  /// Checks if context has project information
  bool get hasProject => projectId != null && projectId!.isNotEmpty;

  /// Checks if context has cost center information
  bool get hasCostCenter => costCenterId != null && costCenterId!.isNotEmpty;

  /// Checks if this is a complete business context
  bool get isComplete => hasDepartment && hasProject && hasCostCenter;

  /// Validates the context according to business rules
  bool get isValid {
    // Company ID is required and cannot be empty
    if (companyId.trim().isEmpty) return false;
    
    // Store ID is required and cannot be empty
    if (storeId.trim().isEmpty) return false;
    
    // Optional fields, if provided, cannot be empty
    if (departmentId != null && departmentId!.trim().isEmpty) return false;
    if (projectId != null && projectId!.trim().isEmpty) return false;
    if (costCenterId != null && costCenterId!.trim().isEmpty) return false;
    
    return true;
  }

  /// Gets validation errors if any
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (companyId.trim().isEmpty) {
      errors.add('Company ID cannot be empty');
    }
    
    if (storeId.trim().isEmpty) {
      errors.add('Store ID cannot be empty');
    }
    
    if (departmentId != null && departmentId!.trim().isEmpty) {
      errors.add('Department ID cannot be empty when provided');
    }
    
    if (projectId != null && projectId!.trim().isEmpty) {
      errors.add('Project ID cannot be empty when provided');
    }
    
    if (costCenterId != null && costCenterId!.trim().isEmpty) {
      errors.add('Cost center ID cannot be empty when provided');
    }
    
    return errors;
  }

  /// Creates a context hierarchy string for reporting
  String getHierarchy() {
    final parts = <String>[companyId, storeId];
    
    if (hasDepartment) parts.add(departmentId!);
    if (hasProject) parts.add(projectId!);
    if (hasCostCenter) parts.add(costCenterId!);
    
    return parts.join(' > ');
  }

  /// Checks if this context belongs to the same company
  bool isSameCompany(TransactionContext other) {
    return companyId == other.companyId;
  }

  /// Checks if this context belongs to the same store
  bool isSameStore(TransactionContext other) {
    return companyId == other.companyId && storeId == other.storeId;
  }

  /// Checks if this context belongs to the same department
  bool isSameDepartment(TransactionContext other) {
    return isSameStore(other) && departmentId == other.departmentId;
  }

  /// Checks if this context belongs to the same project
  bool isSameProject(TransactionContext other) {
    return isSameStore(other) && projectId == other.projectId;
  }

  /// Checks if this context belongs to the same cost center
  bool isSameCostCenter(TransactionContext other) {
    return isSameStore(other) && costCenterId == other.costCenterId;
  }

  /// Creates a new context with additional information
  TransactionContext withAdditionalInfo({
    String? departmentId,
    String? projectId,
    String? costCenterId,
  }) {
    return TransactionContext(
      companyId: companyId,
      storeId: storeId,
      departmentId: departmentId ?? this.departmentId,
      projectId: projectId ?? this.projectId,
      costCenterId: costCenterId ?? this.costCenterId,
    );
  }

  /// Gets a display name for the context
  String getDisplayName() {
    final parts = <String>[];
    
    if (hasDepartment) parts.add('Dept: $departmentId');
    if (hasProject) parts.add('Project: $projectId');
    if (hasCostCenter) parts.add('Cost Center: $costCenterId');
    
    if (parts.isEmpty) {
      return 'Store: $storeId';
    }
    
    return parts.join(', ');
  }

  /// Gets context summary for audit purposes
  String getAuditSummary() {
    return 'Company: $companyId, Store: $storeId'
           '${hasDepartment ? ', Department: $departmentId' : ''}'
           '${hasProject ? ', Project: $projectId' : ''}'
           '${hasCostCenter ? ', Cost Center: $costCenterId' : ''}';
  }

  /// Converts to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'storeId': storeId,
      if (departmentId != null) 'departmentId': departmentId,
      if (projectId != null) 'projectId': projectId,
      if (costCenterId != null) 'costCenterId': costCenterId,
    };
  }

  /// Creates context from map
  factory TransactionContext.fromMap(Map<String, dynamic> map) {
    return TransactionContext(
      companyId: map['companyId'] as String,
      storeId: map['storeId'] as String,
      departmentId: map['departmentId'] as String?,
      projectId: map['projectId'] as String?,
      costCenterId: map['costCenterId'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        companyId,
        storeId,
        departmentId,
        projectId,
        costCenterId,
      ];

  @override
  String toString() => getAuditSummary();
}