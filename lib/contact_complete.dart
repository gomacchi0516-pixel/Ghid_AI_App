// lib/contact_complete.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'common/common_scaffold.dart'; // 👈 共通Scaffoldをインポート

// --- スタイル定義 ---
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


class ContactCompletePage extends StatelessWidget {
  const ContactCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 Scaffold を CommonScaffold に変更
    return CommonScaffold(
      scrollable: false, // 👈 このページはスクロール不要
      
      // 👇 child: にページの中身（Stack）を入れる
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // "Thank you!" (CSSのtop位置を調整)
          Positioned(
            // 元のtop: 289 から、AppBarの高さを考慮して調整
            top: 200, // 👈 位置を調整
            child: const Text(
              'Thank you!',
              style: kThankYouStyle,
              textAlign: TextAlign.center,
            ),
          ),

          // "Your message has been sent..." (CSSのtop位置を調整)
          Positioned(
            // 元のtop: 389 から調整
            top: 300, // 👈 位置を調整
            width: 353,
            child: const Text(
              'Your message has been sent successfully. Please wait for a reply to the E-mail address you provided.',
              style: kSuccessMessageStyle,
              textAlign: TextAlign.center,
            ),
          ),

          // "BACK TO HOME" ボタン (CSSのtop位置を調整)
          Positioned(
            top: 400, // 👈 位置を調整
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
          )
        ],
      ),
    );
  }
}