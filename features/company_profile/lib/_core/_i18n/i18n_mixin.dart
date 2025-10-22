// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'translations.g.dart';

mixin DiscoverTranslationMixin on Cubit<Locale> {
  Translations get discover => AppLocaleUtils.parse(state.toString()).build();
}
