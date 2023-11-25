// import 'metgroup_zebra_rfid_platform_interface.dart';

// class MetgroupZebraRfid {
//   Future<String?> getPlatformVersion() {
//     return MetgroupZebraRfidPlatform.instance.getPlatformVersion();
//   }
// }

import 'metgroup_zebra_rfid_platform_interface.dart';

class MetgroupZebraRfid {
  Future<void> initialize() async {
    await MetgroupZebraRfidPlatform.instance.initialize();
  }

  Future<void> connect() async {
    await MetgroupZebraRfidPlatform.instance.connect();
  }

  Future<void> disconnect() async {
    await MetgroupZebraRfidPlatform.instance.disconnect();
  }

  Future<void> startRfidScan() async {
    await MetgroupZebraRfidPlatform.instance.startRfidScan();
  }

  Future<void> stopRfidScan() async {
    await MetgroupZebraRfidPlatform.instance.stopRfidScan();
  }

  Future<void> scanBarcode() async {
    await MetgroupZebraRfidPlatform.instance.scanBarcode();
  }

  Future<double> getBatteryLevel() async {
    return await MetgroupZebraRfidPlatform.instance.getBatteryLevel();
  }

  // Añadir más métodos de API según sea necesario...
}
