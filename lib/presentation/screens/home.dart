import 'dart:async';

import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:exchange_rate_app/presentation/stores/favorites_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final currencyStore = getIt.get<CurrencyStore>();
  final favoritesStore = getIt.get<FavoritesStore>();

  Timer? pollTimer;

  var favorites = <CurrencyEntity>[];
  @override
  void initState() {
    super.initState();
    currencyStore.getRates();
    pollTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      currencyStore.getRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Курс валют', style: AppStyles.appBarText,)),
      body: Observer(
        builder: (_) {
          if (currencyStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder(
            future: favoritesStore.getFavorites(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return RefreshIndicator(
                  onRefresh: currencyStore.getRates,
                  child: ListView.builder(
                    itemCount: currencyStore.rates.length,
                    itemBuilder: (context, index) {
                      final rate = currencyStore.rates[index];
                      final favorited = snapshot.data!.any((element) => element.id == rate.id);
                      return ListTile(
                        title: Text(rate.symbol, style: AppStyles.currencyMainText,),
                        subtitle: Text(rate.rateUsd.toStringAsFixed(18), style: AppStyles.currencySubText,),
                        trailing: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            favorited
                              ? await favoritesStore.deleteFavorites(rate.id)
                              : await favoritesStore.addFavorites([rate]);
                            await favoritesStore.getFavorites();
                            setState(() {});
                          },
                          child: Icon(favorited ? Icons.favorite : Icons.favorite_outline),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
