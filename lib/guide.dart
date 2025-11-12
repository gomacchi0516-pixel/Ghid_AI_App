import 'package:flutter/material.dart';
import 'common/common_scaffold.dart'; // 共通Scaffold


// CSSで指定されたフォントスタイル
const TextStyle kGuideTextStyle = TextStyle(
  fontFamily: 'Montserrat', // アプリ全体で設定済なら不要
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: Colors.black,
);

const TextStyle kDownloadButtonTextStyle = TextStyle(
  fontFamily: 'Montserrat', // アプリ全体で設定済なら不要
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: Colors.white,
  height: 1.25, // line-height: 15px / font-size: 12px
);

/// 📘 Guide ページ
class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      // CSSは絶対位置指定なのでスクロール無効
      scrollable: false,
      child: Stack(
        // CSSの left: calc(50% ...) を再現するため
        alignment: Alignment.center,
        children: [
          
          

          // --- ガイド表示エリア (Rectangle 12) ---
          Positioned(
            left: 57,
            top: 170,
            child: Container(
              width: 269,
              height: 354,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9), // #D9D9D9
              ),
              // "Full Guide" テキストをCSSの位置に配置
              child: const Stack(
                children: [
                  Positioned(
                    // CSSの left: 164px, top: 348px から
                    // 親コンテナ (left: 57, top: 170) を引いた相対位置
                    left: 107, // 164 - 57 = 107
                    top: 178, // 348 - 170 = 178
                    width: 61,
                    height: 15,
                    child: Text(
                      'Full Guide',
                      style: kGuideTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // --- 英語ダウンロードボタン (Rectangle 13 + Text) ---
          Positioned(
            left: 57,
            top: 566,
            child: GestureDetector(
              onTap: () {
                // TODO: 英語バージョンをダウンロードする処理
              },
              child: Stack(
                alignment: Alignment.center, // テキストを中央寄せにしやすくする
                children: [
                  // Rectangle 13
                  Container(
                    width: 112,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF009FDF), // #009FDF
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Text (CSSの left: 66px, top: 579px)
                  Container(
                    width: 93, // CSSのテキスト幅
                     // CSSの top: 579 - 566 = 13 のズレを調整
                    padding: const EdgeInsets.only(top: 3),
                    child: const Text(
                      'Download English Version',
                      style: kDownloadButtonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // --- ルーマニア語ダウンロードボタン (Rectangle 14 + Text) ---
          Positioned(
            left: 214,
            top: 566,
            child: GestureDetector(
              onTap: () {
                // TODO: ルーマニア語バージョンをダウンロードする処理
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rectangle 14
                  Container(
                    width: 112,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCE1126), // #CE1126
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                   // Text (CSSの left: 215px, top: 579px)
                   Container(
                    width: 111, // CSSのテキスト幅
                     // CSSの top: 579 - 566 = 13 のズレを調整
                    padding: const EdgeInsets.only(top: 3),
                    child: const Text(
                      'Download Romanian Version',
                      style: kDownloadButtonTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // --- フッターロゴ (image 3) ---
          Positioned(
            left: 114,
            top: 721,
            child: Image.asset(
              'assets/images/image.png', // CSSのファイル名
              width: 161.64,
              height: 104,
              errorBuilder: (context, e, s) => Container(
                  width: 161.64, height: 104, color: Colors.grey[200], child: const Text('Logo')),
            ),
          ),

          // CSSの Status bar - iPhone はFlutterが自動で描画するため、ここでは実装しません。
        ],
      ),
    );
  }
}