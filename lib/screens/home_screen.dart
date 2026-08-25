import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../widgets/product_card.dart';
import 'todo_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ProductCard(
              title: "Week 1 Completed",
              subtitle: "UI & Auth Setup",
              icon: Icons.check_circle,
              onTap: () {},
            ),
            ProductCard(
              title: "Week 2 Completed",
              subtitle: "Navigation & Widgets",
              icon: Icons.widgets,
              onTap: () {},
            ),
            ProductCard(
              title: "Week 3 To-Do App",
              subtitle: "Add, Edit, Delete, ListView",
              icon: Icons.task_alt,
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ProductCard(
              title: "Week 4 Weather App",
              subtitle: "API Integration & Async",
              icon: Icons.cloud,
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
      const TodoScreen(),
      const WeatherScreen(),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo.shade100,
                child: Icon(Icons.person, size: 60, color: Colors.indigo.shade700),
              ),
              const SizedBox(height: 16),
              const Text(
                "Mahnoor Fatima",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "BSIT 6th Semester Student\nBackend & AI Developer",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? "Dashboard"
              : _currentIndex == 1
                  ? "Week 3: To-Do App"
                  : _currentIndex == 2
                      ? "Week 4: Weather App"
                      : "Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: "To-Do"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Weather"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
