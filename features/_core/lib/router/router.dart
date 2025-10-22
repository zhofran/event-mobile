// Copyright 2025. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:feature_auth/_core/router.dart';
import 'package:feature_cart/_core/router.dart';
import 'package:feature_company_profile/_core/router.dart';
import 'package:feature_company_profile/company_profile.dart';
import 'package:feature_discover/_core/router.dart';
import 'package:feature_job_applied/_core/router.dart';
import 'package:feature_job_listing/_core/router.dart';
import 'package:flutter/material.dart';

import '../_core/super/_core/dialog/cupertino/cupertino_dialog_builder.dart';
import '../_core/super/_core/dialog/material/material_dialog_builder.dart';
import '../_core/super/_core/modal/cupertino/cupertino_modal_builder.dart';
import '../_core/super/_core/modal/cupertino/cupertino_modal_sheet_route.dart';
import '../_core/super/_core/modal/material/material_modal_builder.dart';
import '../_core/super/_core/sheet/cupertino/cupertino_sheet_builder.dart';
import 'guard.dart';
import 'router.gr.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({required super.builder, required super.settings});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

@AutoRouterConfig(
  modules: [
    AuthFeatureRouter,
    DiscoverFeatureRouter,
    SettingsFeatureRouter,
    UserFeatureRouter,
    CartFeatureRouter,
    CompanyProfileFeatureRouter,
    JobAppliedFeatureRouter,
    JobListingFeatureRouter,
  ],
)
class FeaturesRouter extends $FeaturesRouter {
  FeaturesRouter();

  @override
  RouteType get defaultRouteType => RouteType.custom(
        customRouteBuilder: <T>(
          _,
          child,
          page,
        ) {
          return CustomPageRoute<T>(
            settings: page,
            builder: (_) {
              return CupertinoStackedTransition(
                cornerRadius: Tween(begin: 0, end: 16),
                child: child,
              );
            },
          );
        },
        durationInMilliseconds: 2500,
        reverseDurationInMilliseconds: 2500,
      );

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SuperHandler.page,
          initial: true,
          children: [
            AutoRoute(
              page: DashboardRouter.page,
              guards: [AuthGuard()],
              initial: true,
              children: [
                AutoRoute(
                  page: DiscoverRouter.page,
                  children: [
                    AutoRoute(
                      title: (_, __) => $.tr.discover.title,
                      path: 'discover',
                      page: DiscoverRoute.page,
                      initial: true,
                    ),
                    AutoRoute(
                      path: 'product-details',
                      page: DiscoverDetailsRoute.page,
                    ),
                    AutoRoute(
                      title: (_, __) => 'Company Profile',
                      path: 'company-profile',
                      page: CompanyProfileRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: JobAppliedRouter.page,
                  children: [
                    AutoRoute(
                      title: (_, __) => 'Applied',
                      path: 'applied',
                      page: JobAppliedRoute.page,
                      initial: true,
                    ),
                    AutoRoute(
                      path: 'applied-details',
                      page: JobAppliedDetailsRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: JobListingRouter.page,
                  children: [
                    AutoRoute(
                      title: (_, __) => 'Jobs',
                      path: 'jobs',
                      page: JobListingRoute.page,
                      initial: true,
                    ),
                    AutoRoute(
                      path: 'job-details',
                      page: JobListingDetailsRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  title: (_, __) => $.tr.settings.title,
                  path: 'settings',
                  page: SettingsRoute.page,
                ),
              ],
            ),
            AutoRoute(
              title: (_, __) => $.tr.auth.title,
              path: 'login',
              page: LoginRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Register',
              path: 'register',
              page: RegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Verify Email',
              path: 'verify-email',
              page: VerifyEmailRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Change Email',
              path: 'change-email',
              page: ChangeEmailRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Setup Profile',
              path: 'setup-profile',
              page: SetupProfileRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Setup Phone Number',
              path: 'setup-phone-number',
              page: SetupPhoneNumberRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'OTP Verification',
              path: 'otp-verification',
              page: OTPVerificationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Career',
              path: 'profile-career',
              page: ProfileCareerRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Job',
              path: 'profile-job',
              page: ProfileJobRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Location',
              path: 'profile-location',
              page: ProfileLocationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Recent Job',
              path: 'profile-recent-job',
              page: ProfileRecentJobRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Photo',
              path: 'profile-photo',
              page: ProfilePhotoRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Photo Confirm',
              path: 'profile-photo-confirm',
              page: ProfilePhotoConfirmRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Profile Completed',
              path: 'profile-completed',
              page: ProfileCompletedRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Permission Notification',
              path: 'permission-notification',
              page: PermissionNotificationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Permission Location',
              path: 'permission-location',
              page: PermissionLocationRoute.page,
            ),
            CustomRoute(
              page: MaterialDialogWrapperRoute.page,
              customRouteBuilder: materialDialogRouteBuilder,
            ),
            CustomRoute(
              page: CupertinoDialogWrapperRoute.page,
              customRouteBuilder: cupertinoDialogRouteBuilder,
            ),
            CustomRoute(
              page: MaterialModalWrapperRoute.page,
              customRouteBuilder: materialModalRouteBuilder,
            ),
            CustomRoute(
              page: CupertinoModalWrapperRoute.page,
              customRouteBuilder: cupertinoModalRouteBuilder,
            ),
            CustomRoute(
              page: CupertinoSheetWrapperRoute.page,
              customRouteBuilder: cupertinoSheetRouteBuilder,
            ),
          ],
        ),
      ];
}
