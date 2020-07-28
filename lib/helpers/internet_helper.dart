import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class InternetHelper {
  Future<bool> isInternet() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    DataConnectionChecker _connectionChecker = DataConnectionChecker();

    if (connectivityResult == ConnectivityResult.mobile) {
      if (await _connectionChecker.hasConnection) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await _connectionChecker.hasConnection) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}