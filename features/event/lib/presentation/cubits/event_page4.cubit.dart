import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/infrastructure/infrastructure.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/freezed_annotation.dart';
import 'package:deps/packages/injectable.dart';

import '../../domain/enums/event_key_enum.dart';
import '../../domain/models/event_ticketing.model.dart';

part 'event_page4.cubit.freezed.dart';
part 'states/event_page4.state.dart';

@lazySingleton
class EventPage4Cubit extends Cubit<EventPage4State> {
  EventPage4Cubit() : super(EventPage4State.initial());

  String getTicketSellingTime() {
    if (state.saleStartDate == null ||
        state.saleEndDate == null ||
        state.saleStartTime == null ||
        state.saleEndTime == null) {
      return 'N/A';
    }

    final startDateTime = DateTime(
      state.saleStartDate!.year,
      state.saleStartDate!.month,
      state.saleStartDate!.day,
      int.parse(state.saleStartTime!.split(':')[0]),
      int.parse(state.saleStartTime!.split(':')[1]),
    );

    final endDateTime = DateTime(
      state.saleEndDate!.year,
      state.saleEndDate!.month,
      state.saleEndDate!.day,
      int.parse(state.saleEndTime!.split(':')[0]),
      int.parse(state.saleEndTime!.split(':')[1]),
    );

    // Total difference
    Duration difference = endDateTime.difference(startDateTime);

    // Break down manually using DateTime field difference
    int years = endDateTime.year - startDateTime.year;
    int months = endDateTime.month - startDateTime.month;
    int days = endDateTime.day - startDateTime.day;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    // Normalize negatives (calendar-accurate)
    if (minutes < 0) {
      minutes += 60;
      hours -= 1;
    }
    if (hours < 0) {
      hours += 24;
      days -= 1;
    }
    if (days < 0) {
      final prevMonth = DateTime(endDateTime.year, endDateTime.month, 0);
      days += prevMonth.day;
      months -= 1;
    }
    if (months < 0) {
      months += 12;
      years -= 1;
    }

    // Build result string based on highest unit
    if (years > 0) {
      return '$years Year${years > 1 ? 's' : ''} $months Month${months > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months Month${months > 1 ? 's' : ''} $days Day${days > 1 ? 's' : ''}';
    } else if (days > 0) {
      return '$days Day${days > 1 ? 's' : ''} $hours Hour${hours > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours Hour${hours > 1 ? 's' : ''} $minutes Minute${minutes > 1 ? 's' : ''}';
    } else {
      return '$minutes Minute${minutes > 1 ? 's' : ''}';
    }
  }

  void createTicketSalesPeriod({
    DateTime? saleStartDate,
    String? saleStartTime,
    DateTime? saleEndDate,
    String? saleEndTime,
  }) {
    emit(
      state.copyWith(
        saleStartDate: saleStartDate ?? state.saleStartDate,
        saleStartTime: saleStartTime ?? state.saleStartTime,
        saleEndDate: saleEndDate ?? state.saleEndDate,
        saleEndTime: saleEndTime ?? state.saleEndTime,
      ),
    );
  }

  void clearTicketSalesPeriod() {
    emit(
      state.copyWith(
        saleStartDate: null,
        saleStartTime: null,
        saleEndDate: null,
        saleEndTime: null,
      ),
    );
  }

  Future<void> saveTicketSellingTimeLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    await prefs.writeObject<EventTicketing>(
      EventKey.ticketSellingTime.name,
      EventTicketing(
        id: 'ticketSellingTime-id',
        ticketStartDate: state.saleStartDate!.addTime(state.saleStartTime!),
        ticketEndDate: state.saleEndDate!.addTime(state.saleEndTime!),
      ),
    );
  }

  Future<EventTicketing?> loadTicketSellingTimeLocally() async {
    final prefs = $.get<SharedPreferencesManager>();

    final ticketSellingTime = prefs.readObject<EventTicketing>(
      EventKey.ticketSellingTime.name,
      EventTicketing.fromJson,
    );

    if (ticketSellingTime != null) {
      emit(
        state.copyWith(
          saleStartDate: ticketSellingTime.ticketStartDate,
          saleStartTime:
              '${ticketSellingTime.ticketStartDate.hour.toString().padLeft(2, '0')}:${ticketSellingTime.ticketStartDate.minute.toString().padLeft(2, '0')}',
          saleEndDate: ticketSellingTime.ticketEndDate,
          saleEndTime:
              '${ticketSellingTime.ticketEndDate.hour.toString().padLeft(2, '0')}:${ticketSellingTime.ticketEndDate.minute.toString().padLeft(2, '0')}',
        ),
      );
    }

    return ticketSellingTime;
  }
}
