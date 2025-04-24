import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_data_provider.dart';
import 'theme_switcher.dart';

class FourthPage extends StatelessWidget {
  const FourthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<AppDataProvider>(context, listen: false).goBack();
          },
        ),
        title: const Text("Settings Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Theme Switcher",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ThemeSwitcher()
          ],
        ),
      ),
    );
  }
}
