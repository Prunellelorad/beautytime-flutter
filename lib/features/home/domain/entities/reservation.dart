class Reservation {
  final String date;
  final String heure;
  final bool isAtSalon;
  final double prixService;
  final double fraisReservation;

  Reservation({
    required this.date,
    required this.heure,
    required this.isAtSalon,
    required this.prixService,
    this.fraisReservation = 1000, // Frais fixes de réservation
  });

  // Calcul dynamique du total
  double get total => prixService + fraisReservation + (isAtSalon ? 0 : 2000);
}