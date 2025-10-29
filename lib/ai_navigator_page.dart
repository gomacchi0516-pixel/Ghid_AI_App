import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'common/common_scaffold.dart';

// --- スタイル定義 ---
const TextStyle chatTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.black,
  height: 1.25,
);
const Color bubbleBackgroundColor = Color(0xFFD9D9D9);
final BorderRadius bubbleBorderRadius = BorderRadius.circular(10);
const EdgeInsets bubblePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

/// メッセージデータを保持するクラス
class ChatMessage {
  final String text;
  final bool isUserMessage;

  ChatMessage({required this.text, required this.isUserMessage});
}

/// 吹き出しのしっぽを描画する CustomClipper
class SpeechTailClipper extends CustomClipper<Path> {
  final bool isUserMessage;
  SpeechTailClipper(this.isUserMessage);
  @override
  Path getClip(Size size) {
    final path = Path();
    if (isUserMessage) {
      path.moveTo(0, size.height * 0.2);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height * 0.8);
    } else {
      path.moveTo(size.width, size.height * 0.2);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height * 0.8);
    }
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// しっぽ付きの吹き出しウィジェット
class BubbleWithTail extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final double maxWidth;

  const BubbleWithTail({
    super.key,
    required this.text,
    required this.isUserMessage,
    this.maxWidth = 250,
  });

  @override
  Widget build(BuildContext context) {
    Widget tail = ClipPath(
      clipper: SpeechTailClipper(isUserMessage),
      child: Container(
        width: 10,
        height: 15,
        color: bubbleBackgroundColor,
      ),
    );
    Widget bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: bubblePadding,
      decoration: BoxDecoration(
        color: bubbleBackgroundColor,
        borderRadius: bubbleBorderRadius,
      ),
      child: Text(text, style: chatTextStyle),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isUserMessage
          ? [bubble, tail]
          : [tail, bubble],
    );
  }
}

// --- Stateful Widget ---
class AiNavigatorPage extends StatefulWidget {
  const AiNavigatorPage({super.key});

  @override
  State<AiNavigatorPage> createState() => _AiNavigatorPageState();
}

class _AiNavigatorPageState extends State<AiNavigatorPage> {
  // --- メッセージリスト (初期値を修正) ---
  final List<ChatMessage> _messages = [
    // 👇 Robotの最初のメッセージ
    ChatMessage(text: "Let's request the information you need!!", isUserMessage: false),
  ];

  // --- テキスト入力用 ---
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // --- メッセージ送信処理  ---
  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    setState(() {
      // ユーザーメッセージを追加
      _messages.add(ChatMessage(text: text, isUserMessage: true));
      _textController.clear();

      // 👇 AI(Robot)の応答を追加 (コメントアウト解除 & テキスト修正)
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {

          _messages.add(ChatMessage(text: "OK. First, let's check your knowledge now.", isUserMessage: false));
          _scrollToBottom();
        });
      });
    });
     _scrollToBottom();
  }

  // --- ListViewの最後にスクロール ---
  void _scrollToBottom() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
       if (_scrollController.hasClients) {
         _scrollController.animateTo(
           _scrollController.position.maxScrollExtent,
           duration: const Duration(milliseconds: 300),
           curve: Curves.easeOut,
         );
       }
     });
   }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      scrollable: false,
      child: Column(
        children: [
          // --- チャット表示部分 ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.isUserMessage;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isUser)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Image.asset(
                            'assets/images/Robot.png',
                            width: 48, height: 48,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.android, size: 48),
                          ),
                        ),
                      BubbleWithTail(
                        text: message.text,
                        isUserMessage: isUser,
                      ),
                      if (isUser)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Image.asset(
                              'assets/images/Head.png',
                              width: 48, height: 48,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 48),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --- 入力フィールド部分 ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}