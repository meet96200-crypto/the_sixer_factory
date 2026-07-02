import 'package:flutter/material.dart';

import 'ranking_tab.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xff111827),
          title: const Text("ICC Rankings"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "TEST"),
              Tab(text: "ODI"),
              Tab(text: "T20"),
            ],
          ),
        ),
        body: const RankingTab(),
      ),
    );
  }
}