import 'package:flutter_finance_app/entity/asset.dart';

class Account {
  String? id;
  String name;
  String color;
  String currency;
  double balance;
  String change;
  int lastUpdateTime;
  int createTime;
  List<Asset> assets;

  Account({
    this.id,
    required this.name,
    required this.color,
    required this.currency,
    required this.balance,
    required this.change,
    required this.lastUpdateTime,
    required this.createTime,
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
      'lastUpdateTime': lastUpdateTime,
      'createTime': createTime
    };
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
      lastUpdateTime: map['lastUpdateTime'],
      createTime: map['createTime'],
      assets: [],
    );
  }
}
