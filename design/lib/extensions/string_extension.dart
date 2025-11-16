import 'package:flutter/material.dart';

extension StringToTimeOfDay on String {
  TimeOfDay toTimeOfDay() {
    final parts = split(':');

    if (parts.length != 2) {
      throw const FormatException(
          'Time string must be in format HH:mm (example: 08:30)');
    }

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

extension TimeOfDayToString on TimeOfDay? {
  String? toTimeString() {
    if (this == null) {
      return null;
    }
    final hourStr = this!.hour.toString().padLeft(2, '0');
    final minuteStr = this!.minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}

extension TicketBadgeColor on String {
  Color get badgeTicketColor {
    switch (this) {
      case 'Regular':
        return const Color(0xFFD1F4E0); // Light green
      case 'Premium':
        return const Color(0xFFD1F0FF); // Light blue
      case 'VIP':
        return const Color(0xFFFFF4D1); // Light yellow
      case 'VVIP':
        return const Color(0xFFFFE0F0); // Light pink
      default:
        return const Color(0xFFF5F0FF); // Primary50
    }
  }
}
