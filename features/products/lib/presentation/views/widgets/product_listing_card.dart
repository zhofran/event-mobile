// ignore_for_file: max_lines_for_file, max_lines_for_function
import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/flutter_bloc.dart';
import 'package:deps/packages/skeletonizer.dart';
import 'package:deps/packages/styled_text.dart';
import 'package:deps/packages/talker_flutter.dart';
import 'package:deps/packages/uicons.dart';
import 'package:flutter/material.dart';

class ProductListingCard extends StatelessWidget {
  const ProductListingCard({
    required this.product,
    super.key,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartItem = state.cartItems.where((element) => element.id == product.id).firstOrNull;
        final isAddedToCart = cartItem != null;

        return Skeletonizer(
          enabled: product.isEmpty,
          child: FabCard(
            height: 265,
            pressedOpacity: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlider(
                    productId: product.id,
                    height: 180,
                    images: product.images,
                    onPressed: (pageController) => $.navigator.push(
                      ProductDetailsRoute(
                        product: product,
                        selectedItemIndex: pageController.page!.round(),
                        onSelectedItemChanged: (index) {
                          pageController.jumpToPage(index);
                        },
                      ),
                    ),
                    topLeftChild: FabCard(
                      color: context.fabTheme.onBackgroundColor.withOpacity(0.5),
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          Icon(
                            UIcons.boldRounded.percentage,
                            size: 9,
                            color: context.fabTheme.onPrimaryColor.withOpacity(0.8),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2, top: 1.2),
                            child: Text(
                              '${product.discountRate} off',
                              style: context.fabTheme.caption1Style.copyWith(
                                color: context.fabTheme.surfaceColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    topRightChild: FabCard(
                      height: 20,
                      width: 20,
                      radius: 10,
                      color: context.fabTheme.onBackgroundColor.withOpacity(0.5),
                      onPressed: () => print('amk'),
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(
                        UIcons.boldRounded.heart,
                        size: 12,
                        color: context.fabTheme.onPrimaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  PaddingAll.xs(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: context.fabTheme.footnoteStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        FabTextStyled(
                          '\$${product.discountPrice.toStringAsFixed(2)} <lt>${product.price.toStringAsFixed(2)}</lt>',
                          style: context.fabTheme.subheadStyle.bold,
                          tags: {
                            'lt': StyledTextTag(
                              style: context.fabTheme.footnoteStyle.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: context.fabTheme.inactiveColor,
                              ),
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                    width: double.infinity,
                    padding: $.paddings.xs.horizontal,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: AnimatedOpacity(
                            opacity: isAddedToCart ? 1 : 0,
                            duration: $.timings.mil200,
                            child: FabButton.primary(
                              width: 25,
                              size: FabButtonSize.small,
                              isIconOnly: true,
                              icon: UIcons.boldRounded.minus_small,
                              child: const SizedBox.shrink(),
                              onPressed: () => $.get<CartCubit>().decreaseQuantity(product.id),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: AnimatedOpacity(
                            opacity: isAddedToCart ? 1 : 0,
                            duration: $.timings.mil200,
                            child: FabButton.primary(
                              width: 25,
                              size: FabButtonSize.small,
                              isIconOnly: true,
                              icon: UIcons.boldRounded.plus_small,
                              child: const SizedBox.shrink(),
                              onPressed: () => $.get<CartCubit>().increaseQuantity(product.id),
                            ),
                          ),
                        ),
                        FabButton.primary(
                          width: isAddedToCart ? 70 : 200,
                          size: FabButtonSize.medium,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: AnimatedCrossFade(
                                    crossFadeState:
                                        isAddedToCart ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                    duration: $.timings.mil200,
                                    firstCurve: Curves.easeInOut,
                                    secondCurve: Curves.easeInOut,
                                    firstChild: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'add to cart',
                                        key: const Key('add_to_cart'),
                                        textAlign: TextAlign.center,
                                        style: context.fabTheme.footnoteStyle
                                            .apply(color: context.fabTheme.onPrimaryColor)
                                            .bold,
                                      ),
                                    ),
                                    secondChild: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        '${cartItem?.quantity ?? 1} piece',
                                        key: const Key('quantity'),
                                        textAlign: TextAlign.center,
                                        style: context.fabTheme.footnoteStyle
                                            .apply(color: context.fabTheme.onPrimaryColor)
                                            .bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => $.get<CartCubit>().addToCart(product),
                        ),
                      ],
                    ),
                  ),
                  PaddingGap.xs(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
