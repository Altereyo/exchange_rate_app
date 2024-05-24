import 'dart:async';

import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/internal/enum/sort_by.dart';
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
  ScrollController scrollController = ScrollController();

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
      appBar: AppBar(
        title: Text('Курс валют', style: AppStyles.appBarText),
        actions: [
          IconButton(
            onPressed: () {
              currencyStore.getRates();
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.filter_list),
            initialValue: currencyStore.sortBy,
            onSelected: (SortBy item) async {
              if (item != currencyStore.sortBy && !currencyStore.isLoading) {
                scrollController.jumpTo(0);
              }
              currencyStore.sortBy = item;
              await currencyStore.sortRates();
              setState(() {});
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: null,
                enabled: false,
                child: Text('Сортировать по:'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.alphabetAsc,
                child: Text('Алфавиту (с начала)'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.alphabetDesc,
                child: Text('Алфавиту (с конца)'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.valueDesc,
                child: Text('Значению (от большего)'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.valueAsc,
                child: Text('Значению (от меньшего)'),
              ),
            ],
          ),
        ],
      ),
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
                  child: CurrencyList(favoritesList: snapshot.data!, scrollController: scrollController,),
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

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key, required this.favoritesList, required this.scrollController});

  final List<CurrencyEntity> favoritesList;
  final ScrollController scrollController;

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  final currencyStore = getIt.get<CurrencyStore>();
  final favoritesStore = getIt.get<FavoritesStore>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      key: const PageStorageKey<String>('scroll_save'),
      itemCount: currencyStore.rates.length,
      itemBuilder: (context, index) {
        final rate = currencyStore.rates[index];
        final favorited = widget.favoritesList.any((element) => element.id == rate.id);
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
    );
  }
}
