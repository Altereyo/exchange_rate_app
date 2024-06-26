import 'package:exchange_rate_app/presentation/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final currentPage = GoRouter.of(context).location;

    return BottomNavigationBar(
      selectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: Colors.black),
      unselectedLabelStyle: GoogleFonts.manrope(),
      fixedColor: Colors.black,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: currentPage == '/home' ? Colors.black : AppColors.grey,),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, color: currentPage == '/exchange' ? Colors.black : AppColors.grey,),
          label: 'Конвертер',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle, color: currentPage == '/user' ? Colors.black : AppColors.grey,),
          label: 'Профиль',
        ),
      ],
      onTap: (index) {
        currentIndex = index;
        setState(() {});
        context.go(switch(index) {
          0 => '/home',
          1 => '/exchange',
          2 => '/user',
          _ => '/home',
        });
      },
    );
  }
}
