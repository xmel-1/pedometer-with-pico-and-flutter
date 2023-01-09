import 'package:flutter/material.dart';

class Creditos extends StatefulWidget {
  const Creditos({Key? key}) : super(key: key);

  @override
  State<Creditos> createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créditos"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Autores",
              style: TextStyle(
                  fontSize: 40
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top:40)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Ismael Costa,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Text("1181174", style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
                  ],
                ),
                Column(
                  children: [
                    Text("Diogo Freitas,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("1180919", style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
