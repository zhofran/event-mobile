import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import 'payment_method.page.dart';
import 'widgets/travel_card.dart';

@RoutePage()
class SmartTravelPackPage extends StatefulWidget {
  final String ticketName;
  final int ticketPrice;

  const SmartTravelPackPage({
    required this.ticketName,
    required this.ticketPrice,
    Key? key,
  }) : super(key: key);

  @override
  State<SmartTravelPackPage> createState() => _SmartTravelPackPageState();
}

class _SmartTravelPackPageState extends State<SmartTravelPackPage> {
  String? selectedHotel;
  int hotelPrice = 0;
  String? selectedTransport;
  int transportPrice = 0;

  int get totalPayment => widget.ticketPrice + hotelPrice + transportPrice;

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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'MiningTech Summit 2025',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '15 Nov 25 - 18 Nov 25 | 07.00 WIB',
              style: TextStyle(
                color: Colors.grey,
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Smart Travel Pack',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Smart Travel Pack',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Plan your trip in one click, get the best hotel and transport options instantly.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TravelPackCard(
                    icon: Icons.hotel,
                    title: 'Hotels',
                    description: 'Find the perfect stay near your event, curated options with comfort, distance, and best value in mind.',
                    buttonText: selectedHotel ?? 'Add Hotels',
                    hasSelection: selectedHotel != null,
                    selectedDetails: selectedHotel != null
                        ? 'HARRIS Suites fX Sudirman\nRp 1.700.000\n15 Nov 25 - 18 Nov 25'
                        : null,
                    onTap: () {
                      setState(() {
                        if (selectedHotel == null) {
                          selectedHotel = 'HARRIS Suites fX Sudirman';
                          hotelPrice = 1700000;
                        }
                      });
                    },
                    onChangeTap: () {
                      setState(() {
                        selectedHotel = null;
                        hotelPrice = 0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TravelPackCard(
                    icon: Icons.directions_bus,
                    title: 'Transportation',
                    description: 'Get there hassle-free, explore the best rides, routes, and deals matched to your event schedule.',
                    buttonText: selectedTransport ?? 'Add Transportation',
                    hasSelection: selectedTransport != null,
                    selectedDetails: selectedTransport != null
                        ? 'Mobil Standar\nRp 250.000\nBandung - Jakarta 14 Nov 25, 14.00 WIB'
                        : null,
                    onTap: () {
                      setState(() {
                        if (selectedTransport == null) {
                          selectedTransport = 'Mobil Standar';
                          transportPrice = 250000;
                        }
                      });
                    },
                    onChangeTap: () {
                      setState(() {
                        selectedTransport = null;
                        transportPrice = 0;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Payment',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      'Rp ${totalPayment.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethodPage(
                            eventTitle: 'MinigTech Summit 2025',
                            eventDate: '15 Nov 25 - 18 Nov 25 | 07.00 WIB',
                            totalAmount: double.parse(totalPayment.toString()),
                            ticketDetails: const [
                              '1x Pradipta Pass',
                              '2 Night HARRIS Suites fX Sudirman',
                              '1x Mobil Standar',
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}