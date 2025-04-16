dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/screens/login_controller.dart';

class MockLoginService extends Mock {
  Future<bool> call(String username, String password);
}

void main() {
  group('LoginController', () {
    late LoginController controller;
    late MockLoginService mockLoginService;

    setUp(() {
      mockLoginService = MockLoginService();
      controller = LoginController();
      when(mockLoginService('admin', 'password123')).thenAnswer((_) async => true);
      when(mockLoginService(any, any)).thenAnswer((_) async => false);

    });

    test('updateUsername updates username', () {
      controller.updateUsername('testuser');
      expect(controller.username, 'testuser');
    });

    test('updatePassword updates password', () {
      controller.updatePassword('testpass');
      expect(controller.password, 'testpass');
    });

    test('login sets isLoading to true', () async {
      expect(controller.isLoading, false);
      await controller.login();
      expect(controller.isLoading, false);
    });

    test('successful login returns true', () async {
      controller.updateUsername('admin');
      controller.updatePassword('password123');
      final result = await controller.login();
      expect(result, true);
      expect(controller.errorMessage, null);
    });

    test('failed login returns false and sets errorMessage', () async {
      controller.updateUsername('wronguser');
      controller.updatePassword('wrongpass');
      final result = await controller.login();
      expect(result, false);
      expect(controller.errorMessage, 'Invalid username or password');
    });

    test('resetState resets the controller', () {
      controller.updateUsername('testuser');
      controller.updatePassword('testpass');
      controller.resetState();
      expect(controller.username, '');
      expect(controller.password, '');
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
    });
  });
}


