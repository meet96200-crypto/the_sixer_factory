import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/home_provider.dart';
import '../match/match_details_screen.dart';

import '../../widgets/banner_slider.dart';
import '../../widgets/breaking_news_slider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/hero_live_card.dart';
import '../../widgets/news_card.dart';
import '../../widgets/points_table_card.dart';
import '../../widgets/ranking_card.dart';
import '../../widgets/upcoming_match_card.dart';
import '../../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
        body: provider.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: provider.refresh,
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.error.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.error,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            const BannerSlider(),

            const SizedBox(height: 20),

            if (provider.liveMatches.isNotEmpty)
              HeroLiveCard(
                match: provider.liveMatches.first,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchDetailsScreen(
                        match: provider.liveMatches.first,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "No Live Match Available",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            const BreakingNewsSlider(),

            const SizedBox(height: 20),

            const NewsCard(),

            const SizedBox(height: 20),

            const UpcomingMatchCard(),

            const SizedBox(height: 20),

            const RankingCard(),

            const SizedBox(height: 20),

            const PointsTableCard(),

            const SizedBox(height: 20),

            const VideoCard(),

            const SizedBox(height: 30),
          ],
        ),
      ),
        ),
    );
  }
}