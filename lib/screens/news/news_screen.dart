import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket News'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('Latest Cricket News'),
              subtitle: const Text(
                'News API integration will be added in the next module.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Trending Stories'),
              subtitle: const Text(
                'Trending cricket stories will appear here.',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Upcoming Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Latest Cricket News'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('IPL News'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('ICC News'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Player Interviews'),
          ),
          const ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Video Highlights'),
          ),
        ],
      ),
    );
  }
}
