import 'package:flutter/material.dart';

import '../../models/match_model.dart';
import 'widgets/commentary_tab.dart';
import 'widgets/info_tab.dart';
import 'widgets/playing_xi_tab.dart';
import 'widgets/scorecard_tab.dart';

class MatchDetailsScreen extends StatelessWidget {
  final MatchModel match;

  const MatchDetailsScreen({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),

        appBar: AppBar(
          backgroundColor: const Color(0xff111827),
          centerTitle: true,
          title: Text(match.name),

          bottom: const TabBar(
            isScrollable: true,
            tabs: [

              Tab(text: "Scorecard"),

              Tab(text: "Commentary"),

              Tab(text: "Info"),

              Tab(text: "Playing XI"),

            ],
          ),
        ),

        body: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xff1E293B),

              child: Column(
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              backgroundImage: match.team1Logo.isNotEmpty
                                  ? NetworkImage(match.team1Logo)
                                  : null,
                              child: match.team1Logo.isEmpty
                                  ? const Icon(Icons.sports_cricket)
                                  : null,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              match.team1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              backgroundImage: match.team2Logo.isNotEmpty
                                  ? NetworkImage(match.team2Logo)
                                  : null,
                              child: match.team2Logo.isEmpty
                                  ? const Icon(Icons.sports_cricket)
                                  : null,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              match.team2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    match.liveScore.isEmpty
                        ? "Score Unavailable"
                        : match.liveScore,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    match.series,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Overs : ${match.overs}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Text(
                      "🔴 LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Chip(
                    label: Text(match.matchType.toUpperCase()),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    match.status,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [

                  const ScorecardTab(),

                  const CommentaryTab(),

                  InfoTab(
                    match: match,
                  ),

                  const PlayingXITab(),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}