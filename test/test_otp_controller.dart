dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/screens/otp_controller.dart';

class MockOtpService extends Mock implements OtpService {}

void main() {
  group('OtpController', () {
    late MockOtpService mockOtpService;
    late OtpController otpController;

    setUp(() {
      mockOtpService = MockOtpService();
      otpController = OtpController(mockOtpService);
    });

    tearDown(() {
      otpController.dispose();
    });

    test('initial state is initial', () {
      expect(otpController.state, emits(const OtpState.initial()));
    });

    test('sendOtp updates state correctly on success', () async {
      when(mockOtpService.sendOtp(phoneNumber: anyNamed('phoneNumber')))
          .thenAnswer((_) async {});
      expect(otpController.state, emitsInOrder([
        const OtpState.loading(),
        const OtpState.sent()
      ]));
      await otpController.sendOtp('1234567890');
    });

    test('sendOtp updates state correctly on error', () async {
      when(mockOtpService.sendOtp(phoneNumber: anyNamed('phoneNumber')))
          .thenThrow(Exception('Network error'));
      expect(otpController.state, emits(
          predicate((OtpState state) => state.status == OtpStatus.error)));
      await otpController.sendOtp('1234567890');
    });


    test('verifyOtp updates state correctly on success', () async {
      when(mockOtpService.verifyOtp(
              phoneNumber: anyNamed('phoneNumber'), otp: anyNamed('otp')))
          .thenAnswer((_) async => true);
      expect(otpController.state, emitsInOrder([
        const OtpState.loading(),
        const OtpState.verified()
      ]));
      await otpController.verifyOtp('1234567890', '1234');
    });

    test('verifyOtp updates state correctly on invalid OTP', () async {
      when(mockOtpService.verifyOtp(
              phoneNumber: anyNamed('phoneNumber'), otp: anyNamed('otp')))
          .thenAnswer((_) async => false);
      expect(otpController.state, emits(
          predicate((OtpState state) =>
              state.status == OtpStatus.error && state.message == 'Invalid OTP')));
      await otpController.verifyOtp('1234567890', '1234');
    });

    test('verifyOtp updates state correctly on error', () async {
      when(mockOtpService.verifyOtp(
              phoneNumber: anyNamed('phoneNumber'), otp: anyNamed('otp')))
          .thenThrow(Exception('Network error'));
      expect(otpController.state, emits(
          predicate((OtpState state) => state.status == OtpStatus.error)));
      await otpController.verifyOtp('1234567890', '1234');
    });
  });
}


