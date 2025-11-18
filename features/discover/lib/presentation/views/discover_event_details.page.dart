import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

import '../../domain/models/discover_event.model.dart';

// Import model yang sudah ada
// import 'package:your_app/models/discover_event.model.dart';

@RoutePage()
class DiscoverEventDetailPage extends StatefulWidget {
  final DiscoverEventModel event;

  const DiscoverEventDetailPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<DiscoverEventDetailPage> createState() => _DiscoverEventDetailPageState();
}

class _DiscoverEventDetailPageState extends State<DiscoverEventDetailPage> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Image with Back Button
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.event.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Info Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Text(
                        widget.event.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Event Title
                      Text(
                        widget.event.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Organizer
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.business, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organized by',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                'Heaven Collective',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Location & Date
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Offline | ${widget.event.location}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.event.getFormattedDate(),
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Description Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Join us for the Mining Tech Summit 2025, a premier event showcasing the latest innovations in mining technology. Explore cutting-edge solutions, network with industry leaders, and discover the future of mining.',
                        style: TextStyle(
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          // TODO: Show full description
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View More',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Speakers Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Speakers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Speaker Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person, size: 30, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dr. Rina Putri, M.Ed',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Education Technology Specialist',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Speaker to be announced
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Speaker to Be Announced',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'An inspiring voice is about to join this stage!',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Ticket & Seating Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ticket & Seating',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Adhiya Pass
                      _buildTicketCard(
                        title: 'Adhiya Pass',
                        price: 'Rp150.000',
                        description: 'Akses penuh ke seluruh sesi seminar utama.',
                        badgeText: 'Regular',
                        badgeColor: Colors.green[100]!,
                        badgeTextColor: Colors.green[700]!,
                      ),
                      const SizedBox(height: 12),

                      // Pradipta Pass
                      _buildTicketCard(
                        title: 'Pradipta Pass',
                        price: 'Rp300.000',
                        description: 'Kursi prioritas + e-certificate eksklusif + snack box.',
                        badgeText: 'Premium',
                        badgeColor: Colors.blue[100]!,
                        badgeTextColor: Colors.blue[700]!,
                      ),
                      const SizedBox(height: 12),

                      // Dharma Pass
                      _buildTicketCard(
                        title: 'Dharma Pass',
                        price: 'Rp600.000',
                        description: 'Kursi depan, merchandise eksklusif, & sesi meet & greet dengan pembicara.',
                        badgeText: 'VIP',
                        badgeColor: Colors.orange[100]!,
                        badgeTextColor: Colors.orange[700]!,
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Location Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Open map
                            },
                            child: const Text(
                              'See Map',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Map Preview
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // Placeholder for map
                              Container(
                                color: Colors.green[100],
                              ),
                              const Center(
                                child: Icon(
                                  Icons.location_on,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jakarta Convention Center, Hall A, Jl. Gatot Subroto No. 1, Central Jakarta',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Directions to Venue
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Directions to Venue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: See all directions
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildDirectionItem(
                        icon: Icons.directions_car,
                        iconColor: Colors.pink[300]!,
                        title: 'By Car',
                        description: '2.6 km via Sudirman Street',
                        time: '20 mins',
                      ),
                      const Divider(height: 24),
                      _buildDirectionItem(
                        icon: Icons.motorcycle,
                        iconColor: Colors.orange[300]!,
                        title: 'Ride Hailing',
                        description: '2.4 km via Senayan',
                        time: '15 mins',
                        price: 'Rp 16.000',
                      ),
                      const Divider(height: 24),
                      _buildDirectionItem(
                        icon: Icons.directions_bus,
                        iconColor: Colors.green[300]!,
                        title: 'Public Transportation',
                        description: 'Busway Corridor 9 → JCC Stop',
                        time: '10 mins',
                        price: 'Rp 3.000',
                      ),
                      const Divider(height: 24),
                      _buildDirectionItem(
                        icon: Icons.directions_walk,
                        iconColor: Colors.blue[300]!,
                        title: 'Walk',
                        description: '1.9 km via city center',
                        time: '30 mins',
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Explore Around This Event
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore Around This Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nearby Hotels
                      _buildExploreSection(
                        title: 'Nearby Hotels',
                        icon: Icons.hotel,
                        items: [
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'Kamini Legian Hot...',
                            distance: '639 m from venue',
                            rating: 4.3,
                            reviews: 279,
                            price: 'Rp 1.000.000',
                          ),
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'HARRIS Suites fX...',
                            distance: '799 m from venue',
                            rating: 4.9,
                            reviews: 500,
                            price: 'Rp 1.576.000',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Local Delicacies
                      _buildExploreSection(
                        title: 'Local Delicacies / Souvenirs',
                        icon: Icons.restaurant,
                        items: [
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'Sari Bundo Resta...',
                            distance: '1.2 km from venue',
                            rating: 4.5,
                            reviews: 150,
                            price: 'Rp 5.000 - 250.000',
                          ),
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'Krisna Oleh Oleh',
                            distance: '850 m from venue',
                            rating: 4.6,
                            reviews: 320,
                            price: 'Rp 15.000 - 250.000',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nearby Attractions
                      _buildExploreSection(
                        title: 'Nearby Attractions',
                        icon: Icons.attractions,
                        items: [
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'Trans Studio Cibu...',
                            distance: '15 km from venue',
                            rating: 4.7,
                            reviews: 200,
                            price: 'Rp 350.000',
                          ),
                          _ExploreItem(
                            image: 'https://via.placeholder.com/150',
                            title: 'Ancol Dreamland',
                            distance: '6.5 km from venue',
                            rating: 4.6,
                            reviews: 300,
                            price: 'Rp 200.000',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Tags Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tags',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTag('Innovation Showcase'),
                          _buildTag('Mining Technologies'),
                          _buildTag('Sustainability Solutions'),
                          _buildTag('Future of Mining'),
                          _buildTag('Networking Opportunities'),
                          _buildTag('Industry Insights'),
                          _buildTag('Market Trends'),
                          _buildTag('Consumer Behavior'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() => isBookmarked = !isBookmarked);
                  // TODO: Save bookmark to API
                },
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.orange,
                ),
                label: const Text(
                  'Bookmark',
                  style: TextStyle(color: Colors.orange),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to ticket purchase
                  // $.navigator.push(BookingFlowRoute(event: widget.event));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buy Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard({
    required String title,
    required String price,
    required String description,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.receipt_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                price,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.description_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    String? price,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              if (price != null) ...[
                const SizedBox(height: 2),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildExploreSection({
    required String title,
    required IconData icon,
    required List<_ExploreItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // TODO: See all
              },
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.distance,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating} (${item.reviews})',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}

// Helper class for explore items
class _ExploreItem {
  final String image;
  final String title;
  final String distance;
  final double rating;
  final int reviews;
  final String price;

  _ExploreItem({
    required this.image,
    required this.title,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.price,
  });
}