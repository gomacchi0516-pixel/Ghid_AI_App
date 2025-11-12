// lib/contact_form.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// CSSを参考にしたスタイル
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
  // フォームの状態を管理するためのキー
  final _formKey = GlobalKey<FormState>();
  
  // 各入力フィールドのコントローラー
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    // 画面が破棄されるときにコントローラーも破棄
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// 送信ボタンが押されたときの処理
  void _submitForm() {
    // フォームのバリデーション（入力チェック）を実行
    if (_formKey.currentState?.validate() ?? false) {
      // バリデーションが通った場合
      final name = _nameController.text;
      final companyName = _companyNameController.text;
      final email = _emailController.text;
      final message = _messageController.text;
      
      // TODO: データを送信する処理をここに実装
      print('Name: $name');
      print('Company Name: $companyName');
      print('Email: $email');
      print('Message: $message');
        
      // フォームをクリア
      _formKey.currentState?.reset();
      _nameController.clear();
      _companyNameController.clear();
      _emailController.clear();
      _messageController.clear();

      // 完了ページに遷移
      context.push('/contact-complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Frame 10/7 のCSS (padding: 10px, gap, flex-direction: column) を参考に構築
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0), // CSS padding: 10px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 幅をいっぱいに
          children: [
            const SizedBox(height: 10), // CSS gap
            
            // Name Field
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

            // CompanyName Field
            TextFormField(
              controller: _companyNameController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                hintText: 'Enter your company name',
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
            
            // Email Field
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
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20), // gap
            
            // Message Field
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message',
                labelStyle: kLabelStyle,
                hintStyle: kHintStyle,
                border: OutlineInputBorder(),
                alignLabelWithHint: true, // 複数行の場合のラベル位置
              ),
              maxLines: 5, // 複数行入力
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 30), // gap
            
            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEEF), // contact.dart のボタン色を参考
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
              child: const Text('SUBMIT', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}