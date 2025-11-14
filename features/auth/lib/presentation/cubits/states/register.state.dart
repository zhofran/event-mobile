// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names

part of '../register.cubit.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.failed(IFailure failure) = RegisterStateFailed;

  const factory RegisterState.initial() = RegisterStateInitial;

  const factory RegisterState.loading() = RegisterStateLoading;

  const factory RegisterState.succeeded(UserModel user) = RegisterStateSucceeded;

  const factory RegisterState.berhasil() = RegisterStateBerhasil;
  
  const factory RegisterState.OtpVerifying() = OtpVerifying;

  const factory RegisterState.topicLoaded(List<TopicModel> topic) = RegisterStateTopic;
}
