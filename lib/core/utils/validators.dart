// class Validators {
//   static String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email tidak boleh kosong';
//     }
    
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Format email tidak valid';
//     }
    
//     return null;
//   }

//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password tidak boleh kosong';
//     }
    
//     if (value.length < 6) {
//       return 'Password harus lebih dari 6 karakter';
//     }
    
//     return null;
//   }

//   static String? validateRequired(String? value, String fieldName) {
//     if (value == null || value.isEmpty) {
//       return '$fieldName tidak boleh kosong';
//     }
    
//     return null;
//   }

//   static String? validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Nomor telepon tidak boleh kosong';
//     }
    
//     final phoneRegex = RegExp(r'^[0-9]{10,13}$');
//     if (!phoneRegex.hasMatch(value)) {
//       return 'Format nomor telepon tidak valid';
//     }
    
//     return null;
//   }
// }