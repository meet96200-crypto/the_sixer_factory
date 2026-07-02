import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/match_tile.dart';
import '../match/match_details_screen.dart';

class FixturesTabs extends StatelessWidget {
  const FixturesTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return TabBarView(
      children: [

        // LIVE MATCHES
        RefreshIndicator(
          onRefresh: provider.refresh,
          child: provider.liveMatches.isEmpty
              ? const Center(
            child: Text(
              "No Live Matches",
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.liveMatches.length,
            itemBuilder: (context, index) {
              final match = provider.liveMatches[index];

              return MatchTile(
                match: match,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MatchDetailsScreen(match: match),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // UPCOMING MATCHES
        RefreshIndicator(
          onRefresh: provider.refresh,
          child: provider.upcomingMatches.isEmpty
              ? const Center(
            child: Text(
              "No Upcoming Matches",
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.upcomingMatches.length,
            itemBuilder: (context, index) {
              final match = provider.upcomingMatches[index];

              return MatchTile(
                match: match,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MatchDetailsScreen(match: match),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // RESULTS
        const Center(
          child: Text(
            "Results Coming Soon",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}