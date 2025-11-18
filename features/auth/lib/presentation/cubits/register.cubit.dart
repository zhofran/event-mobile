// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../../data/auth.service.dart';
import '../../domain/models/company_type.model.dart';
import '../../domain/models/country.model.dart';
import '../../domain/models/location.model.dart';
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
  
  List<CountryModel> _countries = [];
  List<CountryModel> get countries => _countries;
  
  List<LocationModel> _cities = [];
  List<LocationModel> get cities => _cities;

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
        (type) {
          _companyTypes = type;
          emit(RegisterStateBerhasil()); 
          // _topics = topics;
          // emit(RegisterStateTopic(topics));

          log('Log result: $_companyTypes', name: 'Log getAllCompanyType Register Cubit');
        },
      );
    } catch (e) {
      
    }
  }

  Future<void> getAllCountries() async {
    try {
      emit(const RegisterStateLoading());

      final response = await _service.countries();

      response.fold(
        (failure) {
          log('Failed to load countries: ${failure.message}', name: 'Register Cubit');
          emit(RegisterStateFailed(failure));
        },
        (countriesList) {
          _countries = countriesList;
          log('Countries loaded successfully: ${_countries.length} countries', name: 'Register Cubit');
          emit(const RegisterStateBerhasil());
        },
      );
    } catch (e) {
      log('Exception in getAllCountries: $e', name: 'Register Cubit');
      // emit(RegisterStateFailed(
      //   UnknownNetworkFailure(message: 'An unexpected error occurred')
      // ));
    }
  }

  Future getAllCities({String? countrCode}) async {
    try {
      emit(RegisterStateInitial());

      final response = await _service.cities(countrCode ?? '');

      return response.fold(
        (failure) => emit(RegisterStateFailed(failure)),
        (citiesList){
          _cities = citiesList;
          emit(const RegisterStateBerhasil());
        }
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

  Future<bool> registerEventOrganizer({
    required String companyName,
    required int companyTypeId,
    required String companyDescription,
    required List<int> eventTypeIds,
    required String averageEventSize,
    required String websiteUrl,
    required int cityId,
    required List<String> venueTypes,
    required String repName,
    required String repPosition,
    required String repEmail,
    String? socialMediaUrl,
  }) async {
    emit(const RegisterStateLoading());

    final response = await _service.registerEventOrganizer(
      companyName: companyName,
      companyTypeId: companyTypeId,
      companyDescription: companyDescription,
      eventTypeIds: eventTypeIds,
      averageEventSize: averageEventSize,
      websiteUrl: websiteUrl,
      socialMediaUrl: socialMediaUrl,
      cityId: cityId,
      venueTypes: venueTypes,
      repName: repName,
      repPosition: repPosition,
      repEmail: repEmail,
    );

    return response.fold(
      (failure) {
        log('Failed to register EO: ${failure.message}', name: 'Register Cubit');
        emit(RegisterStateFailed(failure));
        return false;
      },
      (user) {
        log('EO registered successfully: ${user.id}', name: 'Register Cubit');
        emit(RegisterStateSucceeded(user));
        return true;
      },
    );
  }
  
}
