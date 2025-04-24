import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<int>.rolling(
      current: !Provider.of<ThemeProvider>(context, listen: false).isDarkMode()
          ? 0
          : 1,
      values: const [0, 1], // 0: light, 1: dark
      onChanged: (value) {
        Provider.of<ThemeProvider>(context, listen: false).invertTheme();
      },
      iconBuilder: (value, size) {
        return Icon(
          value == 0 ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          size: 24,
          color: value == 0 ? Colors.yellow[700] : Colors.blueGrey[200],
        );
      },
      style: ToggleStyle(
        backgroundColor: Colors.grey[100],
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        indicatorColor: Theme.of(context).primaryColor,
      ),
      styleBuilder: (value) => ToggleStyle(
        indicatorColor: value == 0 ? Colors.blue : Colors.blueGrey,
      ),
      height: 50.0,
      spacing: 10.0,
    );
  }
}
