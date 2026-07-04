import 'package:flutter/material.dart';
import '../screens/search/search_screen.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff10141A),
      elevation: 0,

      title: Row(
        children: [
          Image.asset(
            "assets/logos/logo.png",
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 10),
          const Text(
            "The Sixer Factory",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),

      actions: [

        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SearchScreen(),
              ),
            );
          },
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),

      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}