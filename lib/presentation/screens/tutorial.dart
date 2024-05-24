import 'dart:math';

import 'package:chips_choice/chips_choice.dart';
import 'package:exchange_rate_app/domain/entities/currency.dart';
import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/presentation/shared/app_effects.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:exchange_rate_app/presentation/stores/currency_store.dart';
import 'package:exchange_rate_app/presentation/stores/favorites_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key, required this.username});

  final String username;

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  bool animationCompleted = false;
  AnimationController? animation2Controller;
  List<CurrencyEntity> choices = [];
  final currencyStore = getIt.get<CurrencyStore>();
  final favoritesStore = getIt.get<FavoritesStore>();

  void onTapNext() {
    favoritesStore.addFavorites(choices);
    context.go('/home');
  }

  @override
  void initState() {
    animation2Controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              RotatedLogo(minified: animationCompleted),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Animate(
                    effects: AppEffects.showFirstGreet,
                    onComplete: (controller) {
                      animation2Controller?.forward();
                    },
                    child: Text(
                      'Здравствуйте, ${widget.username}!',
                      style: AppStyles.bigFatTitle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Animate(
                      autoPlay: false,
                      controller: animation2Controller,
                      effects: AppEffects.showSecondGreet((v) {
                        animationCompleted = true;
                        setState(() {});
                      }),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Выберите любимые валюты (по желанию):',
                          style: AppStyles.bigFatTitle.copyWith(fontSize: 26),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: animationCompleted ? null : 0,
                        child: !animationCompleted
                            ? Container()
                            : Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child:
                                          ChipsChoice<CurrencyEntity>.multiple(
                                        key: UniqueKey(),
                                        wrapped: true,
                                        value: choices,
                                        onChanged: (val) =>
                                            setState(() => choices = val),
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        padding: EdgeInsets.zero,
                                        choiceItems: C2Choice.listFrom<
                                            CurrencyEntity, CurrencyEntity>(
                                          source: currencyStore.rates,
                                          value: (i, v) => v,
                                          label: (i, v) => v.symbol,
                                        ),
                                        choiceBuilder: (item, i) {
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            onTap: () {
                                              item.select!(!item.selected);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: item.selected
                                                    ? Colors.black12
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                item.value.symbol,
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ).animate().shimmer(
                                          duration: const Duration(seconds: 1),
                                        ),
                                  ),
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: onTapNext,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              choices.isEmpty
                                                  ? 'Пропустить'
                                                  : 'Далее',
                                              style: AppStyles.bigFatTitle
                                                  .copyWith(
                                                      fontSize: 18, height: 1),
                                            ),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.chevron_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RotatedLogo extends StatelessWidget {
  const RotatedLogo({super.key, required this.minified});

  final bool minified;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Text(
              'PERFECTPANEL ',
              style: GoogleFonts.majorMonoDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                backgroundColor: Colors.white,
                height: 0.9,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                  delay: const Duration(milliseconds: 500),
                )
                .rotate(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 3000),
                ),
            Transform.rotate(
              angle: pi * 0.5,
              child: Text(
                'PERFECTPANEL ',
                style: GoogleFonts.majorMonoDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  backgroundColor: Colors.white,
                  height: 1,
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                    delay: const Duration(milliseconds: 500),
                  )
                  .rotate(
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 3000),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
