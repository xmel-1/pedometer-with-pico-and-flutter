import 'package:flutter/material.dart';


class TelaResultados extends StatefulWidget {
  //const TelaResultados({Key? key}) : super(key: key);
  final int passos;
  final double distancia;

  const TelaResultados({super.key, required this.passos, required this.distancia});

  @override
  State<TelaResultados> createState() => _TelaResultadosState();
}

class _TelaResultadosState extends State<TelaResultados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Passos: " + widget.passos.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Text("Distância: " + widget.distancia.toStringAsFixed(2) + "m",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}

