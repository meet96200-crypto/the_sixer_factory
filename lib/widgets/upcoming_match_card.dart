import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import '../screens/match/match_details_screen.dart';

class UpcomingMatchCard extends StatelessWidget {
  const UpcomingMatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    if (provider.upcomingMatches.isEmpty) {
      return const Center(
        child: Text(
          "No Upcoming Matches",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.upcomingMatches.length > 5
          ? 5
          : provider.upcomingMatches.length,
      itemBuilder: (context, index) {
        final match = provider.upcomingMatches[index];

        return Card(
          elevation: 6,
          color: const Color(0xff1E293B),
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
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
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    match.series,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 26,
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
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                              radius: 26,
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

                  Row(
                    children: [

                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          match.date,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          match.venue,
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Chip(
                      label: Text(match.matchType.toUpperCase()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}