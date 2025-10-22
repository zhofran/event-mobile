import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/skeletonizer.dart';
import 'package:flutter/material.dart';

class JobAppliedCard extends StatefulWidget {
  const JobAppliedCard({
    required this.product,
    super.key,
  });

  final JobAppliedModel product;

  @override
  State<JobAppliedCard> createState() => _JobAppliedCardState();
}

class _JobAppliedCardState extends State<JobAppliedCard> {
  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.product.isEmpty,
      child: GestureDetector(
        onTap: () => $.navigator.push(
          JobAppliedDetailsRoute(
            product: widget.product,
            onSelectedItemChanged: (index) {},
          ),
        ),
        child: FabCard(
          pressedOpacity: 0.95,
          hasShadow: true,
          color: FabColors.greyscale0,
          radius: 12,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Application Tag and Bookmark
                _buildHeader(context),

                // Company Logo and Info Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildCompanySection(context),
                ),

                PaddingGap.xs(),

                // Job Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildJobDetails(context),
                ),

                PaddingGap.xs(),

                // Footer Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildFooter(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildApplicationLabel(),
      ],
    );
  }

  Widget _buildCompanySection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4EC), // Light orange background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Placeholder for company logo (flower-like shape)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C42),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'PT',
                      style: FabTypography.bodySmallBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // You can replace with actual SVG logo if available
              ],
            ),
          ),
        ),

        PaddingGap.sm(),

        // Job Title and Company Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mining Operations',
                    style: FabTypography.displaySemiBold18.copyWith(
                      color: FabColors.greyscale900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                      },
                      child: Assets.images.icons.bussines.bookmarkLine.svg(
                        width: 24,
                        height: 24,
                        package: 'design',
                        colorFilter: ColorFilter.mode(
                          FabColors.greyscale900,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              PaddingGap.xxs(),

              // Company Name with Verified Badge
              Row(
                children: [
                  Text(
                    'PT. Ceriacorp',
                    style: FabTypography.displayRegular14.copyWith(
                      color: FabColors.greyscale400,
                    ),
                  ),
                  PaddingGap.xxs(),
                  Assets.images.icons.bussines.verifiedBadgeFill.svg(
                    width: 15,
                    height: 15,
                    package: 'design',
                    colorFilter: ColorFilter.mode(
                      FabColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Employment Type
            Row(
              children: [
                Assets.images.icons.userFaces.userLine.svg(
                  width: 18,
                  height: 18,
                  package: 'design',
                  colorFilter: ColorFilter.mode(
                    FabColors.greyscale400,
                    BlendMode.srcIn,
                  ),
                ),
                PaddingGap.xs(),
                Text(
                  'Fulltime',
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale400,
                  ),
                ),
              ],
            ),

            PaddingGap.xxs(),

            // Location
            Row(
              children: [
                Assets.images.icons.map.mapPinLine.svg(
                  width: 18,
                  height: 18,
                  package: 'design',
                  colorFilter: ColorFilter.mode(
                    FabColors.greyscale400,
                    BlendMode.srcIn,
                  ),
                ),
                PaddingGap.xs(),
                Text(
                  'Onsite | Jakarta, Indonesia',
                  style: FabTypography.displayRegular14.copyWith(
                    color: FabColors.greyscale400,
                  ),
                ),
              ],
            ),
          ],
        ),

        PaddingGap.xs(),

        // Experience Level
        Text(
          'Junior (1-2 YoE)',
          style: FabTypography.displayRegular14.copyWith(
            color: FabColors.greyscale400,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Recruiter Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: FabColors.error0,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Recruiter online 4hr ago',
                style: FabTypography.displayRegular14.copyWith(
                  color: FabColors.error100, // Red color as in design
                ),
              ),
            ),

            // Salary Range
            Text(
              '\$200 - \$350/Month',
              style: FabTypography.displayRegular14.copyWith(
                color: FabColors.greyscale400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplicationLabel() {
    return CustomPaint(
      painter: ApplicationLabelPainter(),
      child: Container(
        padding: const EdgeInsets.only(
          left: 23,
          right: 23,
          top: 8,
          bottom: 8,
        ),
        child: Text(
          'Application',
          style: FabTypography.bodySmallMedium.copyWith(
            color: FabColors.greyscale0,
          ),
        ),
      ),
    );
  }
}

class ApplicationLabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF8C42)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from top-left corner
    path.moveTo(0, 0);

    // Top edge to right side (with rounded corner)
    path.lineTo(size.width - 12, 0);

    // Top-right rounded corner
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      12,
    );

    // Right edge down to bottom-right corner
    path.lineTo(size.width, size.height - 12);

    // Bottom-right no rounded corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height,
    );

    // Bottom edge with diagonal cut on the left
    path.lineTo(20, size.height);

    // Diagonal cut from bottom-left to create the "tab" effect
    path.lineTo(0, size.height - 29);

    // Left edge back to start
    path.lineTo(0, 0);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
