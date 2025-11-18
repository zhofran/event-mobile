// payment_step.dart
import 'package:deps/design/design.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/booking_data.model.dart';


class PaymentStep extends StatefulWidget {
  final BookingData bookingData;

  const PaymentStep({super.key, required this.bookingData});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  String _selectedPaymentMethod = 'QRIS';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderSummary(),
        const SizedBox(height: 20),
        const Text(
          "Select Payment Method",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethods(),
        const SizedBox(height: 20),
        _buildSecurityNote(),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Payment",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              widget.bookingData.formattedTotalPayment,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        if (widget.bookingData.selectedTicket != null)
          _buildOrderItem("Ticket", "1x ${widget.bookingData.selectedTicket!.name}"),
        if (widget.bookingData.isTravelPackEnabled) ...[
          if (widget.bookingData.selectedHotel != null)
            _buildOrderItem("Smart Travel Pack", "2 Night ${widget.bookingData.selectedHotel!.name}"),
          if (widget.bookingData.selectedTransportation != null)
            _buildOrderItem("", "1x ${widget.bookingData.selectedTransportation!.type}"),
        ],
        const Divider(),
      ],
    );
  }

  Widget _buildOrderItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            SizedBox(
              width: 120,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: Text(subtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      _PaymentMethod(
        id: 'QRIS',
        name: 'QRIS',
        description: 'Scan QR Code to Payment',
        icon: Icons.qr_code,
      ),
      _PaymentMethod(
        id: 'E-Wallet',
        name: 'E-Wallet',
        description: 'GoPay, OVO, DANA, LinkAja',
        icon: Icons.wallet,
      ),
      _PaymentMethod(
        id: 'VA',
        name: 'Virtual Account (VA)',
        description: 'All Major Bank',
        icon: Icons.account_balance,
      ),
    ];

    return Column(
      children: paymentMethods
          .map((method) => _buildPaymentMethodCard(method))
          .toList(),
    );
  }

  Widget _buildPaymentMethodCard(_PaymentMethod method) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(method.icon, color: Colors.blue[900]),
        title: Text(
          method.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(method.description),
        trailing: Radio(
          value: method.id,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.security, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Safe & Secure Payment\nYour payment information is encrypted and secured. We never store your payment details.",
              style: TextStyle(fontSize: 12, color: FabColors.greyscale600),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  _PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}