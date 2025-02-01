import 'dart:convert';

import 'package:flutter_finance_app/entity/asset.dart';

class Account {
  String? id;
  String name;
  String color;
  String currency;
  double balance;
  String change;
  int updatedAt;
  int createdAt;
  String type;
  Map<String, dynamic> extra; // Change extra to Map
  List<Asset> assets;

  Account({
    this.id,
    required this.name,
    required this.color,
    required this.currency,
    required this.balance,
    required this.change,
    required this.updatedAt,
    required this.createdAt,
    required this.type,
    required this.extra, // Initialize new field
    required this.assets,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'currency': currency,
      'balance': balance,
      'change': change,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'type': type,
      'extra': jsonEncode(extra), // Convert Map to JSON string
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    String color = map['color'];
    if (!color.startsWith('0xFF')) {
      color = '0xFF$color';
    }
    return Account(
      id: map['id'],
      name: map['name'],
      color: color,
      currency: map['currency'],
      balance: map['balance'],
      change: map['change'],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
      type: map['type'],
      extra: jsonDecode(map['extra']),
      // Parse JSON string to Map
      assets: [],
    );
  }

  factory Account.fromJson(String jsonString) {
    final map = jsonDecode(jsonString);
    return Account.fromMap(map);
  }
}
