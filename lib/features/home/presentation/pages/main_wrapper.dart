import 'package:flutter/material.dart';
import 'package:pruno_dev/features/home/presentation/pages/profil_page.dart';
import 'home_page.dart';
import 'reservation_page.dart';
import 'portefeuille_page.dart';


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0; // L'index qui change au clic

  // Liste des pages correspondantes aux icônes
  final List<Widget> _pages = [
    const HomePage(),          // Index 0
    const ReservationPage(),   // Index 1
    const PortefeuillePage(), //Index 2
    const ProfilPage(), // Index 3

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le body affiche la page selon l'index actuel
      body: _pages[_currentIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // C'EST ICI QUE LE CONTENU CHANGE
          setState(() {
            _currentIndex = index; 
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF775A19),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'DÉCOUVRIR'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'RDV'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'PORTEFEUILLE'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFIL'),
        ],
      ),
    );
  }
}