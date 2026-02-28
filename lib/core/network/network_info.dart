/// Network information checker
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // TODO: Implement using connectivity_plus package
  
  @override
  Future<bool> get isConnected async {
    // TODO: Check network connectivity
    return true;
  }
}

