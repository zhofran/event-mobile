part of '../vendor_registration.cubit.dart';

@freezed
class VendorRegistrationState with _$VendorRegistrationState {
  const factory VendorRegistrationState.initial() = VendorRegistrationStateInitial;
  const factory VendorRegistrationState.loading() = VendorRegistrationStateLoading;
  const factory VendorRegistrationState.step1Updated(VendorRegistrationData data) = VendorRegistrationStateStep1Updated;
  const factory VendorRegistrationState.step2Updated(VendorRegistrationData data) = VendorRegistrationStateStep2Updated;
  const factory VendorRegistrationState.step3Updated(VendorRegistrationData data) = VendorRegistrationStateStep3Updated;
  const factory VendorRegistrationState.success(UserModel user) = VendorRegistrationStateSuccess;
  const factory VendorRegistrationState.failed(IFailure failure) = VendorRegistrationStateFailed;
}