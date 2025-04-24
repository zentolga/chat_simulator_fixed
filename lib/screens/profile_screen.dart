import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import '../utils/premium.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final int age;
  final String job;
  final String school;
  final String imagePath;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.age,
    required this.job,
    required this.school,
    required this.imagePath,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool unlocked = false;

  @override
  void initState() {
    super.initState();
    incrementVisitedProfiles();
    checkPremium();
  }

  Future<void> incrementVisitedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt('visitedProfiles') ?? 0;
    prefs.setInt('visitedProfiles', current + 1);
  }

  Future<void> checkPremium() async {
    final isPro = await PremiumManager.isPremium();
    if (isPro) {
      setState(() {
        unlocked = true;
      });
    }
  }

  Future<bool> spendTokens(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt('tokens') ?? 0;
    if (current >= amount) {
      await prefs.setInt('tokens', current - amount);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(widget.imagePath, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 10),
          if (!unlocked)
            ElevatedButton(
              onPressed: () async {
                bool success = await spendTokens(10);
                if (success) {
                  setState(() {
                    unlocked = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Yetersiz jeton!")),
                  );
                }
              },
              child: const Text("Jetonla Aç (10 Jeton)"),
            ),
          if (unlocked)
            Column(
              children: const [
                Text("Instagram: @karakter.official"),
                Text("Sesli Mesaj: Açıldı"),
              ],
            ),
          const Divider(),
          ListTile(title: Text("Yaş: ${widget.age}")),
          ListTile(title: Text("Meslek: ${widget.job}")),
          ListTile(title: Text("Okul: ${widget.school}")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChatScreen(characterName: widget.name),
              ));
            },
            child: const Text("Sohbete Başla"),
          )
        ],
      ),
    );
  }
}
