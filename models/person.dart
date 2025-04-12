import 'dart:convert';

class Transaction {
  final int amount;
  final String description;
  final bool isGiven;

  Transaction({required this.amount, required this.description, required this.isGiven});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'isGiven': isGiven,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      description: json['description'],
      isGiven: json['isGiven'],
    );
  }
}

class Person {
  final String name;
  int balance;
  List<Transaction> transactions;

  Person({required this.name, this.balance = 0, List<Transaction>? transactions})
      : transactions = transactions ?? [];

  void addTransaction(int amount, String description, bool isGiven) {
    transactions.add(Transaction(amount: amount, description: description, isGiven: isGiven));
    balance += isGiven ? amount : -amount;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'balance': balance,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      balance: json['balance'],
      transactions: (json['transactions'] as List<dynamic>)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }
}
