import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salon_provider.dart';
import '../widgets/salon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final salonProvider = context.watch<SalonProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(salonProvider),
              _buildFilters(salonProvider),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SÉLECTION SUR MESURE",
                      style: TextStyle(
                        color: Color(0xFFC49A6C),
                        letterSpacing: 1.5,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Salons Recommandés",
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Voir tout",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 380,
                child: _buildSalonList(salonProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS INTERNES (SANS MODIFICATION) ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bienvenue sur BeautyTime",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4F31),
            ),
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=a042581f4e29026704d',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SalonProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          provider.setSearchQuery(value);
        },
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFFC49A6C)),
          hintText: "Trouvez votre prochain style",
          border: InputBorder.none,
          suffixIcon: Icon(Icons.tune),
        ),
      ),
    );
  }

  Widget _buildFilters(SalonProvider provider) {
    final filters = ["Tout découvrir", "Coiffure", "Barbier", "Esthetique", "Soins"];
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isSelected = provider.selectedCategorie == filters[index];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  provider.setCategorie(filters[index]);
                }
              },
              selectedColor: const Color(0xFFC49A6C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalonList(SalonProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC49A6C)),
      );
    }
    if (provider.salons.isEmpty) {
      return const Center(
        child: Text(
          "Aucun établissement disponible ici",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20),
      scrollDirection: Axis.horizontal,
      itemCount: provider.salons.length,
      itemBuilder: (context, index) => SalonCard(salon: provider.salons[index]),
    );
  }
}