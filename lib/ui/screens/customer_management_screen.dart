import 'package:flutter/material.dart';
import 'package:kasir_kosmetic/ui/widgets/base_screen.dart';

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  List<Map<String, dynamic>> customers = [
    {
      "id": 1,
      "name": "Abir Fauziah",
      "gender": "Perempuan",
      "purchaseCount": 233,
    },
    {
      "id": 2,
      "name": "Adelia Nur Dwi",
      "gender": "Perempuan",
      "purchaseCount": 70,
    },
    {
      "id": 3,
      "name": "Ahmad Ma'sum",
      "gender": "Laki-laki",
      "purchaseCount": 876,
    },
    {
      "id": 4,
      "name": "Ajeng Chalista",
      "gender": "Perempuan",
      "purchaseCount": 10,
    },
    {
      "id": 5,
      "name": "Alfian Prada",
      "gender": "Laki-laki",
      "purchaseCount": 150,
    },
    {
      "id": 6,
      "name": "Amelia Agustin",
      "gender": "Perempuan",
      "purchaseCount": 95,
    },
    {
      "id": 7,
      "name": "Ashila Putri",
      "gender": "Perempuan",
      "purchaseCount": 300,
    },
    {
      "id": 8,
      "name": "Azura Auli Selly",
      "gender": "Perempuan",
      "purchaseCount": 120,
    },
    {
      "id": 9,
      "name": "Bagas Sukmanto",
      "gender": "Laki-laki",
      "purchaseCount": 50,
    },
    {
      "id": 10,
      "name": "Chella Robiatul",
      "gender": "Perempuan",
      "purchaseCount": 200,
    },
  ];

  final TextEditingController _nameCtrl = TextEditingController();
  String? _selectedGender;
  int? _editIndex;

  // Daftar gender tetap
  final List<String> genders = ["Laki-laki", "Perempuan"];

  // Filter pencarian
  String _searchQuery = "";

  // Produk yang difilter berdasarkan pencarian
  List<Map<String, dynamic>> get filteredCustomers {
    if (_searchQuery.isEmpty) return customers;
    return customers.where((c) {
      return c["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _saveCustomer() {
    if (_nameCtrl.text.isEmpty || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Jenis Kelamin harus diisi!")),
      );
      return;
    }

    final newCustomer = {
      "id": _editIndex == null
          ? DateTime.now().millisecondsSinceEpoch
          : customers[_editIndex!]["id"],
      "name": _nameCtrl.text,
      "gender": _selectedGender!,
      "purchaseCount": _editIndex == null ? 0 : customers[_editIndex!]["purchaseCount"], // default 0 jika baru
    };

    setState(() {
      if (_editIndex == null) {
        customers.add(newCustomer);
      } else {
        customers[_editIndex!] = newCustomer;
        _editIndex = null;
      }
    });

    _nameCtrl.clear();
    _selectedGender = null;
    Navigator.pop(context);
  }

  void _editCustomer(int index) {
    final c = customers[index];
    _nameCtrl.text = c["name"];
    _selectedGender = c["gender"];
    _editIndex = index;
    _showAddEditDialog();
  }

  void _deleteCustomer(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pelanggan?"),
        content: const Text("Pelanggan ini akan dihapus permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => customers.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _editIndex == null ? "Tambah Pelanggan Baru" : "Edit Pelanggan",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Nama Pelanggan
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: "Nama Pelanggan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Jenis Kelamin
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: "Jenis Kelamin",
                border: OutlineInputBorder(),
              ),
              items: [
                ...genders.map(
                  (gen) => DropdownMenuItem<String>(
                    value: gen,
                    child: Text(gen),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
            ),
            const SizedBox(height: 12),

            // Jumlah Pembelian (hanya ditampilkan saat edit, tidak bisa diubah manual)
            if (_editIndex != null)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Jumlah Pembelian",
                  hintText: "${customers[_editIndex!]["purchaseCount"]}",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 24),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveCustomer,
                child: Text(
                  _editIndex == null ? "Tambah Pelanggan" : "Update Pelanggan",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Manajemen Pelanggan",
      showProfile: true,
      body: Stack(
        children: [
          // Konten utama
          Column(
            children: [
              const SizedBox(height: 16),

              // HEADER + ADD BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Pelanggan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showAddEditDialog,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // LIST PELANGGAN
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final c = filteredCustomers[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c["gender"],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "${c["purchaseCount"]} Pembelian",
                                        style: const TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () => _editCustomer(customers.indexOf(c)),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _deleteCustomer(customers.indexOf(c)),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}