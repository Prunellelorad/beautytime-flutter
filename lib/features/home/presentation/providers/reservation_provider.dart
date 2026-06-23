import 'package:flutter/material.dart';

class ReservationProvider extends ChangeNotifier {
  DateTime _dateSelectionnee = DateTime.now(); 
  
  DateTime get dateSelectionnee => _dateSelectionnee;
  // On utilise une String pour l'heure afin de mieux contrôler l'affichage
  String _heureSelectionnee = "13:00"; 
  bool _estAuSalon = true;
  
  final double _prixService = 15000;
  final double _fraisReservation = 1000;
  final double _fraisDomicile = 2000;

  // Simulation des créneaux déjà pris (pour la notification de conflit)
  final List<String> _creneauxOccupes = ["09:00", "16:00"];

  // Getters
  
  String get heureSelectionnee => _heureSelectionnee;
  bool get estAuSalon => _estAuSalon;
  double get prixService => _prixService;
  double get fraisReservation => _fraisReservation;
  double get totalPrestation => _prixService + (_estAuSalon ? 0 : _fraisDomicile);
  double get totalAImmediat => totalPrestation + _fraisReservation;

  void updateLocation(bool auSalon) {
    _estAuSalon = auSalon;
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _dateSelectionnee = date;
    notifyListeners();
  }

  bool selectionnerHeure(String heure) {
    if (_creneauxOccupes.contains(heure)) return false;
    _heureSelectionnee = heure;
    notifyListeners();
    return true;
  }
}