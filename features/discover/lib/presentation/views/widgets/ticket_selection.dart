import 'package:flutter/material.dart';

import '../../../domain/models/booking_data.model.dart';
import '../../../domain/models/ticket_type.model.dart';


class TicketSelectionStep extends StatefulWidget {
  final BookingData bookingData;
  final Function(BookingData) onDataChanged;

  const TicketSelectionStep({
    super.key,
    required this.bookingData,
    required this.onDataChanged,
  });

  @override
  State<TicketSelectionStep> createState() => _TicketSelectionStepState();
}

class _TicketSelectionStepState extends State<TicketSelectionStep> {
  late List<TicketType> _tickets;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    // TODO: Replace with API call
    _tickets = [
      TicketType(
        id: "1",
        name: "Adhiya Pass",
        price: 150000,
        description: "Akses penuh ke seluruh sesi seminar utama.",
        seatsLeft: 23,
      ),
      TicketType(
        id: "2",
        name: "Pradipta Pass",
        price: 300000,
        description: "Kursi prioritas + e-certificate eksklusif + snack box.",
        seatsLeft: 2,
      ),
      TicketType(
        id: "3",
        name: "Dharma Pass",
        price: 600000,
        description: "Kursi depan, merchandise eksklusif, & sesi meet & greet dengan pembicara.",
        seatsLeft: 50,
      ),
    ];

    // Select first ticket by default
    if (_tickets.isNotEmpty && widget.bookingData.selectedTicket == null) {
      _selectTicket(_tickets.first);
    }
  }

  void _selectTicket(TicketType ticket) {
    setState(() {
      _tickets = _tickets.map((t) => t.copyWith(
        isSelected: t.id == ticket.id,
      )).toList();
    });

    widget.onDataChanged(
      widget.bookingData.copyWith(selectedTicket: ticket.copyWith(isSelected: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose your ticket type",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._tickets.map((ticket) => _buildTicketCard(ticket)).toList(),
        const SizedBox(height: 20),
        const Divider(),
        _buildTotalPayment(),
      ],
    );
  }

  Widget _buildTicketCard(TicketType ticket) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(ticket.price),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
            const SizedBox(height: 8),
            Text(ticket.description),
            const SizedBox(height: 8),
            Text(
              "${ticket.seatsLeft} seats left",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Radio(
          value: ticket.id,
          groupValue: _tickets.firstWhere((t) => t.isSelected).id,
          onChanged: (value) {
            _selectTicket(_tickets.firstWhere((t) => t.id == value));
          },
        ),
      ),
    );
  }

  Widget _buildTotalPayment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total Payment",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          _formatCurrency(widget.bookingData.selectedTicket?.price ?? 0),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}