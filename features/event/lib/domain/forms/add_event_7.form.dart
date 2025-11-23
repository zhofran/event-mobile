// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_7.form.freezed.dart';
part 'add_event_7.form.g.dart';
part 'add_event_7.form.gform.dart';

@freezed
@Rf()
class AddEvent7Form with _$AddEvent7Form {
  factory AddEvent7Form({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String title,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String type,
    @RfControl() required String requestedProduct,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String productAmount,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String description,
  }) = _AddEvent7Form;

  factory AddEvent7Form.fromJson(Map<String, dynamic> json) =>
      _$AddEvent7FormFromJson(json);

  factory AddEvent7Form.empty() => AddEvent7Form(
        title: '',
        type: '',
        requestedProduct: '',
        productAmount: '',
        description: '',
      );

  AddEvent7Form._();

  bool get isEmpty => this == AddEvent7Form.empty();

  bool equalsTo(AddEvent7Form other) {
    return title == other.title &&
        type == other.type &&
        requestedProduct == other.requestedProduct &&
        productAmount == other.productAmount &&
        description == other.description;
  }
}
