import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/core/theme/app_colors.dart';
import 'package:todo_app_flutter/core/widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> fetchWeather() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.open-meteo.com/v1/forecast?latitude=21.0245&longitude=105.8412&current_weather=true',
    );
    return response.data;
  }

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
                          'Weather in Hanoi',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Real-time updates',
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
                        Icons.location_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Weather Content
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: fetchWeather(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: isDark
                              ? AppColors.accentBlue
                              : AppColors.accentPurple,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: GlassCard(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppColors.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading weather',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${snapshot.error}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data!['current_weather'];
                      final temp = data['temperature'];
                      final windspeed = data['windspeed'];
                      final weatherCode = data['weathercode'] ?? 0;

                      return RefreshIndicator(
                        onRefresh: () async {
                          // Force rebuild to refresh data
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Main Weather Card
                              GlassCard(
                                width: double.infinity,
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    // Weather Icon
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: weatherCode == 0
                                              ? [
                                                  Colors.orange.shade400,
                                                  Colors.yellow.shade600
                                                ]
                                              : [
                                                  Colors.grey.shade400,
                                                  Colors.grey.shade600
                                                ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (weatherCode == 0
                                                    ? Colors.orange
                                                    : Colors.grey)
                                                .withOpacity(0.3),
                                            blurRadius: 30,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        weatherCode == 0
                                            ? Icons.wb_sunny
                                            : Icons.cloud,
                                        size: 64,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Temperature
                                    Text(
                                      '$temp°C',
                                      style: GoogleFonts.poppins(
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? AppColors.textPrimary
                                            : AppColors.textDark,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      weatherCode == 0
                                          ? 'Clear Sky'
                                          : 'Cloudy',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: isDark
                                            ? AppColors.textSecondary
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Weather Details Grid
                              Row(
                                children: [
                                  // Wind Speed Card
                                  Expanded(
                                    child: GlassCard(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: AppColors.primaryGradient,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.air,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            '$windspeed',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? AppColors.textPrimary
                                                  : AppColors.textDark,
                                            ),
                                          ),
                                          Text(
                                            'km/h',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: isDark
                                                  ? AppColors.textSecondary
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Wind Speed',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.textTertiary
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Humidity Card (Placeholder)
                                  Expanded(
                                    child: GlassCard(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: AppColors.accentGradient,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.water_drop,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            '65',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? AppColors.textPrimary
                                                  : AppColors.textDark,
                                            ),
                                          ),
                                          Text(
                                            '%',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: isDark
                                                  ? AppColors.textSecondary
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Humidity',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.textTertiary
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}