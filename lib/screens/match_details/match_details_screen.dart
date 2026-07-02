import 'package:flutter/material.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> match;

  const MatchDetailsScreen({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff10141A),
        title: const Text(
          "Match Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xff1E2633),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [

                  const Text(
                    "🔴 LIVE",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    match["name"] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    match["status"] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Match Information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              color: const Color(0xff1E2633),
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    _infoRow(
                      "Match",
                      match["name"] ?? "-",
                    ),

                    _infoRow(
                      "Status",
                      match["status"] ?? "-",
                    ),

                    _infoRow(
                      "Venue",
                      match["venue"] ?? "-",
                    ),

                    _infoRow(
                      "Date",
                      match["date"] ?? "-",
                    ),

                    _infoRow(
                      "Match Type",
                      match["matchType"] ?? "-",
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}