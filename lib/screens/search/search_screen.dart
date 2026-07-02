import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> recentSearches = [
    "Virat Kohli",
    "Rohit Sharma",
    "Shubman Gill",
    "Jasprit Bumrah",
    "India",
    "Australia",
    "IPL 2026",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff111827),
        title: const Text("Search"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                hintText: "Search Player, Team or Series",
                hintStyle: const TextStyle(color: Colors.white54),

                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.orange,
                ),

                filled: true,
                fillColor: const Color(0xff1E293B),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Searches",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xff1E293B),

                    child: ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: Colors.orange,
                      ),

                      title: Text(
                        recentSearches[index],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white54,
                      ),

                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Search for ${recentSearches[index]} coming soon",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}