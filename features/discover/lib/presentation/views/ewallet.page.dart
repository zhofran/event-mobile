import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EWalletPage extends StatefulWidget {
  final String eventTitle;
  final String eventDate;
  final double totalAmount;
  final String paymentMethod;

  const EWalletPage({
    required this.eventTitle,
    required this.eventDate,
    required this.totalAmount,
    required this.paymentMethod,
    Key? key,
  }) : super(key: key);

  @override
  State<EWalletPage> createState() => _EWalletPageState();
}

class _EWalletPageState extends State<EWalletPage> {
  String? selectedChannel;
  String? imageUrl;

  final List<Map<String, dynamic>> channels = [
    {
      'name': 'Gopay',
      'subtitle': 'Pay with Gopay balance',
      'logo': Assets.images.gopay.path,
    },
    {
      'name': 'OVO',
      'subtitle': 'Pay with OVO balance',
      'logo': Assets.images.ovo.path,
    },
    {
      'name': 'DANA',
      'subtitle': 'Pay with DANA balance',
      'logo': Assets.images.dana.path,
    },
    {
      'name': 'Link Aja',
      'subtitle': 'Pay with LinkAja balance',
      'logo': Assets.images.linkAja.path,
    },
    {
      'name': 'Shopee Pay',
      'subtitle': 'Pay with ShopeePay balance',
      'logo': Assets.images.shopeePay.path,
    },
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orange card
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

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Payment Channel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Channel selection
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 16),
                ...channels.map((channel) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildChannelOption(
                        channel['name'],
                        channel['subtitle'],
                        channel['logo'],
                      ),
                    )),
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
                onPressed: selectedChannel != null
                    ? () {
                      $.navigator.push(
                        EWalletPhoneRoute(
                          eventName: widget.eventTitle,
                          eventDate: widget.eventDate,
                          paymentChannel: selectedChannel ?? '',
                          imageUrl: imageUrl ?? '',
                          expiryTime: '23h 51m 45s',
                        ),
                      );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EWalletDetailPage(
                        //       eventTitle: widget.eventTitle,
                        //       eventDate: widget.eventDate,
                        //       totalAmount: widget.totalAmount,
                        //       channel: selectedChannel!,
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

  Widget _buildChannelOption(String name, String subtitle, String logo) {
    final isSelected = selectedChannel == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChannel = name;
          imageUrl = logo;
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
              child: Center(
                child: Image.asset(
                  logo,
                  width: 24,
                  height: 24,
                  package: 'design',
                ),
              ),
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
