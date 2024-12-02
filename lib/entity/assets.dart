class Asset {
  final String? id;
  final String name;
  final double amount;
  final String currency;
  final String tag;
  final String note;
  final String accountId;
  final String countInfo;

  Asset({
    this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.tag,
    required this.note,
    required this.accountId,
    required this.countInfo,
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
      'countInfo': countInfo,
    };
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
      countInfo: map['countInfo'],
    );
  }
}
