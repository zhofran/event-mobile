import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PaymentConfirmationPage extends StatelessWidget {
  final String eventTitle;
  final String eventDate;
  final double totalAmount;
  final String channel;
  final String phoneNumber;

  const PaymentConfirmationPage({
    required this.eventTitle,
    required this.eventDate,
    required this.totalAmount,
    required this.channel,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              eventTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              eventDate,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'E-Wallet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C42).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Color(0xFFFF8C42),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '23h 51m 45s',
                      style: TextStyle(
                        color: Color(0xFFFF8C42),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFF8C42), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('🏦', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'gopay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text(
                  'Selected',
                  style: TextStyle(
                    color: Color(0xFFFF8C42),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Confirmation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Payment Method', channel),
                const SizedBox(height: 12),
                _buildDetailRow('Phone Number', phoneNumber),
                const Divider(height: 32),
                _buildDetailRow('Item', 'Career Assesment Test'),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Total Payment',
                  'Rp${_formatNumber(totalAmount)}',
                  isAmount: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C42).withOpacity(0.1),
              border: Border.all(color: const Color(0xFFFF8C42)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Color(0xFFFF8C42),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Next Steps',
                      style: TextStyle(
                        color: Color(0xFFFF8C42),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStepText('1. Click "Pay Now" to open GoPay app'),
                _buildStepText('2. Confirm payment in the app'),
                _buildStepText('3. Wait for automatic verification'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Simulate payment success
              Future.delayed(const Duration(seconds: 2), () {
                $.navigator.replace(
                  PaymentSuccessRoute(
                    eventTitle: eventTitle, 
                    totalAmount: totalAmount,
                  ),
                );
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PaymentSuccessPage(
                //       eventTitle: eventTitle,
                //       totalAmount: totalAmount,
                //     ),
                //   ),
                // );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
            color: isAmount ? const Color(0xFFFF8C42) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStepText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
