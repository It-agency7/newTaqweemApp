import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetwotkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;

  NetwotkInfoImpl({
    required this.internetConnectionChecker,
  });

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
