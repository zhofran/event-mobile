// payment_method_page.dart
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PaymentMethodPage extends StatefulWidget {
  final String eventTitle;
  final String eventDate;
  final double totalAmount;
  final List<String> ticketDetails;

  const PaymentMethodPage({
    required this.eventTitle,
    required this.eventDate,
    required this.totalAmount,
    required this.ticketDetails,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? selectedMethod;

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
              widget.eventTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.eventDate,
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
      body: Column(
        children: [
          // Orange card with payment summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C42),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Payment',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp${_formatNumber(widget.totalAmount)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.ticketDetails.map((detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          detail,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payment method selection
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  'QRIS',
                  'Scan QR Code to Payment',
                  Icons.qr_code_2,
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  'E-Wallet',
                  'GoPay, OVO, DANA, LinkAja',
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  'Virtual Account (VA)',
                  'All Major Bank',
                  Icons.account_balance,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Safe & Secure Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Your payment information is encrypted and secured. We never store your payment details.',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Continue button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedMethod != null
                    ? () {
                        if (selectedMethod == 'E-Wallet') {
                          $.navigator.push(
                            EWalletRoute(
                              eventTitle: widget.eventTitle, 
                              eventDate: widget.eventDate, 
                              totalAmount: widget.totalAmount, 
                              paymentMethod: selectedMethod ?? '',
                              ),
                            );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PaymentChannelPage(
                          //       eventTitle: widget.eventTitle,
                          //       eventDate: widget.eventDate,
                          //       totalAmount: widget.totalAmount,
                          //       paymentMethod: selectedMethod!,
                          //     ),
                          //   ),
                          // );
                        } else if (selectedMethod == 'Virtual Account (VA)') {
                          $.navigator.push(
                            BankSelectionRoute(
                              eventTitle: widget.eventTitle, 
                              eventDate: widget.eventDate,
                              totalAmount: widget.totalAmount,
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => BankSelectionPage(
                          //       eventTitle: widget.eventTitle,
                          //       eventDate: widget.eventDate,
                          //       totalAmount: widget.totalAmount,
                          //     ),
                          //   ),
                          // );
                        } else if (selectedMethod == 'QRIS') {
                          $.navigator.push(
                            QRISPaymentRoute(
                              eventTitle: widget.eventTitle, 
                              eventDate: widget.eventDate,
                              totalAmount: widget.totalAmount,
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => QRISPaymentPage(
                          //       eventTitle: widget.eventTitle,
                          //       eventDate: widget.eventDate,
                          //       totalAmount: widget.totalAmount,
                          //     ),
                          //   ),
                          // );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                  disabledBackgroundColor: Colors.grey[300],
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
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon) {
    final isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8C42) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF8C42),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

// payment_success_page.dart


// Example usage in main.dart or how to navigate from your discover page:
/*
void navigateToPayment() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentMethodPage(
        eventTitle: 'MiningTech Summit 2025',
        eventDate: '15 Nov 25 - 18 Nov 25 | 07:00 WIB',
        totalAmount: 2250000,
        ticketDetails: [
          '1x Pradipta Pass',
          'Smart Travel Pack',
          '2 Night HARRIS Suites fX Sudirman',
          '1x Mobil Standar',
        ],
      ),
    ),
  );
}
*/
