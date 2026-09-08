import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

class ApiService {
  // Nota: 10.0.2.2 se usa para pruebas en simulador Android que apuntan a tu PC.
  // En iPhone o Codemagic apuntaremos a la URL de producción.
  static const String baseUrl = 'http://10.0.2.2:3000/api/properties';

  static Future<List<Property>> getProperties({String? district, String? type}) async {
    String url = baseUrl;
    List<String> queryParams = [];

    if (district != null && district.isNotEmpty) queryParams.add('district=$district');
    if (type != null && type.isNotEmpty) queryParams.add('listing_type=$type');
    if (queryParams.isNotEmpty) url += '?${queryParams.join('&')}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];
        return list.map((item) => Property.fromJson(item)).toList();
      } else {
        throw Exception('Error en respuesta del servidor');
      }
    } catch (e) {
      print('Error conectando a la API: $e');
      return [];
    }
  }
}