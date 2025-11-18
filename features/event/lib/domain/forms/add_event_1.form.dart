// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_1.form.freezed.dart';
part 'add_event_1.form.g.dart';
part 'add_event_1.form.gform.dart';

@freezed
@Rf()
class AddEvent1Form with _$AddEvent1Form {
  factory AddEvent1Form({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String eventName,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String eventType,
    @RfControl(
      validators: [
        RequiredValidator(),
        MinLengthValidator(1),
      ],
    )
    required List<String> eventCategory,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String eventDescription,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String eventFormat,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String photoPath,
  }) = _AddEvent1Form;

  factory AddEvent1Form.fromJson(Map<String, dynamic> json) =>
      _$AddEvent1FormFromJson(json);

  factory AddEvent1Form.empty() => AddEvent1Form(
        eventName: '',
        eventType: '',
        eventCategory: [],
        eventDescription: '',
        eventFormat: '',
        photoPath: '',
      );

  AddEvent1Form._();

  bool get isEmpty => this == AddEvent1Form.empty();

  bool equalsTo(AddEvent1Form other) {
    return eventName == other.eventName &&
        eventType == other.eventType &&
        eventCategory.length == other.eventCategory.length &&
        eventCategory.every((e) => other.eventCategory.contains(e)) &&
        eventDescription == other.eventDescription &&
        eventFormat == other.eventFormat &&
        photoPath == other.photoPath;
  }
}
