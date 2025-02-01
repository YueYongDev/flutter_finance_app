import 'dart:convert';

import 'package:flutter_finance_app/enum/operation_log_enum.dart';

class OperationLog {
  final String id;
  final String operationType;
  final String accountId;
  final String? assetId;
  final String key;
  final String value;
  final Map<String, dynamic>? extra;
  final int createdAt;
  final int updatedAt;

  OperationLog({
    required this.id,
    required this.operationType,
    required this.accountId,
    this.assetId,
    required this.key,
    required this.value,
    this.extra,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operation_type': operationType,
      'account_id': accountId,
      'asset_id': assetId,
      'key': key,
      'value': value,
      'extra': jsonEncode(extra),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory OperationLog.fromMap(Map<String, dynamic> map) {
    return OperationLog(
      id: map['id'],
      operationType: map['operation_type'],
      accountId: map['account_id'],
      assetId: map['asset_id'],
      key: map['key'],
      value: map['value'],
      extra: jsonDecode(map['extra']),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  String getDisplayOperationType() {
    return OperationLogTypeEnum.values
        .firstWhere((log) => log.name == operationType)
        .displayName;
  }

  String getDisplayOperationKey() {
    return OperationLogKeyEnum.values
        .firstWhere((log) => log.name == key)
        .displayName;
  }
}
