import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/forms/add_event_2_offline.form.dart';
import '../../../domain/forms/add_event_2_online.form.dart';
import '../../cubits/budget_planner.cubit.dart';
import '../../cubits/event_page1.cubit.dart';
import '../../cubits/event_page2.cubit.dart';

@RoutePage()
class AddEvent2Page extends StatefulWidget {
  const AddEvent2Page({super.key});

  @override
  State<AddEvent2Page> createState() => _AddEvent2PageState();
}

class _AddEvent2PageState extends State<AddEvent2Page> {
  late EventPage1Cubit eventPage1Cubit;
  late EventPage2Cubit eventPage2Cubit;
  late BudgetPlannerCubit budgetPlannerCubit;

  @override
  void initState() {
    super.initState();
    eventPage1Cubit = $.get<EventPage1Cubit>();
    eventPage2Cubit = $.get<EventPage2Cubit>();
    budgetPlannerCubit = $.get<BudgetPlannerCubit>();
    eventPage2Cubit.toggleValidityForm(value: null);
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = eventPage1Cubit.state.eventFormat == 'offline';
    return _EventFormScaffold(
      eventPage2Cubit: eventPage2Cubit,
      budgetPlannerCubit: budgetPlannerCubit,
      isOffline: isOffline,
    );
  }
}

/// Unified scaffold for both online and offline event forms
class _EventFormScaffold extends StatelessWidget {
  const _EventFormScaffold({
    required this.eventPage2Cubit,
    required this.budgetPlannerCubit,
    required this.isOffline,
  });

  final EventPage2Cubit eventPage2Cubit;
  final BudgetPlannerCubit budgetPlannerCubit;
  final bool isOffline;

  static const int _currentStep = 3;
  static const int _totalSteps = 8;

