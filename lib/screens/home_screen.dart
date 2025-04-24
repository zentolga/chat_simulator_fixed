import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/token_bar.dart';
import 'profile_screen.dart';
import 'task_screen.dart';
import '../utils/premium.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> addTokens(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt('tokens') ?? 0;
    await prefs.setInt('tokens', current + amount);
    setState(() {});
  }

  Future<void> activatePremium() async {
    await PremiumManager.activatePremium();
    setState(() {});
  }

  Widget characterCard(String name, int age, String job, String school, String image) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.asset(image, width: 50, height: 70, fit: BoxFit.cover),
        title: Text(name),
        subtitle: Text('$age, $job'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProfileScreen(
              name: name,
              age: age,
              job: job,
              school: school,
              imagePath: image,
            ),
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karakterler')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const TokenBar(),
          ElevatedButton(
            onPressed: () => addTokens(10),
            child: const Text("Jeton Kazan (Simülasyon)"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const TaskScreen(),
              ));
            },
            child: const Text("Görevleri Gör"),
          ),
          ElevatedButton(
            onPressed: () => activatePremium(),
            child: const Text("Premium Aktivasyon (Demo)"),
          ),
          Expanded(
            child: ListView(
              children: [
                characterCard('Sophie', 22, 'Müzisyen', 'NYU', 'assets/images/sample1.jpg'),
                characterCard('Lina', 24, 'Doktor', 'Harvard', 'assets/images/sample2.jpg'),
                characterCard('Emma', 23, 'Öğretmen', 'Oxford', 'assets/images/sample3.jpg'),
                characterCard('Zara', 25, 'Mühendis', 'MIT', 'assets/images/sample4.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
