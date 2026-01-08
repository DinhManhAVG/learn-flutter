import 'package:flutter/material.dart';
import 'package:office_plugin_ui/core/providers/navigation_provider.dart';
import 'package:office_plugin_ui/features/data_bank/data_bank_screen.dart';
import 'package:office_plugin_ui/features/home/home_screen.dart';
import 'package:office_plugin_ui/features/more/more_screen.dart';
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

    return Scaffold(
      body: _screens[navProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          navProvider.changeIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Data bank'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ]
      ),
    );
  }
}