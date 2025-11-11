// digital_screening.dart

import 'package:flutter/material.dart';

class DigitalScreeningPage extends StatefulWidget {
  const DigitalScreeningPage({super.key});

  @override
  State<DigitalScreeningPage> createState() => _DigitalScreeningPageState();
}

class _DigitalScreeningPageState extends State<DigitalScreeningPage> {
  // ⚡ prefer_final_fields 修正
  final int _currentStep = 0; // 変更されない場合 final に

  // ⚡ unused_element 修正：_buildProgressBarは削除
  // Widget _buildProgressBar() { ... }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Screening')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '質問 1 / 5',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // ⚡ sized_box_for_whitespace 修正
            const SizedBox(height: 20),

            const Text(
              'ここに質問文が入ります。',
              style: TextStyle(fontSize: 16),
            ),

            // ⚡ sized_box_for_whitespace 修正
            const SizedBox(height: 30),

            // 回答ボタン例
            ElevatedButton(
              onPressed: () {
                // TODO: 次へ進む処理 (例: 次の質問へ)
              },
              child: const Text('回答 A'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // TODO: 次へ進む処理 (例: 次の質問へ)
              },
              child: const Text('回答 B'),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: 戻る処理 (例: 前の質問へ)
                  },
                  child: const Text('戻る'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 次へ進む処理 (例: 次の質問へ)
                  },
                  child: const Text('次へ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
