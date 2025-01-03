import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../routes/route_names.dart';
import '../auth/auth_controller.dart';
import '../addFrinds/add_frinds_controller.dart'; // Import FriendsController
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final friendsController = Provider.of<FriendsController>(context); // Access FriendsController

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'lib/assets/sign_log.png',
                  width: 300,
                  height: 300,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 20),
                if (authController.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await authController.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (mounted && success) {
                          // Load friends after successful login
                          await friendsController.loadFriends();
                          // Show success message and navigate to home page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Successful!')),
                          );
                          Navigator.pushNamed(context, RouteNames.home);
                        } else if (mounted) {
                          // Show error message if login failed
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                authController.errorMessage ?? 'Login failed!',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.signup);
                  },
                  child: const Text("Don’t have an account? Sign Up"),
                ),
                if (authController.errorMessage != null)
                  Text(
                    authController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}