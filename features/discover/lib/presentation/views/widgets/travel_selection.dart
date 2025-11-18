// travel_pack_step.dart
import 'package:flutter/material.dart';

import '../../../domain/models/booking_data.model.dart';
import '../../../domain/models/hotel_option.model.dart';
import '../../../domain/models/transportation_option.model.dart';


class TravelPackStep extends StatefulWidget {
  final BookingData bookingData;
  final Function(BookingData) onDataChanged;

  const TravelPackStep({
    super.key,
    required this.bookingData,
    required this.onDataChanged,
  });

  @override
  State<TravelPackStep> createState() => _TravelPackStepState();
}

class _TravelPackStepState extends State<TravelPackStep> {
  late List<HotelOption> _hotels;
  late List<TransportationOption> _transportations;

  @override
  void initState() {
    super.initState();
    _loadHotels();
    _loadTransportations();
  }

  void _loadHotels() {
    // TODO: Replace with API call
    _hotels = [
      HotelOption(
        id: "1",
        name: "HARRIS Suites fX Sudirman",
        price: 1700000,
        checkIn: DateTime(2025, 11, 15),
        checkOut: DateTime(2025, 11, 18),
      ),
    ];
  }

  void _loadTransportations() {
    // TODO: Replace with API call
    _transportations = [
      TransportationOption(
        id: "1",
        type: "Mobil Standar",
        price: 250000,
        route: "Bandung - Jakarta",
        date: DateTime(2025, 11, 14),
        time: "14.00 WIB",
      ),
    ];
  }

  void _toggleTravelPack(bool enabled) {
    widget.onDataChanged(
      widget.bookingData.copyWith(isTravelPackEnabled: enabled),
    );
  }

  void _selectHotel(HotelOption hotel) {
    setState(() {
      _hotels = _hotels.map((h) => h.copyWith(
        isSelected: h.id == hotel.id,
      )).toList();
    });

    widget.onDataChanged(
      widget.bookingData.copyWith(selectedHotel: hotel.copyWith(isSelected: true)),
    );
  }

  void _selectTransportation(TransportationOption transport) {
    setState(() {
      _transportations = _transportations.map((t) => t.copyWith(
        isSelected: t.id == transport.id,
      )).toList();
    });

    widget.onDataChanged(
      widget.bookingData.copyWith(selectedTransportation: transport.copyWith(isSelected: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTravelPackToggle(),
        if (widget.bookingData.isTravelPackEnabled) ...[
          const SizedBox(height: 20),
          _buildHotelsSection(),
          const SizedBox(height: 20),
          _buildTransportationSection(),
        ],
        const SizedBox(height: 20),
        const Divider(),
        _buildTotalPayment(),
      ],
    );
  }

  Widget _buildTravelPackToggle() {
    return Card(
      child: ListTile(
        title: const Text(
          "Add Smart Travel Pack",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text("Plan your trip in one click, get the best hotel and transport options instantly."),
        trailing: Switch(
          value: widget.bookingData.isTravelPackEnabled,
          onChanged: _toggleTravelPack,
        ),
      ),
    );
  }

  Widget _buildHotelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hotels",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("Find the perfect stay near your event, curated options with comfort, distance, and best value in mind."),
        const SizedBox(height: 12),
        ..._hotels.map((hotel) => _buildHotelCard(hotel)).toList(),
        if (_hotels.isEmpty) _buildAddButton("Add Hotels"),
      ],
    );
  }

  Widget _buildHotelCard(HotelOption hotel) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotel.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(hotel.price),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
            const SizedBox(height: 4),
            Text(
              "${_formatDate(hotel.checkIn)} - ${_formatDate(hotel.checkOut)}",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            _selectHotel(hotel);
          },
          child: const Text("Select"),
        ),
      ),
    );
  }

  Widget _buildTransportationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transportation",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("Get there hassle-free, explore the best rides, routes, and deals matched to your event schedule."),
        const SizedBox(height: 12),
        ..._transportations.map((transport) => _buildTransportationCard(transport)).toList(),
        if (_transportations.isEmpty) _buildAddButton("Add Transportation"),
      ],
    );
  }

  Widget _buildTransportationCard(TransportationOption transport) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transport.type,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _formatCurrency(transport.price),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            ),
            const SizedBox(height: 4),
            Text(
              "${transport.route} ${_formatDate(transport.date)}, ${transport.time}",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: TextButton(
          onPressed: () {
            _selectTransportation(transport);
          },
          child: const Text("Select"),
        ),
      ),
    );
  }

  Widget _buildAddButton(String text) {
    return OutlinedButton(
      onPressed: () {
        // TODO: Navigate to selection screen
      },
      child: Text(text),
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
          widget.bookingData.formattedTotalPayment,
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

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}