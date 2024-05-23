import 'package:exchange_rate_app/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {

  final UserRepository _userRepository;
  String username = '';

  _AuthStore(this._userRepository);

  Future<void> login(BuildContext context, String userName, String secret) async {
    final result = await _userRepository.login(userName, secret);
    if (result && context.mounted) {
      print('GAVNO');
      print(userName);
      username = userName;
      print(username);
      context.go('/tutorial', extra: userName);
    }
  }

  void logout() {

  }
}