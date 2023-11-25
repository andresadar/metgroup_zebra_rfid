// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// import 'metgroup_zebra_rfid_method_channel.dart';

// abstract class MetgroupZebraRfidPlatform extends PlatformInterface {
//   /// Constructs a MetgroupZebraRfidPlatform.
//   MetgroupZebraRfidPlatform() : super(token: _token);

//   static final Object _token = Object();

//   static MetgroupZebraRfidPlatform _instance = MethodChannelMetgroupZebraRfid();

//   /// The default instance of [MetgroupZebraRfidPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelMetgroupZebraRfid].
//   static MetgroupZebraRfidPlatform get instance => _instance;

//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [MetgroupZebraRfidPlatform] when
//   /// they register themselves.
//   static set instance(MetgroupZebraRfidPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }

//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }
// }

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'metgroup_zebra_rfid_method_channel.dart';

abstract class MetgroupZebraRfidPlatform extends PlatformInterface {
  MetgroupZebraRfidPlatform() : super(token: _token);

  static final Object _token = Object();

  static MetgroupZebraRfidPlatform _instance = MethodChannelMetgroupZebraRfid();

  static MetgroupZebraRfidPlatform get instance => _instance;

  static set instance(MetgroupZebraRfidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize();
  Future<void> connect();
  Future<void> disconnect();
  Future<void> startRfidScan();
  Future<void> stopRfidScan();
  Future<void> scanBarcode();
  Future<double> getBatteryLevel();

  // Definir aquí las interfaces para más métodos...
}
