import 'package:flutter/material.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/features/seller/pengajuan/views/ajukan_mobil_page.dart';
import 'package:showroom_mobil/features/seller/pengajuan/views/riwayat_pengajuan_page.dart';
import 'package:showroom_mobil/features/seller/profil/views/seller_profile_page.dart';

class SellerMainPage extends StatefulWidget {
  const SellerMainPage({super.key});

  @override
  State<SellerMainPage> createState() => _SellerMainPageState();
}

class _SellerMainPageState extends State<SellerMainPage> {
  int _selectedIndex = 1; // default ke Riwayat

  late final List<Widget> _pages = const [
    AjukanMobilPage(),
    RiwayatPengajuanPage(),
    SellerProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primary.withOpacity(0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded),
            label: 'Ajukan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_toggle_off_rounded),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}