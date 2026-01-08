// lib/data/models/user_model.dart
class UserModel {
  final String id; // UUID dari Supabase Auth
  final String nama;
  final String peran; // "admin" atau "cashier"

  UserModel({
    required this.id,
    required this.nama,
    required this.peran,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      peran: json['peran'] as String,
    );
  }
}