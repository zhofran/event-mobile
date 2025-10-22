import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class JobListingRouter extends StatelessWidget {
  const JobListingRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}