import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ctrl = GetIt.I.get<AuthController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Insira o seu e-mail de cadastro para receber o link de recuperação.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              controller: ctrl.txtEmailForgotPassword,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ctrl.forgotPassword(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('RECUPERAR SENHA'),
            ),
          ],
        ),
      ),
    );
  }
}
