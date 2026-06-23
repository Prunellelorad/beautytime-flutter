import 'package:flutter/material.dart';
import 'package:pruno_dev/features/home/presentation/pages/payment_page.dart';
import 'package:pruno_dev/services/api_service.dart';

class ReservationPage extends StatefulWidget {
  final int? salonId;
  final String? salonName;
  final String? salonCategory;

  const ReservationPage({
    super.key,
    this.salonId,
    this.salonName,
    this.salonCategory,
  });

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final TextEditingController _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isAtHome = false;
  bool _isLoading = false;

  final String serviceName = "Soin Signature Éclat";
  final double servicePrice = 15000;
  final double homeServiceFee = 2000;
  final double bookingFees = 1000;

  String get salonName => widget.salonName ?? "Studio Le Rituel - Plateau";
  String get category => widget.salonCategory ?? "Coiffure Femme";
  int get salonId => widget.salonId ?? 1;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB8860B),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB8860B),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  Future<void> _validerReservation() async {
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez choisir une heure"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final date =
          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";

      await ApiService.createReservation(
        salonId: salonId,
        date: date,
        heure: _timeController.text,
        isAtSalon: !_isAtHome,
        prixService: servicePrice,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Réservation enregistrée !"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            totalService: servicePrice + (_isAtHome ? homeServiceFee : 0),
            bookingFees: bookingFees,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la réservation"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double currentTotal =
        servicePrice + bookingFees + (_isAtHome ? homeServiceFee : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          "Réserver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildOptionTab("Au salon", !_isAtHome, Icons.storefront),
                  _buildOptionTab(
                      "À domicile", _isAtHome, Icons.home_outlined),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Choisir la date"),
            const SizedBox(height: 10),
            _buildPickerTile(
              onTap: () => _selectDate(context),
              icon: Icons.calendar_month_outlined,
              value:
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
            ),
            const SizedBox(height: 25),
            _buildSectionTitle("Heure du rendez-vous"),
            const SizedBox(height: 10),
            _buildPickerTile(
              onTap: () => _selectTime(context),
              icon: Icons.access_time_rounded,
              value: _timeController.text.isEmpty
                  ? "Choisir l'heure"
                  : _timeController.text,
              isPlaceholder: _timeController.text.isEmpty,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Récapitulatif"),
            const SizedBox(height: 10),
            _buildRecapCard(currentTotal),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validerReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8860B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Passer au paiement",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTab(String label, bool isSelected, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isAtHome = (label == "À domicile")),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color:
                      isSelected ? const Color(0xFFB8860B) : Colors.black45),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerTile({
    required VoidCallback onTap,
    required IconData icon,
    required String value,
    bool isPlaceholder = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFB8860B)),
            const SizedBox(width: 15),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isPlaceholder ? Colors.black38 : Colors.black87,
              ),
            ),
            const Spacer(),
            const Text(
              "Modifier",
              style: TextStyle(
                color: Color(0xFFB8860B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecapCard(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEBE3)),
      ),
      child: Column(
        children: [
          _recapRow("Salon", salonName, isBold: true),
          _recapRow("Catégorie", category),
          _recapRow("Service", serviceName),
          const Divider(height: 30),
          _recapRow("Prix de service", "${servicePrice.toInt()} FCFA"),
          if (_isAtHome)
            _recapRow("Option : À domicile",
                "+ ${homeServiceFee.toInt()} FCFA"),
          _recapRow("Frais de réservation", "${bookingFees.toInt()} FCFA"),
          const SizedBox(height: 10),
          _recapRow(
            "TOTAL À RÉGLER",
            "${total.toInt()} FCFA",
            isBold: true,
            color: const Color(0xFFB8860B),
          ),
        ],
      ),
    );
  }

  Widget _recapRow(String label, String value,
      {bool isBold = false, Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}