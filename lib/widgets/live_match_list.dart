import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../screens/match/match_details_screen.dart';

class LiveMatchList extends StatelessWidget {
  final List<MatchModel> matches;

  const LiveMatchList({
    super.key,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    if (matches.length <= 1) {
      return const SizedBox();
    }

    final remainingMatches = matches.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "More Live Matches",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: remainingMatches.length,
          itemBuilder: (context, index) {
            final match = remainingMatches[index];

            return Card(
              color: const Color(0xff1E293B),
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          Expanded(
                            child: Text(
                              match.team1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const Text(
                            "VS",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Expanded(
                            child: Text(
                              match.team2,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          const Icon(
                            Icons.scoreboard,
                            color: Colors.greenAccent,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              match.liveScore.isEmpty
                                  ? "Score Unavailable"
                                  : match.liveScore,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Chip(
                            backgroundColor: Colors.red,
                            label: Text(
                              match.matchType.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          const Icon(
                            Icons.timer,
                            color: Colors.orange,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            "Overs : ${match.overs}",
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              match.venue,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          match.status,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}