dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'signup_controller.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('SignupController', () {
    late SignupController controller;
    late MockBuildContext mockContext;

    setUp(() {
      controller = SignupController();
      mockContext = MockBuildContext();
    });

    tearDown(() {
      controller.dispose();
    });

    test('dispose disposes controllers', () {
      expect(controller.emailController.disposed, isFalse);
      expect(controller.passwordController.disposed, isFalse);
      expect(controller.confirmPasswordController.disposed, isFalse);
      controller.dispose();
      expect(controller.emailController.disposed, isTrue);
      expect(controller.passwordController.disposed, isTrue);
      expect(controller.confirmPasswordController.disposed, isTrue);
    });

    test('validate returns true if form is valid', () {
      when(controller.formKey.currentState?.validate()).thenReturn(true);
      expect(controller.validate(), isTrue);
    });

    test('validate returns false if form is invalid', () {
      when(controller.formKey.currentState?.validate()).thenReturn(false);
      expect(controller.validate(), isFalse);
    });


    test('signUp shows success snackbar', () async {
      when(controller.formKey.currentState?.validate()).thenReturn(true);
      await controller.signUp(mockContext);
      verify(ScaffoldMessenger.of(mockContext).showSnackBar(
        argThat(
          isA<SnackBar>()
              .having((s) => s.content.toString(), 'content', 'Signup successful (stub)'),
        ),
      ));
    });

    test('signUp does not show snackbar if form is invalid', () async {
      when(controller.formKey.currentState?.validate()).thenReturn(false);
      await controller.signUp(mockContext);
      verifyNever(ScaffoldMessenger.of(mockContext).showSnackBar(any));
    });
  });
}


