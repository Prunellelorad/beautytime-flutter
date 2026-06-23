import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://localhost:8000/api';
  static String? _token;

  static void setToken(String token) => _token = token;
  static String? getToken() => _token;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // INSCRIPTION
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // CONNEXION
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // LISTE DES SALONS
  static Future<List<dynamic>> getSalons({String? categorie, String? search}) async {
    String url = '$baseUrl/salons';
    List<String> params = [];
    if (categorie != null && categorie != 'Tout découvrir') {
      params.add('categorie=$categorie');
    }
    if (search != null && search.isNotEmpty) {
      params.add('search=$search');
    }
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final response = await http.get(Uri.parse(url), headers: _headers);
    return jsonDecode(response.body);
  }

  // CRÉER UNE RÉSERVATION
  static Future<Map<String, dynamic>> createReservation({
    required int salonId,
    required String date,
    required String heure,
    required bool isAtSalon,
    required double prixService,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: _headers,
      body: jsonEncode({
        'salon_id'    : salonId,
        'date'        : date,
        'heure'       : heure,
        'is_at_salon' : isAtSalon,
        'prix_service': prixService,
      }),
    );
    return jsonDecode(response.body);
  }

  // MES RÉSERVATIONS
  static Future<List<dynamic>> getReservations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservations'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }
}