  static const List<SelectOption<String>> _eventPlatformOptions = [
    SelectOption(value: 'zoom', label: 'Zoom'),
    SelectOption(value: 'microsoft teams', label: 'Microsoft Teams'),
    SelectOption(value: 'google meet', label: 'Google Meet'),
    SelectOption(value: 'others', label: 'Others'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FabPageHeader(title: 'Create Event'),
            Expanded(
              child: BlocBuilder<EventPage2Cubit, EventPage2State>(
                bloc: eventPage2Cubit,
                buildWhen: (previous, current) =>
                    previous.isFormValid != current.isFormValid,
                builder: (context, state) {
                  return isOffline
                      ? _buildOfflineForm(context)
                      : _buildOnlineForm(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineForm(BuildContext context) {
    return AddEvent2OfflineFormFormBuilder(
      builder: (_, data, __) => _buildFormContent(
          context: context,
          formFields: _buildOfflineFields(data),
          onSubmit: byPass
          // onSubmit: () => _handleOfflineSubmit(
          //   context: context,
          //   formData: data,
          //   onValid: (model) => _handleContinue(
          //     context,
          //     offlineModel: model,
          //   ),
          // ),
          ),
    );
  }

  Widget _buildOnlineForm(BuildContext context) {
    return AddEvent2OnlineFormFormBuilder(
      builder: (_, data, __) => _buildFormContent(
          context: context,
          formFields: _buildOnlineFields(data),
          onSubmit: byPass
          // onSubmit: () => _handleOnlineSubmit(
          //   context: context,
          //   formData: data,
          //   onValid: (model) => _handleContinue(
          //     context,
          //     onlineModel: model,
          //   ),
          // ),
          ),
    );
  }

  Widget _buildFormContent({
    required BuildContext context,
    required Widget formFields,
    required VoidCallback onSubmit,
  }) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedStepProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),
        ),
        PaddingGap.xl(),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _WelcomeSection(
                  venueBudget: budgetPlannerCubit.state.vendorBudget.toDouble(),
                ),
              ),
              PaddingGap.md(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<EventPage2Cubit, EventPage2State>(
                  bloc: eventPage2Cubit,
                  buildWhen: (previous, current) =>
                      previous.isFormValid != current.isFormValid,
                  builder: (_, __) => formFields,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: FabButton.primary(
            onPressed: onSubmit,
            size: FabButtonSize.large,
            width: double.infinity,
            child: Text(
              'Continue',
              style: FabTypography.displaySemiBold16.copyWith(
                color: FabColors.greyscale0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineFields(AddEvent2OfflineFormForm data) {
    final inputFormatters = [ThousandsSeparatorInputFormatter(separator: ',')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCommonTopFields(
          dateControl: data.dateControl,
          timeControl: data.timeControl,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: data.venueControl,
          keyboardType: TextInputType.name,
          labelText: 'Venue',
          hintText: 'e.g., Jakarta Convention Center',
          textInputAction: TextInputAction.next,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: data.addressControl,
          keyboardType: TextInputType.name,
          labelText: 'Address',
          hintText: 'e.g., Jl. Jend. Gatot Subroto',
          textInputAction: TextInputAction.next,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: data.locationControl,
          keyboardType: TextInputType.text,
          labelText: 'Location',
          hintText: 'e.g., https://share.google.com/jcc',
          textInputAction: TextInputAction.next,
        ),
        PaddingGap.md(),
        _buildCommonBottomFields(
          priceControl: data.priceControl,
          capacityControl: data.capacityControl,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  Widget _buildOnlineFields(AddEvent2OnlineFormForm data) {
    final inputFormatters = [ThousandsSeparatorInputFormatter(separator: ',')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCommonTopFields(
          dateControl: data.dateControl,
          timeControl: data.timeControl,
        ),
        PaddingGap.md(),
        FabDropdown<String>(
          formControl: data.platformControl,
          options: _eventPlatformOptions,
          labelText: 'Platform',
          hintText: 'Select Platform',
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: data.linkControl,
          keyboardType: TextInputType.name,
          labelText: 'Link',
          hintText: 'e.g., meet.zoom.com/abc-123',
          textInputAction: TextInputAction.next,
        ),
        PaddingGap.md(),
        _buildCommonBottomFields(
          priceControl: data.priceControl,
          capacityControl: data.capacityControl,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  /// Common fields shared between online and offline forms
  Widget _buildCommonTopFields({
    required dynamic dateControl,
    required dynamic timeControl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FabDatepicker(
          formControl: dateControl,
          labelText: 'Date',
        ),
        PaddingGap.md(),
        FabTimepicker(
          formControl: timeControl,
          labelText: 'Time',
        ),
      ],
    );
  }

  /// Common fields shared between online and offline forms
  Widget _buildCommonBottomFields({
    required dynamic priceControl,
    required dynamic capacityControl,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FabTextfield(
          formControl: priceControl,
          keyboardType: TextInputType.number,
          labelText: 'Price',
          hintText: 'e.g., 100.000.000',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: capacityControl,
          keyboardType: TextInputType.number,
          labelText: 'Capacity',
          hintText: 'e.g., 500',
          textInputAction: TextInputAction.next,
          inputFormatters: inputFormatters,
        ),
        PaddingGap.md(),
      ],
    );
  }

  void _handleOnlineSubmit({
    required BuildContext context,
    required AddEvent2OnlineFormForm formData,
    required void Function(AddEvent2OnlineForm) onValid,
  }) {
    formData.submit(
      onValid: onValid,
      onNotValid: () {
        eventPage2Cubit.toggleValidityForm(value: false);
        _showErrorSnackBar(context);
      },
    );
  }

  void _handleOfflineSubmit({
    required BuildContext context,
    required AddEvent2OfflineFormForm formData,
    required void Function(AddEvent2OfflineForm) onValid,
  }) {
    formData.submit(
      onValid: onValid,
      onNotValid: () {
        eventPage2Cubit.toggleValidityForm(value: false);
        _showErrorSnackBar(context);
      },
    );
  }

  Future<void> byPass() async {
    eventPage2Cubit.createScheduleVenueOffline(
      date: DateTime.now(),
      time: '10:00',
      venue: 'Jakarta Convention Center',
      address: 'Jl. Jend. Gatot Subroto',
      location: 'https://share.google.com/jcc',
      price: 50000000,
      capacity: 5000,
    );

    await $.navigator.push(const AddEvent3Route());
  }

  void _handleContinue(
    BuildContext context, {
    AddEvent2OnlineForm? onlineModel,
    AddEvent2OfflineForm? offlineModel,
  }) {
    final parsedPriceNum =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(
              onlineModel?.price ?? offlineModel?.price ?? '',
            ) ??
            0;

    final parsedCapacityNum =
        ThousandsSeparatorInputFormatter.parseFormattedNumber(
              onlineModel?.capacity ?? offlineModel?.capacity ?? '',
            ) ??
            0;
    final venuePrice = parsedPriceNum.toDouble();
    final venueBudget = budgetPlannerCubit.state.venueBudget;

    if (venuePrice > venueBudget) {
      _showBudgetExceededDialog(context, venuePrice - venueBudget);
    } else {
      if (onlineModel != null) {
        eventPage2Cubit.createScheduleVenueOnline(
          date: onlineModel.date,
          time: onlineModel.time,
          platform: onlineModel.platform,
          link: onlineModel.link,
          price: parsedPriceNum,
          capacity: parsedCapacityNum,
        );
      }
      if (offlineModel != null) {
        eventPage2Cubit.createScheduleVenueOffline(
          date: offlineModel.date,
          time: offlineModel.time,
          venue: offlineModel.venue,
          address: offlineModel.address,
          location: offlineModel.location,
          price: parsedPriceNum,
          capacity: parsedCapacityNum,
        );
      }
      _showSuccessSnackBar(context);
      // Navigate to next page
      $.navigator.push(const AddEvent3Route());
    }
  }

  void _showBudgetExceededDialog(BuildContext context, double exceeded) {
    BudgetExceededDialog.show(
      context: context,
      title: 'Schedule & Venue Exceeded',
      exceededAmount: FabFunction.formatRupiah(currency: exceeded),
      onAdjustBudget: () {},
      onContinueAnyway: () {
        // Navigate anyway
        $.navigator.push(const AddEvent3Route());
      },
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    FabSnackbar.success(
      context: context,
      content: 'Schedule & Venue saved successfully!',
    );
  }

  void _showErrorSnackBar(BuildContext context) {
    FabSnackbar.error(
      context: context,
      content: 'Please fill all required fields',
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({
    required this.venueBudget,
  });

  final double venueBudget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Schedule & Venue',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          "You've set a maximum budget of ${FabFunction.formatRupiah(
            currency: venueBudget,
          )}. Make sure your input stays within this limit.",
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
        ),
      ],
    );
  }
}
