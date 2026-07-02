import 'package:flutter/material.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1E2633),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🏆 ICC Rankings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: CircleAvatar(
              child: Text("1"),
            ),
            title: Text(
              "India",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "124",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
          Divider(color: Colors.white24),
          ListTile(
            leading: CircleAvatar(
              child: Text("2"),
            ),
            title: Text(
              "Australia",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              "118",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }
}