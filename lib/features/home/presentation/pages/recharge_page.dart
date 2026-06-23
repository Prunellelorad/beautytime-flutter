import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedMethod = "MTN MoMo";
  
  // Montants suggérés pour aller plus vite
  final List<int> _suggestions = [1000, 2000, 5000, 10000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Recharger mon compte", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SAISIE DU MONTANT ---
            const Text("Combien voulez-vous recharger ?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFB8860B)),
              decoration: InputDecoration(
                hintText: "Montant (FCFA)",
                suffixText: "FCFA",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
              ),
            ),
            const SizedBox(height: 15),
            
            // Suggestions de montants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _suggestions.map((amt) => _buildSuggestionChip(amt)).toList(),
            ),

            const SizedBox(height: 35),

            // --- 2. CHOIX DU RÉSEAU (BÉNIN) ---
            const Text("Moyen de recharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildMethodTile("MTN MoMo", Icons.account_balance_wallet),
            _buildMethodTile("Moov Money", Icons.payments_outlined),
            _buildMethodTile("Celtiis Cash", Icons.vibration),

            const SizedBox(height: 30),

            // --- 3. NUMÉRO DE TÉLÉPHONE ---
            const Text("Numéro de débit (+229)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                hintText: "01 XX XX XX XX",
                prefixText: "+229 ",
                prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.black12)),
              ),
            ),

            const SizedBox(height: 40),

            // --- BOUTON DE VALIDATION ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _processRecharge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("Lancer la recharge", 
                  style: TextStyle(color: Color(0xFFB8860B), fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(int amount) {
    return GestureDetector(
      onTap: () => setState(() => _amountController.text = amount.toString()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: _amountController.text == amount.toString() ? const Color(0xFFB8860B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFB8860B).withValues(alpha: 0.3)),
        ),
        child: Text("${amount}F", 
          style: TextStyle(
            color: _amountController.text == amount.toString() ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold
          )),
      ),
    );
  }

  Widget _buildMethodTile(String name, IconData icon) {
    bool isSelected = _selectedMethod == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8860B).withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFFB8860B) : Colors.black12, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFB8860B) : Colors.grey),
            const SizedBox(width: 15),
            Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFB8860B)),
          ],
        ),
      ),
    );
  }

  void _processRecharge() {
    if (_amountController.text.isEmpty || _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez remplir tous les champs correctement")));
      return;
    }
    // Ici, appel vers ton API Laravel pour initier le paiement FedaPay/CinetPay
    _showSuccessMessage();
  }

  void _showSuccessMessage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phonelink_ring, size: 60, color: Color(0xFFB8860B)),
            const SizedBox(height: 20),
            const Text("Validation en cours", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Veuillez confirmer le retrait de ${_amountController.text} FCFA sur votre téléphone ($_selectedMethod).",
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text("J'ai compris", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}