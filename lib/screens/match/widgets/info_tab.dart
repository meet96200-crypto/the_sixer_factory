import 'package:flutter/material.dart';
import '../../../models/match_model.dart';

class InfoTab extends StatelessWidget {
  final MatchModel match;

  const InfoTab({
    super.key,
    required this.match,
  });

  Widget item(String title, String value) {
    return Card(
      color: const Color(0xff1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        item("Series", match.series),

        item("Venue", match.venue),

        item("Date", match.date),

        item("Match Type", match.matchType),

        item("Status", match.status),

      ],
    );
  }
}