import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/providers/navigation_provider.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/features/data_bank/data_bank_screen.dart';
import 'package:todo_app_flutter/features/home/home_screen.dart';
import 'package:todo_app_flutter/features/more/more_screen.dart';
import 'package:provider/provider.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    DataBankScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: _screens[navProvider.currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primaryMedium,
                  ],
                )
              : null,
          color: isDark ? null : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                  isSelected: navProvider.currentIndex == 0,
                  isDark: isDark,
                  onTap: () => navProvider.changeIndex(0),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.storage_outlined,
                  selectedIcon: Icons.storage,
                  label: 'Data Bank',
                  index: 1,
                  isSelected: navProvider.currentIndex == 1,
                  isDark: isDark,
                  onTap: () => navProvider.changeIndex(1),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.more_horiz_outlined,
                  selectedIcon: Icons.more_horiz,
                  label: 'More',
                  index: 2,
                  isSelected: navProvider.currentIndex == 2,
                  isDark: isDark,
                  onTap: () => navProvider.changeIndex(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? const LinearGradient(
                    colors: AppColors.primaryGradient,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? AppColors.textSecondary
                        : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? AppColors.textSecondary
                          : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}