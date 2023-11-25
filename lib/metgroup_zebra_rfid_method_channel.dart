import 'dart:developer';

import 'package:flutter/services.dart';
import 'metgroup_zebra_rfid_platform_interface.dart';

class MethodChannelMetgroupZebraRfid extends MetgroupZebraRfidPlatform {
  final methodChannel = const MethodChannel('metgroup_zebra_rfid');
  final _rfidScanEventChannel =
      const EventChannel('metgroup_zebra_rfid/rfid_scan');
  final _triggerActionEventChannel =
      const EventChannel('metgroup_zebra_rfid/trigger_action');
  final _deviceStatusEventChannel =
      const EventChannel('metgroup_zebra_rfid/device_status');
  final _connectionStatusEventChannel =
      const EventChannel('metgroup_zebra_rfid/connection_status');

  @override
  Future<dynamic> initialize() async {
    log("===========INITIALIZE");
    return await methodChannel.invokeMethod('initialize');
  }

  @override
  Future<void> startRfidScan(int memoryBankIndex) async {
    log("===========startRfidScan");
    await methodChannel
        .invokeMethod('startRfidScan', {'memoryBankIndex': memoryBankIndex});
  }

  @override
  Future<void> stopRfidScan() async {
    log("===========stopRfidScan");
    await methodChannel.invokeMethod('stopRfidScan');
  }

  @override
  Stream<dynamic> onListenRFID() =>
      _rfidScanEventChannel.receiveBroadcastStream();

  @override
  Stream<dynamic> onTriggerAction() =>
      _triggerActionEventChannel.receiveBroadcastStream();

  @override
  Stream<dynamic> onDeviceStatus() =>
      _deviceStatusEventChannel.receiveBroadcastStream();

  @override
  Future<bool> connectRfid() async {
    log("===========connectRfid");
    return await methodChannel.invokeMethod("connectRfid");
  }

  @override
  Future<bool> disconnectRfid() async {
    log("===========disconnectRfid");
    return await methodChannel.invokeMethod("disconnectRfid");
  }

  @override
  Stream onConnectionStatus() =>
      _connectionStatusEventChannel.receiveBroadcastStream();
}
