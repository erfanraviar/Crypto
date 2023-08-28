import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raviar_crypto/Presentation/ui/ui_helper/BottomNav.dart';
import 'package:raviar_crypto/logic/providers/CryptoDataProvider.dart';


import 'HomePage.dart';
import 'MarketViewPage.dart';
import 'Profile.dart';
import 'WatchListPage.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.compare_arrows_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(
        controller: _myPage,
      ),
      body: PageView(
        controller: _myPage,
        children: [
          ChangeNotifierProvider<CryptoDataProvider>(
        create: (context) => CryptoDataProvider(),
              child: HomePage()),
          const MarketViewPage(),
          const ProfilePage(),
          const WatchListPage()
        ],
      ),
    );
  }
}
