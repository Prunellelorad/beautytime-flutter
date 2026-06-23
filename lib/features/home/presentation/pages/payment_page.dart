import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final double totalService;
  final double bookingFees;

  const PaymentPage({
    super.key, 
    required this.totalService, 
    required this.bookingFees
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // --- ÉTATS ---
  bool _payOnlyBooking = true; 
  String _selectedMethod = "MTN MoMo"; // Valeur par défaut (Bénin)
  final TextEditingController _phoneController = TextEditingController();

  // Liste des opérateurs au Bénin
  final List<String> _beninMethods = ["MTN MoMo", "Moov Money", "Celtiis Cash"];

  @override
  Widget build(BuildContext context) {
    double amountToPay = _payOnlyBooking 
        ? widget.bookingFees 
        : (widget.totalService + widget.bookingFees);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("Paiement Bénin", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountDisplay(amountToPay),
            const SizedBox(height: 30),

            const Text("Option de règlement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildChoiceTile(
              title: "Frais de réservation",
              amount: widget.bookingFees,
              isSelected: _payOnlyBooking,
              onTap: () => setState(() => _payOnlyBooking = true),
            ),
            _buildChoiceTile(
              title: "Totalité du service",
              amount: widget.totalService + widget.bookingFees,
              isSelected: !_payOnlyBooking,
              onTap: () => setState(() => _payOnlyBooking = false),
            ),

            const SizedBox(height: 30),

            // --- MENU DÉROULANT (MTN, MOOV, CELTIIS) ---
            const Text("Mode de paiement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMethod,
                  isExpanded: true,
                  items: _beninMethods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) => setState(() => _selectedMethod = val!),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- NUMÉRO DE TÉLÉPHONE (Format Bénin 10 chiffres) ---
            const Text("Numéro Mobile Money", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "01 XX XX XX XX",
                prefixIcon: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("+229 ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _handleFinalPayment(amountToPay),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8860B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  "Payer ${amountToPay.toInt()} FCFA",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTIONS ---

  Widget _buildAmountDisplay(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          const Text("Montant à régler", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 5),
          Text("${amount.toInt()} FCFA", style: const TextStyle(color: Color(0xFFB8860B), fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildChoiceTile({required String title, required double amount, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB8860B).withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFB8860B) : Colors.black12, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? const Color(0xFFB8860B) : Colors.black26),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                Text("${amount.toInt()} FCFA", style: const TextStyle(color: Color(0xFFB8860B), fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleFinalPayment(double total) {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez saisir un numéro valide à 10 chiffres (Bénin)")),
      );
      return;
    }
    // Simulation du Push USSD
    debugPrint("Envoi de la requête de paiement vers $_selectedMethod au +229${_phoneController.text}");
    _showSuccessDialog(total);
  }

  void _showSuccessDialog(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          "Paiement de ${total.toInt()} FCFA initié.\nVeuillez confirmer sur votre téléphone.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }
}