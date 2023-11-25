import Flutter
import UIKit

public class MetgroupZebraRfidPlugin: NSObject, FlutterPlugin {
    private var deviceStatusTimer: Timer?
    private var rfidScanTimer: Timer?
    private let rfidScanHandler = RfidScanStreamHandler()
    private let triggerActionHandler = TriggerActionStreamHandler()
    private let deviceStatusHandler = DeviceStatusStreamHandler()
    private let connectionStatusHandler = ConnectionStatusStreamHandler()
    private var isConnected = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MetgroupZebraRfidPlugin()

        let channel = FlutterMethodChannel(name: "metgroup_zebra_rfid", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)

        let rfidScanChannel = FlutterEventChannel(name: "metgroup_zebra_rfid/rfid_scan", binaryMessenger: registrar.messenger())
        rfidScanChannel.setStreamHandler(instance.rfidScanHandler)

        let triggerActionChannel = FlutterEventChannel(name: "metgroup_zebra_rfid/trigger_action", binaryMessenger: registrar.messenger())
        triggerActionChannel.setStreamHandler(instance.triggerActionHandler)

        let deviceStatusChannel = FlutterEventChannel(name: "metgroup_zebra_rfid/device_status", binaryMessenger: registrar.messenger())
        deviceStatusChannel.setStreamHandler(instance.deviceStatusHandler)

        let connectionStatusChannel = FlutterEventChannel(name: "metgroup_zebra_rfid/connection_status", binaryMessenger: registrar.messenger())
        connectionStatusChannel.setStreamHandler(instance.connectionStatusHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            startDeviceStatusEvents() // Enviar datos fake del estado del dispositivo después de inicializar
            result(nil)
        case "connectRfid":
            isConnected = true
            connectionStatusHandler.sendConnectionUpdate(isConnected: isConnected)
            result(true)
        case "disconnectRfid":
            isConnected = false
            connectionStatusHandler.sendConnectionUpdate(isConnected: isConnected)
            result(true)
        case "startRfidScan":
            if let args = call.arguments as? [String: Any], let memoryBankValue = args["memoryBankIndex"] as? Int {
                startSendingRfidScanEvents(memoryBankIndex: memoryBankValue)
            }
            result(nil)
        case "stopRfidScan":
            stopRfidScanEvents()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startDeviceStatusEvents() {
        deviceStatusTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.deviceStatusHandler.sendFakeDeviceStatusData()
        }
    }

    private func startSendingRfidScanEvents(memoryBankIndex: Int) {
        rfidScanTimer?.invalidate()
        rfidScanTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            let fakeData = "Datos simulados para el banco de memoria \(memoryBankIndex)"
            strongSelf.rfidScanHandler.sendFakeRfidScanData(data: fakeData)
            strongSelf.triggerActionHandler.sendFakeTriggerActionData()
        }
    }

    private func stopRfidScanEvents() {
        rfidScanTimer?.invalidate()
        rfidScanTimer = nil
    }
}

class RfidScanStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendFakeRfidScanData(data: String) {
        eventSink?(["id": "123", "data": data])
    }
}

class TriggerActionStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendFakeTriggerActionData() {
        eventSink?(["trigger": "pressed"])
    }
}

class DeviceStatusStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendFakeDeviceStatusData() {
        let fakeDeviceStatus: [String: Any] = ["batteryLevel": 75, "power": true, "temperature": 30]
        eventSink?(fakeDeviceStatus)
    }
}

class ConnectionStatusStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Puedes enviar un estado inicial aquí si es necesario
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    func sendConnectionUpdate(isConnected: Bool) {
        eventSink?(isConnected)
    }
}