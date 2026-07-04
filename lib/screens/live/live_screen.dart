import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/live_match_list.dart';
import '../../providers/home_provider.dart';
import '../../widgets/hero_live_card.dart';
import '../match/match_details_screen.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        centerTitle: true,
        title: const Text(
          "🔴 Live Matches",
        ),
      ),

      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            if (provider.error.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  provider.error,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            Row(
              children: [

                const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 14,
                ),

                const SizedBox(width: 8),

                const Text(
                  "LIVE NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Chip(
                  backgroundColor: Colors.orange,
                  label: Text(
                    "${provider.liveMatches.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

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
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [

                    Icon(
                      Icons.sports_cricket,
                      color: Colors.orange,
                      size: 60,
                    ),

                    SizedBox(height: 15),

                    Text(
                      "No Live Matches",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Live matches will appear here automatically.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                  ],
                ),
              ),
            const SizedBox(height: 25),

            LiveMatchList(
              matches: provider.liveMatches,
            ),
            const SizedBox(height: 30),

            const Text(
              "Pull down to refresh live scores",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}