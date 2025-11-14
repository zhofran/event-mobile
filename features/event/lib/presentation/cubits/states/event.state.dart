// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of '../event.cubit.dart';

enum EventStateStatus { initial, loading, failed, succeeded }

@freezed
sealed class EventState with _$EventState {
  const factory EventState({
    required EventStateStatus status,
    required List<EventItemModel> cartItems,
    required Failure failure,
  }) = _EventState;

  factory EventState.initial() => EventState(
        status: EventStateStatus.initial,
        cartItems: [],
        failure: Failure.empty(),
      );
}
