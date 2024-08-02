import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

class Products extends StatelessWidget {
  final dynamic selectedOrder;

  const Products({Key? key, required this.selectedOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> products = selectedOrder['detalle_productos'];
    String baseUrl = "https://raw.githubusercontent.com/DarkKing516/Erikas_HomeMade_Django/main/";
    
    // Si no hay productos, mostrar imagen de gatos
    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Productos del Pedido'),
        ),
        body: Center(
          child: Image.network(
            'https://http.cat/401', // URL de la imagen de gatos
            fit: BoxFit.cover, // Ajustar imagen
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos del Pedido'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          dynamic product = products[index];
          String imageUrl = baseUrl + product['imagen'];

          // Formatear el subtotal del producto
          String formattedPrice = NumberFormat('#,###', 'es_CO').format(double.parse(product['subtotal_productos']));

          return Card(
            color: const Color.fromRGBO(225, 217, 217, 217),
            margin: const EdgeInsets.all(8),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          '${product['nombre_productos']}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cantidad: ${product['cant_productos']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Precio: \$${formattedPrice}', // Usa el precio formateado aquí
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Espacio entre el texto y la imagen
                  _buildProductImage(imageUrl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: 100, // Ancho de la imagen
      height: 100, // Alto de la imagen
      fit: BoxFit.cover, // Ajuste de la imagen
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return CircularProgressIndicator();
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(Icons.error);
      },
    );
  }
}
