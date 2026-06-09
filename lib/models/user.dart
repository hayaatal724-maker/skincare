/// نموذج المستخدم — يطابق ما يعيده الباك إند في login/register/profile.
class User {
  final int id;
  final String fullName;
  final String email;
  final String? skinType;
  final String? createdAt;
  final int? scansCount;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.skinType,
    this.createdAt,
    this.scansCount,
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      id: (j['id'] as num?)?.toInt() ?? 0,
      fullName: (j['full_name'] ?? '').toString(),
      email: (j['email'] ?? '').toString(),
      skinType: j['skin_type']?.toString(),
      createdAt: j['created_at']?.toString(),
      scansCount: (j['scans_count'] as num?)?.toInt(),
    );
  }
}
