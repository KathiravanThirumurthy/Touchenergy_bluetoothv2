import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' as fb;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
//import 'package:flutter_switch/flutter_switch.dart';

class Toggleswitch extends StatefulWidget {
  @override
  _ToggleswitchState createState() => _ToggleswitchState();
}

class _ToggleswitchState extends State<Toggleswitch> {
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  fb.FlutterBlue _bluetoothfb = fb.FlutterBlue.instance;
  fb.BluetoothDevice connectedDevice;
  List<fb.BluetoothService> bluetoothServices;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  String _address = "...";

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;
  // enable and disable scan device button
  bool isButtonDisabled = false;
  int _deviceState;
  // Define a new class member variable
// for storing the devices list
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;
  // To track whether the device is still connected to Bluetooth
  //bool get isConnected => connection != null && connection.isConnected;

  //String get address => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceState = 0;
    // checkblueToothState();
    _bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_ON) {
          isButtonDisabled = true;
        } else {
          isButtonDisabled = false;
        }
      });
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        if (_bluetoothState == BluetoothState.STATE_ON) {
          isButtonDisabled = true;
        } else {
          isButtonDisabled = false;
        }

        // For retrieving the paired devices list
        _bluetoothfb.connectedDevices
            .asStream()
            .listen((List<fb.BluetoothDevice> devices) {
          for (fb.BluetoothDevice device in devices) {
            //_showDeviceTolist(device);
            print(device);
          }
        });
        _bluetoothfb.scanResults.listen((List<fb.ScanResult> results) {
          for (fb.ScanResult result in results) {
            //_showDeviceTolist(result.device);
            print(result.device);
          }
        });
        _bluetoothfb.startScan();
      });
    });

    enableBluetooth();
  }

  Future<void> getPairedDevices() async {}

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> disableBluetooth() async {
    _bluetoothState = await _bluetooth.state;
    if (_bluetoothState == BluetoothState.STATE_ON) {
      await _bluetooth.requestDisable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

// to check blue tooth state
  checkblueToothState() {
    _bluetooth.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        if (_bluetoothState == BluetoothState.STATE_ON) {
          isButtonDisabled = true;
        } else {
          isButtonDisabled = false;
        }

        // For retrieving the paired devices list
        getPairedDevices();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Enable Bluetooth',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1,
                  child: Switch(
                    value: _bluetoothState.isEnabled,
                    /* activeColor: Colors.blue,
                    activeTrackColor: Colors.yellow,
                    inactiveThumbColor: Colors.redAccent,
                    inactiveTrackColor: Colors.orange,*/
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          // Enable Bluetooth
                          await _bluetooth.requestEnable();
                          // await getPairedDevices();
                        } else {
                          // Disable Bluetooth
                          await _bluetooth.requestDisable();
                          // await getPairedDevices();
                        }
                        await getPairedDevices();
                        // _isButtonUnavailable = false;
                      }

                      future().then((_) {
                        setState(() {});
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Text(_bluetoothState.toString()),
          //_scanDeviceButton(),
          RaisedButton(
            onPressed: isButtonDisabled
                ? () {
                    //getPairedDevices();
                    //bluetoothConnectionState();
                    print("Scan");

                    /* _bluetoothfb.scanResults
                        .listen((List<fb.ScanResult> results) {
                      for (fb.ScanResult result in results) {
                        //_showDeviceTolist(result.device);
                        print("result : $result.device");
                      }
                    });*/
                  }
                : null,
            child: Text('Scan Device'),
            textColor: Colors.white,
            color: Colors.amber[900],
          )
        ],
      ),
    );
  }
}
