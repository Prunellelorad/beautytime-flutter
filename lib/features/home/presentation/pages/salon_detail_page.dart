import 'package:flutter/material.dart';
import '../../domain/entities/salon.dart';
import '../pages/reservation_page.dart';

class SalonDetailPage extends StatelessWidget {
  final Salon salon;

  const SalonDetailPage({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGallery(context),
                _buildHeaderInfo(),
                _buildTabs(),
                _buildServiceList(),
                _buildArtisanSection(),
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildFloatingBookingButton(context),
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(BuildContext context) {
    return Container(
      height: 380,
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(salon.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f",
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            "https://images.unsplash.com/photo-1562322140-8baeececf3df",
                            fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text("+12",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(salon.name,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif')),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  Text(" ${salon.distance}, Le Marais, Paris",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(children: [
                  const Icon(Icons.star, color: Color(0xFFC49A6C), size: 18),
                  Text(" ${salon.rating}",
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ]),
                const Text("128 AVIS",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tabItem("SERVICES", true),
          _tabItem("GALERIE", false),
          _tabItem("AVIS", false),
        ],
      ),
    );
  }

  Widget _tabItem(String title, bool isActive) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey[400])),
        if (isActive)
          Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 30,
              color: const Color(0xFF6B4F31)),
      ],
    );
  }

  Widget _buildServiceList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Coupe & Coiffage",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _serviceRow("Coupe Femme Signature",
              "Shampoing, soin, coupe et brushing.", "45 MIN", "65€"),
          const SizedBox(height: 20),
          _serviceRow(
              "Balayage Lumière", "Effet soleil naturel.", "120 MIN", "140€"),
        ],
      ),
    );
  }

  Widget _serviceRow(String name, String desc, String time, String price) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 5),
              Text("$time  •  $price",
                  style: const TextStyle(
                      color: Color(0xFF6B4F31), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Icon(Icons.add_circle_outline, color: Colors.grey),
      ],
    );
  }

  Widget _buildArtisanSection() {
    if (salon.artisans.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Nos Maîtres Artisans",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: salon.artisans.length,
            itemBuilder: (context, index) {
              final artisan = salon.artisans[index];
              return _artisanCard(
                artisan.name,
                artisan.role,
                artisan.imageUrl,
                artisan.isDirector,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _artisanCard(String name, String role, String img, bool isDirector) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(img,
                    height: 180, width: 140, fit: BoxFit.cover),
              ),
              if (isDirector)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF6B4F31),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Text("DIRECTOR",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFloatingBookingButton(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB88E5B),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationPage(
                salonId: salon.id,
                salonName: salon.name,
                salonCategory: salon.categorie,
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Réserver maintenant",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}