import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        centerTitle: true,
        title: const Text("Settings"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          const Text(
            "General",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            color: const Color(0xff1E293B),
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.person,color: Colors.white),
                  title: const Text(
                    "Account",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white70,size: 16),
                  onTap: () {},
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.notifications,color: Colors.white),
                  title: const Text(
                    "Notification Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white70,size: 16),
                  onTap: () {},
                ),

                const Divider(height: 1),

                SwitchListTile(
                  value: false,
                  onChanged: (_) {},
                  secondary: const Icon(Icons.dark_mode,color: Colors.white),
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "Support",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            color: const Color(0xff1E293B),

            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.share,color: Colors.white),
                  title: const Text(
                    "Share App",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.star,color: Colors.amber),
                  title: const Text(
                    "Rate App",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {},
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.privacy_tip,color: Colors.green),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _openUrl("https://example.com/privacy");
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.description,color: Colors.blue),
                  title: const Text(
                    "Terms & Conditions",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _openUrl("https://example.com/terms");
                  },
                ),

              ],
            ),
          ),

          const SizedBox(height: 25),

          Card(
            color: const Color(0xff1E293B),

            child: const ListTile(
              leading: Icon(Icons.info,color: Colors.orange),
              title: Text(
                "The Sixer Factory",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),

        ],
      ),
    );
  }
}