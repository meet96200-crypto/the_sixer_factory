import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../../widgets/match_card.dart';
import '../match/match_details_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        centerTitle: true,
        title: const Text("🏏 Matches"),
      ),

      body: provider.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: provider.refresh,
        child: provider.upcomingMatches.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 180),

            Icon(
              Icons.sports_cricket,
              size: 70,
              color: Colors.orange,
            ),

            SizedBox(height: 20),

            Center(
              child: Text(
                "No Upcoming Matches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            Center(
              child: Text(
                "Pull down to refresh",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.upcomingMatches.length,
          itemBuilder: (context, index) {
            final match = provider.upcomingMatches[index];

            return MatchCard(
              match: match,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchDetailsScreen(
                      match: match,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}