import 'dart:convert';
import 'dart:developer';

import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../data/create_event.service.dart';
import '../../data/file_service.dart';

part 'event_page1.cubit.freezed.dart';
part 'states/event_page1.state.dart';

@lazySingleton
class EventPage1Cubit extends Cubit<EventPage1State> {
  EventPage1Cubit() : super(EventPage1State.initial());

  final createEventService = $.get<CreateEventService>();
  final fileService = $.get<FileService>();

  void resetStatus() {
    emit(state.copyWith(status: EventPage1StateStatus.initial));
  }

  void toggleValidityForm({required bool? value}) {
    emit(state.copyWith(isFormValid: value));
  }

  void setEventBanner({required String value}) {
    emit(state.copyWith(eventBanner: value));
  }

  Future<void> postCreateEventDetails() async {
    emit(state.copyWith(status: EventPage1StateStatus.loadingPost));

    // comment when dev cuz already upload on select image
    // await uploadEventBanner(photoPath: state.eventBanner);


    final result = await createEventService.createEventDetails(
      organizerId: '123e4567-e89b-12d3-a456-426614174000',
      eventName: 'Sample Event',
      eventType: 'conference',
      eventCategory: [0, 1, 2],
      description: 'Sample Event Description',
      eventFormat: 'offline',
      eventBanner:
          'http://minio:9000/apni-event/2025/11/18/d8001dc9-e6c4-46d9-ae57-998001582632.jpg',
    );

    // uncomment to prod
    // final result = await createEventService.createEventDetails(
    //   organizerId: '123e4567-e89b-12d3-a456-426614174000',
    //   eventName: state.eventName,
    //   eventType: state.eventType,
    //   eventCategory: state.eventCategory.join(', '),
    //   description: state.eventDescription,
    //   eventFormat: state.eventFormat,
    //   eventBanner:
    //       'http://minio:9000/apni-event/2025/11/18/d8001dc9-e6c4-46d9-ae57-998001582632.jpg',
    // );

    result.fold(
      (failure) {
        log(failure.toString(), name: 'postCreateEventDetails - err');
        emit(
          state.copyWith(status: EventPage1StateStatus.failed),
        );
      },
      (response) {
        log(response.toString(), name: 'postCreateEventDetails - success');

        emit(
          state.copyWith(status: EventPage1StateStatus.succeeded),
        );
      },
    );
  }

  Future<void> uploadEventBanner({required String photoPath}) async {
    final result = await fileService.uploadFile(photoPath);

    result.fold(
      (failure) {
        log(failure.toString(), name: 'uploadEventBanner - err');
        emit(
          state.copyWith(status: EventPage1StateStatus.failed),
        );
      },
      (response) {
        log(response, name: 'uploadEventBanner - success');

        emit(
          state.copyWith(status: EventPage1StateStatus.succeeded),
        );
      },
    );
  }

  Future<void> getEventCategories({bool refresh = false}) async {
    if (state.eventCategoryOptions.isNotEmpty && !refresh) {
      return;
    }

    emit(state.copyWith(status: EventPage1StateStatus.loading));

    final result = await createEventService.getEventCategories();

    result.fold(
      (failure) {
        log(failure.toString(), name: '_getEventCategories - err');
        emit(
          state.copyWith(status: EventPage1StateStatus.failed),
        );
      },
      (response) {
        log(jsonEncode(response), name: '_getEventCategories - success');

        final options = response
            .map((e) => SelectOption(label: e.name, value: e.name))
            .toList();

        emit(
          state.copyWith(
            eventCategoryOptions: options,
            status: EventPage1StateStatus.succeeded,
          ),
        );
      },
    );
  }

  void createEvent({
    required String eventName,
    required String eventType,
    required List<String> eventCategory,
    required String eventDescription,
    required String eventFormat,
    required String eventBanner,
  }) {
    emit(
      state.copyWith(
        eventName: eventName,
        eventType: eventType,
        eventCategory: eventCategory,
        eventDescription: eventDescription,
        eventFormat: eventFormat,
        eventBanner: eventBanner,
      ),
    );
  }
}
