import 'package:flutter/material.dart';
import '../../domain/entities/salon.dart';
import '../../domain/entities/artisan.dart';
import 'package:pruno_dev/services/api_service.dart';

class SalonProvider extends ChangeNotifier {
  List<Salon> _allSalons = [];
  String _selectedCategorie = "Tout découvrir";
  String _searchQuery = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get selectedCategorie => _selectedCategorie;

  List<Salon> get salons {
    return _allSalons.where((salon) {
      final matchesCategory = _selectedCategorie == "Tout découvrir" ||
          salon.categorie == _selectedCategorie;
      final matchesSearch = salon.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setCategorie(String categorie) {
    _selectedCategorie = categorie;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchSalons() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getSalons();
      _allSalons = data.map((json) {
        final id = json['id'] as int;
        return Salon(
          id: id,
          name: json['name'] ?? '',
          subTitle: json['sub_title'] ?? '',
          categorie: json['categorie'] ?? '',
          distance: json['distance'] ?? '',
          rating: (json['rating'] as num).toDouble(),
          ouverture: json['ouverture'] ?? '',
          fermeture: json['fermeture'] ?? '',
          imageUrl: json['image_url'] ?? '',
          isPremium: json['is_premium'] == 1 || json['is_premium'] == true,
          artisans: _getArtisansPourSalon(id),
        );
      }).toList();
    } catch (e) {
      _allSalons = _localSalons();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Artisan> _getArtisansPourSalon(int id) {
    final Map<int, List<Artisan>> artisans = {
      1: [
        Artisan(name: "Kofi", role: "Expert Coloriste",
            imageUrl: "https://picsum.photos/seed/kofi/300/300", isDirector: true),
        Artisan(name: "Mia", role: "Styliste Visagiste",
            imageUrl: "https://picsum.photos/seed/mia/300/300", isDirector: false),
      ],
      2: [
        Artisan(name: "Pierre", role: "Spécialiste Soins",
            imageUrl: "https://picsum.photos/seed/pierre/300/300", isDirector: true),
        Artisan(name: "Yasmine", role: "Esthéticienne",
            imageUrl: "https://picsum.photos/seed/yasmine/300/300", isDirector: false),
      ],
      3: [
        Artisan(name: "Nathan", role: "Maître Barbier",
            imageUrl: "https://picsum.photos/seed/nathan/300/300", isDirector: true),
        Artisan(name: "Boris", role: "Barbier Senior",
            imageUrl: "https://picsum.photos/seed/boris/300/300", isDirector: false),
      ],
      4: [
        Artisan(name: "Clara", role: "Expert Coloriste",
            imageUrl: "https://picsum.photos/seed/clara/300/300", isDirector: true),
        Artisan(name: "Alex", role: "Styliste",
            imageUrl: "https://picsum.photos/seed/alex/300/300", isDirector: false),
      ],
      5: [
        Artisan(name: "Wale", role: "Barbier Expert",
            imageUrl: "https://picsum.photos/seed/wale/300/300", isDirector: true),
        Artisan(name: "Luc", role: "Barbier Junior",
            imageUrl: "https://picsum.photos/seed/luc/300/300", isDirector: false),
      ],
      6: [
        Artisan(name: "Omar", role: "Spécialiste Soins",
            imageUrl: "https://picsum.photos/seed/omar/300/300", isDirector: true),
        Artisan(name: "Vera", role: "Esthéticienne",
            imageUrl: "https://picsum.photos/seed/vera/300/300", isDirector: false),
      ],
    };
    return artisans[id] ?? [
      Artisan(name: "Artisan", role: "Expert",
          imageUrl: "https://picsum.photos/seed/$id/300/300", isDirector: true),
    ];
  }

  List<Salon> _localSalons() {
    return [
      Salon(
        id: 1,
        name: "L'Atelier d'Or",
        subTitle: "Haute Coiffure & Spa",
        categorie: "Coiffure",
        distance: "0.8 km",
        rating: 4.9,
        ouverture: "10:00",
        fermeture: "22:00",
        imageUrl: "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500",
        isPremium: true,
        artisans: [
          Artisan(name: "Kofi", role: "Expert Coloriste",
              imageUrl: "https://picsum.photos/seed/kofi/300/300", isDirector: true),
          Artisan(name: "Mia", role: "Styliste Visagiste",
              imageUrl: "https://picsum.photos/seed/mia/300/300", isDirector: false),
        ],
      ),
      Salon(
        id: 2,
        name: "Maison de Beauté",
        subTitle: "Facial Specialist",
        categorie: "Soins",
        distance: "1.2 km",
        rating: 4.8,
        ouverture: "09:30",
        fermeture: "19:30",
        imageUrl: "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=500",
        isPremium: false,
        artisans: [
          Artisan(name: "Pierre", role: "Spécialiste Soins",
              imageUrl: "https://picsum.photos/seed/pierre/300/300", isDirector: true),
          Artisan(name: "Yasmine", role: "Esthéticienne",
              imageUrl: "https://picsum.photos/seed/yasmine/300/300", isDirector: false),
        ],
      ),
      Salon(
        id: 3,
        name: "The Heritage Barber",
        subTitle: "Classic Grooming",
        categorie: "Barbier",
        distance: "2.4 km",
        rating: 5.0,
        ouverture: "09:00",
        fermeture: "22:00",
        imageUrl: "https://images.unsplash.com/photo-1503951914875-452162b0f3f1?q=80&w=500",
        isPremium: true,
        artisans: [
          Artisan(name: "Nathan", role: "Maître Barbier",
              imageUrl: "https://picsum.photos/seed/nathan/300/300", isDirector: true),
          Artisan(name: "Boris", role: "Barbier Senior",
              imageUrl: "https://picsum.photos/seed/boris/300/300", isDirector: false),
        ],
      ),
      Salon(
        id: 4,
        name: "L'Atelier d'Or",
        subTitle: "Haute Coiffure & Spa",
        categorie: "Esthetique",
        distance: "0.8 km",
        rating: 4.9,
        ouverture: "11:00",
        fermeture: "22:00",
        imageUrl: "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=500",
        isPremium: true,
        artisans: [
          Artisan(name: "Clara", role: "Expert Coloriste",
              imageUrl: "https://picsum.photos/seed/clara/300/300", isDirector: true),
          Artisan(name: "Alex", role: "Styliste",
              imageUrl: "https://picsum.photos/seed/alex/300/300", isDirector: false),
        ],
      ),
      Salon(
        id: 5,
        name: "Maison de Beauté",
        subTitle: "Facial Specialist",
        categorie: "Barbier",
        distance: "1.2 km",
        rating: 4.8,
        ouverture: "08:00",
        fermeture: "22:00",
        imageUrl: "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=500",
        isPremium: false,
        artisans: [
          Artisan(name: "Wale", role: "Barbier Expert",
              imageUrl: "https://picsum.photos/seed/wale/300/300", isDirector: true),
          Artisan(name: "Luc", role: "Barbier Junior",
              imageUrl: "https://picsum.photos/seed/luc/300/300", isDirector: false),
        ],
      ),
      Salon(
        id: 6,
        name: "The Heritage Barber",
        subTitle: "Classic Grooming",
        categorie: "Soins",
        distance: "2.4 km",
        rating: 5.0,
        ouverture: "09:00",
        fermeture: "20:00",
        imageUrl: "https://images.unsplash.com/photo-1503951914875-452162b0f3f1?q=80&w=500",
        isPremium: true,
        artisans: [
          Artisan(name: "Omar", role: "Spécialiste Soins",
              imageUrl: "https://picsum.photos/seed/omar/300/300", isDirector: true),
          Artisan(name: "Vera", role: "Esthéticienne",
              imageUrl: "https://picsum.photos/seed/vera/300/300", isDirector: false),
        ],
      ),
    ];
  }
}