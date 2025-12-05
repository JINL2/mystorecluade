/// Store Employee Entity
///
/// Simple entity to hold store employee user IDs from get_employee_info RPC.
/// Used to filter reliability leaderboard by store employees.
class StoreEmployee {
  final String userId;
  final String fullName;
  final String? email;

  const StoreEmployee({
    required this.userId,
    required this.fullName,
    this.email,
  });

  /// Create from JSON map
  factory StoreEmployee.fromJson(Map<String, dynamic> json) {
    return StoreEmployee(
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString(),
    );
  }

  @override
  String toString() => 'StoreEmployee(userId: $userId, name: $fullName)';
}
