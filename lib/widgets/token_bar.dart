import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenBar extends StatefulWidget {
  const TokenBar({super.key});

  @override
  State<TokenBar> createState() => _TokenBarState();
}

class _TokenBarState extends State<TokenBar> {
  int tokens = 0;

  @override
  void initState() {
    super.initState();
    loadTokens();
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tokens = prefs.getInt('tokens') ?? 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.stars, color: Colors.amber),
        const SizedBox(width: 5),
        Text("Jeton: $tokens", style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
