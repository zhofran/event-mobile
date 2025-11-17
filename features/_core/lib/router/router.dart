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
import 'package:feature_event/_core/router.dart';
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
    EventFeatureRouter,
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
                  title: (_, __) => 'Home',
                  path: 'home',
                  page: HomeRoute.page,
                ),
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
            // AutoRoute(
            //   title: (_, __) => 'Home',
            //   path: 'home',
            //   page: HomeRoute.page,
            // ),
            AutoRoute(
              title: (_, __) => 'Splash',
              path: 'splash',
              page: SplashRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'OnBoarding1',
              path: 'onboarding1',
              page: OnBoarding1Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Role Selection',
              path: 'role-selection',
              page: RoleSelectionRoute.page,
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
            AutoRoute(
              title: (_, __) => 'Register Attendee',
              path: 'register-attendee',
              page: AttendeeRegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Topic Attendee',
              path: 'topic-attendee',
              page: AttendeeTopicRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Location Attendee',
              path: 'location-attendee',
              page: AttendeeLocationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Forgot Password',
              path: 'forgot-password',
              page: ForgotPasswordRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Set New Password',
              path: 'set-new-password',
              page: SetNewPasswordRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Set Successful',
              path: 'set-successful',
              page: SetSuccessfulRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Register Speaker',
              path: 'register-speaker',
              page: SpeakerRegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Specialize Speaker',
              path: 'specialize-speaker',
              page: SpeakerSpecializeRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Background Speaker',
              path: 'background-speaker',
              page: SpeakerBackgroundRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Location Speaker',
              path: 'location-speaker',
              page: SpeakerLocationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Requirements Speaker',
              path: 'requirement-speaker',
              page: SpeakerRequirementRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Register Sponsor',
              path: 'register-sponsor',
              page: SponsorRegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Detail Sponsor',
              path: 'detail-sponsor',
              page: SponsorDetailRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Operate Sponsor',
              path: 'operate-sponsor',
              page: SponsorOperateRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Goals Sponsor',
              path: 'goal-sponsor',
              page: SponsorGoalRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Products Sponsor',
              path: 'product-sponsor',
              page: SponsorProductRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Campaign Sponsor',
              path: 'campaign-sponsor',
              page: SponsorCampaignRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Verification Sponsor',
              path: 'verify-sponsor',
              page: SponsorVerificationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Register EO',
              path: 'register-eo',
              page: EORegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Details EO',
              path: 'detail-eo',
              page: EODetailRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Location EO',
              path: 'location-eo',
              page: EOLocationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Representative EO',
              path: 'representative-eo',
              page: EORepresentativeRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Register Vendor',
              path: 'register-vendor',
              page: VendorRegisterRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Detail Vendor',
              path: 'detail-vendor',
              page: VendorDetailRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Location Vendor',
              path: 'location-vendor',
              page: VendorLocationRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 1',
              path: 'add-event-1',
              page: AddEvent1Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 2',
              path: 'add-event-2',
              page: AddEvent2Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 3',
              path: 'add-event-3',
              page: AddEvent3Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 4',
              path: 'add-event-4',
              page: AddEvent4Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 5',
              path: 'add-event-5',
              page: AddEvent5Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 6',
              path: 'add-event-6',
              page: AddEvent6Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 7',
              path: 'add-event-7',
              page: AddEvent7Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Add Event 8',
              path: 'add-event-8',
              page: AddEvent8Route.page,
            ),
            AutoRoute(
              title: (_, __) => 'Event Approval',
              path: 'event-approval',
              page: EventApprovalRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Budget Planning',
              path: 'budget-planning',
              page: BudgetPlanningRoute.page,
            ),
            AutoRoute(
              title: (_, __) => 'Finance Summary',
              path: 'finance-summary',
              page: FinancialManagementRoute.page,
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
