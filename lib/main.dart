import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const OperiaApp());
}

class OperiaApp extends StatelessWidget {
  const OperiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PALETA OFICIAL OPERIA
    const operiaBlue = Color(0xFF0B2D4A);
    const operiaTeal = Color(0xFF0F9D8E);
    const operiaDark = Color(0xFF071D30);
    const operiaLight = Color(0xFFE8EDF1);

    return MaterialApp(
      title: 'Operia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: operiaBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: operiaBlue,
          primary: operiaBlue,
          secondary: operiaTeal,
        ),
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: operiaBlue,
          elevation: 0.5,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// PANTALLA PRINCIPAL CON NAVEGACIÓN INFERIOR (BOTTOM BAR)
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),        // 1. Explorar Activos
    const BuscoMatchScreen(),   // 2. Módulo BUSCO 50/50
    const PlaceholderScreen(title: "Operia PropAI Estimate™"), // 3. Tasador IA
    const PlaceholderScreen(title: "Mi Perfil & Membresía"),   // 4. Mi Cuenta
  ];

  @override
  Widget build(BuildContext context) {
    const operiaBlue = Color(0xFF0B2D4A);
    const operiaTeal = Color(0xFF0F9D8E);

    return Scaffold(
      body: _screens[_currentIndex],
      // BOTÓN FLOTANTE PARA PUBLICAR NAVE O LOCAL
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: operiaBlue,
        icon: const Icon(Icons.add_business, color: Colors.white, size: 20),
        label: const Text(
          "+ Publicar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: () {
          // Abrir formulario nativo de publicación
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Abriendo formulario de publicación...")),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: operiaTeal,
        unselectedItemColor: const Color(0xFF6B7280),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.handshake_outlined), label: "BUSCO 50/50"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "PropAI"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Mi Cuenta"),
        ],
      ),
    );
  }
}

// 1. PANTALLA PRINCIPAL: LISTA NATIVA DE PROPIEDADES DESDE MYSQL
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _properties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  // CONSULTAR A MYSQL DE OPERIA.PE
  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("https://operia.pe/api.php?t=${DateTime.now().millisecondsSinceEpoch}"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          setState(() {
            _properties = data['data'];
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Error al cargar propiedades: $e");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const operiaBlue = Color(0xFF0B2D4A);
    const operiaTeal = Color(0xFF0F9D8E);

    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          "https://operia.pe/img/logo.jpg",
          height: 38,
          errorBuilder: (_, __, ___) => const Text("OPERIA", style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: operiaBlue),
            onPressed: _fetchProperties,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProperties,
        color: operiaTeal,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: operiaTeal))
            : _properties.isEmpty
                ? const Center(child: Text("No hay activos publicados aún en Operia."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _properties.length,
                    itemBuilder: (context, index) {
                      final item = _properties[index];
                      final isRent = item['listing_type'] == 'rent';
                      final price = double.tryParse(item['price_usd'].toString()) ?? 0;
                      final photo = (item['cover_image'] != null && item['cover_image'].toString().isNotEmpty)
                          ? item['cover_image']
                          : (item['image'] ?? '');

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FOTO REAL
                            Container(
                              height: 180,
                              width: double.infinity,
                              color: const Color(0xFFE8EDF1),
                              child: photo.toString().startsWith('http') || photo.toString().startsWith('data:image')
                                  ? Image.network(
                                      photo,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Text("🏢 Operia Industrial", style: TextStyle(color: Colors.grey)),
                                      ),
                                    )
                                  : const Center(
                                      child: Text("🏢 Operia Industrial", style: TextStyle(color: Colors.grey)),
                                    ),
                            ),
                            // DATOS TÉCNICOS
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "📍 ${item['district'] ?? 'Lima'}",
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                                      ),
                                      Text(
                                        "\$ ${price.toStringAsFixed(0)} USD",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: operiaBlue),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['title'] ?? 'Inmueble Industrial',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: operiaBlue),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Área: ${item['total_area_m2']} m²", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        Text("Alt: ${item['clear_height_m']}m", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        Text("Zonif: ${item['zoning'] ?? 'I-2'}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: operiaTeal)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// 2. PANTALLA BUSCO 50/50 CON MATCH NATIVO
class BuscoMatchScreen extends StatelessWidget {
  const BuscoMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Módulo BUSCO (50/50)", style: TextStyle(fontWeight: FontWeight.w900))),
      body: const Center(child: Text("Muro de Co-Brokerage 50/50 Conectado a Operia.")),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
    );
  }
}