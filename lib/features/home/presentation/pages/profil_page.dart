import 'package:flutter/material.dart';
import 'package:pruno_dev/features/home/presentation/pages/connexion_page.dart';
import 'package:pruno_dev/services/api_service.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGold = Color(0xFF775A19);
    const Color secondaryBrown = Color(0xFF6B4F31);
    const Color bgColor = Color(0xFFFCF9F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?u=benny'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: primaryGold,
                            radius: 18,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Dohou Lorad",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                        color: secondaryBrown,
                      ),
                    ),
                    const Text(
                      "Membre Privilège",
                      style: TextStyle(
                          color: primaryGold,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuCard([
                _buildMenuItem(
                    Icons.person_outline, "Informations personnelles"),
                _buildMenuItem(Icons.notifications_none, "Notifications"),
                _buildMenuItem(
                    Icons.history, "Historique des réservations"),
              ]),
              const SizedBox(height: 20),
              _buildMenuCard([
                _buildMenuItem(Icons.shield_outlined, "Sécurité"),
                _buildMenuItem(Icons.help_outline, "Aide & Support"),
                _buildMenuItem(
                    Icons.info_outline, "À propos de BeautyTime"),
              ]),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ApiService.setToken('');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const ConnexionPage()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    "Se déconnecter",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF775A19), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }
}