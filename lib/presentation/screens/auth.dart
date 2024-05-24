import 'package:exchange_rate_app/internal/di.dart';
import 'package:exchange_rate_app/presentation/shared/app_styles.dart';
import 'package:exchange_rate_app/presentation/stores/auth_store.dart';
import 'package:exchange_rate_app/presentation/widgets/input.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final authStore = getIt.get<AuthStore>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вход',
              style: AppStyles.bigFatTitle,
            ),
            const SizedBox(height: 50),
            AppInput(
              controller: _usernameController,
              focusNode: usernameFocus,
              label: 'Имя пользователя',
              onSubmitted: (v) {
                usernameFocus.unfocus();
                passwordFocus.requestFocus();
              },
            ),
            const SizedBox(height: 10),
            AppInput(
              controller: _passwordController,
              focusNode: passwordFocus,
              label: 'Пароль',
              obscureText: true,
              onSubmitted: (v) => passwordFocus.unfocus(),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  authStore.login(context, _usernameController.text, _passwordController.text);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Войти',
                        style: AppStyles.bigFatTitle
                            .copyWith(fontSize: 18, height: 1),
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
    );
  }
}
