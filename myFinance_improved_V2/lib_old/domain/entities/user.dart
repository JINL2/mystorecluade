class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
}