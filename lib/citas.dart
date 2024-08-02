import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'signin.dart';
import 'main.dart';
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
      home: const Citas(title: 'API Flutter'),
    );
  }
}

class Citas extends StatefulWidget {
  const Citas({Key? key, required this.title});

  final String title;

  @override
  State<Citas> createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://erikas-homemade.onrender.com/reservas/reservasAPI/'));
    if (response.statusCode == 200) {
      List<dynamic> allData = json.decode(utf8.decode(response.bodyBytes)); // Decodifica como UTF-8
      // Filtrar las citas por el ID del usuario actual
      List<dynamic> filteredData =
          allData.where((cita) => cita['usuario'].toString() == LoginPage.odiii).toList();
      return filteredData;
    } else {
      throw Exception('Failed to load data');
    }
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
                )),
      );
    }
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr); // Parse the string to a DateTime object
    return DateFormat('dd/MM/yyyy').format(date); // Format the date
  }

  void _showDetails(Map<String, dynamic> journalData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de la Reserva'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text('ID Usuario: ${journalData['usuario']}'),
              Text('Nombre: ${LoginPage.userName}'), // Mostrar el nombre del usuario actual
              Text('Fecha: ${formatDate(journalData['fecha_cita'])}'), // Formatted date
              Text('Descripción:\n ${journalData['descripcion']}'),
              Text('Estado: ${journalData['estado']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showDetails(data[index]);
                  },
                  child: Card(
                    color: const Color.fromRGBO(225, 217, 217, 217),
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Nombre Usuario: ${LoginPage.userName}', // Mostrar el nombre del usuario actual
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Fecha: ${formatDate(data[index]['fecha_cita'])}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estado: ${data[index]['estado']}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showDetails(data[index]);
                            },
                            icon: Icon(Icons.visibility),
                            label: Text('Ver Descripción'),
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
