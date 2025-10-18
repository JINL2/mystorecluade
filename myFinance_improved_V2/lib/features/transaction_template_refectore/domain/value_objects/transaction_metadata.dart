import 'package:equatable/equatable.dart';

/// Value object representing transaction metadata for audit trail
/// 
/// Encapsulates audit information including creation, modification, and
/// tracking details. This is an immutable value object.
class TransactionMetadata extends Equatable {
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? updatedBy;
  final String? ipAddress;
  final String? userAgent;
  final int version;

  const TransactionMetadata({
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
    this.ipAddress,
    this.userAgent,
    this.version = 1,
  });

  /// Factory constructor for creating initial metadata
  factory TransactionMetadata.create({
    required String createdBy,
    String? ipAddress,
    String? userAgent,
  }) {
    final now = DateTime.now();
    return TransactionMetadata(
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
      ipAddress: ipAddress,
      userAgent: userAgent,
      version: 1,
    );
  }

  /// Creates a new metadata instance for update
  TransactionMetadata updateWith({
    String? updatedBy,
    String? ipAddress,
    String? userAgent,
  }) {
    return TransactionMetadata(
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      updatedBy: updatedBy ?? this.updatedBy,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      version: version + 1,
    );
  }

  /// Checks if metadata has been updated since creation
  bool get hasBeenUpdated => updatedAt.isAfter(createdAt);

  /// Gets the duration since creation
  Duration get ageSinceCreation => DateTime.now().difference(createdAt);

  /// Gets the duration since last update
  Duration get ageSinceUpdate => DateTime.now().difference(updatedAt);

  /// Checks if metadata is recent (within specified duration)
  bool isRecentlyCreated([Duration threshold = const Duration(hours: 1)]) {
    return ageSinceCreation <= threshold;
  }

  /// Checks if metadata was recently updated
  bool isRecentlyUpdated([Duration threshold = const Duration(hours: 1)]) {
    return ageSinceUpdate <= threshold;
  }

  /// Formats creation date for display
  String formatCreatedAt([String pattern = 'yyyy-MM-dd HH:mm:ss']) {
    return _formatDateTime(createdAt, pattern);
  }

  /// Formats update date for display
  String formatUpdatedAt([String pattern = 'yyyy-MM-dd HH:mm:ss']) {
    return _formatDateTime(updatedAt, pattern);
  }

  /// Gets a summary of who created and last updated
  String getAuditSummary() {
    if (!hasBeenUpdated) {
      return 'Created by $createdBy on ${formatCreatedAt('MMM dd, yyyy')}';
    }
    
    final updater = updatedBy ?? createdBy;
    return 'Created by $createdBy on ${formatCreatedAt('MMM dd, yyyy')}, '
           'updated by $updater on ${formatUpdatedAt('MMM dd, yyyy')}';
  }

  /// Validates metadata according to business rules
  bool get isValid {
    // Creator ID cannot be empty
    if (createdBy.trim().isEmpty) return false;
    
    // Created date cannot be in the future
    if (createdAt.isAfter(DateTime.now())) return false;
    
    // Updated date cannot be before created date
    if (updatedAt.isBefore(createdAt)) return false;
    
    // Version must be positive
    if (version < 1) return false;
    
    return true;
  }

  /// Gets validation errors if any
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (createdBy.trim().isEmpty) {
      errors.add('Created by cannot be empty');
    }
    
    if (createdAt.isAfter(DateTime.now())) {
      errors.add('Created date cannot be in the future');
    }
    
    if (updatedAt.isBefore(createdAt)) {
      errors.add('Updated date cannot be before created date');
    }
    
    if (version < 1) {
      errors.add('Version must be positive');
    }
    
    return errors;
  }

  /// Helper method to format DateTime
  String _formatDateTime(DateTime dateTime, String pattern) {
    // Simplified formatting - in real app would use intl package
    switch (pattern) {
      case 'yyyy-MM-dd HH:mm:ss':
        return '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} '
               '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}:${_pad(dateTime.second)}';
      case 'MMM dd, yyyy':
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
      default:
        return dateTime.toString();
    }
  }

  /// Helper method to pad numbers with leading zero
  String _pad(int number) => number.toString().padLeft(2, '0');

  @override
  List<Object?> get props => [
        createdBy,
        createdAt,
        updatedAt,
        updatedBy,
        ipAddress,
        userAgent,
        version,
      ];

  @override
  String toString() => getAuditSummary();
}