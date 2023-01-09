import 'package:flutter/material.dart';
import 'package:teste/TelaPrincipal.dart';


void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaPrincipal(),debugShowCheckedModeBanner: false);
  }
}
