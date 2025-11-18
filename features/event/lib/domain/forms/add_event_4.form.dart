// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_4.form.freezed.dart';
part 'add_event_4.form.g.dart';
part 'add_event_4.form.gform.dart';

@freezed
@Rf()
class AddEvent4 with _$AddEvent4 {
  factory AddEvent4({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required DateTime saleStartDate,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String saleStartTime,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required DateTime saleEndDate,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String saleEndTime,
  }) = _AddEvent4;

  factory AddEvent4.fromJson(Map<String, dynamic> json) =>
      _$AddEvent4FromJson(json);

  factory AddEvent4.empty() => AddEvent4(
        saleStartDate: DateTime.now(),
        saleStartTime: '00:00',
        saleEndDate: DateTime.now(),
        saleEndTime: '00:00',
      );

  AddEvent4._();

  bool get isEmpty => this == AddEvent4.empty();

  bool equalsTo(AddEvent4 other) {
    return saleStartDate == other.saleStartDate &&
        saleStartTime == other.saleStartTime &&
        saleEndDate == other.saleEndDate &&
        saleEndTime == other.saleEndTime;
  }
}
