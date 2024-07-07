class WithdrawalRequest {
  String id;
  String userId;
  double amount;
  WithdrawalStatus status;

  WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
  });

  factory WithdrawalRequest.fromMap(Map<String, dynamic> map) {
    return WithdrawalRequest(
      id: map['id'] as String? ?? '',
      userId: map['userID'] as String? ?? '',
      amount: (map['withdrawal amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] == 'approved'
          ? WithdrawalStatus.approved
          : WithdrawalStatus.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userId,
      'withdrawal amount': amount,
      'status': status == WithdrawalStatus.approved ? 'approved' : 'pending',
    };
  }
}

enum WithdrawalStatus {
  pending,
  approved,
}
