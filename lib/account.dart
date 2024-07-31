import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Importa el archivo

import 'main.dart'; // for using json.decode()

void main() {
  runApp(const MyAppAccount());
}

class MyAppAccount extends StatelessWidget {
  const MyAppAccount({Key? key}) : super(key: key);

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
                  color: Colors.purple,
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
                  color: Colors.purple[900],
                ),
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Editar Usuario',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Account(),
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
                  color: Colors.purple,
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
                  color: Colors.purple[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => LoginForm();

  // Declara _odiii, _userName, _email como variables estáticas
  static String _odiii = '';
  static String _userName = '';
  static String _email = '';

  // Métodos estáticos para acceder a las variables
  static String get odiii => _odiii;
  static String get userName => _userName;
  static String get email => _email;
}

class LoginForm extends State<Account> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userName = '';
  bool _passwordVisible = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://api-movil-rh0g.onrender.com/api/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': _email,
          'password': _password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _userName = responseData['name'];
        Account._odiii = responseData['_id']; // Guarda el ID del usuario
        Account._userName =
            responseData['username']; // Guarda el nombre de usuario
        Account._email = responseData['email']; // Guarda el correo electrónico
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
                        labelText: 'Nombre',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Documento',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                      ),
                    ),
                    // const SizedBox(height: 10),
                    TextFormField(
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
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
