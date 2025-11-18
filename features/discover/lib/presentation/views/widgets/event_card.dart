import 'package:flutter/material.dart';

import '../../../domain/models/discover_event.model.dart';

class FabEventCard extends StatefulWidget {
  /// Data event yang akan ditampilkan
  final DiscoverEventModel event;
  
  /// Callback ketika card di-tap
  final VoidCallback? onTap;
  
  /// Callback ketika tombol share di-tap
  final VoidCallback? onShare;
  
  /// Callback ketika tombol bookmark di-tap
  /// Parameter bool menunjukkan status bookmark setelah di-tap
  final Function(bool isBookmarked)? onBookmark;
  
  /// Status awal bookmark
  final bool initialBookmarked;
  
  /// Margin untuk card
  final EdgeInsetsGeometry? margin;
  
  /// Tinggi gambar event
  final double imageHeight;
  
  /// Border radius untuk card
  final double borderRadius;

  const FabEventCard({
    Key? key,
    required this.event,
    this.onTap,
    this.onShare,
    this.onBookmark,
    this.initialBookmarked = false,
    this.margin,
    this.imageHeight = 150,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  State<FabEventCard> createState() => _FabEventCardState();
}

class _FabEventCardState extends State<FabEventCard> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.initialBookmarked;
  }

  void _handleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    widget.onBookmark?.call(isBookmarked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin ?? const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.borderRadius),
                    topRight: Radius.circular(widget.borderRadius),
                  ),
                  child: Image.network(
                    widget.event.imageUrl,
                    height: widget.imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: widget.imageHeight,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.event.badge != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.event.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 20),
                        onPressed: widget.onShare ?? () {
                          // Default share action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Share feature coming soon')),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 20,
                        ),
                        onPressed: _handleBookmark,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.event.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.event.getFormattedDate(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.receipt_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'From Rp ${widget.event.getFormattedPrice()}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}