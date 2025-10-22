import 'package:deps/design/design.dart';
import 'package:deps/features/features.dart';
import 'package:deps/packages/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:feature_auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSeen();
  }
  
  Future<void> _checkSeen() async { // { changed code }
    print('SplashPage: Checking seen status');
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenOnboarding') ?? false;
    print('SplashPage: seenOnboarding = $seen');
    if (seen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          print('SplashPage: Widget not mounted, skipping navigation');
          return;
        }
        print('SplashPage: Navigating to LoginRoute');
        $.navigator.replace(LoginRoute(onResult: (bool _) {}));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          print('SplashPage: Widget not mounted, skipping navigation');
          return;
        }
        print('SplashPage: Navigating to OnBoarding1Route');
        $.navigator.replace(OnBoarding1Route());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FabColors.background,
      body: Center(
        child: Assets.images.logos.mining.image(
          width: 150,
          height: 150,
          package: 'design',
        ),
      ),
    );
  }
}