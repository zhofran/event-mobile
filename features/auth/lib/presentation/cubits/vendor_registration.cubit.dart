// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/auth.service.dart';
import '../../domain/models/vendor_registration_data.model.dart';

part 'vendor_registration.cubit.freezed.dart';
part 'states/vendor_registration.state.dart';

@injectable
class VendorRegistrationCubit extends Cubit<VendorRegistrationState> {
  VendorRegistrationCubit(this._authService) : super(const VendorRegistrationStateInitial());

  final AuthService _authService;
  VendorRegistrationData _data = VendorRegistrationData();

  VendorRegistrationData get data => _data;

  void updateStep1({
    String? companyName,
    String? companyType,
    String? companyTypeId,
    String? companyDescription,
    String? companyAvatar,
  }) {
    _data = _data.copyWith(
      companyName: companyName,
      companyType: companyType,
      companyTypeId: companyTypeId,
      companyDescription: companyDescription,
      companyAvatar: companyAvatar,
    );
    
    emit(VendorRegistrationStateStep1Updated(_data));
    log('Step 1 updated: ${_data.toString()}', name: 'VendorRegistration');
  }

  void updateStep2({
    String? foundedYear,
    String? websiteUrl,
    String? socialMediaUrl,
    String? paymentTerm,
  }) {
    _data = _data.copyWith(
      foundedYear: foundedYear,
      websiteUrl: websiteUrl,
      socialMediaUrl: socialMediaUrl,
      paymentTerm: paymentTerm,
    );
    
    emit(VendorRegistrationStateStep2Updated(_data));
    log('Step 2 updated: ${_data.toString()}', name: 'VendorRegistration');
  }

  void updateStep3({
    String? country,
    String? countryIso2,
    String? city,
    String? cityId,
    List<String>? marketFocus,
  }) {
    _data = _data.copyWith(
      country: country,
      countryIso2: countryIso2,
      city: city,
      cityId: cityId,
      marketFocus: marketFocus,
    );
    
    emit(VendorRegistrationStateStep3Updated(_data));
    log('Step 3 updated: ${_data.toString()}', name: 'VendorRegistration');
  }

  void updateAdditionalData({
    List<int>? eventTypeIds,
    String? averageEventSize,
    List<String>? venueTypes,
    String? repName,
    String? repPosition,
    String? repEmail,
  }) {
    _data = _data.copyWith(
      eventTypeIds: eventTypeIds,
      averageEventSize: averageEventSize,
      venueTypes: venueTypes,
      repName: repName,
      repPosition: repPosition,
      repEmail: repEmail,
    );
  }

  Future<void> submitRegistration() async {
    if (!_data.isComplete) {
      emit(VendorRegistrationStateFailed(
        UnexpectedFailure(message: 'Please complete all required fields')
      ));
      return;
    }

    try {
      emit(const VendorRegistrationStateLoading());

      final payload = _data.toApiPayload();
      log('Submitting vendor registration: $payload', name: 'VendorRegistration');

      final response = await _authService.registerVendor(
        companyName: _data.companyName!,
        companyTypeId: _data.companyTypeId!,
        companyDescription: _data.companyDescription!,
        eventTypeIds: _data.eventTypeIds,
        averageEventSize: _data.averageEventSize ?? 'Medium',
        websiteUrl: _data.websiteUrl!,
        socialMediaUrl: _data.socialMediaUrl!,
        cityId: _data.cityId ?? '1', // Default city ID if not provided
        venueTypes: _data.venueTypes.isNotEmpty ? _data.venueTypes : ['Indoor'],
        repName: _data.repName ?? 'N/A',
        repPosition: _data.repPosition ?? 'N/A',
        repEmail: _data.repEmail ?? 'N/A',
      );

      response.fold(
        (failure) {
          emit(VendorRegistrationStateFailed(failure));
          log('Vendor registration failed: ${failure.message}', name: 'VendorRegistration');
        },
        (user) {
          emit(VendorRegistrationStateSuccess(user));
          log('Vendor registration success: ${user.toString()}', name: 'VendorRegistration');
        },
      );
    } catch (e) {
      emit(VendorRegistrationStateFailed(
        UnexpectedFailure(message: 'An unexpected error occurred: $e')
      ));
      log('Vendor registration error: $e', name: 'VendorRegistration');
    }
  }

  void reset() {
    _data = VendorRegistrationData();
    emit(const VendorRegistrationStateInitial());
  }
}