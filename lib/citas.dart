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
      home: const Citas(title: 'Reservas'),
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
      List<dynamic> allData = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> filteredData =
          allData.where((cita) => cita['usuario'].toString() == LoginPage.odiii).toList();
      return filteredData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateReservationStatus(int reservationId, String newStatus) async {
    final response = await http.get(
        Uri.parse('https://erikas-homemade.onrender.com/reservas/reservasAPI/'));
    if (response.statusCode == 200) {
      List<dynamic> allReservations = json.decode(utf8.decode(response.bodyBytes));
      dynamic reservationToUpdate = allReservations.firstWhere((reservation) => reservation['id'] == reservationId);
      
      reservationToUpdate['estado'] = newStatus;

      final updateResponse = await http.put(
        Uri.parse('https://erikas-homemade.onrender.com/reservas/reservasAPI/$reservationId/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reservationToUpdate),
      );

      if (updateResponse.statusCode == 200) {
        print('Reserva actualizada con éxito');
      } else {
        throw Exception('Failed to update reservation');
      }
    } else {
      throw Exception('Failed to load reservation');
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
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _showStatusDialog(BuildContext context, dynamic reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedStatus = reservation['estado'];
        List<String> statusOptions = [];
        if(LoginPage.canEditReserva){
        statusOptions += ['Pendiente', 'En Proceso', 'Cancelado'];
        }else{
        statusOptions += ['Cancelado'];
        }
        
        if (!statusOptions.contains(selectedStatus)) {
          selectedStatus = statusOptions[0];
        }

        return AlertDialog(
          title: Text('Editar Estado de la Reserva'),
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
                  await updateReservationStatus(reservation['id'], selectedStatus);
                  setState(() {
                    _futureData = fetchData();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar el estado: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDetails(Map<String, dynamic> reservationData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de la Reserva'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${LoginPage.userName}'),
              Text('Fecha: ${formatDate(reservationData['fecha_cita'])}'),
              Text('Descripción:\n ${reservationData['descripcion']}'),
              Text('Estado: ${reservationData['estado']}'),
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
                return Card(
                  color: const Color.fromRGBO(225, 217, 217, 217),
                  margin: EdgeInsets.all(8),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${LoginPage.userName}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fecha: ${formatDate(data[index]['fecha_cita'])}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Estado: ${data[index]['estado']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _showDetails(data[index]);
                              },
                              icon: Icon(Icons.visibility),
                              label: Text('Ver Descripción'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showStatusDialog(context, data[index]);
                              },
                              icon: Icon(Icons.edit),
                              label: Text('Editar Estado'),
                            ),
                          ],
                        ),
                      ],
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