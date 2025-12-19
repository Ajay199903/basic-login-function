import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

final storage = FlutterSecureStorage();
const String apiBaseUrl = 'http://localhost:5000';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '認証デモ',
      home: LoginPage(),
    );
  }
}

/* =======================
   LOGIN / Register PAGE
   ======================= */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> register() async {
    final res = await http.post(
      Uri.parse('$apiBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userNameController.text,
        'userPassword': passwordController.text,
      }),
    );

    setState(() {
      message = res.statusCode == 201
          ? '登録が完了しました'
          : '登録に失敗しました';
    });
  }

  Future<void> login() async {
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

      //Redirect after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      setState(() {
        message = 'ログインに失敗しました';
      });
    }
  }

  Future<String> fetchProfileMessage() async {
    final token = await storage.read(key: 'jwt');

    final res = await http.get(
      Uri.parse('$apiBaseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['message'];
    } else {
      return 'プロフィール取得に失敗しました';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('サインイン / サインアップ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: register,
              child: Text('登録'),
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('ログイン'),
            ),
            const SizedBox(height: 12),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

/* =======================
   HOME PAGE
   ======================= */
class HomePage extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'jwt');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Future<String> fetchProfileMessage() async {
    final token = await storage.read(key: 'jwt');

    final res = await http.get(
      Uri.parse('$apiBaseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['message'];
    } else {
      return 'プロフィール取得に失敗しました';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ホーム')),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchProfileMessage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('エラーが発生しました');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data ?? '',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => logout(context),
                  child: Text('ログアウト'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}