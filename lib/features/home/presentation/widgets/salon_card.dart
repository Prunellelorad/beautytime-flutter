import 'package:flutter/material.dart';
import 'package:pruno_dev/features/home/domain/entities/salon.dart';
import 'package:pruno_dev/features/home/presentation/pages/salon_detail_page.dart';

class SalonCard extends StatelessWidget {
  final Salon salon;

  const SalonCard({
    super.key, 
    required this.salon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers le détail du salon
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalonDetailPage(salon: salon),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION IMAGE ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    salon.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Image de secours si le lien est mort
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                if (salon.isPremium)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildPremiumBadge(),
                  ),
              ],
            ),

            // --- SECTION INFORMATIONS ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ligne : Nom et Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon.name,
                          style: const TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildRating(salon.rating),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Sous-titre
                  Text(
                    salon.subTitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),

                  const SizedBox(height: 12),

                  // --- LE STYLE DEMANDÉ : CATEGORIE | HEURES ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Catégorie
                        Text(
                          salon.categorie.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFB8860B),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        // Séparateur vertical
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: 10,
                          width: 1.5,
                          color: Colors.black12,
                        ),
                        // Horaires
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          "${salon.ouverture} — ${salon.fermeture}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // --- PIED DE CARTE ---
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        salon.distance,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Spacer(),
                      // Petit bouton d'action discret
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliaire : Badge Premium
  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB8860B).withValues(alpha: 0.4)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: Color(0xFFB8860B), size: 12),
          SizedBox(width: 4),
          Text(
            "PREMIUM",
            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget auxiliaire : Note
  Widget _buildRating(double rating) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFC49A6C), size: 18),
        const SizedBox(width: 2),
        Text(
          rating.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}