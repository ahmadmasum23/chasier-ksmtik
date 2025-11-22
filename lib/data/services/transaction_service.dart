import '../models/transaction_model.dart';
import '../../core/utils/supabase_helper.dart';

class TransactionService {
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final data = await SupabaseHelper.fetchTableData('transactions');
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      return [];
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final data = await SupabaseHelper.fetchTableData('transactions');
      final transactionData = data.firstWhere((transaction) => transaction['id'] == id, orElse: () => null);
      if (transactionData != null) {
        return TransactionModel.fromJson(transactionData);
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await SupabaseHelper.insertData('transactions', transaction.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await SupabaseHelper.updateData('transactions', transaction.id, transaction.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await SupabaseHelper.deleteData('transactions', id);
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete transaction: $e');
    }
  }
}