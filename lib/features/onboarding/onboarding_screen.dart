import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; 

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 100),
          const SizedBox(height: 40),

          const Text(
            'Hello world',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 16),

          const Text(
            'Test App',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())
            );
            }, 
            child: const Text('Get started')),
          )
        ],
      ),
        ),
    );
  }
}