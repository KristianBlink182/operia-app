import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Property> properties = [];
  bool isLoading = true;
  String selectedFilter = '';

  // Control de sesión: por defecto falso para obligar a registrarse
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData({String? district}) async {
    setState(() => isLoading = true);
    final data = await ApiService.getProperties(district: district);
    setState(() {
      properties = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060A12),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('▲', style: TextStyle(color: Colors.black, fontSize: 14)),
            ),
            const SizedBox(width: 8),
            const Text('PROP', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
            const Text('NEXT', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Selector de Regiones
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('Todos', ''),
                _buildFilterChip('⚓ Callao', 'Callao'),
                _buildFilterChip('🚛 Lurín', 'Lurín'),
                _buildFilterChip('🚢 Chancay', 'Chancay'),
                _buildFilterChip('⚡ Chilca', 'Chilca'),
              ],
            ),
          ),

          // Lista de Naves con Precios Protegidos
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : properties.isEmpty
                    ? const Center(child: Text('No hay activos disponibles.', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final prop = properties[index];
                          final isRent = prop.listingType == 'rent';

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetailScreen(property: prop)),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B111E),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF1E293B)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isRent ? Colors.blue.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isRent ? 'ALQUILER' : 'VENTA',
                                            style: TextStyle(
                                              color: isRent ? Colors.blueAccent : Colors.greenAccent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '📍 ${prop.district}',
                                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      prop.title,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('📐 ${prop.totalAreaM2.toStringAsFixed(0)} m²', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                        Text('📶 ${prop.clearHeightM}m Altura', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                        const Text('Zonif. I-2/I-3', style: TextStyle(color: Colors.amber, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(color: Color(0xFF1E293B)),
                                    
                                    // BLOQUEO DE PRECIO CON CANDADO
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        isLoggedIn
                                            ? Text(
                                                '\$ ${prop.priceUsd.toStringAsFixed(0)} USD',
                                                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 18),
                                              )
                                           : GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.amber, size: 14),
          SizedBox(width: 4),
          Text(
            'Inicia sesión para ver precio',
            style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  ),
                                        const Text('Ver Ficha →', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String districtValue) {
    final isSelected = selectedFilter == districtValue;
    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = districtValue);
        fetchData(district: districtValue);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : const Color(0xFF0B111E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.amber : const Color(0xFF1E293B)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}