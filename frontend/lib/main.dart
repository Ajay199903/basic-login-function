import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

const String apiBaseUrl = 'http://localhost:5000';
final storage = FlutterSecureStorage();

/* =======================
   APP ROOT (AUTO LOGIN)
   ======================= */
class MyApp extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'jwt');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
      ),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? HomePage() : AuthPage();
        },
      ),
    );
  }
}

/* =======================
   AUTH PAGE
   ======================= */
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  void resetForm() {
    userNameController.clear();
    passwordController.clear();
    message = '';
  }

  bool validateLoginForm() {
    if (userNameController.text.isEmpty ||
      passwordController.text.isEmpty) {
      message = '名前とパスワードを入力してください';
      return false;
    }
    return true;
  }

  bool validateRegisterForm() {
    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      message = 'すべての項目を入力してください';
      return false;
    }
    if (userName.length < 1) {
      message = '名前は入力してください';
      return false;
    }
    if (password.length < 6) {
      message = 'パスワードは6文字以上にしてください';
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!validateRegisterForm()) {
      setState(() {});
      return;
    }

    final res = await http.post(
      Uri.parse('$apiBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userNameController.text,
        'userPassword': passwordController.text,
      }),
    );

    if (res.statusCode == 201) {
      setState(() {
        isLogin = true;
        resetForm();
        message = '登録が完了しました。ログインしてください。';
      });
    } else {
      setState(() {
        message = '登録に失敗しました';
      });
    }
  }

  Future<void> login() async {
    if (!validateLoginForm()) {
      setState(() {});
      return;
    }

    final res = await http.post(
      Uri.parse('$apiBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userNameController.text,
        'userPassword': passwordController.text,
      }),
    );

    if (res.statusCode == 200) {
      final token = jsonDecode(res.body)['access_token'];
      await storage.write(key: 'jwt', value: token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      setState(() {
        message = '名前またはパスワードが間違っています';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.eco, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(
                    isLogin ? 'ログイン' : '新規登録',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: '名前',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'パスワード',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: isLogin ? login : register,
                    child: Text(isLogin ? 'ログイン' : '登録'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        resetForm();
                        message = '';
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'アカウントを作成する'
                          : 'ログイン画面に戻る',
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(message, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =======================
   HOME PAGE
   ======================= */
class HomePage extends StatelessWidget {
  Future<String> fetchProfileMessage() async {
    final token = await storage.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('$apiBaseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return res.statusCode == 200
        ? jsonDecode(res.body)['message']
        : '取得失敗';
  }

  Widget energyCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'jwt');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エネルギーダッシュボード'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: fetchProfileMessage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(snapshot.data!, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    energyCard(Icons.solar_power, '太陽光', Colors.orange),
                    energyCard(Icons.wind_power, '風力', Colors.blue),
                    energyCard(
                        Icons.battery_charging_full, '蓄電池', Colors.green),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}