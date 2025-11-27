import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'username': FormControl<String>(
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'username',
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'Lo username non può essere vuoto',
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'L\'email non può essere vuota',
                  ValidationMessage.email: (_) => 'Email non valida',
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'password',
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validationMessages: {
                  ValidationMessage.required: (_) =>
                      'La password non può essere vuota',
                },
              ),
              const SizedBox(height: 24),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  final isValid = formGroup.valid;
                  return ElevatedButton(
                    onPressed: isValid
                        ? () {
                            final username =
                                formGroup.control('username').value as String;
                            final email =
                                formGroup.control('email').value as String;

                            ref
                                .read(authProvider.notifier)
                                .login(email: email, username: username);

                            context.go('/home');
                          }
                        : null,
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
