import 'package:exchange_rate_app/presentation/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  const ScreenLayout({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: const AppBottomBar(),
    );
  }
}
