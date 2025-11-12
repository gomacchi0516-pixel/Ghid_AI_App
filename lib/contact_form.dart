// lib/contact_form.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ... (kLabelStyle, kHintStyle の定義は変更なし) ...
const TextStyle kLabelStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
const TextStyle kHintStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  color: Colors.grey,
);


/// お問い合わせフォームのウィジェット
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  
  // 各入力フィールドのコントローラー
  final _nameController = TextEditingController();
  final _companyController = TextEditingController(); // 👈 会社名用コントローラーを追加
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose(); // 👈 dispose を追加
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// 送信ボタンが押されたときの処理
  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    setState(() {
      _isSending = true;
    });

    const String formspreeEndpoint = 'https://formspree.io/f/xjkjvqne'; // 👈 あなたのURLに要変更

    // 送信するデータ
    final data = {
      'name': _nameController.text,
      'company': _companyController.text, // 👈 会社名を追加
      'email': _emailController.text,
      'message': _messageController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(formspreeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // 送信成功
        _formKey.currentState?.reset();
        _nameController.clear();
        _companyController.clear(); // 👈 クリア処理を追加
        _emailController.clear();
        _messageController.clear();
        
        if (mounted) context.push('/contact-complete');

      } else {
        if (mounted) _showErrorDialog('Failed to send message. Please try again later.');
      }
    } catch (e) {
      if (mounted) _showErrorDialog('An error occurred: ${e.toString()}');
    }
    
    if (mounted) {
      setState(() {
        _isSending = false;
      });
    }
  }

  /// エラーダイアログ表示 (変更なし)
  void _showErrorDialog(String message) {
    // ... (コード省略) ...
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
            
            // Name Field (変更なし)
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                labelStyle: kLabelStyle,
                hintStyle: kHintStyle,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20), // gap
            
            // ▼▼▼ Company Name Field (追加) ▼▼▼
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                hintText: 'Enter your company name (Optional)', // 任意の場合
                labelStyle: kLabelStyle,
                hintStyle: kHintStyle,
                border: OutlineInputBorder(),
              ),
              // 会社名は任意入力（バリデーションなし）にする場合
              validator: null, // 👈 バリデーション不要な場合
              
              // (もし会社名も必須にする場合)
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter your company name';
              //   }
              //   return null;
              // },
            ),
            // ▲▲▲ ここまで追加 ▲▲▲
            
            const SizedBox(height: 20), // gap
            
            // Email Field (変更なし)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                labelStyle: kLabelStyle,
                hintStyle: kHintStyle,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                // ... (変更なし) ...
              },
            ),
            
            const SizedBox(height: 20),
            
            // Message Field (変更なし)
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message',
                labelStyle: kLabelStyle,
                hintStyle: kHintStyle,
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                // ... (変更なし) ...
              },
            ),
            
            const SizedBox(height: 30),
            
            // Submit Button (変更なし)
            ElevatedButton(
              onPressed: _isSending ? null : _submitForm, 
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
                )
              ),
              child: _isSending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('SUBMIT', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}