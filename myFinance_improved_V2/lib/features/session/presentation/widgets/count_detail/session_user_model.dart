/// Session user data model (from inventory_get_session_items RPC participants)
class SessionUser {
  final String id;
  final String userName;
  final String? userProfileImage;
  final int itemsCount;
  final int quantity;

  SessionUser({
    required this.id,
    required this.userName,
    this.userProfileImage,
    required this.itemsCount,
    required this.quantity,
  });
}
