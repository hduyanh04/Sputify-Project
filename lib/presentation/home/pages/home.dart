import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sputify/common/helpers/is_dark_mode.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';
import 'package:sputify/core/config/assets/app_images.dart';
import 'package:sputify/core/config/assets/app_vectors.dart';
import 'package:sputify/core/config/theme/app_colors.dart';
import 'package:sputify/presentation/home/widgets/artists.dart';
import 'package:sputify/presentation/home/widgets/news_songs.dart';
import 'package:sputify/presentation/home/widgets/play_list.dart';
import 'package:sputify/presentation/home/widgets/search_songs.dart';
import 'package:sputify/presentation/profile/pages/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputify/presentation/home/bloc/search_songs_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Pages list
    final pages = [
      _homeContent(),
      BlocProvider(
        create: (_) => SearchSongsCubit(),
        child: const SearchSongs(),
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? BasicAppBar(
        hideBack: true,
        title: SvgPicture.asset(AppVectors.logo, height: 30, width: 30),
      )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: context.isDarkMode ? Colors.white70 : Colors.black54,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _homeTopCard(),
          _tabs(),
          SizedBox(
            height: 250,
            child: TabBarView(
              controller: _tabController,
              children: const [
                NewsSongs(),
                Artists(),
              ],
            ),
          ),
          const Playlist(),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(AppImages.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: AppColors.primary,
          labelColor: context.isDarkMode ? Colors.white : Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(child: Text('New Songs')),
            Tab(child: Text('Artists')),
          ],
        ),
      ),
    );
  }
}