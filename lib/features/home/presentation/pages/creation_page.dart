import 'package:flutter/material.dart';
import 'package:pruno_dev/services/api_service.dart';
import 'connexion_page.dart';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  final Color primaryGold = const Color(0xFFB88E5B);
  final Color inputBgColor = const Color(0xFFF5F6FA);

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Veuillez remplir tous les champs");
      return;
    }

    if (name.length < 3) {
      _showError("Le nom doit contenir au moins 3 caractères");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showError("Veuillez entrer un email valide");
      return;
    }

    if (password.length < 6) {
      _showError("Le mot de passe doit faire au moins 6 caractères");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.register(name, email, password);

      if (result.containsKey('token')) {
        _showSuccess("Compte créé avec succès !");
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ConnexionPage()),
          );
        });
      } else {
        _showError(result['message'] ?? "Erreur lors de l'inscription");
      }
    } catch (e) {
      _showError("Impossible de contacter le serveur");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Créer un compte",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Rejoignez-nous pour une expérience personnalisée.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  _label("Nom Complet"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: _inputStyle(
                        hint: "Votre nom",
                        icon: Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 20),
                  _label("Adresse Email"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputStyle(
                        hint: "exemple@mail.com",
                        icon: Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 20),
                  _label("Mot de passe"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: _inputStyle(
                            hint: "6 caractères min.",
                            icon: Icons.lock_outline_rounded)
                        .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryGold),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  _buildRegisterButton(),
                  const SizedBox(height: 30),
                  _buildFooter(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGold.withValues(alpha: 0.1),
        borderRadius:
            const BorderRadius.only(bottomLeft: Radius.circular(80)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "BeautyTime",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6B4F31)),
                ),
                const SizedBox(height: 5),
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: primaryGold,
                        borderRadius: BorderRadius.circular(10))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryGold.withValues(alpha: 0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("S'INSCRIRE",
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Déjà un compte ? "),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ConnexionPage())),
            child: Text("Connectez-vous",
                style: TextStyle(
                    color: primaryGold,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87));

  InputDecoration _inputStyle({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryGold, size: 22),
      filled: true,
      fillColor: inputBgColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryGold, width: 1.5)),
    );
  }
}