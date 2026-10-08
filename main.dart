import 'package:flutter/material.dart';
import 'package:http/http' as http;
import 'dart:convert';

void main() {
  runApp(const RecoveryApp());
}

class RecoveryApp extends StatelessWidget {
  const RecoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recovery & Life App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const SleepTab(),
    const EnglishTab(),
    const AICoachTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام التعافي والحياة'),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.bed), label: 'النوم'),
          NavigationDestination(icon: Icon(Icons.school), label: 'إنجليزي'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'المدرب AI'),
        ],
      ),
    );
  }
}

// 1. الشاشة الرئيسية وزرار الصباح والطوارئ
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('صباح الفل يا بطل! قوم اغسل وشك وتوضأ وصلي فوراً.')),
              );
            },
            icon: const Icon(Icons.wb_sunny, color: Colors.black),
            label: const Text(
              'أنا صحيت (ابدأ يومك بدون موبايل)',
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('زر الطوارئ 🚨'),
                  content: const Text('قوم من مكانك فوراً! خُد 5 أنفاس عميقة، واشرب مية باردة.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('تم، أنا مسيطر'),
                    )
                  ],
                ),
              );
            },
            icon: const Icon(Icons.warning, color: Colors.white),
            label: const Text(
              'زر الطوارئ (اضغط عند الرغبة)',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. ميزة حاسبة ومثبت مواعيد النوم
class SleepTab extends StatefulWidget {
  const SleepTab({super.key});

  @override
  State<SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<SleepTab> {
  TimeOfDay wakeTime = const TimeOfDay(hour: 8, minute: 0);

  List<String> calculateBedtimes(TimeOfDay wake) {
    final now = DateTime.now();
    final wakeDateTime = DateTime(now.year, now.month, now.day, wake.hour, wake.minute);
    
    List<String> bedtimes = [];
    for (int cycles in [6, 5, 4]) {
      final sleepTime = wakeDateTime.subtract(Duration(minutes: (cycles * 90) + 15));
      final hour = sleepTime.hour.toString().padLeft(2, '0');
      final minute = sleepTime.minute.toString().padLeft(2, '0');
      bedtimes.add('$hour:$minute ($cycles دورات نوم)');
    }
    return bedtimes;
  }

  @override
  Widget build(BuildContext context) {
    final bedtimes = calculateBedtimes(wakeTime);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('حاسبة ومثبت مواعيد النوم الذكي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.grey[850],
            title: Text('وقت الاستيقاظ المطلوب: ${wakeTime.format(context)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: wakeTime);
              if (picked != null) {
                setState(() => wakeTime = picked);
              }
            },
          ),
          const SizedBox(height: 20),
          const Text('عشان تصحى فايق وأعصابك مرتاحة، أنسب مواعيد تنام فيها:'),
          const SizedBox(height: 10),
          ...bedtimes.map((time) => Card(
            child: ListTile(
              leading: const Icon(Icons.nightlight_round, color: Colors.indigoAccent),
              title: Text('نام الساعة: $time'),
            ),
          )),
        ],
      ),
    );
  }
}

// 3. شاشة كورس الإنجليزي
class EnglishTab extends StatelessWidget {
  const EnglishTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('جدول كلمات الإنجليزي اليومي + تايمر 20 دقيقة'));
  }
}

// 4. شاشة مدرب الـ AI المربوط بـ Gemini API
class AICoachTab extends StatefulWidget {
  const AICoachTab({super.key});

  @override
  State<AICoachTab> createState() => _AICoachTabState();
}

class _AICoachTabState extends State<AICoachTab> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // ضع المفتاح الخاص بك هنا
  final String apiKey = 'AQ.Ab8RN6JJr38W4txQteDdm2oPlypwfqzyKuIDnHqnSygpWGII3g';

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': text}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiReply = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({'role': 'ai', 'text': aiReply});
        });
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'حدث خطأ في الاتصال، حاول مرة أخرى.'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'تأكد من الاتصال بالإنترنت أو صحة الـ API Key.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.teal : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg['text'] ?? ''),
                ),
              );
            },
          ),
        ),
        if (_isLoading) const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'اكتب سؤالك للمدرب الذكي...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.teal),
                onPressed: () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
