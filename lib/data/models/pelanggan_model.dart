class Pelanggan {
  final int id;
  final String nama;
  final String? email;
  final String nomorHp;
  final String? alamat;
  final String jenisKelamin; // ✅ Nama field ini
  final int totalPembelian;
  final DateTime dibuatPada;
  final DateTime? diperbaruiPada;

  Pelanggan({
    required this.id,
    required this.nama,
    this.email,
    required this.nomorHp,
    this.alamat,
    required this.jenisKelamin, // ✅
    required this.totalPembelian,
    required this.dibuatPada,
    this.diperbaruiPada,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(String? str) {
      if (str == null || str.trim().isEmpty) return null;
      try {
        return DateTime.parse(str.trim());
      } catch (e) {
        print('⚠️ Gagal parse tanggal: "$str" | Error: $e');
        return null;
      }
    }

    return Pelanggan(
      id: json['id'] as int,
      nama: json['nama'] as String,
      email: json['email'] as String?,
      nomorHp: json['nomor_hp'] as String,
      alamat: json['alamat'] as String?,
      jenisKelamin: json['jenis_kelamin'] as String, // ✅ Dari kolom database
      totalPembelian: (json['total_pembelian'] as int?) ?? 0,
      dibuatPada: parseDateTime(json['dibuat_pada'] as String?) ?? DateTime.now(),
      diperbaruiPada: parseDateTime(json['diperbarui_pada'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nomor_hp': nomorHp,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin, // ✅ Simpan ke kolom ini
      'total_pembelian': totalPembelian,
    };
  }
}