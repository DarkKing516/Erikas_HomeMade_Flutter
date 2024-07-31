import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Importa los paquetes necesarios
import 'dashboard_users.dart';

import 'drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erika´s Home Made',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erika´s Home Made'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Center(
              child: FadeInUp(
                duration: const Duration(seconds: 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Erikas homemade',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnimatedIcon(Icons.schedule, delay: 0),
                _buildAnimatedIcon(Icons.shopping_cart_outlined, delay: 2),
                _buildAnimatedIcon(Icons.calendar_today, delay: 4),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(onItemTapped: _onItemTapped),
    );
  }

  Widget _buildAnimatedIcon(IconData iconData, {required int delay}) {
    return BounceInUp(
      duration: Duration(seconds: 2),
      delay: Duration(milliseconds: delay * 500),
      child: Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          iconData,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}

// Definición de DrawerWidget y DashboardLogin omitidos por brevedad
