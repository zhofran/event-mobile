// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../../data/auth.service.dart';

part 'login.cubit.freezed.dart';
part 'states/login.state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._service) : super(const LoginStateInitial());

  final AuthService _service;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // try {
    //   final response = await _service.login(email, password);
      
    //   // 👇 Tambahkan log ini
    //   log('Raw Response: $response', name: 'Login Cubit');
      
    //   // final user = UserModel.fromJson(response);
    //   // return Right(user);
    // } catch (e, stackTrace) {
    //   log('Error: $e');
    //   log('StackTrace: $stackTrace');
    //   // return Left(ServerFailure(message: e.toString()));
    // }
    var didLogin = false;

    emit(const LoginStateLoading());

    final response = await _service.login(email, password);

    response.fold(
      (failure)  {
        log('Log Response hasil awai: ${failure.message}', name: 'Login Cubit');
        emit(LoginStateFailed(failure));
      },
      (user) {
        emit(LoginStateSucceeded(user));

        didLogin = true;
      },
    );

    return didLogin;
  }

  // Future<void> verifyOtp(String otp, String phoneNumber) async {
  //   try {
  //     emit(const OtpVerifying());

  //     // TODO: Replace dengan actual API call
  //     // final result = await authRepository.verifyOtp(otp, phoneNumber);
      
  //     // Simulasi API call
  //     await Future.delayed(const Duration(seconds: 2));

  //     // Simulasi validasi
  //     if (otp == '123456') {
  //       // Success
  //       stopTimer();
  //       emit(const OtpVerified(
  //         message: 'OTP verified successfully!',
  //         userData: {
  //           'phone': phoneNumber,
  //           'verified': true,
  //         },
  //       ));
  //     } else {
  //       // Invalid OTP
  //       emit(const OtpInvalid(message: 'Invalid OTP code. Please try again.'));
  //       // Restart timer after error
  //       Future.delayed(const Duration(milliseconds: 500), () {
  //         if (_remainingSeconds > 0) {
  //           emit(OtpTimerRunning(_remainingSeconds));
  //         } else {
  //           emit(const OtpTimerCompleted());
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     emit(OtpError(e.toString()));
  //     // Restart timer after error
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       if (_remainingSeconds > 0) {
  //         emit(OtpTimerRunning(_remainingSeconds));
  //       } else {
  //         emit(const OtpTimerCompleted());
  //       }
  //     });
  //   }
  // }


}
