import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:teste/TelaResultados.dart';

class TelaTreino extends StatefulWidget {
  final String enderecoBluetooth;
  final String nomeBluetooth;

  const TelaTreino({super.key, required this.enderecoBluetooth, required this.nomeBluetooth});

  @override
  State<TelaTreino> createState() => _TelaTreinoState();
}


class resultados{
  int _numeroPassos = 0;
  int _numeroPassosCorrer = 0;
  int _numeroPassosAndar = 0;
  double _distanciaPercorrida = 0;

  resultados(this._numeroPassos, this._distanciaPercorrida, this._numeroPassosAndar, this._numeroPassosCorrer);
}


class _TelaTreinoState extends State<TelaTreino> {

  resultados Resultados = resultados(0, 0, 0, 0);

  String _leituraBluetooth = "nada";
  String mensagem = "";

  // Mudar para endereço dinâmico
  String addressBluetooth = "98:D3:36:80:F4:6A";
  //String addressBluetooth = "98:D3:31:F9:5E:F8";
  late BluetoothConnection connection;

  // Estados dos Botões
  bool _estadoComecar = true;
  bool _estadoTerminar = false;

  // Variáveis para contagem de passos;
  int dadosLidosAnteriormente = 8000;

  @override
  void initState(){
    _lerDados();
  }



// Leitura dos dados enviados pelo hc-05
  Future<void> _lerDados() async {

    mensagem = "";

    // Reset das variáveis no início do treino
    Resultados._numeroPassos = 0;
    Resultados._distanciaPercorrida = 0;
    Resultados._numeroPassosAndar = 0;
    Resultados._numeroPassosCorrer = 0;
    _leituraBluetooth = "";

    setState(() {});

    try {
      // Ligação ao hc-05
      print('Início do processo de ligação a ' + widget.enderecoBluetooth);
      /*
      if (connection==null){
        connection = await BluetoothConnection.toAddress("98:D3:36:80:F4:6A");
      }
      */

      connection = await BluetoothConnection.toAddress(widget.enderecoBluetooth);

      // Verificar o estado da ligação
      if (connection.isConnected){
        print("Já estava ligado ao dispositivo");
      }

      // Estados botões
      _estadoComecar = false;
      _estadoTerminar = true;

      // leitura dos dados
      connection.input?.listen((Uint8List data) {
        _leituraBluetooth = ascii.decode(data);
        mensagem += _leituraBluetooth;
        if (_leituraBluetooth.contains("\n")){
          print('Dados: ' + mensagem);
          _tratarDados(mensagem);
          mensagem = "";
        }
      }).onDone(() {  // Caso perca a ligação, terminar o treino
        print('Perdeu a Ligação');
        _terminarTreino();
      });
    }
    catch (exception) {
      print('Impossível Ligar');
    }
  }


  void _tratarDados(dadosRecebidos){

    dadosRecebidos = int.parse(dadosRecebidos);

    // Validação dos dados
    if ( dadosRecebidos > 12000 ){

      if ( dadosRecebidos < dadosLidosAnteriormente ){
        // Se detetar um passo
        Resultados._numeroPassos++;

        if ( dadosLidosAnteriormente > 19000 ){
          // Passo a correr
          Resultados._distanciaPercorrida += 1.7;
          Resultados._numeroPassosCorrer++;
        }else{
          // Passo a andar
          Resultados._distanciaPercorrida += 0.74;
          Resultados._numeroPassosAndar++;
        }

        dadosLidosAnteriormente = 8000;

      }else{
        dadosLidosAnteriormente = dadosRecebidos;
      }

    }

    setState(() {});

  }


  void _terminarTreino(){

    // Atualizar os estados dos botões
    _estadoComecar = true;
    _estadoTerminar = false;
    connection.dispose();
    setState(() {});

    // Mudança de Página
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=>TelaResultados(
                passos: Resultados._numeroPassos,
                distancia: Resultados._distanciaPercorrida
            )
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_estadoComecar
                  ? "Iniciar Treino"
                  : "Treino a Decorrer"

          ),
          backgroundColor: Colors.deepOrangeAccent,
          automaticallyImplyLeading: (_estadoComecar
                        ? true
                        : false
                  ),
        ),
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Pedómetro: " + widget.nomeBluetooth),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Andar: " + Resultados._numeroPassosAndar.toString()),
                    Text("Correr: " + Resultados._numeroPassosCorrer.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "Passos: " + Resultados._numeroPassos.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                    Text(
                        "Distância: " + Resultados._distanciaPercorrida.toStringAsFixed(2) + "m",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _lerDados,
                      child: (_estadoComecar
                          ? Text("Começar")
                          : Text("Recomeçar")
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (_estadoTerminar
                          ? _terminarTreino
                          : null
                      ),
                      child: Text("Terminar"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent
                      ),

                    )
                  ],
                ),
              ],
            )
        )
    );
  }
}
