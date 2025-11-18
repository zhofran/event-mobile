import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/forms/add_event_1.form.dart';
import '../../cubits/event_page1.cubit.dart';

@RoutePage()
class AddEvent1Page extends StatefulWidget {
  const AddEvent1Page({super.key});

  @override
  State<AddEvent1Page> createState() => _AddEvent1PageState();
}

class _AddEvent1PageState extends State<AddEvent1Page> {
  late EventPage1Cubit eventPage1Cubit;

  int currentStep = 2;
  int totalSteps = 8;

  final List<SelectOption<String>> _eventTypeOptions = [
    const SelectOption(value: 'conference', label: 'Conference'),
    const SelectOption(value: 'exhibition', label: 'Exhibition'),
    const SelectOption(value: 'workshop', label: 'Workshop'),
    const SelectOption(value: 'webinar', label: 'Webinar'),
  ];

  final List<SelectOption<String>> _eventFormatOptions = [
    const SelectOption(value: 'online', label: 'Online'),
    const SelectOption(value: 'offline', label: 'Offline'),
  ];

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {});

    eventPage1Cubit = $.get<EventPage1Cubit>();
    eventPage1Cubit
      ..toggleValidityForm(value: null)
      ..getEventCategories()
      ..resetStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventPage1Cubit, EventPage1State>(
      bloc: eventPage1Cubit,
      listener: (context, state) {
        if (state.status == EventPage1StateStatus.loadingPost) {
          FabLoadingOverlay.show(context);
        } else {
          FabLoadingOverlay.hide(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                  child: AddEvent1FormFormBuilder(
                    builder: (_, data, __) {
                      return Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () =>
                                  eventPage1Cubit.getEventCategories(
                                refresh: true,
                              ),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: _buildWelcomeSection(),
                                  ),
                                  PaddingGap.md(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: BlocBuilder<EventPage1Cubit,
                                        EventPage1State>(
                                      bloc: eventPage1Cubit,
                                      builder: (context, state) {
                                        if (state.eventCategoryOptions
                                            .isNotEmpty) {
                                          return _buildAddEventForm(data);
                                        }
                                        return const Center(
                                          child:
                                              CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: FabButton.primary(
                              onPressed: byPass,
                              // onPressed: () {
                              //   data.submit(
                              //     onValid: (model) {
                              //       eventPage1Cubit.createEvent(
                              //         eventName: model.eventName,
                              //         eventType: model.eventType,
                              //         eventCategory: model.eventCategory,
                              //         eventDescription: model.eventDescription,
                              //         eventFormat: model.eventFormat,
                              //         eventBanner: model.photoPath,
                              //       );
        
                              //       $.navigator.push(const AddEvent2Route());
        
                              //       FabSnackbar.success(
                              //         context: context,
                              //         content:
                              //             'Create Event Details saved successfully!',
                              //       );
                              //     },
                              //     onNotValid: () {
                              //       eventPage1Cubit.toggleValidityForm(
                              //         value: false,
                              //       );
                              //       FabSnackbar.error(
                              //         context: context,
                              //         content: 'Please fill all required fields',
                              //       );
                              //     },
                              //   );
                              // },
                              size: FabButtonSize.large,
                              width: double.infinity,
                              child: Text(
                                'Continue',
                                style: FabTypography.displaySemiBold16
                                    .copyWith(
                                  color: FabColors.greyscale0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> byPass() async {
    await eventPage1Cubit.postCreateEventDetails();
    // eventPage1Cubit.createEvent(
    //   eventName: 'Sample Event',
    //   eventType: 'conference',
    //   eventCategory: ['Technology', 'Leadership'],
    //   eventDescription: 'Sample Event Description',
    //   eventFormat: 'offline',
    //   eventBanner:
    //       'http://minio:9000/apni-event/2025/11/18/d8001dc9-e6c4-46d9-ae57-998001582632.jpg',
    // );

    // FabSnackbar.success(
    //   context: context,
    //   content: 'Create Event Details saved successfully!',
    // );

    // await $.navigator.push(const AddEvent2Route());
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FabTextStyled(
          'Event Details',
          style: FabTypography.displayBold22,
        ),
        PaddingGap.xs(),
        FabTextStyled(
          'You can edit this anytime before publishing.',
          style: FabTypography.displayRegular14
              .copyWith(color: FabColors.greyscale400),
          // textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAddEventForm(AddEvent1FormForm data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FabTextfield(
          formControl: data.eventNameControl,
          keyboardType: TextInputType.name,
          labelText: 'Event Name',
          hintText: 'Event Name',
          textInputAction: TextInputAction.next,
        ),
        PaddingGap.md(),
        FabDropdown<String>(
          formControl: data.eventTypeControl,
          options: _eventTypeOptions,
          labelText: 'Event Type',
          hintText: 'Select Event Type',
        ),
        PaddingGap.md(),
        FabSelectBottomSheet(
          formControl: data.eventCategoryControl,
          options: eventPage1Cubit.state.eventCategoryOptions,
          labelText: 'Event Category',
          hintText: 'Select Event Category',
          isMultiSelect: true,
        ),
        PaddingGap.md(),
        FabTextfield(
          formControl: data.eventDescriptionControl,
          keyboardType: TextInputType.text,
          labelText: 'Description',
          hintText: 'Write a short summary about your event.',
          textInputAction: TextInputAction.next,
          maxLines: 6,
          minLines: 1,
        ),
        PaddingGap.md(),
        FabDropdown<String>(
          formControl: data.eventFormatControl,
          options: _eventFormatOptions,
          labelText: 'Event Type',
          hintText: 'Select Event Type',
        ),
        PaddingGap.md(),
        FabPhoto(
          formControl: data.photoPathControl,
          labelText: 'Event Banner',
          helperText: 'Upload 1920x1005 images (JPG or PNG)',
          width: double.infinity,
          height: 100,
          shape: BoxShape.rectangle,
          backgroundColor: FabColors.background,
          iconColor: FabColors.primary200,
          onImagePicked: (value) {
            // _selectedImage = File(photo.path));
            if (value == null) {
              return;
            }
            eventPage1Cubit.setEventBanner(value: value.path);
          },
        ),
      ],
    );
  }
}
