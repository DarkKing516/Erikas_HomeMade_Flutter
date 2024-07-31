import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'citas.dart';
import 'drawer.dart';
import 'main.dart';
import 'products.dart';
import 'signin.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const orders(title: 'Pedidos'),
    );
  }
}

class orders extends StatefulWidget {
  const orders({Key? key, required this.title});

  final String title;

  @override
  State<orders> createState() => _ordersState();
}

class _ordersState extends State<orders> {
  late Future<List<dynamic>> _futureData;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Citas(
            title: 'Citas',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://api-movil-rh0g.onrender.com/api/orders'));
    if (response.statusCode == 200) {
      List<dynamic> allOrders = json.decode(response.body);
      String userId = LoginPage
          .odiii; // Suponiendo que LoginPage.odiii contiene el ID del usuario
      List<dynamic> userOrders =
          allOrders.where((order) => order['user_id'] == userId).toList();
      return userOrders;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _navigateToProducts(BuildContext context, dynamic selectedOrder) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Products(selectedOrder: selectedOrder)),
    );
  }

  String formatDate(String dateStr) {
    DateTime date =
        DateTime.parse(dateStr); // Parse the string to a DateTime object
    return DateFormat('dd/MM/yyyy').format(date); // Format the date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: DrawerWidget(onItemTapped: _onItemTapped),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                dynamic order = data[index];
                return Card(
                  color: const Color.fromRGBO(225, 217, 217, 217),
                  margin: const EdgeInsets.all(8),
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      _navigateToProducts(context, order);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 8),
                                // Text(
                                //   'ID Usuario: ${LoginPage.odiii}',
                                //   style: const TextStyle(
                                //     fontSize: 18,
                                //   ),
                                // ),
                                const SizedBox(height: 8),
                                Text(
                                  // 'Fecha de entrega: ${order['delivery_date']}',
                                  'Fecha de entrega: ${formatDate(order['delivery_date'])}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Estado del Pedido: ${order['order_status']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Total del Pedido: \$${order['total_order']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _navigateToProducts(context, order);
                                  },
                                  icon: Icon(Icons.visibility),
                                  label: Text('Ver Productos'),
                                ),
                                // const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
