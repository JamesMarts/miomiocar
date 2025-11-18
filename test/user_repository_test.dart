import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/data/repositories/user_repository.dart';
import 'package:flutter_demo/app/data/models/user_model.dart';

// 生成Mock类
// 运行命令：flutter pub run build_runner build
@GenerateMocks([DioClient])
import 'user_repository_test.mocks.dart';

void main() {
  // 测试组：UserRepository
  group('UserRepository Tests', () {
    // 声明变量
    late MockDioClient mockDioClient;
    late UserRepository userRepository;

    // 每个测试前执行
    setUp(() {
      mockDioClient = MockDioClient();
      userRepository = UserRepository(mockDioClient);
    });

    // 测试：获取用户列表成功
    test('getUserList returns list of users successfully', () async {
      // 准备测试数据
      final mockResponse = {
        'page': 1,
        'pageSize': 20,
        'total': 100,
        'totalPages': 5,
        'items': [
          {
            'id': 1,
            'username': 'test_user',
            'email': 'test@example.com',
          },
        ],
      };

      // 设置Mock行为
      when(mockDioClient.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);

      // 执行测试
      final result = await userRepository.getUserList(page: 1, pageSize: 20);

      // 验证结果
      expect(result.page, 1);
      expect(result.pageSize, 20);
      expect(result.total, 100);
      expect(result.items.length, 1);
      expect(result.items[0].username, 'test_user');

      // 验证Mock调用
      verify(mockDioClient.get<Map<String, dynamic>>(
        '/users',
        queryParameters: {'page': 1, 'page_size': 20},
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    // 测试：根据ID获取用户成功
    test('getUserById returns user successfully', () async {
      // 准备测试数据
      final mockUser = {
        'id': 1,
        'username': 'test_user',
        'email': 'test@example.com',
      };

      // 设置Mock行为
      when(mockDioClient.get<Map<String, dynamic>>(
        any,
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockUser);

      // 执行测试
      final result = await userRepository.getUserById(1);

      // 验证结果
      expect(result.id, 1);
      expect(result.username, 'test_user');
      expect(result.email, 'test@example.com');

      // 验证Mock调用
      verify(mockDioClient.get<Map<String, dynamic>>(
        '/users/1',
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    // 测试：登录成功
    test('login returns LoginResponse successfully', () async {
      // 准备测试数据
      final mockResponse = {
        'access_token': 'test_token',
        'refresh_token': 'test_refresh_token',
        'token_type': 'Bearer',
        'expires_in': 3600,
        'user': {
          'id': 1,
          'username': 'test_user',
          'email': 'test@example.com',
        },
      };

      // 设置Mock行为
      when(mockDioClient.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockResponse);

      // 执行测试
      final request = LoginRequest(
        username: 'test_user',
        password: 'password123',
      );
      final result = await userRepository.login(request);

      // 验证结果
      expect(result.accessToken, 'test_token');
      expect(result.user.username, 'test_user');

      // 验证Mock调用
      verify(mockDioClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });
  });
}

