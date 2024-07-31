import 'package:flutter/material.dart';
import 'account.dart';
import 'edit_user.dart';
import 'main.dart';
import 'citas.dart';
import 'orders.dart';
import 'signin.dart';

class DrawerWidget extends StatelessWidget {
  final Function(int) onItemTapped;

  DrawerWidget({required this.onItemTapped});

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Citas(
          title: 'Citas',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildHeader(context), // Aquí se llama al método _buildHeader
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () {
              _navigateToHome(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Citas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Citas(
                    title: 'Citas',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const orders(
                    title: 'Pedidos',
                  ),
                ),
              );
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Cuenta'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EditUser()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.account_circle),
          //   title: const Text('Cuenta'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => Account()),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginBonito()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
      color: Colors.blue.shade700,
      padding: EdgeInsets.only(
        top: 64 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/DarkKing516/entregableFlutterErikas/main/assets/images/mi_icono.png'),
          ),
          SizedBox(height: 12),
          Text(
            LoginPage.userName.isNotEmpty ? 'Bienvenido ${LoginPage.userName}' : 'Bienvenido',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            LoginPage.email,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
}
