// To parse this JSON data, do
//
//     final transactionList = transactionListFromJson(jsonString);

import 'dart:convert';

TransactionList transactionListFromJson(String str) => TransactionList.fromJson(json.decode(str));

String transactionListToJson(TransactionList data) => json.encode(data.toJson());

class TransactionList {
  String? message;
  List<Transaction>? transactions;

  TransactionList({
    this.message,
    this.transactions,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) => TransactionList(
    message: json["message"],
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Transaction {
  int? id;
  String? razorpayOrderId;
  String? razorpayPaymentId;
  String? razorpaySignature;
  int? uId;
  int? amount;
  String? paymentDate;
  String? paymentTime;
  bool? dekshinaPaymentStatus;
  String? type;
  bool? donationPaymentStatus;
  bool? feePaymentStatus;
  bool? maintenancePaymentStatus;

  Transaction({
    this.id,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.razorpaySignature,
    this.uId,
    this.amount,
    this.paymentDate,
    this.paymentTime,
    this.dekshinaPaymentStatus,
    this.type,
    this.donationPaymentStatus,
    this.feePaymentStatus,
    this.maintenancePaymentStatus,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    razorpayOrderId: json["razorpay_order_id"],
    razorpayPaymentId: json["razorpay_payment_id"],
    razorpaySignature: json["razorpay_signature"],
    uId: json["UId"],
    amount: json["amount"],
    paymentDate: json["payment_date"],
    paymentTime: json["payment_time"],
    dekshinaPaymentStatus: json["dekshina_payment_status"],
    type: json["type"],
    donationPaymentStatus: json["donation_payment_status"],
    feePaymentStatus: json["fee_payment_status"],
    maintenancePaymentStatus: json["maintenance_payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "razorpay_order_id": razorpayOrderId,
    "razorpay_payment_id": razorpayPaymentId,
    "razorpay_signature": razorpaySignature,
    "UId": uId,
    "amount": amount,
    "payment_date": paymentDate,
    "payment_time": paymentTime,
    "dekshina_payment_status": dekshinaPaymentStatus,
    "type": type,
    "donation_payment_status": donationPaymentStatus,
    "fee_payment_status": feePaymentStatus,
    "maintenance_payment_status": maintenancePaymentStatus,
  };
}
