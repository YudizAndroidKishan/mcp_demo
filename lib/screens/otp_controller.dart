// otp_service.dart
import 'dart:async';

abstract class OtpService {
  /// Sends an OTP to the given phone number.
  Future<void> sendOtp({required String phoneNumber});

  /// Verifies the given [otp] for the [phoneNumber].
  /// Returns true if valid.
  Future<bool> verifyOtp({required String phoneNumber, required String otp});
}

// otp_state.dart
/// Possible states of the OTP flow.
enum OtpStatus { initial, loading, sent, verified, error }

/// Holds the current OTP state and optional message (e.g. error text).
class OtpState {
  final OtpStatus status;
  final String? message;

  const OtpState._({required this.status, this.message});
  const OtpState.initial() : this._(status: OtpStatus.initial);
  const OtpState.loading() : this._(status: OtpStatus.loading);
  const OtpState.sent() : this._(status: OtpStatus.sent);
  const OtpState.verified() : this._(status: OtpStatus.verified);
  const OtpState.error(String message)
      : this._(status: OtpStatus.error, message: message);
}

/// A controller that manages OTP sending & verification.
/// Its dependency [OtpService] is injected, making it easy to mock for tests.
class OtpController {
  final OtpService _service;
  final StreamController<OtpState> _stateController =
      StreamController<OtpState>.broadcast();

  /// Stream to listen for state changes.
  Stream<OtpState> get state => _stateController.stream;

  OtpController(this._service) {
    _stateController.add(const OtpState.initial());
  }

  /// Sends OTP and updates state accordingly.
  Future<void> sendOtp(String phoneNumber) async {
    _stateController.add(const OtpState.loading());
    try {
      await _service.sendOtp(phoneNumber: phoneNumber);
      _stateController.add(const OtpState.sent());
    } catch (e) {
      _stateController.add(OtpState.error(e.toString()));
    }
  }

  /// Verifies OTP and updates state accordingly.
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    _stateController.add(const OtpState.loading());
    try {
      final isValid =
          await _service.verifyOtp(phoneNumber: phoneNumber, otp: otp);
      if (isValid) {
        _stateController.add(const OtpState.verified());
      } else {
        _stateController.add(const OtpState.error('Invalid OTP'));
      }
    } catch (e) {
      _stateController.add(OtpState.error(e.toString()));
    }
  }

  /// Clean up resources.
  void dispose() {
    _stateController.close();
  }
}
