import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/core/widgets/glass_card.dart';
import 'package:todo_app_flutter/core/widgets/gradient_button.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.backgroundGradient,
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentBlue.withOpacity(0.1),
                    AppColors.accentPurple.withOpacity(0.1),
                  ],
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Header
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: AppColors.primaryGradient,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.accentBlue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Doe',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'john.doe@example.com',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Edit Button
                        IconButton(
                          onPressed: () {
                            // TODO: Edit profile
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: isDark
                                ? AppColors.accentBlue
                                : AppColors.accentPurple,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Account Settings',
                    subtitle: 'Manage your account',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Configure alerts',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.lock_outlined,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    subtitle: 'Theme settings',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get assistance',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version 1.0.0',
                    isDark: isDark,
                    onTap: () {},
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  GradientButton(
                    text: 'Logout',
                    width: double.infinity,
                    icon: Icons.logout,
                    gradientColors: const [
                      AppColors.error,
                      Color(0xFFDC2626),
                    ],
                    onPressed: () {
                      // TODO: Implement logout
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to logout?',
                            style: GoogleFonts.inter(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Perform logout
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Container(
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
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark
              ? AppColors.textSecondary
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}