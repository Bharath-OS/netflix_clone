import 'package:flutter/material.dart';
import 'package:movflix/core/app_style.dart';
import 'package:movflix/presentation/home/home.dart';
import 'package:movflix/presentation/search/search.dart';

import 'hot_news/hot_news.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = AppColors.white;
    const Color unselectedColor = AppColors.grey;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          labelColor: selectedColor,
          indicatorColor: selectedColor,
          unselectedLabelColor: unselectedColor,
          tabs: [
            Tab(icon: Icon(Icons.home_outlined), text: "Home"),
            Tab(icon: Icon(Icons.search_rounded), text: "Search"),
            Tab(icon: Icon(Icons.photo_library_outlined), text: "Hot News"),
          ],
        ),
        body: TabBarView(
          children: [
            Center(child: NetflixHomeScreen()),
            Center(child: NetflixSearchScreen()),
            Center(child: NetflixHotNewsScreen()),
          ],
        ),
      ),
    );
  }
}
