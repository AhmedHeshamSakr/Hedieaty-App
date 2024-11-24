import 'package:flutter/material.dart';
import '../../../domain/usecases/login_user_usecase.dart';
import '../../../domain/usecases/register_user_usecase.dart';

class AuthController extends ChangeNotifier {
  // Controllers and form keys
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;

  final LoginUserUseCase loginUserUseCase;
  final RegisterUserUseCase registerUserUseCase;

  AuthController({
    required this.loginUserUseCase,
    required this.registerUserUseCase,
  });

  Future<void> loginUser() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      await loginUserUseCase.execute(emailController.text, passwordController.text);
      // Navigate to home page
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerUser() async {
    if (!signUpFormKey.currentState!.validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      await registerUserUseCase.execute(nameController.text, emailController.text, passwordController.text);
      // Navigate to login page
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}