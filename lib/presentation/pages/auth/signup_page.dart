import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../pages/auth/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: authController.signUpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: authController.nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: Validators.nonEmptyValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.emailValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authController.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.passwordValidator,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authController.registerUser,
                child: authController.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}