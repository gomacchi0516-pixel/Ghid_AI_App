import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // ✅ SVG対応のため追加
import 'common/common_scaffold.dart'; // 共通Scaffold

// --- スタイル定義 ---
const TextStyle titleStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 20,
  color: Colors.white,
);

const TextStyle contentStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 18,
  color: Colors.white,
);

/// 連絡先情報カードを作成するヘルパーウィジェット
class ContactInfoCard extends StatelessWidget {
  final Color backgroundColor;
  final String iconAssetPath; // アイコン画像パス (SVG/PNG対応)
  final IconData fallbackIcon; // 代替アイコン
  final String title;
  final String content;
  final double iconLeft;
  final double iconTop;
  final double titleLeft;
  final double titleTop;
  final double contentLeft;
  final double contentTop;
  final double contentWidth;

  const ContactInfoCard({
    super.key,
    required this.backgroundColor,
    required this.iconAssetPath,
    required this.fallbackIcon,
    required this.title,
    required this.content,
    this.iconLeft = 9.5,
    required this.iconTop,
    this.titleLeft = 63.5,
    required this.titleTop,
    required this.contentLeft,
    required this.contentTop,
    required this.contentWidth,
  });

  /// ✅ SVG/PNGに対応したアイコン読み込み処理
  Widget _buildIcon() {
    if (iconAssetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconAssetPath,
        width: 48,
        height: 49,
        placeholderBuilder: (context) =>
            Icon(fallbackIcon, size: 48, color: Colors.white),
      );
    } else {
      return Image.asset(
        iconAssetPath,
        width: 48,
        height: 49,
        errorBuilder: (context, error, stackTrace) =>
            Icon(fallbackIcon, size: 48, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      height: 109,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ✅ SVG/PNG自動判別アイコン
          Positioned(
            left: iconLeft,
            top: iconTop,
            child: _buildIcon(),
          ),

          // タイトル（E-mail / Telefon / Office）
          Positioned(
            left: titleLeft,
            top: titleTop,
            child: Text(title, style: titleStyle, textAlign: TextAlign.center),
          ),

          // コンテンツ（メール/電話/住所）
          Positioned(
            left: contentLeft,
            top: contentTop,
            width: contentWidth,
            child: Text(content, style: contentStyle, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

/// ✉️ Contact ページ
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Group 3 (E-mail) ---
              const ContactInfoCard(
                backgroundColor: Color(0xFF00AEEF),
                iconAssetPath: 'assets/images/email.svg',
                fallbackIcon: Icons.email,
                title: 'E-mail',
                content: 'contact@ghidAI.ro',
                iconTop: 2,
                titleTop: 15,
                contentLeft: 80.5,
                contentTop: 51,
                contentWidth: 178,
              ),

              const SizedBox(height: 50),

              // Contact Form Button
              Container(
                width: 191,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF00AEEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Contact Form',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // --- Group 1 (Telefon) ---
              const ContactInfoCard(
                backgroundColor: Color(0xFFCCCC00),
                iconAssetPath: 'assets/images/phone.svg',
                fallbackIcon: Icons.phone,
                title: 'Telefon',
                content: '+40 213169922',
                iconTop: 9,
                titleTop: 15,
                contentLeft: 103.5,
                contentTop: 58,
                contentWidth: 132,
              ),

              const SizedBox(height: 50),

              // --- Group 2 (Office) ---
              const ContactInfoCard(
                backgroundColor: Color(0xFFFC9706),
                iconAssetPath: 'assets/images/pin.svg',
                fallbackIcon: Icons.location_city,
                title: 'Office',
                content: 'Bulevardul dacia 56, Bucuresti, Romania',
                iconTop: 6,
                titleTop: 12,
                contentLeft: 73.5,
                contentTop: 55,
                contentWidth: 191,
              ),

              const SizedBox(height: 50),

              // Basemap image
              Image.asset(
                'assets/images/basemap.png',
                width: 339,
                height: 200,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
