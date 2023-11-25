import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:metgroup_zebra_rfid/metgroup_zebra_rfid.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final rfid = MetgroupZebraRfid();

  // Inicializar
  void initialize() async {
    await rfid.initialize();

    rfid.onListenRFID().listen((event) {
      log("==============");
      log("onListenRFID $event");
    });

    rfid.onTriggerAction().listen((event) {
      log("==============");
      log("onTriggerAction $event");
    });

    rfid.onDeviceStatus().listen((event) {
      log("==============");
      log("onDeviceStatus $event");
    });

    rfid.onConnectionStatus().listen((event) {
      log("==============");
      log("onConnectionStatus $event");
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("METGROUP ZEBRA RFID"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Conectarse:
            ElevatedButton(
                onPressed: rfid.connectRfid, child: Text("Conectarse")),
            ElevatedButton(
                onPressed: rfid.disconnectRfid, child: Text("Desconectarse")),
            ElevatedButton(
                onPressed: () =>
                    rfid.startRfidScanner(memoryBank: MemoryBank.tid),
                child: Text("Iniciar inventorio")),
            ElevatedButton(
                onPressed: rfid.stopRfidScanner,
                child: Text("Detener inventorio")),

            // Desconectarse
          ],
        ),
      ),
    );
  }
}
