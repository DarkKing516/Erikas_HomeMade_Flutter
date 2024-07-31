import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final dynamic selectedOrder;

  const Products({Key? key, required this.selectedOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> products = selectedOrder['products'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products of Order'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          dynamic product = products[index];
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
                          'Producto : ${product['name']}',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cantidad: ${product['quantity']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Precio: \$${product['price']}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Espacio entre el texto y la imagen
                  _buildProductImage(product['image']),
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