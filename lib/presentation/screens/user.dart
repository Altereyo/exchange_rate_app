import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/presentation/shared/app_colors.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:exchange_rate_app/presentation/stores/auth_store.dart';
import 'package:exchange_rate_app/presentation/stores/favorites_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final authStore = getIt.get<AuthStore>();

  final favoritesStore = getIt.get<FavoritesStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профиль', style: AppStyles.appBarText)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(authStore.username, style: AppStyles.inputText),
              titleAlignment: ListTileTitleAlignment.top,
              leading: const CircleAvatar(
                  backgroundColor: AppColors.main, radius: 30),
            ),
            const SizedBox(height: 40),
            Text(
              'Избранные',
              style: AppStyles.mediumTitle,
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: favoritesStore.getFavorites(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.map((rate) {
                          return ListTile(
                            title: Text(
                              rate.symbol,
                              style: AppStyles.currencyMainText,
                            ),
                            subtitle: Text(
                              rate.rateUsd.toStringAsFixed(18),
                              style: AppStyles.currencySubText,
                            ),
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(40),
                              onTap: () async {
                                await favoritesStore.deleteFavorites(rate.id);
                                setState(() {});
                              },
                              child: const Icon(Icons.favorite),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  authStore.logout();
                  context.go('/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                ),
                child: Text(
                  'Выйти из аккаунта',
                  style: GoogleFonts.manrope(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
