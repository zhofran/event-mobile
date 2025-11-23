// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'invite_speaker.form.freezed.dart';
part 'invite_speaker.form.g.dart';
part 'invite_speaker.form.gform.dart';

@freezed
@Rf()
class InviteSpeakerForm with _$InviteSpeakerForm {
  factory InviteSpeakerForm({
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String name,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String title,
    @RfControl(
      validators: [
        RequiredValidator(),
        EmailValidator(),
      ],
    )
    required String email,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String fee,
  }) = _InviteSpeakerForm;

  factory InviteSpeakerForm.fromJson(Map<String, dynamic> json) =>
      _$InviteSpeakerFormFromJson(json);

  factory InviteSpeakerForm.empty() => InviteSpeakerForm(
        name: '',
        title: '',
        email: '',
        fee: '',
      );

  InviteSpeakerForm._();

  bool get isEmpty => this == InviteSpeakerForm.empty();

  bool equalsTo(InviteSpeakerForm other) {
    return name == other.name &&
        title == other.title &&
        email == other.email &&
        fee == other.fee;
  }
}
