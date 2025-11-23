import 'package:flutter/material.dart';

import '../../design.dart';

/// Model data untuk setiap item Quick Access
class QuickAccessItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  QuickAccessItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Widget global untuk Quick Access Menu
class FabQuickAccessMenu extends StatelessWidget {
  final String title;
  final List<QuickAccessItem> items;
  final bool useSliderWhenOverflow; // true = slider, false = bottom sheet
  final int maxVisibleItems;

  const FabQuickAccessMenu({
    super.key,
    required this.title,
    required this.items,
    this.useSliderWhenOverflow = true,
    this.maxVisibleItems = 4,
  });

  @override
  Widget build(BuildContext context) {
    final showMore = items.length > maxVisibleItems;

    final visibleItems = showMore ? items.take(maxVisibleItems).toList() : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: FabTypography.displayBold16.copyWith(
            color: FabColors.textPrimary
          ),
        ),
        const SizedBox(height: 12),
        if (useSliderWhenOverflow && showMore)
          // Mode slider horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...visibleItems.map((item) => _buildMenuItem(context, item)),
                _buildMoreButton(context),
              ],
            ),
          )
        else
          // Mode grid biasa (dengan opsi bottom sheet jika showMore)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...visibleItems.map((item) => _buildMenuItem(context, item)),
              if (showMore) _buildMoreButton(context),
            ],
          ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, QuickAccessItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.orange.shade50,
              child: Icon(
                item.icon,
                color: Colors.black87,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 42, // Tinggi minimum untuk menampung 2 baris text
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FabTypography.bodySmallBold.copyWith(
                  color: FabColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAllMenu(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.more_horiz, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              'More',
              style: FabTypography.bodySmallRegular.copyWith(
                color: FabColors.textPrimary
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: items.map((item) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                item.onTap();
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.orange.shade50,
                    child: Icon(item.icon, color: Colors.black87, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label, 
                    style: FabTypography.bodySmallRegular.copyWith(
                      color: FabColors.textPrimary
                    )
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
