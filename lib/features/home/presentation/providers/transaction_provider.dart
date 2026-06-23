import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final double _balance = 50000.0;
  double get balance => _balance;

  final List<TransactionModel> _transactions = [
    TransactionModel(
      title: "Soin Éclat Visage",
      date: "24 Oct 2023",
      reference: "Réservation #8291",
      amount: 25000,
      status: "CONFIRMÉ",
      icon: Icons.spa_outlined,
    ),
    TransactionModel(
      title: "Rechargement MoMo",
      date: "20 Oct 2023",
      reference: "Via +237 6xx xxx 445",
      amount: 50000,
      status: "SUCCÈS",
      icon: Icons.add_circle_outline,
      isPositive: true,
    ),
    TransactionModel(
      title: "Coupe & Coiffage Editorial",
      date: "15 Oct 2023",
      reference: "Réservation #8104",
      amount: 15000,
      status: "CONFIRMÉ",
      icon: Icons.content_cut,
    ),
  ];

  List<TransactionModel> get transactions => _transactions;
}