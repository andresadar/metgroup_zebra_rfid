// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// import 'metgroup_zebra_rfid_platform_interface.dart';

// /// An implementation of [MetgroupZebraRfidPlatform] that uses method channels.
// class MethodChannelMetgroupZebraRfid extends MetgroupZebraRfidPlatform {
//   /// The method channel used to interact with the native platform.
//   @visibleForTesting
//   final methodChannel = const MethodChannel('metgroup_zebra_rfid');

//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
//     return version;
//   }
// }

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'metgroup_zebra_rfid_platform_interface.dart';

class MethodChannelMetgroupZebraRfid extends MetgroupZebraRfidPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('metgroup_zebra_rfid');

  @override
  Future<void> initialize() async {
    await methodChannel.invokeMethod('initialize');
  }

  @override
  Future<void> connect() async {
    await methodChannel.invokeMethod('connect');
  }

  @override
  Future<void> disconnect() async {
    await methodChannel.invokeMethod('disconnect');
  }

  @override
  Future<void> startRfidScan() async {
    await methodChannel.invokeMethod('startRfidScan');
  }

  @override
  Future<void> stopRfidScan() async {
    await methodChannel.invokeMethod('stopRfidScan');
  }

  @override
  Future<void> scanBarcode() async {
    await methodChannel.invokeMethod('scanBarcode');
  }

  @override
  Future<double> getBatteryLevel() async {
    final batteryLevel =
        await methodChannel.invokeMethod<double>('getBatteryLevel');
    return batteryLevel ?? 0.0;
  }

  // Implementar aquí los canales para los otros métodos...
}
