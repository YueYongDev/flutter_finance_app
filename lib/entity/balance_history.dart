import 'package:flutter/cupertino.dart';
import 'dart:convert'; // Added import for jsonEncode and jsonDecode

class BalanceHistory {
  String? id;
  String? accountId; // 新增字段，如果为null则表示是所有账户的总余额
  double totalBalance;
  int recordedAt;
  int createdAt;

  BalanceHistory({
    this.id,
    this.accountId,
    required this.totalBalance,
    required this.recordedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'total_balance': totalBalance,
      'recorded_at': recordedAt,
      'created_at': createdAt,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory BalanceHistory.fromMap(Map<String, dynamic> map) {
    return BalanceHistory(
      id: map['id'],
      accountId: map['account_id'],
      totalBalance: map['total_balance'] as double,
      recordedAt: map['recorded_at'] as int,
      createdAt: map['created_at'] as int,
    );
  }

  factory BalanceHistory.fromJson(String jsonString) {
    final map = jsonDecode(jsonString);
    return BalanceHistory.fromMap(map);
  }

  @override
  String toString() {
    return 'BalanceHistory{id: $id, accountId: $accountId, totalBalance: $totalBalance, recordedAt: $recordedAt, createdAt: $createdAt}';
  }
}
