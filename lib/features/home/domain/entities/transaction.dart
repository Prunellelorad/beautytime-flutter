import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String date;
  final String reference;
  final double amount;
  final String status;
  final IconData icon;
  final bool isPositive;

  TransactionModel({
    required this.title,
    required this.date,
    required this.reference,
    required this.amount,
    required this.status,
    required this.icon,
    this.isPositive = false,
  });
}