import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'auth_notifier.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    final email = user?.email ?? '';
    final username = user?.username ?? '';

    form = FormGroup(
      {
        'username': FormControl<String>(
          value: username,
          validators: [Validators.required],
        ),
        'email': FormControl<String>(
          value: email,
          validators: [Validators.required, Validators.email],
        ),
        'confirmEmail': FormControl<String>(
          value: email,
          validators: [Validators.required, Validators.email],
        ),
      },
      validators: [
        Validators.mustMatch('email', 'confirmEmail'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Nessun utente loggato')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'username',
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(labelText: 'Nuova email'),
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'confirmEmail',
                decoration: const InputDecoration(labelText: 'Conferma email'),
                validationMessages: {
                  ValidationMessage.mustMatch: (_) =>
                      'Le due email devono coincidere',
                },
              ),
              const SizedBox(height: 24),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  final isValid = formGroup.valid; // bonus: disabilita Save
                  return ElevatedButton(
                    onPressed: isValid
                        ? () {
                            final newUsername =
                                formGroup.control('username').value as String;
                            final newEmail =
                                formGroup.control('email').value as String;

                            ref
                                .read(authProvider.notifier)
                                .updateUsername(newUsername);
                            ref
                                .read(authProvider.notifier)
                                .updateEmail(newEmail);

                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text('Save'),
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
