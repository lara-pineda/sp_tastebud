import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionCheckerPlus _internetChecker =
      InternetConnectionCheckerPlus();
  StreamController<ConnectivityStatus> _connectionStatusController =
      StreamController<ConnectivityStatus>();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetConnectionStatus>? _internetSubscription;

  ConnectivityService() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _handleConnectivityChange(result);
    });
    _internetSubscription = _internetChecker.onStatusChange.listen((status) {
      _connectionStatusController.add(_mapStatusToConnectivityStatus(status));
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _connectionStatusController.close();
  }

  Stream<ConnectivityStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Assuming the first result in the list is the status update
    if (results.isNotEmpty) {
      _updateConnectionStatus(results.first);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _connectionStatusController.add(ConnectivityStatus.disconnected);
    } else {
      final hasConnection = await _internetChecker.hasConnection;
      if (hasConnection) {
        _connectionStatusController.add(ConnectivityStatus.connected);
      } else {
        _connectionStatusController.add(ConnectivityStatus.disconnected);
      }
    }
  }

  ConnectivityStatus _mapStatusToConnectivityStatus(
      InternetConnectionStatus status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        return ConnectivityStatus.connected;
      case InternetConnectionStatus.disconnected:
        return ConnectivityStatus.disconnected;
      default:
        return ConnectivityStatus.disconnected;
    }
  }

  Future<bool> hasInternetAccess() async {
    try {
      // try to ping google
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5));
      if (result.statusCode == 200) {
        return true;
      }
    } on SocketException {
      print('No Internet connection');
    } on TimeoutException {
      print('The connection has timed out');
    } on HttpException {
      print('HTTP error');
    } on FormatException {
      print('Format error');
    } catch (e) {
      print('Unexpected error: $e');
    }
    return false;
  }
}

enum ConnectivityStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final ConnectivityService _connectivityService;

  ConnectivityCubit(this._connectivityService)
      : super(ConnectivityStatus.connected) {
    _connectivityService.connectionStatusStream.listen((status) {
      emit(status);
    });
  }

  Future<void> checkConnectivity() async {
    final hasConnection = await _connectivityService.hasInternetAccess();
    if (hasConnection) {
      emit(ConnectivityStatus.connected);
    } else {
      emit(ConnectivityStatus.disconnected);
    }
  }

  @override
  Future<void> close() {
    _connectivityService.dispose();
    return super.close();
  }
}
