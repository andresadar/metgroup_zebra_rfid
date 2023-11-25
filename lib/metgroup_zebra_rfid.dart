import 'dart:developer';

import 'metgroup_zebra_rfid_platform_interface.dart';

enum MemoryBank { epc, tid, user, reserved }

class MetgroupZebraRfid {
  static final MetgroupZebraRfid _instance = MetgroupZebraRfid._internal();
  factory MetgroupZebraRfid() => _instance;
  MetgroupZebraRfid._internal();

  final rfid = MetgroupZebraRfidPlatform.instance;

  Future<dynamic> initialize() => rfid.initialize();

  Future<bool> connectRfid() => rfid.connectRfid();

  Future<bool> disconnectRfid() => rfid.disconnectRfid();

  Stream<dynamic> onConnectionStatus() => rfid.onConnectionStatus();

  Future<void> startRfidScanner({required MemoryBank memoryBank}) =>
      rfid.startRfidScan(memoryBank.index);

  Future<void> stopRfidScanner() => rfid.stopRfidScan();

  Stream<dynamic> onListenRFID() => rfid.onListenRFID();

  Stream<dynamic> onTriggerAction() => rfid.onTriggerAction();

  Stream<dynamic> onDeviceStatus() => rfid.onDeviceStatus();
}
