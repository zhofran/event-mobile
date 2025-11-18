// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_2_online.form.freezed.dart';
part 'add_event_2_online.form.g.dart';
part 'add_event_2_online.form.gform.dart';

@freezed
@Rf()
class AddEvent2OnlineForm with _$AddEvent2OnlineForm {
  factory AddEvent2OnlineForm({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required DateTime date,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String time,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String platform,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String link,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String price,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String capacity,
  }) = _AddEvent2OnlineForm;

  factory AddEvent2OnlineForm.fromJson(Map<String, dynamic> json) =>
      _$AddEvent2OnlineFormFromJson(json);

  factory AddEvent2OnlineForm.empty() => AddEvent2OnlineForm(
        date: DateTime.now(),
        time: '00:00',
        platform: '',
        link: '',
        price: '',
        capacity: '',
      );

  AddEvent2OnlineForm._();

  bool get isEmpty => this == AddEvent2OnlineForm.empty();

  bool equalsTo(AddEvent2OnlineForm other) {
    return date == other.date &&
        time == other.time &&
        platform == other.platform &&
        link == other.link &&
        price == other.price &&
        capacity == other.capacity;
  }
}
