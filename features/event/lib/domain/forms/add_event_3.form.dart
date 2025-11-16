// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_3.form.freezed.dart';
part 'add_event_3.form.g.dart';
part 'add_event_3.form.gform.dart';

@freezed
@Rf()
class AddEvent3Form with _$AddEvent3Form {
  factory AddEvent3Form({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String ticketName,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String ticketType,
    @RfControl(
      validators: [
        RequiredValidator(),
        MinLengthValidator(1),
      ],
    )
    required String price,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String quota,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String description,
  }) = _AddEvent3Form;

  factory AddEvent3Form.fromJson(Map<String, dynamic> json) =>
      _$AddEvent3FormFromJson(json);

  factory AddEvent3Form.empty() => AddEvent3Form(
        ticketName: '',
        ticketType: '',
        price: '',
        quota: '',
        description: '',
      );

  AddEvent3Form._();

  bool get isEmpty => this == AddEvent3Form.empty();

  bool equalsTo(AddEvent3Form other) {
    return ticketName == other.ticketName &&
        ticketType == other.ticketType &&
        price == other.price &&
        quota == other.quota &&
        description == other.description;
  }
}
