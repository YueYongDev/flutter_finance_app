class Asset {
  String? id;
  String name;
  double amount;
  String currency;
  String tag;
  String note;
  String accountId;
  bool enableCounting;

  Asset({
    this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.tag,
    required this.note,
    required this.accountId,
    required this.enableCounting,
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
      enableCounting: map['enableCounting'] == 1, // Convert int to bool
    );
  }
}