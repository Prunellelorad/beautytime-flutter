class Artisan {
  final String name;
  final String role;
  final String imageUrl;
  final bool isDirector;

  Artisan({
    required this.name, 
    required this.role, 
    required this.imageUrl, 
    this.isDirector = false
  });
}