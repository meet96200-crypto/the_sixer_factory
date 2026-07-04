import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        centerTitle: true,
        title: const Text("Notifications"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          _notificationCard(
            title: "India vs Australia has started",
            subtitle: "Tap to watch live score.",
            icon: Icons.sports_cricket,
            color: Colors.red,
            time: "2 min ago",
          ),

          _notificationCard(
            title: "Breaking Cricket News",
            subtitle: "Virat Kohli scores another century.",
            icon: Icons.article,
            color: Colors.orange,
            time: "20 min ago",
          ),

          _notificationCard(
            title: "Upcoming Match Reminder",
            subtitle: "England vs Pakistan starts in 1 hour.",
            icon: Icons.notifications_active,
            color: Colors.green,
            time: "1 hour ago",
          ),
        ],
      ),
    );
  }

  Widget _notificationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String time,
  }) {
    return Card(
      color: const Color(0xff1E293B),
      margin: const EdgeInsets.only(bottom: 16),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ),

        trailing: Text(
          time,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}