import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office_plugin_ui/core/services/storage_service.dart';
import 'package:office_plugin_ui/features/dashboard/main_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final dio = Dio();
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': _emailController.text,
            'password': _passwordController.text,
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final token = response.data['accessToken'];

          await StorageService().saveToken(token);

          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboard()));
          }
        } else {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboard()));
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: $e'))
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter email';
                // if (!value.contains('@')) return 'Email not valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be have least 6 character';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _handleLogin();
                }
              },
              child: const Text('Login')),
          ],
        ),
      ),
      ),
    );
  }
}