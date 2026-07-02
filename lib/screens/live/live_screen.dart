import 'package:flutter/material.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Matches'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.sports_cricket),
              title: const Text('No Live Matches'),
              subtitle: const Text(
                'Live score integration will be added in the next module.',
              ),
              trailing: ElevatedButton(
                onPressed: null,
                child: const Text('LIVE'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Upcoming Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Live Scores'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Ball by Ball Commentary'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Scorecard'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Playing XI'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Match Statistics'),
          ),
        ],
      ),
    );
  }
}
