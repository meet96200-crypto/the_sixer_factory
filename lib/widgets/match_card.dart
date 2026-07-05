import 'package:flutter/material.dart';

import '../models/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onTap;

  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1E293B),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Series
              Text(
                match.series,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 18),

              /// Teams
              Row(
                children: [

                  Expanded(
                    child: _team(
                      match.team1,
                      match.team1Logo,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  Expanded(
                    child: _team(
                      match.team2,
                      match.team2Logo,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [

                  const Icon(
                    Icons.scoreboard,
                    color: Colors.greenAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      match.liveScore.isEmpty
                          ? "Score Unavailable"
                          : match.liveScore,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

                  const SizedBox(width: 8),

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
                    color: Colors.redAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

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

              const SizedBox(height: 18),

              Row(
                children: [

                  Chip(
                    backgroundColor: Colors.orange,
                    label: Text(
                      match.matchType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    match.status,
                    style: TextStyle(
                      color: match.matchStarted
                          ? Colors.greenAccent
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _team(String name, String logo) {
    return Column(
      children: [

        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          backgroundImage:
          logo.isNotEmpty ? NetworkImage(logo) : null,
          child: logo.isEmpty
              ? const Icon(Icons.sports_cricket)
              : null,
        ),

        const SizedBox(height: 8),

        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}