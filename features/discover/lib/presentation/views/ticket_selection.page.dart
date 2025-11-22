import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import 'widgets/ticket_card.dart';
import 'smart_travel.page.dart';

@RoutePage()
class TicketSelectionPage extends StatefulWidget {
  const TicketSelectionPage({Key? key}) : super(key: key);

  @override
  State<TicketSelectionPage> createState() => _TicketSelectionPageState();
}

class _TicketSelectionPageState extends State<TicketSelectionPage> {
  String? selectedTicket;
  int totalPayment = 0;

  void selectTicket(String ticket, int price) {
    setState(() {
      selectedTicket = ticket;
      totalPayment = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
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
                    'Choose your ticket type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TicketCard(
                    title: 'Adhiya Pass',
                    price: 'Rp150.000',
                    description: 'Akses penuh ke seluruh sesi seminar utama.',
                    seatsLeft: '23 seats left',
                    badge: 'Regular',
                    badgeColor: Colors.green[100]!,
                    isSelected: selectedTicket == 'Adhiya',
                    onTap: () => selectTicket('Adhiya', 150000),
                  ),
                  const SizedBox(height: 12),
                  TicketCard(
                    title: 'Pradipta Pass',
                    price: 'Rp300.000',
                    description: 'Kursi prioritas + e-certificate eksklusif + snack box.',
                    seatsLeft: '2 seats left',
                    badge: 'Premium',
                    badgeColor: Colors.cyan[100]!,
                    isSelected: selectedTicket == 'Pradipta',
                    onTap: () => selectTicket('Pradipta', 300000),
                  ),
                  const SizedBox(height: 12),
                  TicketCard(
                    title: 'Dharma Pass',
                    price: 'Rp600.000',
                    description: 'Kursi depan, merchandise eksklusif, & sesi meet & greet dengan pembicara.',
                    seatsLeft: '50 seats left',
                    badge: 'VIP',
                    badgeColor: Colors.orange[200]!,
                    isSelected: selectedTicket == 'Dharma',
                    onTap: () => selectTicket('Dharma', 600000),
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
                    onPressed: selectedTicket != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SmartTravelPackPage(
                                  ticketName: selectedTicket!,
                                  ticketPrice: totalPayment,
                                ),
                              ),
                            );
                          }
                        : null,
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