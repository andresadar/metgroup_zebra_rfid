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

  // Inicializar el SDK
  Future<dynamic> initialize();

  Future<bool> connectRfid();
  Future<bool> disconnectRfid();

  // Stream para cambios del estado del dispositivo (Conectado, desconectado)
  Stream<dynamic> onConnectionStatus();

  // Empezar el proceso de inventario
  Future<void> startRfidScan(int memoryBankIndex);

  // Detener el proceso de inventario
  Future<void> stopRfidScan();

  // Stream de los tags leídos después de un proceso de empezar inventario
  Stream<dynamic> onListenRFID();

  // Stream para los eventos del gatillo (En el proceso de inventario)
  Stream<dynamic> onTriggerAction();

  // Stream para el estado del Dispositivo RFID
  Stream<dynamic> onDeviceStatus();

  // Empezar la localización de un tag (Necesita el id del tag)
  // TODO:

  // Detener la localización de un tag
  // TODO:

  // Stream para la ubicación de un tag
  // TODO:

  // Cambiar la pistola a modo de RFID a Barcode y viceversa
  // TODO:

  // Escribir en los tags
  // TODO:
}
