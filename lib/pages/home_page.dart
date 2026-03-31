import 'package:flutter/material.dart';
// import 'quran_page.dart';
// import 'favorites_page.dart';
// import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        children: [
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const QuranPage()),
          //       );
          //     },
          //     child: const Text("Quran"),
          //   ),
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const FavoritesPage()),
          //       );
          //     },
          //     child: const Text("Favorites"),
          //   ),
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const SettingsPage()),
          //       );
          //     },
          //     child: const Text("Settings"),
          //   ),
        ],
      ),
    );
  }
}
