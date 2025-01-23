class AssetOperation {
  final String id;
  final String accountId;
  final String assetId;
  final double amount;
  final String description;
  final int recordedAt;
  final int createdAt;

  AssetOperation({
    required this.id,
    required this.accountId,
    required this.assetId,
    required this.amount,
    required this.description,
    required this.recordedAt,
    required this.createdAt,
  });

  // Factory method to create an AssetOperation from a map
  factory AssetOperation.fromMap(Map<String, dynamic> map) {
    final now = DateTime.now();
    return AssetOperation(
      id: map['id'],
      accountId: map['account_id'],
      assetId: map['asset_id'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      recordedAt: map['recorded_at'] ?? now.millisecondsSinceEpoch,
      createdAt: map['created_at'] ?? now.millisecondsSinceEpoch,
    );
  }

  // Method to convert an AssetOperation to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'account_id': accountId,
      'asset_id': assetId,
      'amount': amount,
      'description': description,
      'recorded_at': recordedAt,
      'created_at': createdAt,
    };
  }
}
