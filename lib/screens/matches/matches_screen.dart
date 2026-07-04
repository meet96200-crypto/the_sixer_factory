import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/home_provider.dart';
import '../match/match_details_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Matches"),
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
            SizedBox(height: 250),
            Center(
              child: Text(
                "No Upcoming Matches",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.upcomingMatches.length,
          itemBuilder: (context, index) {
            final match =
            provider.upcomingMatches[index];

            return Card(
              elevation: 5,
              margin:
              const EdgeInsets.only(bottom: 18),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(18),
              ),

              child: InkWell(
                borderRadius:
                BorderRadius.circular(18),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MatchDetailsScreen(
                            match: match,
                          ),
                    ),
                  );
                },

                child: Padding(
                  padding:
                  const EdgeInsets.all(18),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        match.series,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              children: [

                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                  Colors.white,
                                  backgroundImage:
                                  match.team1Logo
                                      .isNotEmpty
                                      ? NetworkImage(
                                      match
                                          .team1Logo)
                                      : null,

                                  child: match
                                      .team1Logo
                                      .isEmpty
                                      ? const Icon(Icons
                                      .sports_cricket)
                                      : null,
                                ),

                                const SizedBox(
                                    height: 8),

                                Text(
                                  match.team1,
                                  textAlign:
                                  TextAlign
                                      .center,
                                ),
                              ],
                            ),
                          ),

                          const Padding(
                            padding:
                            EdgeInsets.symmetric(
                                horizontal: 12),

                            child: Text(
                              "VS",
                              style: TextStyle(
                                color:
                                Colors.orange,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              children: [

                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                  Colors.white,

                                  backgroundImage:
                                  match.team2Logo
                                      .isNotEmpty
                                      ? NetworkImage(
                                      match
                                          .team2Logo)
                                      : null,

                                  child: match
                                      .team2Logo
                                      .isEmpty
                                      ? const Icon(Icons
                                      .sports_cricket)
                                      : null,
                                ),

                                const SizedBox(
                                    height: 8),

                                Text(
                                  match.team2,
                                  textAlign:
                                  TextAlign
                                      .center,
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
                            size: 18,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              match.date,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          const Icon(
                            Icons.location_on,
                            size: 18,
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              match.venue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment:
                        Alignment.centerRight,

                        child: Chip(
                          label: Text(
                            match.matchType
                                .toUpperCase(),
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
      ),
    );
  }
}