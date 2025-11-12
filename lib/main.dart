import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'common/common_scaffold.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

void main() => runApp(const MyApp());

/// ========================
/// AIチャット用の型（旧 _Message / Sender を置換）
/// ========================
enum ChatSender { user, bot }

class ChatMessage {
  final ChatSender sender;
  final String text;
  const ChatMessage({required this.sender, required this.text});
}

/// Routing
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const WelcomePage()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/ai', builder: (_, __) => const AiNavigatorPage()),
    GoRoute(
      path: '/screening',
      builder: (_, __) => const DigitalScreeningPage(),
    ),
    GoRoute(path: '/guide', builder: (_, __) => const GuidePage()),
    GoRoute(path: '/guide/full', builder: (_, __) => const FullGuidePage()),
    GoRoute(path: '/contact', builder: (_, __) => const ContactPage()),
    // Contact Form を専用ページ化（CommonScaffold適用）
    GoRoute(path: '/contact-form', builder: (_, __) => const ContactFormPage()),
    // 完了ページ
    GoRoute(
      path: '/contact-complete',
      builder: (_, __) => const ContactCompletePage(),
    ),
  ],
);

/// Entire the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: _router,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF4F46E5),
      fontFamily: 'Montserrat',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
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
          _NavButton(
            label: 'AI Navigator',
            iconPath: 'assets/images/supporter.svg',
            onTap: () => context.go('/ai'),
            backgroundColor: const Color.fromARGB(255, 111, 205, 255),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          _NavButton(
            label: 'Digital Screening',
            iconPath: 'assets/images/skill.svg',
            onTap: () => context.go('/screening'),
            backgroundColor: const Color.fromARGB(255, 146, 248, 112),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          _NavButton(
            label: 'View the Guide',
            iconPath: 'assets/images/guide.svg',
            onTap: () => context.go('/guide'),
            backgroundColor: const Color.fromARGB(255, 255, 112, 219),
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            borderColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          _NavButton(
            label: 'Contact Us',
            iconPath: 'assets/images/mail.svg',
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
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final String? iconPath;

  const _NavButton({
    required this.label,
    required this.onTap,
    this.backgroundColor = const Color(0xFF4F46E5),
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.iconPath,
  });

  bool _isSvg(String path) => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
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
          padding: const EdgeInsets.symmetric(vertical: 36),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null) ...[
              _isSvg(iconPath!)
                  ? SvgPicture.asset(iconPath!, height: 50, fit: BoxFit.contain)
                  : Image.asset(iconPath!, height: 36, fit: BoxFit.contain),
              const SizedBox(width: 12),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}

/// 🤖 AI Navigator ページ（CommonScaffold 準拠）
class AiNavigatorPage extends StatefulWidget {
  const AiNavigatorPage({super.key});
  @override
  State<AiNavigatorPage> createState() => _AiNavigatorPageState();
}

class _AiNavigatorPageState extends State<AiNavigatorPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    const ChatMessage(
      sender: ChatSender.bot,
      text: 'Hi! What AI-related information are you looking for today?',
    ),
  ];

  bool _isTyping = false;

  static const String _apiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: text));
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottomSoon();

    try {
      final reply = await _callOpenAI(text);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(sender: ChatSender.bot, text: reply));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            sender: ChatSender.bot,
            text:
                'Sorry, I ran into an error. ($e)\nPlease try again in a moment.',
          ),
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => _isTyping = false);
      _scrollToBottomSoon();
    }
  }

  Future<String> _callOpenAI(String userText) async {
    if (_apiKey.isEmpty) {
      throw 'OPENAI_API_KEY is not set (pass via --dart-define).';
    }
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    final body = jsonEncode({
      'model': _model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a helpful AI assistant for an educational guide app. Answer briefly and clearly.',
        },
        {'role': 'user', 'content': userText},
      ],
      'temperature': 0.7,
    });

    final resp = await http.post(
      Uri.parse(_endpoint),
      headers: headers,
      body: body,
    );
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final choices = data['choices'] as List?;
      final msg = choices?.first?['message']?['content'] as String?;
      return (msg != null && msg.trim().isNotEmpty)
          ? msg.trim()
          : 'I could not generate a response.';
    } else {
      throw 'HTTP ${resp.statusCode}: ${resp.body}';
    }
  }

  void _scrollToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final pos = _scrollController.position;
      if (!(pos.hasPixels && pos.hasContentDimensions)) return;
      _scrollController
          .animateTo(
            pos.maxScrollExtent + 120,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          )
          .catchError((_) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      scrollable: false,
      centerContent: false,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingBubble();
                }
                final msg = _messages[index];
                final isUser = (msg.sender == ChatSender.user);
                final maxBubbleWidth = MediaQuery.of(context).size.width * 0.72;
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          // 入力エリア
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// タイピング中アニメーション
class _TypingBubble extends StatefulWidget {
  const _TypingBubble({super.key});
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => FadeTransition(
              opacity: Tween(begin: 0.2, end: 1.0).animate(
                CurvedAnimation(
                  parent: _ac,
                  curve: Interval(
                    0.2 * i,
                    0.6 + 0.2 * i,
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text('•', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🧪 Digital Screening（3-step, persist answers, Step3は連絡先フォーム + 右下Submit）
class DigitalScreeningPage extends StatefulWidget {
  const DigitalScreeningPage({super.key});

  @override
  State<DigitalScreeningPage> createState() => _DigitalScreeningPageState();
}

class _DigitalScreeningPageState extends State<DigitalScreeningPage> {
  int _step = 0; // 0: Digital Skills, 1: AI Literacy, 2: Contact form

  // ====== Answer stores ======
  final Map<String, int> _answersStep1 = {};
  final Map<String, int> _answersStep2 = {};

  // ====== Step1 Questions (5) ======
  final List<_Question> _step1Questions = [
    _Question(
      id: 'ds_q1',
      text:
          'Cum apreciați nivelul general al competențelor digitale de bază în rândul angajaților companiei?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ds_q2',
      text:
          'Cât de des sunt necesare sesiuni de instruire pentru îmbunătățirea competențelor digitale ale angajaților?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ds_q3',
      text:
          'Care sunt sarcinile repetitive care consumă cel mai mult timp în cadrul companiei?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ds_q4',
      text: 'Există întârzieri frecvente sau erori în procesele operaționale?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ds_q5',
      text: 'Cum sunt colectate și analizate datele în companie?',
      options: ['A', 'B', 'C', 'D'],
    ),
  ];

  // ====== Step2 Questions (10) ======
  final List<_Question> _step2Questions = [
    _Question(
      id: 'ai_q1',
      text:
          'Cum sunt stocate datele colectate de către compania dumneavoastră?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q2',
      text:
          ' Ce soluții de siguranță cibernetică sunt implementate în compania dumneavoastră?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q3',
      text:
          'Cât de des sunt utilizate datele pentru a fundamenta deciziile strategice?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q4',
      text:
          'Există dificultăți în gestionarea feedback-ului sau a solicitărilor din partea clienților?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q5',
      text:
          'Cât de familiarizați sunt angajații companiei cu conceptele de bază ale inteligenței artificiale?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q6',
      text:
          'Ce aplicații AI sunt cel mai des utilizate de angajați în cadrul companiei?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q7',
      text:
          ' Care sunt principalele obiective pe termen scurt și mediu ale companiei?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q8',
      text:
          'În ce departamente considerați că AI-ul ar avea cel mai mare impact?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q9',
      text:
          'Există un plan de digitalizare sau modernizare a proceselor interne în următorii 1-3 ani?',
      options: ['A', 'B', 'C', 'D'],
    ),
    _Question(
      id: 'ai_q10',
      text:
          'Care este gradul de satisfacție al clienților în ceea ce privește serviciile oferite?',
      options: ['A', 'B', 'C', 'D'],
    ),
  ];

  bool get _step1AllAnswered => _answersStep1.length == _step1Questions.length;
  bool get _step2AllAnswered => _answersStep2.length == _step2Questions.length;

  void _selectAnswer({
    required int step,
    required String qid,
    required int optionIndex,
  }) {
    setState(() {
      if (step == 0) {
        _answersStep1[qid] = optionIndex;
      } else if (step == 1) {
        _answersStep2[qid] = optionIndex;
      }
    });
  }

  void _goNext() {
    if (_step == 0 && _step1AllAnswered) {
      setState(() => _step = 1);
    } else if (_step == 1 && _step2AllAnswered) {
      setState(() => _step = 2);
    }
  }

  void _goPrev() {
    if (_step > 0) setState(() => _step--);
  }

  // ====== Step3: Contact Form ======
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); // optional
  final _messageCtrl = TextEditingController();

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    for (final c in [
      _nameCtrl,
      _companyCtrl,
      _roleCtrl,
      _emailCtrl,
      _phoneCtrl,
      _messageCtrl,
    ]) {
      c.addListener(_recheckCanSubmit);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _companyCtrl,
      _roleCtrl,
      _emailCtrl,
      _phoneCtrl,
      _messageCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _recheckCanSubmit() {
    final ok = _basicValidate();
    if (_canSubmit != ok) {
      setState(() => _canSubmit = ok);
    }
  }

  bool _basicValidate() {
    return _nameCtrl.text.trim().isNotEmpty &&
        _companyCtrl.text.trim().isNotEmpty &&
        _roleCtrl.text.trim().isNotEmpty &&
        _isValidEmail(_emailCtrl.text.trim()) &&
        _messageCtrl.text.trim().isNotEmpty;
  }

  bool _isValidEmail(String s) {
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(s);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'name': _nameCtrl.text.trim(),
      'company': _companyCtrl.text.trim(),
      'role': _roleCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'message': _messageCtrl.text.trim(),
      'scores': {
        'digital_skills': _avgScore(_answersStep1),
        'ai_literacy': _avgScore(_answersStep2),
      },
      'answers': {'step1': _answersStep1, 'step2': _answersStep2},
    };
    // TODO: backend/email 連携
    // print(payload);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Submitted! We will email your results soon.'),
      ),
    );
    // 必要なら画面遷移
    // context.go('/home');
  }

  int _avgScore(Map<String, int> answers) {
    if (answers.isEmpty) return 0;
    const max = 3; // 0..3
    final sum = answers.values.fold<int>(0, (a, b) => a + b);
    final score = (sum / (answers.length * max)) * 100.0;
    return score.round();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ステップインジケータ
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: _StepProgress(
                  current: _step,
                  labels: const [
                    'Digital Skills',
                    'AI Literacy',
                    'Feedback & Results',
                  ],
                ),
              ),

              if (_step == 0) ...[
                const Text(
                  'Digital Skills Assessment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                for (final q in _step1Questions) ...[
                  _QuestionBlock(
                    question: q,
                    groupValue: _answersStep1[q.id],
                    onChanged: (i) =>
                        _selectAnswer(step: 0, qid: q.id, optionIndex: i),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                _NavButtons(
                  showBack: false,
                  nextEnabled: _step1AllAnswered,
                  onNext: _goNext,
                ),
              ] else if (_step == 1) ...[
                const Text(
                  'AI Literacy Check',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                for (final q in _step2Questions) ...[
                  _QuestionBlock(
                    question: q,
                    groupValue: _answersStep2[q.id],
                    onChanged: (i) =>
                        _selectAnswer(step: 1, qid: q.id, optionIndex: i),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                _NavButtons(
                  showBack: true,
                  onBack: _goPrev,
                  nextEnabled: _step2AllAnswered,
                  onNext: _goNext,
                ),
              ] else ...[
                const Text(
                  'Feedback & Results (by Email)',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please fill in your contact details. We will send your personalized feedback by email.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _ContactForm(
                  formKey: _formKey,
                  nameCtrl: _nameCtrl,
                  companyCtrl: _companyCtrl,
                  roleCtrl: _roleCtrl,
                  emailCtrl: _emailCtrl,
                  phoneCtrl: _phoneCtrl,
                  messageCtrl: _messageCtrl,
                  emailValidator: _isValidEmail,
                ),
                const SizedBox(height: 80), // FABと被らない余白
              ],
            ],
          ),

          // Step3のみ右下にSubmitボタン（有効化は入力状態で判定）
          if (_step == 2)
            Positioned(
              right: 12,
              bottom: 12,
              child: IgnorePointer(
                ignoring: !_canSubmit,
                child: Opacity(
                  opacity: _canSubmit ? 1.0 : 0.5,
                  child: FloatingActionButton.extended(
                    onPressed: _canSubmit ? _submit : null,
                    label: const Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ========== UI Parts (progress/question blocks etc.) ==========

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.current, required this.labels});
  final int current; // 0..2
  final List<String> labels;

  Color _circleColor(int i) =>
      i <= current ? const Color(0xFF60A5FA) : const Color(0xFFE5E7EB);
  Color _lineColor(int i) =>
      i < current ? const Color(0xFF60A5FA) : const Color(0xFFE5E7EB);
  TextStyle _labelStyle(int i) => TextStyle(
    fontSize: 12,
    fontWeight: i == current ? FontWeight.w800 : FontWeight.w600,
    color: i == current ? Colors.black : Colors.black54,
    height: 1.3,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 丸と線を1セットで中央寄せ
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(3, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    _StepDot(color: _circleColor(i), index: i + 1),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 60,
                      child: Text(
                        labels[i],
                        textAlign: TextAlign.center,
                        style: _labelStyle(i),
                      ),
                    ),
                  ],
                ),
                if (i < 2) _StepLine(color: _lineColor(i), width: 70),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.color, required this.index});
  final Color color;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(1, 2),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color.computeLuminance() < 0.5
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.color, required this.width});
  final Color color;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _Question {
  final String id;
  final String text;
  final List<String> options;
  const _Question({
    required this.id,
    required this.text,
    required this.options,
  });
}

class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    required this.question,
    required this.groupValue,
    required this.onChanged,
  });

  final _Question question;
  final int? groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (int i = 0; i < question.options.length; i++)
            RadioListTile<int>(
              value: i,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              dense: true,
              activeColor: const Color(0xFF60A5FA),
              contentPadding: EdgeInsets.zero,
              title: Text(
                question.options[i],
                style: const TextStyle(fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({
    this.showBack = true,
    this.onBack,
    this.onNext,
    this.nextEnabled = true,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool nextEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          Expanded(
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        if (showBack) const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: nextEnabled ? onNext : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

/// Step3: 連絡先フォーム本体（Screening用）
class _ContactForm extends StatelessWidget {
  const _ContactForm({
    required this.formKey,
    required this.nameCtrl,
    required this.companyCtrl,
    required this.roleCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.messageCtrl,
    required this.emailValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController companyCtrl;
  final TextEditingController roleCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl; // optional
  final TextEditingController messageCtrl;
  final bool Function(String) emailValidator;

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return emailValidator(v.trim()) ? null : 'Invalid email';
  }

  String? _phone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final ok = RegExp(r'^[0-9+\-\s()]{6,}$').hasMatch(v.trim());
    return ok ? null : 'Invalid phone';
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameCtrl,
                  validator: _req,
                  decoration: _dec('Full name *', hint: 'John Smith'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: companyCtrl,
                  validator: _req,
                  decoration: _dec('Company *', hint: 'ACME Inc.'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: roleCtrl,
                  validator: _req,
                  decoration: _dec('Role/Title *', hint: 'Manager'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: emailCtrl,
                  validator: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _dec('Email *', hint: 'name@example.com'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: phoneCtrl,
                  validator: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: _dec('Phone (optional)', hint: '+40 7xx xxx xxx'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: messageCtrl,
            validator: _req,
            maxLines: 5,
            decoration: _dec('Message *', hint: 'Anything we should know...'),
          ),
        ],
      ),
    );
  }
}

/// 📘 View the Guide（中央レイアウト＋ロゴ付きボタン＋リンク）
class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  static final Uri _pdfRo = Uri.parse(
    'https://drive.google.com/uc?export=download&id=11PndIhQAAGSpmJR2aVsXDUBZzIOnGFDj',
  );
  static final Uri _pdfEn = Uri.parse(
    'https://drive.google.com/uc?export=download&id=16E6OsDc4kQ001CijYQT-PQg0qUSxhg0s',
  );

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      scrollable: false,
      centerContent: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🟣 Full Guide ボタン（SVGロゴ入り）
            InkWell(
              onTap: () => context.go('/guide/full'),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4EC),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/guidebook.svg',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Full Guide',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 🔗 PDFリンク（RO & EN）
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LinkLine(
                  label: 'Download PDF (Română)',
                  flagPath: 'assets/images/romania.svg',
                  onTap: () => _openUrl(_pdfRo, context),
                ),
                const SizedBox(height: 12),
                _LinkLine(
                  label: 'Download PDF (English)',
                  flagPath: 'assets/images/eng.svg',
                  onTap: () => _openUrl(_pdfEn, context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openUrl(Uri url, BuildContext context) async {
    final ok =
        await canLaunchUrl(url) &&
        await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link.')));
    }
  }
}

/// 下線付き・薄青リンク行（文字＆下線同色）
class _LinkLine extends StatelessWidget {
  const _LinkLine({
    required this.label,
    required this.onTap,
    required this.flagPath,
  });

  final String label;
  final VoidCallback onTap;
  final String flagPath;

  @override
  Widget build(BuildContext context) {
    const linkColor = Color.fromARGB(255, 0, 174, 255);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/pdf.png',
              height: 26,
              width: 26,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: linkColor,
                decoration: TextDecoration.underline,
                decorationColor: linkColor,
                decorationThickness: 1.8,
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(flagPath, height: 20, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}

/// 📖 Full Guide ページ（枠線なし・章一覧→タップで展開・ExpansionTile版）
class FullGuidePage extends StatelessWidget {
  const FullGuidePage({super.key});

  // 章データ（例文）
  List<_Chapter> get _chapters => const [
    _Chapter(
      title: 'Introducere',
      body:
          'Bine ați venit la Ghidul AI! Acest capitol prezintă scopul aplicației, beneficiile generale ale AI și modul de navigare în ghid.',
    ),
    _Chapter(
      title: 'Capitolul 1 – Importanța și avantajele AI-ului pentru IMM-uri',
      body:
          'AI crește productivitatea și scade costurile. Exemple: automatizarea sarcinilor repetitive, analiză de vânzări, chatbot-uri pentru suport clienți.',
    ),
    _Chapter(
      title: 'Capitolul 2 – Utilizarea AI-ului în marketing',
      body:
          'Personalizare la scară, recomandări de produse, analiză de sentiment, generare de conținut (texte/imagini) pentru campanii.',
    ),
    _Chapter(
      title: 'Capitolul 3 – Utilizarea AI-ului în contabilitate și finanțe',
      body:
          'Recunoașterea facturilor, reconciliere bancară, prognoză de cashflow și raportare financiară în timp real.',
    ),
    _Chapter(
      title: 'Capitolul 4 – Optimizarea mentenanței și producției',
      body:
          'Întreținere predictivă cu senzori IoT, detectarea anomaliilor, optimizarea lanțului de aprovizionare și planificarea producției.',
    ),
    _Chapter(
      title: 'Capitolul 5 – Cum alegem soluțiile AI potrivite',
      body:
          'Analiza nevoilor, criterii de selecție (securitate, integrare, cost), pilotare, formare echipă și plan de implementare.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 20),
                child: Text(
                  'CONTENTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _chapters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final c = _chapters[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        expansionTileTheme: const ExpansionTileThemeData(
                          iconColor: Colors.black87,
                          collapsedIconColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                        ),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        title: Text(
                          c.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        children: [
                          Text(
                            c.body,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.55,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chapter {
  final String title;
  final String body;
  const _Chapter({required this.title, required this.body});
}

/// Contact 共通スタイル
const TextStyle titleStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 20,
  color: Colors.white,
);

const TextStyle contentStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 18,
  color: Colors.white,
);

const TextStyle formButtonTextStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 18,
  color: Colors.white,
);

/// Contact Us ページ（CommonScaffold + 中央寄せ）
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchMaps(String address) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/place/ECDL+ROMANIA/@44.446268,26.105071,19z/data=!4m6!3m5!1s0x40b1ff50cc34eb9b:0x6758b14caf668183!8m2!3d44.446166!4d26.105071!16s%2Fg%2F1hc580tfb?hl=en&entry=ttu&g_ep=EgoyMDI1MTEwNS4wIKXMDSoASAFQAw%3D%3D',
    );
    final Uri appleMapsUrl = Uri.parse(
      'https://www.google.com/maps/place/ECDL+ROMANIA/@44.446268,26.105071,19z/data=!4m6!3m5!1s0x40b1ff50cc34eb9b:0x6758b14caf668183!8m2!3d44.446166!4d26.105071!16s%2Fg%2F1hc580tfb?hl=en&entry=ttu&g_ep=EgoyMDI1MTEwNS4wIKXMDSoASAFQAw%3D%3D',
    );
    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        // ignore
      }
    } catch (_) {}
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', '').replaceAll('-', ''),
    );
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (_) {}
  }

  Future<void> _copyToClipboard(BuildContext context, String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('E-mail address copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String officeAddress =
        'Corp A, Bulevardul Dacia 56, București 020061';
    const String phoneNumber = '+40 213169922';
    const String emailAddress = 'contact@ghidAI.ro';

    return CommonScaffold(
      centerContent: true,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ContactInfoCard(
                  backgroundColor: const Color(0xFF00AEEF),
                  iconAssetPath: 'assets/images/email.svg',
                  fallbackIcon: Icons.email,
                  title: 'E-mail',
                  content: emailAddress,
                  forceSingleLine: true,
                  onTap: () => _copyToClipboard(context, emailAddress),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => context.push('/contact-form'),
                  child: Container(
                    width: 191,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00AEEF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Contact Form',
                        style: formButtonTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ContactInfoCard(
                  backgroundColor: const Color(0xFFCCCC00),
                  iconAssetPath: 'assets/images/phone.svg',
                  fallbackIcon: Icons.phone,
                  title: 'Telefon',
                  content: phoneNumber,
                  forceSingleLine: true,
                  onTap: () => _launchPhone(phoneNumber),
                ),
                const SizedBox(height: 50),
                ContactInfoCard(
                  backgroundColor: const Color(0xFFFC9706),
                  iconAssetPath: 'assets/images/pin.svg',
                  fallbackIcon: Icons.location_city,
                  title: 'Office',
                  content: officeAddress.replaceAll(', ', ',\n'),
                  onTap: () => _launchMaps(officeAddress),
                ),
                const SizedBox(height: 50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/map_placeholder.png',
                    width: 338,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 338,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Map Placeholder',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 連絡先情報カード
class ContactInfoCard extends StatelessWidget {
  final Color backgroundColor;
  final String iconAssetPath;
  final IconData fallbackIcon;
  final String title;
  final String content;
  final VoidCallback? onTap;
  final bool forceSingleLine;

  const ContactInfoCard({
    super.key,
    required this.backgroundColor,
    required this.iconAssetPath,
    required this.fallbackIcon,
    required this.title,
    required this.content,
    this.onTap,
    this.forceSingleLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 338,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.none,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAssetPath,
              width: 48,
              height: 49,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              placeholderBuilder: (context) =>
                  Icon(fallbackIcon, size: 48, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: titleStyle, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: contentStyle,
                    textAlign: TextAlign.center,
                    softWrap: !forceSingleLine,
                    overflow: forceSingleLine
                        ? TextOverflow.ellipsis
                        : TextOverflow.clip,
                    maxLines: forceSingleLine ? 1 : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Contact Form ページ（CommonScaffold で包む）
class ContactFormPage extends StatelessWidget {
  const ContactFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      scrollable: true,
      centerContent: true,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ContactForm(),
          ),
        ),
      ),
    );
  }
}

/// お問い合わせフォーム本体（ContactFormページ用）
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final companyName = _companyNameController.text;
      final email = _emailController.text;
      final message = _messageController.text;

      // TODO: 送信処理
      // print('Name: $name, Company: $companyName, Email: $email, Message: $message');

      _formKey.currentState?.reset();
      _nameController.clear();
      _companyNameController.clear();
      _emailController.clear();
      _messageController.clear();

      context.push('/contact-complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _companyNameController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                hintText: 'Enter your company name',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Please enter your company name'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your email';
                if (!v.contains('@') || !v.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter a message' : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEEF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const TextStyle kThankYouStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w700,
  fontSize: 48,
  color: Colors.black,
);

const TextStyle kSuccessMessageStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w400,
  fontSize: 17,
  color: Colors.black,
  height: 22 / 17,
);

/// 送信完了ページ（CommonScaffold）
class ContactCompletePage extends StatelessWidget {
  const ContactCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      scrollable: false,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 200,
            child: const Text(
              'Thank you!',
              style: kThankYouStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 300,
            width: 353,
            child: const Text(
              'Your message has been sent successfully. Please wait for a reply to the E-mail address you provided.',
              style: kSuccessMessageStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 400,
            width: 296,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text(
                  'BACK TO HOME',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
