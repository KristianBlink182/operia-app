import 'package:flutter/material.dart';
import '../models/property_model.dart';

class DetailScreen extends StatelessWidget {
  final Property property;

  const DetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final priceM2 = (property.priceUsd / property.totalAreaM2).toStringAsFixed(2);
    final isRent = property.listingType == 'rent';

    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060A12),
        elevation: 0,
        title: const Text('Expediente Oficial', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Operación y Distrito
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isRent ? Colors.blue.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isRent ? 'ALQUILER INSTITUCIONAL' : 'VENTA DE ACTIVO',
                    style: TextStyle(color: isRent ? Colors.blueAccent : Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('📍 ${property.district}, Perú', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              property.title,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),

            // Tarjeta de Valor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0B111E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VALOR COMERCIAL', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('\$ ${property.priceUsd.toStringAsFixed(0)} USD', style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  Text('\$$priceM2 / m²', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Métricas de Ingeniería
            const Text('⚙️ ESPECIFICACIONES TÉCNICAS', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMetricBox('Área Terreno', '${property.totalAreaM2.toStringAsFixed(0)} m²'),
                const SizedBox(width: 10),
                _buildMetricBox('Altura Libre', '${property.clearHeightM} metros'),
                const SizedBox(width: 10),
                _buildMetricBox('Zonificación', 'I-2 / I-3'),
              ],
            ),
            const SizedBox(height: 20),

            // Memoria Descriptiva
            const Text('📄 MEMORIA DESCRIPTIVA', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              property.descriptionEs,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 30),

            // Botón de Contacto
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abriendo canal oficial con el Broker...')),
                  );
                },
                child: const Text('📅 Agendar Visita Técnica Oficial', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B111E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}