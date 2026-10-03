class ApiConfig {
  // Conexión oficial a tu servidor de producción
  static const String baseUrl = "https://operia.pe/api.php";
  
  // Headers para peticiones HTTP
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}