import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';

class AccountRepository {
  final dbHelper = DatabaseHelper();

  Future<void> createAccount(Account account) async {
    await dbHelper.insertAccount(account.toMap());
  }

  Future<Account> retrieveAccount(String id) async {
    final result = await dbHelper.getAccount(id);
    return Account.fromMap(result);
  }

  Future<List<Account>> retrieveAccounts() async {
    final result = await dbHelper.getAccounts();
    return result.map((map) => Account.fromMap(map)).toList();
  }

  Future<void> updateAccount(Account account) async {
    if (account.id != null) {
      await dbHelper.updateAccount(account.id!, account.toMap());
    }
  }

  Future<void> deleteAccount(String id) async {
    await dbHelper.deleteAccount(id);
  }
}
