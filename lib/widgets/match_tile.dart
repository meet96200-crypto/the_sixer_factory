import 'package:flutter/material.dart';

import '../models/match_model.dart';

class MatchTile extends StatelessWidget {
  final MatchModel match;
  final VoidCallback? onTap;

  const MatchTile({
    super.key,
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xff1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                match.series,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [

                  Expanded(
                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                          Colors.white,
                          backgroundImage:
                          match.team1Logo.isNotEmpty
                              ? NetworkImage(
                            match.team1Logo,
                          )
                              : null,
                          child:
                          match.team1Logo.isEmpty
                              ? const Icon(
                            Icons
                                .sports_cricket,
                            size: 18,
                          )
                              : null,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            match.team1,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [

                        Expanded(
                          child: Text(
                            match.team2,
                            textAlign:
                            TextAlign.end,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                          Colors.white,
                          backgroundImage:
                          match.team2Logo.isNotEmpty
                              ? NetworkImage(
                            match.team2Logo,
                          )
                              : null,
                          child:
                          match.team2Logo.isEmpty
                              ? const Icon(
                            Icons
                                .sports_cricket,
                            size: 18,
                          )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                children: [

                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white54,
                    size: 16,
                  ),

                  const SizedBox(width: 6),

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

              const SizedBox(height: 8),

              Row(
                children: [

                  const Icon(
                    Icons.location_on,
                    color: Colors.white54,
                    size: 16,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      match.venue,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Align(
                alignment:
                Alignment.centerRight,
                child: Chip(
                  backgroundColor:
                  Colors.orange,
                  label: Text(
                    match.matchType
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}