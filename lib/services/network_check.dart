import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DataConnectivityService {

  StreamController<InternetStatus> connectivityStreamController = StreamController<InternetStatus>();
  DataConnectivityService() {
    InternetConnection().onStatusChange.listen((dataConnectionStatus) {
      connectivityStreamController.add(dataConnectionStatus);
    });
  }

}