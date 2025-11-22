import '../models/stock_model.dart';
import '../../core/utils/supabase_helper.dart';

class StockService {
  Future<List<StockModel>> getAllStockItems() async {
    try {
      final data = await SupabaseHelper.fetchTableData('stock');
      return data.map((json) => StockModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      return [];
    }
  }

  Future<StockModel?> getStockItemById(String id) async {
    try {
      final data = await SupabaseHelper.fetchTableData('stock');
      final stockData = data.firstWhere((item) => item['id'] == id, orElse: () => null);
      if (stockData != null) {
        return StockModel.fromJson(stockData);
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> addStockItem(StockModel stockItem) async {
    try {
      await SupabaseHelper.insertData('stock', stockItem.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to add stock item: $e');
    }
  }

  Future<void> updateStockItem(StockModel stockItem) async {
    try {
      await SupabaseHelper.updateData('stock', stockItem.id, stockItem.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to update stock item: $e');
    }
  }

  Future<void> deleteStockItem(String id) async {
    try {
      await SupabaseHelper.deleteData('stock', id);
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete stock item: $e');
    }
  }
}