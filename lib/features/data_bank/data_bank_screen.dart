import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/core/widgets/glass_card.dart';

class DataBankScreen extends StatelessWidget {
  const DataBankScreen({super.key});

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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data Bank',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Manage your files',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textSecondary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: AppColors.primaryGradient,
                        ),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildCategoryCard(
                        icon: Icons.description_outlined,
                        title: 'Documents',
                        count: '24 files',
                        gradient: AppColors.primaryGradient,
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        icon: Icons.image_outlined,
                        title: 'Images',
                        count: '156 files',
                        gradient: AppColors.accentGradient,
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        icon: Icons.videocam_outlined,
                        title: 'Videos',
                        count: '8 files',
                        gradient: const [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ],
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        icon: Icons.link_outlined,
                        title: 'Links',
                        count: '32 items',
                        gradient: const [
                          Color(0xFFF59E0B),
                          Color(0xFFD97706),
                        ],
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        icon: Icons.folder_outlined,
                        title: 'Folders',
                        count: '12 folders',
                        gradient: const [
                          Color(0xFF3B82F6),
                          Color(0xFF2563EB),
                        ],
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        icon: Icons.star_outline,
                        title: 'Favorites',
                        count: '18 items',
                        gradient: const [
                          Color(0xFFEC4899),
                          Color(0xFFDB2777),
                        ],
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String count,
    required List<Color> gradient,
    required bool isDark,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: gradient),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  isDark ? AppColors.textPrimary : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}