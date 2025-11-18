import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// 网络状态枚举
enum NetworkStatus {
  /// 已连接
  connected,
  
  /// 未连接
  disconnected,
  
  /// 未知
  unknown,
}

/// 网络连接服务
/// 监听网络状态变化
class ConnectivityService {
  /// Connectivity实例
  final Connectivity _connectivity = Connectivity();
  
  /// 网络状态流控制器
  final StreamController<NetworkStatus> _statusController = StreamController<NetworkStatus>.broadcast();
  
  /// 当前网络状态
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  
  /// 网络状态订阅
  StreamSubscription<ConnectivityResult>? _subscription;

  /// 获取网络状态流
  Stream<NetworkStatus> get statusStream => _statusController.stream;
  
  /// 获取当前网络状态
  NetworkStatus get currentStatus => _currentStatus;
  
  /// 判断是否已连接
  bool get isConnected => _currentStatus == NetworkStatus.connected;

  /// 初始化网络监听
  Future<void> init() async {
    try {
      // 检查当前网络状态
      final result = await _connectivity.checkConnectivity();
      _updateStatus([result]);
      
      // 监听网络状态变化
      _subscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          _updateStatus([result]);
        },
        onError: (error) {
          debugPrint('❌ Connectivity error: $error');
          _updateStatus([ConnectivityResult.none]);
        },
      );
      
      debugPrint('🌐 Connectivity service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize connectivity service: $e');
    }
  }

  /// 更新网络状态
  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus = _determineStatus(results);
    
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
      
      debugPrint('🌐 Network status changed: ${_currentStatus.name}');
    }
  }

  /// 判断网络状态
  NetworkStatus _determineStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkStatus.disconnected;
    }
    
    // 如果包含wifi、mobile或ethernet，视为已连接
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet)) {
      return NetworkStatus.connected;
    }
    
    return NetworkStatus.unknown;
  }

  /// 手动检查网络状态
  Future<NetworkStatus> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final status = _determineStatus([result]);
      _currentStatus = status;
      return status;
    } catch (e) {
      debugPrint('❌ Failed to check connectivity: $e');
      return NetworkStatus.unknown;
    }
  }

  /// 释放资源
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}

