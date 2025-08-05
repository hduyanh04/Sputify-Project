import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sputify/common/helpers/is_dark_mode.dart';
import 'package:sputify/common/widgets/appbar/app_bar.dart';
import 'package:sputify/core/config/assets/app_images.dart';
import 'package:sputify/core/config/assets/app_vectors.dart';
import 'package:sputify/core/config/theme/app_colors.dart';
import 'package:sputify/presentation/home/widgets/news_songs.dart';
import 'package:sputify/presentation/home/widgets/play_list.dart';
import 'package:sputify/presentation/profile/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        action: IconButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => const ProfilePage())
              );
            },
            icon: const Icon(
              Icons.person
            )
        ),
        title: SvgPicture.asset(
            AppVectors.logo,
            height: 30,
            width: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _tabController,
                  children: [
                    const NewsSongs(),
                    Container(),
                    Container(),
                    Container()
                  ],
              ),
            ),
            const Playlist()
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard(){
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                  AppImages.homeTopCard
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 50
                ),
                child: Image.asset(
                    AppImages.homeArtist
                ),
              ),
            )
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
          isScrollable: false, // <-- This centers tabs
          indicatorColor: AppColors.primary,
          labelColor: context.isDarkMode ? Colors.white : Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(child: Text('News')),
            Tab(child: Text('Videos')),
            Tab(child: Text('Artists')),
            Tab(child: Text('Podcasts', softWrap: false,
              overflow: TextOverflow.ellipsis,)),
          ],
        ),
      ),
    );
  }
}