// ignore_for_file: max_lines_for_file, max_lines_for_function
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/skeletonizer.dart';
import 'package:deps/packages/styled_text.dart';
import 'package:deps/packages/talker_flutter.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

class DiscoverListingCard extends StatefulWidget {
  const DiscoverListingCard({
    required this.product,
    super.key,
  });

  final DiscoverModel product;

  @override
  State<DiscoverListingCard> createState() => _DiscoverListingCardState();
}

class _DiscoverListingCardState extends State<DiscoverListingCard> {
  bool isLiked = false;
  int likeCount = 54;
  int commentCount = 20;
  int shareCount = 11;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.product.isEmpty,
      child: FabCard(
        radius: 0,
        pressedOpacity: 1,
        color: FabColors.greyscale0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Section - User Information
            _buildUserHeader(context),
            
            // Job Posting Image
            _buildJobImage(context),
            
            // Action Buttons (Like, Comment, Share)
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Padding(
      padding: $.paddings.sm.all,
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.fabTheme.primaryColor.withOpacity(0.1),
            ),
            child: ClipOval(
              child: FabImage(
                uri: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                width: 40,
                height: 40,
              ),
            ),
          ),
          
          PaddingGap.sm(),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Picay Yundar',
                      style: FabTypography.displayMedium16.copyWith(
                        color: FabColors.greyscale900,
                      ),
                    ),
                    
                    PaddingGap.xxs(),
                    
                    Assets.images.icons.bussines.verifiedBadgeFill.svg(
                      width: 22,
                      height: 22,
                      package: 'design',
                      colorFilter: ColorFilter.mode(
                        FabColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                
                PaddingGap.xxs(),
                
                Text(
                  'Human Capital at Seksam.id | 2hr',
                  style: FabTypography.displayRegular12.copyWith(
                    color: FabColors.greyscale300,
                  ),
                ),
              ],
            ),
          ),
          
          // More Options Button
          IconButton(
            onPressed: () {},
            icon: Assets.images.icons.system.more2Line.svg(
              width: 24,
              height: 24,
              package: 'design',
              colorFilter: ColorFilter.mode(
                FabColors.greyscale900,
                BlendMode.srcIn,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobImage(BuildContext context) {
    return GestureDetector(
      onTap: () => $.navigator.push(
        DiscoverDetailsRoute(
          product: widget.product,
          selectedItemIndex: 0,
          onSelectedItemChanged: (index) {},
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: $.context.height * 0.37, // Reduced height for better proportions
        child: FabImage(
                  uri: "https://socialsonic.com/blog/wp-content/uploads/2024/11/15-Inspiring-LinkedIn-Post-Ideas-Examples-3-scaled.jpg",
                  width: double.infinity,
                  height: $.context.height * 0.33,
                  radius: 0, // No border radius
                )
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Like Button
          GestureDetector(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
                if (isLiked) {
                  likeCount++;
                } else {
                  likeCount--;
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Assets.images.icons.system.thumbUpLine.svg(
                    width: 23,
                    height: 23,
                    package: 'design',
                    colorFilter: ColorFilter.mode(
                      isLiked ? FabColors.primary : FabColors.greyscale300,
                      BlendMode.srcIn,
                    ),
                  ),
                   
                  PaddingGap.xs(),
                  
                  Text(
                    '$likeCount Like',
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: isLiked ? FabColors.primary : FabColors.greyscale300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          PaddingGap.md(),
          
          // Comment Button
          GestureDetector(
            onTap: () {
              // Handle comment action
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   UIcons.regularRounded.comment,
                  //   color: FabColors.greyscale300,
                  //   size: 23,
                  // ),

                  Assets.images.icons.communication.chat1Line.svg(
                    width: 23,
                    height: 23,
                    package: 'design',
                    colorFilter: ColorFilter.mode(
                      FabColors.greyscale300,
                      BlendMode.srcIn,
                    ),
                  ),
                  
                  PaddingGap.xs(),
                  
                  Text(
                    '$commentCount Comment',
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: FabColors.greyscale300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          PaddingGap.md(),
          
          // Share Button
          GestureDetector(
            onTap: () {
              // Handle share action
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Assets.images.icons.system.shareForwardLine.svg(
                    width: 23,
                    height: 23,
                    package: 'design',
                    colorFilter: ColorFilter.mode(
                      FabColors.greyscale300,
                      BlendMode.srcIn,
                    ),
                  ),
                  
                  PaddingGap.xs(),
                  
                  Text(
                    '$shareCount Share',
                    style: FabTypography.bodySmallMedium.copyWith(
                      color: FabColors.greyscale300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
