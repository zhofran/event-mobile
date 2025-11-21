import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/add_event_4.form.dart';
import '../../cubits/event_page4.cubit.dart';

@RoutePage()
class AddEvent4Page extends StatefulWidget {
  const AddEvent4Page({super.key});

  @override
  State<AddEvent4Page> createState() => _AddEvent4PageState();
}

class _AddEvent4PageState extends State<AddEvent4Page> {
  late EventPage4Cubit eventPage4Cubit;

  int currentStep = 5;
  int totalSteps = 10;
  bool _isFormPopulated = false;

  @override
  void initState() {
    super.initState();
    eventPage4Cubit = $.get<EventPage4Cubit>();

    // Load saved ticket selling time and populate form
    _loadTicketSellingTime();
  }

  Future<void> _loadTicketSellingTime() async {
    await eventPage4Cubit.loadTicketSellingTimeLocally();
  }

  void _populateFormWithSavedData(
    AddEvent4Form data,
    EventPage4State state,
  ) {
    if (_isFormPopulated) {
      return;
    }

    if (state.saleStartDate != null && state.saleStartTime != null) {
      data.saleStartDateControl.value = state.saleStartDate;
      data.saleStartTimeControl.value = state.saleStartTime;
      data.saleEndDateControl.value = state.saleEndDate;
      data.saleEndTimeControl.value = state.saleEndTime;

      _isFormPopulated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FabColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const FabPageHeader(title: 'Create Event'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedStepProgressIndicator(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),
              ),
              PaddingGap.xl(),
              Expanded(
                child: BlocBuilder<EventPage4Cubit, EventPage4State>(
                  bloc: eventPage4Cubit,
                  builder: (context, state) {
                    return AddEvent4FormBuilder(
                      builder: (_, data, __) {
                        _populateFormWithSavedData(data, state);
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                children: [
                                  _buildWelcomeSection(),
                                  PaddingGap.md(),
                                  _buildTicketStartDate(data),
                                  PaddingGap.md(),
                                  _buildTicketEndDate(data),
                                  PaddingGap.md(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: FabButton.primary(
                                // onPressed: byPass,
                                onPressed: () {
                                  data.submit(
                                    onValid: (model) {
                                      eventPage4Cubit.createTicketSalesPeriod(
                                        saleStartDate: model.saleStartDate,
                                        saleStartTime: model.saleStartTime,
                                        saleEndDate: model.saleEndDate,
                                        saleEndTime: model.saleEndTime,
                                      );

                                      FabSnackbar.success(
                                        context: context,
                                        content:
                                            'Create Ticket Sales Period saved successfully!',
                                      );

                                      $.navigator.push(AddEvent5Route());
                                    },
                                    onNotValid: () {
                                      setState(() {
                                        FabSnackbar.error(
                                          context: context,
                                          content:
                                              'Please fill all required fields',
                                        );
                                      });
                                    },
                                  );
                                },
                                size: FabButtonSize.large,
                                width: double.infinity,
                                child: Text(
                                  'Continue',
                                  style:
                                      FabTypography.displaySemiBold16.copyWith(
                                    color: FabColors.greyscale0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildTicketStartDate(AddEvent4Form data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Ticket Sales Start Date',
          style: FabTypography.displayBold18,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Tickets will be available for purchase starting from this date.',
          style: FabTypography.displayRegular12
              .copyWith(color: FabColors.greyscale400),
        ),
        PaddingGap.xs(),
        FabDatepicker(
          formControl: data.saleStartDateControl,
          labelText: 'Date',
          onChanged: (value) => setState(() {
            eventPage4Cubit.createTicketSalesPeriod(saleStartDate: value);
          }),
        ),
        PaddingGap.md(),
        FabTimepicker(
          formControl: data.saleStartTimeControl,
          labelText: 'Time',
          onChanged: (value) => setState(() {
            eventPage4Cubit.createTicketSalesPeriod(
              saleStartTime: value.toTimeString(),
            );
          }),
        ),
      ],
    );
  }

  Column _buildTicketEndDate(AddEvent4Form data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Ticket Sales End Date',
          style: FabTypography.displayBold18,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'After this date, attendees can no longer buy tickets.',
          style: FabTypography.displayRegular12
              .copyWith(color: FabColors.greyscale400),
        ),
        PaddingGap.xs(),
        FabDatepicker(
          formControl: data.saleEndDateControl,
          labelText: 'Date',
          onChanged: (value) => setState(() {
            eventPage4Cubit.createTicketSalesPeriod(saleEndDate: value);
          }),
        ),
        PaddingGap.md(),
        FabTimepicker(
          formControl: data.saleEndTimeControl,
          labelText: 'Time',
          onChanged: (value) => setState(() {
            eventPage4Cubit.createTicketSalesPeriod(
              saleEndTime: value.toTimeString(),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Ticket Selling Time',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'Choose the start and end dates for your ticket sales to control when attendees can purchase tickets.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
          // textAlign: TextAlign.center,
        ),
        PaddingGap.md(),
        Row(
          children: [
            Text(
              'Ticket Selling Time: ',
              style: FabTypography.bodySmallMedium.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
            Text(
              eventPage4Cubit.getTicketSellingTime(),
              style: FabTypography.bodySmallBold,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> byPass() async {
    setState(() {
      eventPage4Cubit.createTicketSalesPeriod(
        saleStartDate: DateTime.now(),
        saleStartTime: '10:00',
        saleEndDate: DateTime.now().add(const Duration(days: 10)),
        saleEndTime: '15:00',
      );
    });

    await eventPage4Cubit.saveTicketSellingTimeLocally().then(
      (value) {
        if (!mounted) {
          return;
        }

        FabSnackbar.success(
          context: context,
          content: 'Create Ticket Selling Time saved successfully!',
        );
        $.navigator.push(AddEvent5Route());
      },
    );
  }
}
