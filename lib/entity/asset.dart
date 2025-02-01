import 'dart:convert';

class Asset {
  String? id;
  String name;
  double amount;
  String currency;
  String tag;
  String note;
  String accountId;
  bool enableCounting;
  int createdAt; // Use int for timestamp
  int updatedAt; // Use int for timestamp
  String type; // New field for asset type
  Map<String, dynamic> extra; // Change extra to Map

  Asset({
    this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.tag,
    required this.note,
    required this.accountId,
    required this.enableCounting,
    required this.createdAt,
    required this.updatedAt,
    required this.type, // Initialize new field
    required this.extra, // Initialize new field
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'currency': currency,
      'tag': tag,
      'note': note,
      'accountId': accountId,
      'enableCounting': enableCounting ? 1 : 0, // Convert bool to int
      'createdAt': createdAt, // Store as timestamp
      'updatedAt': updatedAt, // Store as timestamp
      'type': type, // Add new field to map
      'extra': jsonEncode(extra), // Convert Map to JSON string
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      currency: map['currency'],
      tag: map['tag'],
      note: map['note'],
      accountId: map['accountId'],
      enableCounting: map['enableCounting'] == 1,
      // Convert int to bool
      createdAt: map['createdAt'],
      // Parse timestamp
      updatedAt: map['updatedAt'],
      // Parse timestamp
      type: map['type'],
      // Parse new field
      extra: jsonDecode(map['extra']), // Parse JSON string to Map
    );
  }

  factory Asset.fromJson(String jsonString) {
    final map = jsonDecode(jsonString);
    return Asset.fromMap(map);
  }
}
