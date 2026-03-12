import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/core/widgets/gradient_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentBlue.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(delay: 200.ms, duration: 400.ms),
                
                const SizedBox(height: 48),

                // Title
                Text(
                  'Todo App',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Your professional office companion',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 60),

                // Feature Cards
                _buildFeatureCard(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Easy Upload',
                  description: 'Upload and manage your files',
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 16),

                _buildFeatureCard(
                  icon: Icons.storage_outlined,
                  title: 'Data Bank',
                  description: 'Secure storage for all your documents',
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 500.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 16),

                _buildFeatureCard(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  description: 'Track and analyze your data',
                )
                    .animate()
                    .fadeIn(delay: 1100.ms, duration: 500.ms)
                    .slideX(begin: -0.2, end: 0),

                const Spacer(),

                // Get Started Button
                GradientButton(
                  text: 'Get Started',
                  width: double.infinity,
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(delay: 1300.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}