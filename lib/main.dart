import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- LES IMPORTS DE TES PAGES ---
import 'package:pruno_dev/features/home/presentation/pages/connexion_page.dart';// Le parent de la navigation

// --- LES IMPORTS DE TES PROVIDERS ---
import 'package:pruno_dev/features/home/presentation/providers/salon_provider.dart';
import 'package:pruno_dev/features/home/presentation/providers/reservation_provider.dart';
import 'package:pruno_dev/features/home/presentation/providers/transaction_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // Charge les salons dès le lancement
          create: (_) => SalonProvider()..fetchSalons(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReservationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyTime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Ta couleur marron/dorée pour le thème pro
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4F31)),
      ),
      // On démarre toujours sur la Connexion
      home: const ConnexionPage(),
    );
  }
}