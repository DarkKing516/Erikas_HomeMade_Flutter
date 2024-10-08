import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Importa el archivo

import 'main.dart'; // for using json.decode()

void main() {
  runApp(const LoginBonito());
}

class LoginBonito extends StatelessWidget {
  const LoginBonito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erika´s HomeMade',
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -40,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            Positioned(
              top: -110,
              left: 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[900],
                ),
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  LoginPage(),
                ],
              ),
            ),
            Positioned(
              bottom: -40,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            Positioned(
              bottom: -110,
              right: 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginForm();

  // Declara _odiii, _userName, _email como variables estáticas
  static String _odiii = '';
  static int _userIdxd = 0;
  static String _userName = '';
  static String _email = '';
  static String _roluser = '';

  // Declara las variables booleanas para los permisos
  static bool _canEditReserva = false;
  static bool _canEditEstadoPedidos = false;

  // Métodos estáticos para acceder a las variables
  static String get odiii => _odiii;
  static int get userIdxd => _userIdxd;
  static String get userName => _userName;
  static String get email => _email;
  static String get roluser => _roluser;

 // Métodos estáticos para acceder a las variables booleanas
  static bool get canEditReserva => _canEditReserva;
  static bool get canEditEstadoPedidos => _canEditEstadoPedidos;
}

class LoginForm extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userName = '';
  bool _passwordVisible = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://erikas-homemade.onrender.com/configuracion/loginAPI/'),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({
          'correo': _email,
          'contraseña': _password,
        }),
      );
      if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes)); // Decodifica como UTF-8
        _userName = responseData['nombre'];
        LoginPage._roluser = responseData['idRol']['nombre_rol'].toString(); // Guarda el nombre del rol
        LoginPage._odiii = responseData['id'].toString(); // Guarda el ID del usuario
        LoginPage._userIdxd = int.tryParse(LoginPage._odiii) ?? 0; // Convierte el ID a int y maneja errores
        print('userId: ${LoginPage._roluser}, tipo: ${LoginPage._roluser.runtimeType}');
        print('userId: ${LoginPage._odiii}, tipo: ${LoginPage._odiii.runtimeType}');
        print('userId: ${LoginPage._userIdxd}, tipo: ${LoginPage._userIdxd.runtimeType}');
        LoginPage._userName =
            responseData['usuario']; // Guarda el nombre de usuario
        LoginPage._email =
            responseData['correo']; // Guarda el correo electrónico

        // Extrae los permisos y guarda los booleanos
        final permisos = responseData['idRol']['permisos'] as List;
        LoginPage._canEditReserva = permisos.any((permiso) =>
            permiso['nombre_permiso'] == 'Editar Reservas' && permiso['estado_permiso'] == 'A');
        LoginPage._canEditEstadoPedidos = permisos.any((permiso) =>
            permiso['nombre_permiso'] == 'Editar Estado Pedidos' && permiso['estado_permiso'] == 'A');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido $_userName a Erika´s HomeMade'),
          ),
        );
      } else {
        print('Error code: ${response.statusCode}');
        print('Error body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de inicio de sesión: ${response.body}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthPortion = MediaQuery.of(context).size.width * 0.75;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: screenWidthPortion,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Correo electrónico',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su correo electrónico';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        border: InputBorder.none,
                        // suffixIcon: IconButton(
                        //   icon: Icon(_passwordVisible
                        //       ? Icons.visibility_off
                        //       : Icons.visibility),
                        //   onPressed: () {
                        //     setState(() {
                        //       _passwordVisible = !_passwordVisible;
                        //     });
                        //   },
                        // ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su contraseña';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom - (-40),
            left: MediaQuery.of(context).size.width / 1 - 140,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
                backgroundColor: Colors.lightBlue,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
