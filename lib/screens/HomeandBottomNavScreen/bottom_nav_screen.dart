import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../ProfileScreens/Profile.dart';
import '../SettingsScreens/SettingsScreen.dart';
import 'home.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1578ff),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xff1578ff),
          animationDuration: const Duration(milliseconds: 600),
          index: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items:const [
             Icon(Icons.settings_suggest_outlined,color:  Color(0xff1578ff),),
             Icon(Icons.home,color:  Color(0xff1578ff),),
             Icon(Icons.person,color:  Color(0xff1578ff),),
          ],
      ),
      body: _buildScreen(_currentIndex),
    );
  }
  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const SettingsScreen(); // Create FavoriteScreen widget
      case 1:
        return const HomeScreen(); // Create HomeScreen widget
      case 2:
        return const ProfileScreen(); // Create SettingsScreen widget
      default:
        return const HomeScreen(); // Default to HomeScreen
    }
  }
}
