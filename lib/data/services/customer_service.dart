import '../models/customer_model.dart';
import '../../core/utils/supabase_helper.dart';

class CustomerService {
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final data = await SupabaseHelper.fetchTableData('customers');
      return data.map((json) => CustomerModel.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      return [];
    }
  }

  Future<CustomerModel?> getCustomerById(String id) async {
    try {
      final data = await SupabaseHelper.fetchTableData('customers');
      final customerData = data.firstWhere((customer) => customer['id'] == id, orElse: () => null);
      if (customerData != null) {
        return CustomerModel.fromJson(customerData);
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    try {
      await SupabaseHelper.insertData('customers', customer.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to add customer: $e');
    }
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      await SupabaseHelper.updateData('customers', customer.id, customer.toJson());
    } catch (e) {
      // Handle error
      throw Exception('Failed to update customer: $e');
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await SupabaseHelper.deleteData('customers', id);
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete customer: $e');
    }
  }
}