
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:teste/BluetoothDeviceListEntry.dart';
import 'package:teste/Creditos.dart';
import 'package:teste/TelaTreino.dart';

// Imports do Bluetooth





void main(){
  runApp(MaterialApp(
    home: TelaPrincipal(),
    debugShowCheckedModeBanner: false,
  ));
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

// Para lista dos equipamentos bluetooth //
enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int? rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}
//////////////////


class _TelaPrincipalState extends State<TelaPrincipal> {

  // Bluetooth
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Lista de dispositivos
  List<BluetoothDevice> dispositivos = <BluetoothDevice>[];

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;


  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();
    _listBondedDevices();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  _listBondedDevices(){
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> dispositivosBonded){
      dispositivos = dispositivosBonded;
      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    // lista de dispositivos bluetooth
    List<_DeviceWithAvailability> devices =
      List<_DeviceWithAvailability>.empty(growable: true);

    List<BluetoothDeviceListEntry> listDispositivos = devices
        .map((_device) => BluetoothDeviceListEntry(
      device: _device.device,
      rssi: _device.rssi,
      enabled: _device.availability == _DeviceAvailability.yes,
      onTap: () {
        Navigator.of(context).pop(_device.device);
      },
    )).toList();


    return Scaffold(
      appBar: AppBar(
        title: Text("Pedómetro - LAMEC 22/23"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Selecione o Pedómetro:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: 10
                )
            ),
            Expanded(
                child: ListView(
                  children: dispositivos.map(
                          (_dispositivo)=>BluetoothDeviceListEntry(
                        device: _dispositivo,
                        enabled: true,
                        onTap: (){
                          print("Carregaste no ${_dispositivo.name}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>TelaTreino(
                                      enderecoBluetooth: _dispositivo.address.toString(),
                                      nomeBluetooth: _dispositivo.name.toString()
                                  )
                              )
                          );
                        },
                      )
                  ).toList(),
                )
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 40)
            ),
            Text(
              "Não encontra o pedómetro? Tente fazer a ligação nas definições,"
                  " clicando no botão abaixo:",
              style: TextStyle(
                  fontSize: 12
              ),
            )
          ],
        ),
      ),
      // Botões Rodapé
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green
          ),
          onPressed: () {
            FlutterBluetoothSerial.instance.openSettings();
          },
          child: const Icon(Icons.settings),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green
          ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>Creditos()
                  )
              );
            } ,
            child: const Icon(Icons.info)
        )
      ],
    );
  }
}
