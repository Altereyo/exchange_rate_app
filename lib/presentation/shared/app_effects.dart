import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppEffects {
  static const double _greetsYOffset = -30;
  static const Duration _greetsDuration = Duration(milliseconds: 500);

  static List<Effect> showFirstGreet = <Effect>[
    const MoveEffect(
      begin: Offset(0, _greetsYOffset),
      end: Offset(0, 0),
      duration: _greetsDuration,
    ),
    const FadeEffect(
      begin: 0,
      end: 1,
      duration: _greetsDuration,
    ),
    const ThenEffect(delay: Duration(seconds: 2)),
    const MoveEffect(
      begin: Offset(0, 0),
      end: Offset(0, _greetsYOffset),
      duration: _greetsDuration,
    ),
    const FadeEffect(
      begin: 1,
      end: 0,
      duration: _greetsDuration,
    ),
  ];

  static List<Effect> showSecondGreet (Function(bool) callback) => <Effect>[
    const MoveEffect(
      begin: Offset(0, _greetsYOffset),
      end: Offset(0, 0),
      duration: _greetsDuration,
    ),
    const FadeEffect(
      begin: 0,
      end: 1,
      duration: _greetsDuration,
    ),
    const ThenEffect(delay: Duration(seconds: 2)),
    CallbackEffect(callback: callback),
    const ScaleEffect(
      alignment: Alignment.topLeft,
      duration: Duration(milliseconds: 500),
      begin: Offset(1, 1),
      end: Offset(0.8, 0.8),
      curve: Curves.easeOut,
    ),
  ];
}