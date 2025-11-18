import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/models/booking_data.model.dart';
import '../../domain/models/booking_event.model.dart';
import '../../domain/models/discover_event.model.dart';
import 'widgets/payment_selection.dart';
import 'widgets/ticket_selection.dart';
import 'widgets/travel_selection.dart';


@RoutePage()
class BookingFlowPage extends StatefulWidget {
  final DiscoverEventModel event;

  const BookingFlowPage({super.key, required this.event});

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  late BookingData _bookingData;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _bookingData = BookingData(
      event: BookingEventModel.fromDiscoverEvent(widget.event),
    );
  }

  List<Step> get _steps => [
        Step(
          title: const Text('Ticket'),
          content: TicketSelectionStep(
            bookingData: _bookingData,
            onDataChanged: _updateBookingData,
          ),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('Travel Pack'),
          content: TravelPackStep(
            bookingData: _bookingData,
            onDataChanged: _updateBookingData,
          ),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text('Payment'),
          content: PaymentStep(bookingData: _bookingData),
          isActive: _currentStep >= 2,
        ),
      ];

  void _updateBookingData(BookingData newData) {
    setState(() {
      _bookingData = newData;
    });
  }

  void _onStepContinue() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Finalize booking
      _completeBooking();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      $.navigator.pop();
    }
  }

  void _completeBooking() {
    // TODO: Implement booking completion logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Successful!'),
        content: const Text('Your tickets have been booked successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              $.navigator.pop((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_bookingData.event.title),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Event Header
          _buildEventHeader(),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              steps: _steps,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(
                            _currentStep == _steps.length - 1 
                                ? 'Complete Booking' 
                                : 'Continue',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _bookingData.event.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatDate(_bookingData.event.startDate)} - ${_formatDate(_bookingData.event.endDate)} | ${_bookingData.event.time}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}