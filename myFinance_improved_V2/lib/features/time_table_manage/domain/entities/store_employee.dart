/// Store Employee Entity
///
/// Pure domain entity to hold store employee user IDs.
/// Used to filter reliability leaderboard by store employees.
///
/// ✅ Clean Architecture: No JSON parsing logic (moved to Data Layer)
class StoreEmployee {
  final String userId;
  final String fullName;
  final String? email;

  const StoreEmployee({
    required this.userId,
    required this.fullName,
    this.email,
  });

  @override
  String toString() => 'StoreEmployee(userId: $userId, name: $fullName)';
}
