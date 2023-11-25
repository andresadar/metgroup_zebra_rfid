package com.example.metgroup_zebra_rfid;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;
import android.os.Handler;
import android.os.Looper;

public class MetgroupZebraRfidPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private EventChannel rfidScanChannel;
  private EventChannel triggerActionChannel;
  private EventChannel deviceStatusChannel;
  private EventChannel connectionStatusChannel; // Nuevo canal para estado de conexión
  private Timer timer;
  private EventChannel.EventSink rfidScanEventSink;
  private EventChannel.EventSink triggerActionEventSink;
  private EventChannel.EventSink deviceStatusEventSink;
  private EventChannel.EventSink connectionStatusEventSink; // Nuevo EventSink para estado de conexión
  private boolean isConnected = false; // Variable para rastrear el estado de conexión

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "metgroup_zebra_rfid");
    channel.setMethodCallHandler(this);

    rfidScanChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "metgroup_zebra_rfid/rfid_scan");
    rfidScanChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        rfidScanEventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        rfidScanEventSink = null;
      }
    });

    triggerActionChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(),
        "metgroup_zebra_rfid/trigger_action");
    triggerActionChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        triggerActionEventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        triggerActionEventSink = null;
      }
    });

    deviceStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(),
        "metgroup_zebra_rfid/device_status");
    deviceStatusChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        deviceStatusEventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        deviceStatusEventSink = null;
      }
    });

    connectionStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "metgroup_zebra_rfid/connection_status");
    connectionStatusChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        connectionStatusEventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
        connectionStatusEventSink = null;
      }
    });
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    rfidScanChannel.setStreamHandler(null);
    triggerActionChannel.setStreamHandler(null);
    deviceStatusChannel.setStreamHandler(null);
    connectionStatusChannel.setStreamHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "initialize":
        startDeviceStatusEvents();
        result.success(null);
        break;
      case "connectRfid":
        isConnected = true;
        sendConnectionUpdate(isConnected);
        result.success(true);
        break;
      case "disconnectRfid":
        isConnected = false;
        sendConnectionUpdate(isConnected);
        result.success(true);
        break;
      case "startRfidScan":
        Integer memoryBankIndex = call.argument("memoryBankIndex");
        startSendingRandomEvents(memoryBankIndex);
        result.success(null);
        break;
      case "stopRfidScan":
        stopSendingRandomEvents();
        result.success(null);
        break;
      default:
        result.notImplemented();
    }
  }

  // Actualizar el estado interno de conexión del dispositivo RFID
  private void sendConnectionUpdate(boolean isConnected) {
    if (connectionStatusEventSink != null) {
      connectionStatusEventSink.success(isConnected);
    }
  }

  private Timer deviceStatusTimer; // Temporizador separado para el estado del dispositivo

  private void startDeviceStatusEvents() {
    if (deviceStatusTimer != null) {
      deviceStatusTimer.cancel();
    }
    deviceStatusTimer = new Timer();
    final Handler mainThreadHandler = new Handler(Looper.getMainLooper());

    deviceStatusTimer.schedule(new TimerTask() {
      @Override
      public void run() {
        mainThreadHandler.post(new Runnable() {
          @Override
          public void run() {
            // Actualizar y enviar estado del dispositivo en el hilo principal
            HashMap<String, Object> deviceStatus = new HashMap<>();
            deviceStatus.put("batteryLevel", 75);
            deviceStatus.put("power", true);
            deviceStatus.put("temperature", 30);
            if (deviceStatusEventSink != null) {
              deviceStatusEventSink.success(deviceStatus);
            }
          }
        });
      }
    }, 0, 30000); // Cada 30 segundos
  }

  private void startSendingRandomEvents(int memoryBankIndex) {
    if (timer != null) {
      timer.cancel();
    }
    timer = new Timer();
    final Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    timer.schedule(new TimerTask() {
      @Override
      public void run() {
        mainThreadHandler.post(new Runnable() {
          @Override
          public void run() {
            String fakeData = "Datos simulados para el banco de memoria " + memoryBankIndex;
            if (rfidScanEventSink != null) {
              HashMap<String, Object> rfidData = new HashMap<>();
              rfidData.put("id", "123");
              rfidData.put("data", fakeData);
              rfidScanEventSink.success(rfidData);
            }
            if (triggerActionEventSink != null) {
              HashMap<String, Object> triggerActionData = new HashMap<>();
              triggerActionData.put("trigger", "pressed");
              triggerActionEventSink.success(triggerActionData);
            }
          }
        });
      }
    }, 0, 10000); // Cada 10 segundos
  }

  private void stopSendingRandomEvents() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }
}