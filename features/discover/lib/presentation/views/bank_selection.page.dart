import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BankSelectionPage extends StatefulWidget {
  final String eventTitle;
  final String eventDate;
  final double totalAmount;

  const BankSelectionPage({
    required this.eventTitle,
    required this.eventDate,
    required this.totalAmount,
    Key? key,
  }) : super(key: key);

  @override
  State<BankSelectionPage> createState() => _BankSelectionPageState();
}

class _BankSelectionPageState extends State<BankSelectionPage> {
  String? selectedBank;

  final List<Map<String, String>> banks = [
    {'name': 'Bank Central Asia (BCA)', 'subtitle': 'Pay with Gopay balance'},
    {'name': 'Bank Mandiri', 'subtitle': 'Pay with OVO balance'},
    {'name': 'Bank Negara Indonesia (BNI)', 'subtitle': 'Pay with DANA balance'},
    {'name': 'Bank Rakyat Indonesia (BRI)', 'subtitle': 'Pay with LinkAja balance'},
    {'name': 'Permata Bank', 'subtitle': 'Pay with ShopeePay balance'},
  ];

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
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
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
                const Text(
                  '• 1x Pradipta Pass',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const Text(
                  'Smart Travel Pack',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const Text(
                  '• 2 Night HARRIS Suites fX Sudirman',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const Text(
                  '• 1x Mobil Standar',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text(
                  'Select Payment Channel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...banks.map((bank) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBankOption(bank['name']!, bank['subtitle']!),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedBank != null
                    ? () {
                      $.navigator.push(
                        VirtualAccountRoute(
                          eventTitle: widget.eventTitle, 
                          eventDate: widget.eventDate, 
                          totalAmount: widget.totalAmount, 
                          bankName: selectedBank ?? '',
                        ),
                      );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => VirtualAccountPage(
                        //       eventTitle: widget.eventTitle,
                        //       eventDate: widget.eventDate,
                        //       totalAmount: widget.totalAmount,
                        //       bankName: selectedBank!,
                        //     ),
                        //   ),
                        // );
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

  Widget _buildBankOption(String name, String subtitle) {
    final isSelected = selectedBank == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBank = name;
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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