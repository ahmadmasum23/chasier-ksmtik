import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatRupiahDouble(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static int parseRupiah(String formattedAmount) {
    // Remove 'Rp ' and any non-numeric characters except commas and dots
    final cleaned = formattedAmount
        .replaceAll('Rp ', '')
        .replaceAll('.', '')
        .replaceAll(',', '');
    
    return int.tryParse(cleaned) ?? 0;
  }
}