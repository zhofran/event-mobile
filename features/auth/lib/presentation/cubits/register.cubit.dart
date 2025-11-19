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
import '../../domain/models/company_type.model.dart';
import '../../domain/models/topic.model.dart';

part 'register.cubit.freezed.dart';
part 'states/register.state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._service) : super(const RegisterStateInitial());

  final AuthService _service;

  List<TopicModel> _topics = [];
  List<TopicModel> get topics => _topics;

  List<CompanyTypeModel> _companyTypes = [];
  List<CompanyTypeModel> get companyTypes => _companyTypes;

  Future register({
    required String email,
    required String password,
  }) async {
    var data = {};
    var didLogin = false;

    emit(const RegisterStateLoading());

    final response = await _service.register(email, password);

    // log('Log result: $response', name: 'Register Cubit');

    response.fold(
      (failure) => emit(RegisterStateFailed(failure)),
      (user) {
        emit(RegisterStateSucceeded(user));

        didLogin = true;

        data = {
          'login': didLogin,
          'user': user.id,
        };
      },
    );

    return data;
  }

  Future selectRole({int? roleID}) async {
    emit(RegisterStateLoading());

    final response = await _service.selectRole(roleID ?? 0);

    return response.fold(
      (failure) => emit(RegisterStateFailed(failure)), 
      (result) => emit(const RegisterStateBerhasil()),
    );
  }
  
  // Verify OTP
  Future verifyOtp({String? OTP, String? id}) async {
    bool regisSuccess = false;

    try {
      emit(const OtpVerifying());

      final response = await _service.otp(OTP ?? '', id ?? '');

      log('Log response hasil: $response', name: 'Login Cubit');

      response.fold(
        (failure) => emit(RegisterStateFailed(failure)), 
        (user) {
          emit(RegisterStateSucceeded(user));

          regisSuccess = true;
        },
      );

      return regisSuccess;
      
    } catch (e) {
      log('Error message: $e', name: 'Register Cubit Verify OTP');
    }
  }

  // Topic Attendee
  Future getAllTopic() async {
    try {
      emit(const RegisterStateInitial());

      final response = await _service.topic();

      // log('Log result: $response', name: 'Log Register Cubit');

      return response.fold(
        (failure) => emit(RegisterStateFailed(failure)), 
        (topics) {
          _topics = topics;
          emit(RegisterStateTopic(topics));

          // log('Log result: $topics', name: 'Log Register Cubit');
        },
      );
    } catch (e) {
      
    }
  }
  
  // Topic Attendee
  Future getAllCompanyType() async {
    try {
      emit(const RegisterStateInitial());

      final response = await _service.companyTypes();

      // log('Log result: $response', name: 'Log Register Cubit');

      return response.fold(
        (failure) => emit(RegisterStateFailed(failure)), 
        (companyTypes) {
          _companyTypes = companyTypes;
          emit(const RegisterStateInitial());
          // log('Log result: $companyTypes', name: 'Log Register Cubit');
        },
      );
    } catch (e) {
      
    }
  }

  Future registerAttendee({
    String? firstname,
    String? lastname,
    String? bio,
    String? avatar,
    List<int>? topics,
    List<int>? locations,
  }) async {
    emit(const RegisterStateInitial());

    final response = await _service.registerAttendee(
      firstname ?? '', 
      lastname ?? '', 
      bio ?? '', 
      avatar ?? '', 
      topics ?? [], 
      locations ?? [],
    );

    return response.fold(
      (failure) => emit(RegisterStateFailed(failure)), 
      (user) {
        log('Result from API: $user', name: 'Log Register Cubit');
        emit(RegisterStateSucceeded(user));
        log('User Successful created', name: 'Log Register Cubit');
      }
    );
  }
}
