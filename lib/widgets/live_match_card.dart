import 'package:flutter/material.dart';

class LiveMatchCard extends StatelessWidget {
  const LiveMatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff1E3A8A),
            Color(0xff312E81),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Row(
                  children: [

                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 10,
                    ),

                    SizedBox(width: 6),

                    Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.sports_cricket,
                color: Colors.white,
              ),

            ],
          ),

          const SizedBox(height: 25),

          const Center(
            child: Text(
              "RCB 154/3",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "VS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "MI 148/6",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Divider(
            color: Colors.white24,
          ),

          const SizedBox(height: 10),

          const Row(
            children: [

              Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 18,
              ),

              SizedBox(width: 5),

              Expanded(
                child: Text(
                  "Narendra Modi Stadium",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 8),

          const Row(
            children: [

              Icon(
                Icons.access_time,
                color: Colors.white70,
                size: 18,
              ),

              SizedBox(width: 5),

              Text(
                "RCB need 7 runs in 22 balls",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: () {},

              icon: const Icon(Icons.play_arrow),

              label: const Text(
                "View Match",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ),
        ],
      ),
    );
  }
}