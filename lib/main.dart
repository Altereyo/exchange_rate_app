import 'package:exchange_rate_app/internal/di.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {
  await GetStorage.init();
  setupDI();
  runApp(const MyApp());
}