class ProductModel {
  final int id;
  final String nama;
  final double hargaJual;
  final double hargaBeli;
  final int stok;
  final String? urlGambar; // ✅ BUAT NULLABLE
  final DateTime dibuatPada;
  final String? kategori;

  ProductModel({
    required this.id,
    required this.nama,
    required this.hargaJual,
    required this.hargaBeli,
    required this.stok,
    this.urlGambar, // ✅ BISA NULL
    required this.dibuatPada,
    this.kategori,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      nama: json['nama'] as String,
      hargaJual: (json['harga_jual'] as num).toDouble(),
      hargaBeli: (json['harga_beli'] as num).toDouble(),
      stok: json['stok'] as int,
      urlGambar: json['url_gambar'] as String?,
      dibuatPada: DateTime.parse(json['dibuat_pada'] as String),
      kategori: json['kategori'] as String?,
    );
  }

  // product_model.dart
  Map<String, dynamic> toJson({bool includeId = true}) {
    final map = {
      'nama': nama,
      'harga_jual': hargaJual,
      'harga_beli': hargaBeli,
      'stok': stok,
      'url_gambar': urlGambar,
      'dibuat_pada': dibuatPada.toIso8601String(),
      'kategori': kategori,
    };

    if (includeId && id != 0) {
      map['id'] = id;
    }

    return map;
  }
}
