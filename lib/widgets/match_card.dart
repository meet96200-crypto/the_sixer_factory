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
              /// Match Title
              Text(
                match.shortTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                match.series,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),
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
              if (match.isLive || match.isFinished)
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
              if (match.isLive)
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
                      match.displayVenue,
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
                    Icons.calendar_month,
                    color: Colors.white70,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    match.formattedDate,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  const SizedBox(height: 10),

                  Text(
                    match.displayStatus,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: match.isFinished
                          ? Colors.greenAccent
                          : match.isLive
                          ? Colors.redAccent
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}