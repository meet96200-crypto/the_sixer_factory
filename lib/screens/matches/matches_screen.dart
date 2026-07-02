import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Upcoming Matches'),
              subtitle: Text('Schedule integration will be added in the next module.'),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text('Recent Matches'),
              subtitle: Text('Recent results will appear here.'),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text('Series'),
              subtitle: Text('International & domestic series list coming soon.'),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Upcoming Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Match Schedule'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Series Details'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Match Details'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Points Table'),
          ),
        ],
      ),
    );
  }
}
