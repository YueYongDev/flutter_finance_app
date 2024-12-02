class Account {
  final String? id;
  final String name;
  final String color;
  final String currency;

  Account({
    this.id,
    required this.name,
    required this.color,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'currency': currency,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      currency: map['currency'],
    );
  }
}
