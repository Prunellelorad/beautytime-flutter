import 'package:flutter/material.dart';
import 'package:pruno_dev/services/api_service.dart';
import 'recharge_page.dart';

class TransactionModel {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class PortefeuillePage extends StatefulWidget {
  const PortefeuillePage({super.key});

  @override
  State<PortefeuillePage> createState() => _PortefeuillePageState();
}

class _PortefeuillePageState extends State<PortefeuillePage> {
  double balance = 25000.0;
  bool _isLoading = false;

  List<TransactionModel> history = [
    TransactionModel(
        title: "Réservation Coiffure",
        date: "Hier, 16:20",
        amount: 15000,
        isCredit: false),
    TransactionModel(
        title: "Rechargement Celtiis",
        date: "08 Mars 2026",
        amount: 10000,
        isCredit: true),
  ];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getReservations();
      final List<TransactionModel> reservations = data.map((r) {
        return TransactionModel(
          title: "Réservation — Salon #${r['salon_id']}",
          date: "${r['date']} à ${r['heure']}",
          amount: (r['total'] as num).toDouble(),
          isCredit: false,
        );
      }).toList();

      setState(() {
        // Ajoute les réservations réelles en haut
        for (var r in reservations) {
          if (!history.any((h) => h.title == r.title && h.date == r.date)) {
            history.insert(0, r);
          }
        }
      });
    } catch (e) {
      // Garde l'historique local si erreur
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Mon Portefeuille",
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _loadReservations,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWalletCard(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Activités récentes",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          if (_isLoading)
            const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFB8860B)))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return _transactionTile(history[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Colors.black]),
      ),
    
      child: Column(
        children: [
          const Text("Solde disponible",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text("${balance.toInt()} FCFA",
              style: const TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionBtn(Icons.add_circle, "Recharger"),
              _actionBtn(Icons.file_download, "Retirer"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return GestureDetector(
      onTap: () async {
        if (label == "Recharger") {
          final double? montantAjoute = await Navigator.push<double>(
              context,
              MaterialPageRoute(
                  builder: (context) => const RechargePage()));

          if (montantAjoute != null) {
            setState(() {
              balance += montantAjoute;
              history.insert(
                  0,
                  TransactionModel(
                    title: "Rechargement compte",
                    date: "À l'instant",
                    amount: montantAjoute,
                    isCredit: true,
                  ));
            });
          }
        }
      },
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB8860B), size: 30),
          const SizedBox(height: 5),
          Text(label,
              style:
                  const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _transactionTile(TransactionModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.isCredit
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          child: Icon(item.isCredit ? Icons.add : Icons.remove,
              color: item.isCredit ? Colors.green : Colors.red),
        ),
        title: Text(item.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.date),
        trailing: Text(
          "${item.isCredit ? '+' : '-'} ${item.amount.toInt()} F",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isCredit ? Colors.green : Colors.black),
        ),
      ),
    );
  }
}