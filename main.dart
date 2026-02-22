import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const PetCareApp());
}

/* ================= APP ROOT ================= */
class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Care Robot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

/* ================= SPLASH SCREEN ================= */
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();

    Future.delayed(const Duration(seconds: 3), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.smart_toy, size: 100, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Pet Care Robot',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= LOGIN SCREEN ================= */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.smart_toy, size: 90, color: Colors.blue),
            const SizedBox(height: 10),
            const Text(
              'Pet Care Robot Control',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Email field
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password field with toggle
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Forgot Password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Add forgot password logic
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= MAIN SCREEN ================= */
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  final List<String> logs = [];

  void addLog(String text) {
    setState(() {
      logs.insert(0, text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onAction: addLog),
      LogsScreen(logs: logs),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.teal,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}


/* ================= DASHBOARD WITH COLORFUL CARDS ================= */
/* ================= DASHBOARD WITH FULLY RESPONSIVE CARDS ================= */
class DashboardScreen extends StatefulWidget {
  final Function(String) onAction;
  const DashboardScreen({super.key, required this.onAction});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Map<String, String> _status = {
    'Feed Pet': 'Not done yet',
    'Give Water': 'Not done yet',
    'Launch Ball': 'Not done yet',
    'Line Follow': 'Not done yet',
    'IoT Status': 'Disconnected',
  };

  final Map<String, Color> _colors = {
    'Feed Pet': Colors.orange,
    'Give Water': Colors.blue,
    'Launch Ball': Colors.green,
    'Line Follow': Colors.purple,
    'IoT Status': Colors.teal,
  };

  final Map<String, IconData> _icons = {
    'Feed Pet': Icons.fastfood,
    'Give Water': Icons.water_drop,
    'Launch Ball': Icons.sports_baseball,
    'Line Follow': Icons.alt_route,
    'IoT Status': Icons.wifi,
  };

  @override
  Widget build(BuildContext context) {
    final cardTitles = _status.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: cardTitles.map((title) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _colors[title],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    final time = TimeOfDay.now().format(context);
                    setState(() {
                      _status[title] = 'Last executed at $time';
                    });
                    widget.onAction('$title executed at $time');

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text('Action details for $title'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_icons[title], size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(_status[title]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/* ================= LOGS ================= */
class LogsScreen extends StatelessWidget {
  final List<String> logs;
  const LogsScreen({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Logs')),
      body: logs.isEmpty
          ? const Center(child: Text('No activity yet'))
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.teal),
                  title: Text(logs[index]),
                );
              },
            ),
    );
  }
}

/* ================= SETTINGS ================= */
/* ================= SETTINGS WITH ANIMATED BATTERY ================= */

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double batteryLevel = 0.75; // initial battery 75%
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate battery updates every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        batteryLevel -= 0.01;
        if (batteryLevel < 0) batteryLevel = 0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color getBatteryColor(double level) {
    if (level > 0.6) return Colors.green;
    if (level > 0.3) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SwitchListTile(
              value: true,
              onChanged: null,
              title: Text('Enable Notifications'),
            ),
            const ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Feeding Schedule'),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About Robot'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Battery Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Animated Battery Icon
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: batteryLevel),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, level, _) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: 40 * level,
                          height: 20,
                          decoration: BoxDecoration(
                            color: getBatteryColor(level),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 12),
                // Animated Progress Bar
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: batteryLevel),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, level, _) {
                      return LinearProgressIndicator(
                        value: level,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        color: getBatteryColor(level),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Text('${(batteryLevel * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}