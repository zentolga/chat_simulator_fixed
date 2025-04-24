import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int visitedProfiles = 0;
  bool rewardGiven = false;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      visitedProfiles = prefs.getInt('visitedProfiles') ?? 0;
      rewardGiven = prefs.getBool('rewardGiven') ?? false;
    });
  }

  Future<void> claimReward() async {
    final prefs = await SharedPreferences.getInstance();
    int tokens = prefs.getInt('tokens') ?? 0;
    await prefs.setInt('tokens', tokens + 10);
    await prefs.setBool('rewardGiven', true);
    setState(() => rewardGiven = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Görevler")),
      body: Column(
        children: [
          ListTile(
            title: const Text("3 profil gez"),
            subtitle: Text("Tamamlanan: $visitedProfiles / 3"),
            trailing: rewardGiven
                ? const Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: visitedProfiles >= 3 ? claimReward : null,
                    child: const Text("Jeton Al (+10)"),
                  ),
          )
        ],
      ),
    );
  }
}
