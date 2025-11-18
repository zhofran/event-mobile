// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'add_event_2_offline.form.freezed.dart';
part 'add_event_2_offline.form.g.dart';
part 'add_event_2_offline.form.gform.dart';

@freezed
@Rf()
class AddEvent2OfflineForm with _$AddEvent2OfflineForm {
  factory AddEvent2OfflineForm({
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
    required String venue,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String address,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String location,
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
  }) = _AddEvent2OfflineForm;

  factory AddEvent2OfflineForm.fromJson(Map<String, dynamic> json) =>
      _$AddEvent2OfflineFormFromJson(json);

  factory AddEvent2OfflineForm.empty() => AddEvent2OfflineForm(
        date: DateTime.now(),
        time: '00:00',
        venue: '',
        address: '',
        location: '',
        price: '',
        capacity: '',
      );

  AddEvent2OfflineForm._();

  bool get isEmpty => this == AddEvent2OfflineForm.empty();

  bool equalsTo(AddEvent2OfflineForm other) {
    return date == other.date &&
        time == other.time &&
        venue == other.venue &&
        address == other.address &&
        location == other.location &&
        price == other.price &&
        capacity == other.capacity;
  }
}
