import 'package:flutter/material.dart';

import 'fixtures_tabs.dart';

class FixturesScreen extends StatelessWidget {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),

        appBar: AppBar(
          backgroundColor: const Color(0xff111827),
          title: const Text("Fixtures"),
          centerTitle: true,

          bottom: const TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "LIVE"),
              Tab(text: "UPCOMING"),
              Tab(text: "RESULTS"),
            ],
          ),
        ),

        body: const FixturesTabs(),
      ),
    );
  }
}