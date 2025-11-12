import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'common/common_scaffold.dart'; // ← 共通UIを別ファイルで定義したやつ
import 'ai_navigator_page.dart'; // 👈 追加
import 'contact.dart';
import 'guide.dart';
import 'digital_screening.dart';
import 'contact_form.dart';
import 'contact_complete.dart';

void main() => runApp(const MyApp());

/// GoRouter ルーティング設定
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const WelcomePage()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/ai', builder: (_, __) => const AiNavigatorPage()),
    GoRoute(
      path: '/screening',
      // 👇 ここを新しいページクラスに変更
      builder: (_, __) => const DigitalScreeningPage(),
    ),
    GoRoute(path: '/guide', builder: (_, __) => const GuidePage()),
    GoRoute(path: '/contact', builder: (_, __) => const ContactPage()),
    GoRoute(
      path: '/contact-form',
      // CommonScaffoldで囲んで表示する
      builder: (_, __) => const CommonScaffold(
        scrollable: true, // Stackレイアウトのため
        child: ContactForm(),
      ),
    ),
    GoRoute(
      path: '/contact-complete',
      builder: (_, __) => const ContactCompletePage(),
    ),
  ],
);

/// アプリ全体
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: _router,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF4F46E5), // メインカラー

      // 👇 この行を追加します
      fontFamily: 'Montserrat', // アプリ全体のデフォルトフォントを指定
    ),
  );
}

/// 🟢 Welcome（起動画面）
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(
    parent: _ac,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    // 3秒後にHomeへ遷移
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 上：メインロゴ
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: FadeTransition(
                  opacity: _fade,
                  child: Image.asset(
                    'assets/images/main_logo.png',
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // 中央：Bun venit!
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: const Text(
                  'Bun venit!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),

            // 下：会社ロゴ
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: FadeTransition(
                  opacity: _fade,
                  child: Image.asset(
                    'assets/images/company_logo.png',
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🏠 Home（メイン画面）
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => CommonScaffold(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Home Page',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'We can add more discription here',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // 各ページに飛ぶボタン
          _NavButton(
            label: 'AI Navigator',
            onTap: () => context.go('/ai'),
            backgroundColor: const Color.fromARGB(255, 111, 205, 255),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),

          _NavButton(
            label: 'Digital Screening',
            onTap: () => context.go('/screening'),
            backgroundColor: const Color.fromARGB(255, 146, 248, 112),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),

          _NavButton(
            label: 'View the Guide',
            onTap: () => context.go('/guide'),
            backgroundColor: const Color.fromARGB(255, 255, 112, 219),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),

          _NavButton(
            label: 'Contact Us',
            onTap: () => context.go('/contact'),
            backgroundColor: const Color.fromARGB(255, 255, 188, 105),
            foregroundColor: Colors.black,
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    ),
  );
}

/// 共通デザインのナビゲーションボタン
class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor; // 背景色
  final Color foregroundColor; // 文字色
  final Color? borderColor; // 枠線（任意）

  const _NavButton({
    required this.label,
    required this.onTap,
    this.backgroundColor = const Color(0xFF4F46E5),
    this.foregroundColor = Colors.white,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 10, // ← ボタン間の上下間隔（増やした）
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 2)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 36, // ← ボタンの縦幅（ここを増やす）
          ),
          textStyle: const TextStyle(
            fontSize: 24, // 少し大きめの文字サイズに
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

/// 🤖 AI Navigator ページ
// class AiNavigatorPage extends StatelessWidget {
//   const AiNavigatorPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const CommonScaffold(child: Text('AI Navigator'));
      
// }

/// 🧩 Digital Screening ページ
// class DigitalScreeningPage extends StatelessWidget {
//   const DigitalScreeningPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const CommonScaffold(child: Text('Digital Screening'));
// }

// /// 📘 Guide ページ
// class GuidePage extends StatelessWidget {
//   const GuidePage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const CommonScaffold(child: Text('View the Guide'));
// }

/// ✉️ Contact ページ
// class ContactPage extends StatelessWidget {
//   const ContactPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const CommonScaffold(child: Text('Contact Us'));
// }
