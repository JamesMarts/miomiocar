import 'app_exception.dart';

/// 统一结果类型
/// 使用 sealed class 实现类型安全的结果处理
sealed class Result<T> {
  const Result();

  /// 判断是否成功
  bool get isSuccess => this is Success<T>;

  /// 判断是否失败
  bool get isFailure => this is Failure<T>;

  /// 获取数据（如果成功）
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };

  /// 获取异常（如果失败）
  AppException? get exceptionOrNull => switch (this) {
        Success() => null,
        Failure(exception: final e) => e,
      };

  /// 创建成功结果
  factory Result.success(T data) = Success<T>;

  /// 创建失败结果
  factory Result.failure(AppException exception) = Failure<T>;

  /// 从异步操作创建结果
  static Future<Result<T>> fromAsync<T>(Future<T> Function() operation) async {
    try {
      final data = await operation();
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e, stackTrace) {
      return Result.failure(UnknownException.from(e, stackTrace));
    }
  }

  /// 从同步操作创建结果
  static Result<T> fromSync<T>(T Function() operation) {
    try {
      final data = operation();
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e, stackTrace) {
      return Result.failure(UnknownException.from(e, stackTrace));
    }
  }
}

/// 成功结果
final class Success<T> extends Result<T> {
  /// 成功数据
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

/// 失败结果
final class Failure<T> extends Result<T> {
  /// 异常信息
  final AppException exception;

  const Failure(this.exception);

  @override
  String toString() => 'Failure(exception: $exception)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> && other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;
}

/// Result 扩展方法
extension ResultExtension<T> on Result<T> {
  /// 模式匹配处理结果
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(exception: final e) => failure(e),
    };
  }

  /// 只处理成功情况
  void whenSuccess(void Function(T data) action) {
    if (this case Success(data: final data)) {
      action(data);
    }
  }

  /// 只处理失败情况
  void whenFailure(void Function(AppException exception) action) {
    if (this case Failure(exception: final e)) {
      action(e);
    }
  }

  /// 映射成功数据
  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Result.success(mapper(data)),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// 异步映射成功数据
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    return switch (this) {
      Success(data: final data) => Result.success(await mapper(data)),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// 扁平化映射
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => mapper(data),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// 异步扁平化映射
  Future<Result<R>> flatMapAsync<R>(Future<Result<R>> Function(T data) mapper) async {
    return switch (this) {
      Success(data: final data) => await mapper(data),
      Failure(exception: final e) => Result.failure(e),
    };
  }

  /// 获取数据或默认值
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(data: final data) => data,
      Failure() => defaultValue,
    };
  }

  /// 获取数据或抛出异常
  T getOrThrow() {
    return switch (this) {
      Success(data: final data) => data,
      Failure(exception: final e) => throw e,
    };
  }

  /// 恢复失败情况
  Result<T> recover(T Function(AppException exception) recovery) {
    return switch (this) {
      Success() => this,
      Failure(exception: final e) => Result.success(recovery(e)),
    };
  }

  /// 转换异常
  Result<T> mapException(AppException Function(AppException exception) mapper) {
    return switch (this) {
      Success() => this,
      Failure(exception: final e) => Result.failure(mapper(e)),
    };
  }

  /// 执行副作用但返回原结果
  Result<T> tap({
    void Function(T data)? onSuccess,
    void Function(AppException exception)? onFailure,
  }) {
    switch (this) {
      case Success(data: final data):
        onSuccess?.call(data);
      case Failure(exception: final e):
        onFailure?.call(e);
    }
    return this;
  }
}

/// Future<Result> 扩展方法
extension FutureResultExtension<T> on Future<Result<T>> {
  /// 异步模式匹配
  Future<R> when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) async {
    final result = await this;
    return result.when(success: success, failure: failure);
  }

  /// 异步映射
  Future<Result<R>> map<R>(R Function(T data) mapper) async {
    final result = await this;
    return result.map(mapper);
  }

  /// 异步扁平化映射
  Future<Result<R>> flatMap<R>(Result<R> Function(T data) mapper) async {
    final result = await this;
    return result.flatMap(mapper);
  }
}

/// 组合多个Result
extension ResultCombineExtension on Iterable<Result<dynamic>> {
  /// 检查所有结果是否都成功
  bool get allSuccess => every((r) => r.isSuccess);

  /// 检查是否有任意失败
  bool get anyFailure => any((r) => r.isFailure);

  /// 获取第一个失败的异常
  AppException? get firstFailure {
    for (final result in this) {
      if (result case Failure(exception: final e)) {
        return e;
      }
    }
    return null;
  }
}

