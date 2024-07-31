import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for using json.decode()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Consumo API Users/Erika',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => pruebasApi();
}

class pruebasApi extends State<HomePage> {
  List _loadedUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const apiUrl = 'https://api-movil-rh0g.onrender.com/api/users';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _loadedUsers = data;
        });
      } else {
        print('Failed to load users');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Erika´s Homemade'),
      ),
      body: SafeArea(
        child: _loadedUsers.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _loadedUsers.length,
                itemBuilder: (BuildContext ctx, index) {
                  return ListTile(
                    title: Text(_loadedUsers[index]["name"]),
                    subtitle: Text('Usuario: ${_loadedUsers[index]["username"]}\nEmail: ${_loadedUsers[index]["email"]}'),
                  );
                },
              ),
      ),
    );
  }
}
