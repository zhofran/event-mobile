// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/features/features.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/reactive_forms_annotations.dart';

part 'register.form.freezed.dart';
part 'register.form.g.dart';
part 'register.form.gform.dart';

@freezed
@Rf()
class RegisterForm with _$RegisterForm {
  factory RegisterForm({
    @RfControl(
      validators: [
        RequiredValidator(),
        FormValidators.email,
      ],
    )
    required String email,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String password,
    @RfControl(
      validators: [
        RequiredValidator(),
      ],
    )
    required String confirmPassword,
  }) = _RegisterForm;

  factory RegisterForm.fromJson(Map<String, dynamic> json) => _$RegisterFormFromJson(json);

  factory RegisterForm.empty() => RegisterForm(email: '', password: '', confirmPassword: '');

  RegisterForm._();

  bool get isEmpty => this == RegisterForm.empty();
  
  bool equalsTo(RegisterForm other) {
    return email == other.email && password == other.password && confirmPassword == other.confirmPassword;
  }
}
