import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_demo/app/core/network/dio_client.dart';
import 'package:flutter_demo/app/features/user/data/repositories/user_repository.dart';
import 'package:flutter_demo/app/features/user/data/models/user_model.dart';

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

      // 验证结果 - 使用 Result 类型
      expect(result.isSuccess, true);
      final pageResponse = result.dataOrNull!;
      expect(pageResponse.page, 1);
      expect(pageResponse.pageSize, 20);
      expect(pageResponse.total, 100);
      expect(pageResponse.items.length, 1);
      expect(pageResponse.items[0].username, 'test_user');

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

      // 验证结果 - 使用 Result 类型
      expect(result.isSuccess, true);
      final user = result.dataOrNull!;
      expect(user.id, 1);
      expect(user.username, 'test_user');
      expect(user.email, 'test@example.com');

      // 验证Mock调用
      verify(mockDioClient.get<Map<String, dynamic>>(
        '/users/1',
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    // 测试：搜索用户成功
    test('searchUsers returns list of users successfully', () async {
      // 准备测试数据
      final mockResponse = {
        'page': 1,
        'pageSize': 20,
        'total': 10,
        'totalPages': 1,
        'items': [
          {
            'id': 1,
            'username': 'search_user',
            'email': 'search@example.com',
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
      final result = await userRepository.searchUsers(
        keyword: 'search',
        page: 1,
        pageSize: 20,
      );

      // 验证结果 - 使用 Result 类型
      expect(result.isSuccess, true);
      final pageResponse = result.dataOrNull!;
      expect(pageResponse.items.length, 1);
      expect(pageResponse.items[0].username, 'search_user');

      // 验证Mock调用
      verify(mockDioClient.get<Map<String, dynamic>>(
        '/users/search',
        queryParameters: {'keyword': 'search', 'page': 1, 'page_size': 20},
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });

    // 测试：更新用户成功
    test('updateUser returns updated user successfully', () async {
      // 准备测试数据
      final mockUser = {
        'id': 1,
        'username': 'updated_user',
        'email': 'updated@example.com',
      };

      // 设置Mock行为
      when(mockDioClient.put<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockUser);

      // 执行测试
      final result = await userRepository.updateUser(1, {'username': 'updated_user'});

      // 验证结果 - 使用 Result 类型
      expect(result.isSuccess, true);
      final user = result.dataOrNull!;
      expect(user.username, 'updated_user');
    });

    // 测试：获取当前用户成功
    test('getCurrentUser returns current user successfully', () async {
      // 准备测试数据
      final mockUser = {
        'id': 1,
        'username': 'current_user',
        'email': 'current@example.com',
      };

      // 设置Mock行为
      when(mockDioClient.get<Map<String, dynamic>>(
        any,
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async => mockUser);

      // 执行测试
      final result = await userRepository.getCurrentUser();

      // 验证结果 - 使用 Result 类型
      expect(result.isSuccess, true);
      final user = result.dataOrNull!;
      expect(user.id, 1);
      expect(user.username, 'current_user');
    });
  });
}
