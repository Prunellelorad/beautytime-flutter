import 'artisan.dart';

class Salon {
  final int id;
  final String name;
  final String subTitle;
  final String categorie;
  final String distance;
  final double rating;
  final String ouverture;
  final String fermeture;
  final String imageUrl;
  final List<Artisan> artisans;
  final bool isPremium;

  Salon({
    this.id = 0,
    required this.name,
    required this.subTitle,
    required this.categorie,
    required this.distance,
    required this.ouverture,
    required this.fermeture,
    required this.rating,
    required this.imageUrl,
    required this.artisans,
    this.isPremium = false,
  });
}