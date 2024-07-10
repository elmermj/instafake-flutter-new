import 'package:connectivity_plus/connectivity_plus.dart' as cp;
import 'package:flutter/material.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart' as ws;

enum ConnectivityStatus { connected, disconnected }

class ConnectivityProvider extends ChangeNotifier {
  late ws.WebSocketChannel _channel;
  ConnectivityStatus _status = ConnectivityStatus.disconnected;
  bool _isConnected = true;

  ConnectivityStatus get status => _status;
  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    cp.Connectivity().onConnectivityChanged.listen((status) {
      _getNetworkStatus(status.first);
    });
    // _connectToWSS();
  }

  void _getNetworkStatus(cp.ConnectivityResult status) {
    if (status == cp.ConnectivityResult.mobile ||
        status == cp.ConnectivityResult.wifi ||
        status == cp.ConnectivityResult.other) {
      _status = ConnectivityStatus.connected;
    } else {
      _status = ConnectivityStatus.disconnected;
    }
    notifyListeners();
  }

  void _connectToWSS() {
    _channel = ws.WebSocketChannel.connect(Uri.parse(WEBSOCKET_URL));

    _channel.stream.listen((data) {
      Log.green("Connected to websocket");
      _isConnected = true;
      notifyListeners();
    }, onError: (error) {
      Log.red("error ::: $error");
      _isConnected = false;
      notifyListeners();
    }, onDone: () {
      Log.pink("done");
      _isConnected = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

}
