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

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://erikas-homemade.onrender.com/pedidos/pedidosAPI/'));
    if (response.statusCode == 200) {
      List<dynamic> allOrders = json.decode(utf8.decode(response.bodyBytes));
      int deberiafuncionar = LoginPage.userIdxd;
      print('userId: $deberiafuncionar, tipo: ${deberiafuncionar.runtimeType}');
      String? userId = LoginPage.odiii;
      if (userId == null || userId.isEmpty) {
        print("El userId es nulo o vacío");
        return [];
      }

      int parsedUserId;
      try {
        parsedUserId = int.parse(userId);
      } catch (e) {
        print("Error al convertir userId a entero: $e");
        return [];
      }
      print('userId: $parsedUserId, tipo: ${parsedUserId.runtimeType}');

      List<dynamic> userOrders = allOrders.where((order) => order['id_Usuario'] == deberiafuncionar).toList();

      if (userOrders.isEmpty) {
        throw Exception('No tienes pedidos actualmente');
      }

      return userOrders;
    } else {
      throw Exception('Error al Cargar');
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final response = await http.get(Uri.parse('https://erikas-homemade.onrender.com/pedidos/pedidosAPI/'));

    if (response.statusCode == 200) {
      List<dynamic> allOrders = json.decode(utf8.decode(response.bodyBytes));
      dynamic orderToUpdate = allOrders.firstWhere((order) => order['idPedido'] == orderId);
      
      // Actualiza el estado del pedido
      orderToUpdate['estado_pedido'] = newStatus;

      // Si la evidencia de pago no es requerida, elimina el campo del objeto
      if (orderToUpdate.containsKey('evidencia_pago')) {
        orderToUpdate.remove('evidencia_pago');
      }

      // Imprime los datos que vas a enviar al servidor
      print('Datos a enviar para actualizar: ${jsonEncode(orderToUpdate)}');

      final updateResponse = await http.put(
        Uri.parse('https://erikas-homemade.onrender.com/pedidos/pedidosAPI/$orderId/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(orderToUpdate),
      );

      // Imprime el estado de la respuesta
      print('Estado de la respuesta PUT: ${updateResponse.statusCode}');
      print('Respuesta del servidor: ${updateResponse.body}');

      if (updateResponse.statusCode == 200) {
        print('Pedido actualizado con éxito');
      } else {
        throw Exception('Failed to update order');
      }
    } else {
      throw Exception('Failed to load order');
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
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Guardamos el contexto del Scaffold para usar en el SnackBar
  void _showStatusDialog(BuildContext context, dynamic order) {
    final scaffoldContext = context; // Guardamos el contexto de la pantalla principal

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedStatus = order['estado_pedido'];
        List<String> statusOptions = [];
        if(LoginPage.canEditEstadoPedidos){
          statusOptions = ['Por hacer', 'En proceso', 'Hecho', 'Cancelado'];
        } else {
          statusOptions = ['Cancelado'];
        }

        // Si el estado actual no está en la lista, usa el primer valor como predeterminado
        if (!statusOptions.contains(selectedStatus)) {
          selectedStatus = statusOptions[0];
        }

        return AlertDialog(
          title: Text('Editar Estado del Pedido'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedStatus,
                items: statusOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await updateOrderStatus(order['idPedido'], selectedStatus);
                  setState(() {
                    _futureData = fetchData();  // Recargar los datos
                  });
                } catch (e) {
                  // Mostrar el error completo en el SnackBar
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    SnackBar(content: Text('Error al actualizar el estado: $e')),
                  );
                  // Imprimir el error en la consola para mayor visibilidad
                  print("Error al actualizar el estado: $e");
                }
              },
            ),

          ],
        );
      },
    );
  }

  Widget buildOrderCard(dynamic order, BuildContext context) {
    return Card(
      color: const Color.fromRGBO(225, 217, 217, 217),
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha de entrega: ${formatDate(order['fecha_pedido'])}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Estado del Pedido: ${order['estado_pedido']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total del Pedido: \$${order['total']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _navigateToProducts(context, order),
                  icon: Icon(Icons.visibility),
                  label: Text('Ver Productos'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showStatusDialog(context, order),
                  icon: Icon(Icons.edit),
                  label: Text('Editar Estado'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            return Center(
              child: Text(
                snapshot.error.toString().contains('No tienes pedidos')
                    ? 'No tienes pedidos actualmente'
                    : 'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return buildOrderCard(data[index], context);
              },
            );
          }
        },
      ),
    );
  }

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
}
