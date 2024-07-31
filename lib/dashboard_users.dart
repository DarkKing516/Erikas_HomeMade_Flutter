import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for using json.decode()
import 'login.dart';
import 'citas.dart';
import 'edit_user.dart';
import 'drawer.dart';
import 'main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      title: 'Consumo API Rest',
      home: const DashboardLogin(),
    );
  }
}

class DashboardLogin extends StatefulWidget {
  const DashboardLogin({Key? key}) : super(key: key);

  @override
  State<DashboardLogin> createState() => _DashboardLoginState();
}

class _DashboardLoginState extends State<DashboardLogin> {
  // The list that contains information about posts
  List _loadedPosts = [];

  // The function that fetches data from the API
  Future<void> _fetchData() async {
    const apiUrl = 'https://api-movil-rh0g.onrender.com/api/users';

    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    setState(() {
      _loadedPosts = data;
    });
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
        MaterialPageRoute(builder: (context) => const EditUser()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Citas(
                  title: 'Citas',
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${LoginPage.userName}'),
      ),
      drawer: DrawerWidget(onItemTapped: _onItemTapped),
      body: SafeArea(
        child: _loadedPosts.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Para que la Columna use solo el espacio necesario
                  children: [
                    ElevatedButton(
                      onPressed: _fetchData,
                      child: const Text('Load Posts'),
                    ),
                    SizedBox(height: 20), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => EditUser()),
                        );
                      },
                      child: const Text('Editar User'),
                    ),
                    SizedBox(height: 20), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {
                        // Aquí implementas la funcionalidad para cerrar sesión
                        // Esto te llevará de vuelta a la pantalla de login
                        // Navigator.pop(context);

                        // O si estás usando una navegación basada en rutas nombradas podrías hacer algo como:
                        // Navigator.pushReplacementNamed(context, '/login');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .red, // Color del botón, puedes personalizarlo
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _loadedPosts.length,
                itemBuilder: (BuildContext ctx, index) {
                  // return ListTile(
                  //   title: Text(_loadedPosts[index]["title"]),
                  //   subtitle:
                  //       Text('ID: ${_loadedPosts[index]["id"]} \n${_loadedPosts[index]["body"]}'),
                  // );

                  return ColoredBox(
                    color: Colors.green,
                    child: Material(
                      child: ListTile(
                        title: Text(_loadedPosts[index]["title"]),
                        subtitle: Text(
                            'ID: ${_loadedPosts[index]["id"]} \n${_loadedPosts[index]["body"]}'),
                        tileColor: Colors.cyan,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
