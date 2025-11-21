// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_6.form.freezed.dart';
part 'add_event_6.form.g.dart';
part 'add_event_6.form.gform.dart';

@freezed
@Rf()
class AddEvent6Form with _$AddEvent6Form {
  factory AddEvent6Form({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String categories,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String vendor,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String budget,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String description,
  }) = _AddEvent6Form;

  factory AddEvent6Form.fromJson(Map<String, dynamic> json) =>
      _$AddEvent6FormFromJson(json);

  factory AddEvent6Form.empty() => AddEvent6Form(
        categories: '',
        vendor: '',
        budget: '',
        description: '',
      );

  AddEvent6Form._();

  bool get isEmpty => this == AddEvent6Form.empty();

  bool equalsTo(AddEvent6Form other) {
    return categories == other.categories &&
        vendor == other.vendor &&
        budget == other.budget &&
        description == other.description;
  }
}
