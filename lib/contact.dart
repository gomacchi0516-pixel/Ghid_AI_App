import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ai_guide_app/common/common_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'common/common_scaffold.dart';

// --- スタイル定義 (変更なし) ---
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

// --- ページ本体 (StatelessWidget) ---
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // --- 地図アプリ起動用の関数 (変更なし) ---
  Future<void> _launchMaps(String address) async {
    final Uri googleMapsUrl = Uri.parse(
      'http://googleusercontent.com/maps/google.com/27${Uri.encodeComponent(address)}'
    );
    final Uri appleMapsUrl = Uri.parse(
      'http://googleusercontent.com/maps/google.com/28${Uri.encodeComponent(address)}'
    );
    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        print('Could not launch maps');
      }
    } catch (e) {
      print('Error launching maps: $e');
    }
  }

  // --- 電話をかける関数 (変更なし) ---
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(' ', '').replaceAll('-', ''),
    );
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        print('Could not launch phone dialer');
      }
    } catch (e) {
      print('Error launching phone: $e');
    }
  }

  // --- E-mailコピー用の関数 (変更なし) ---
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
    const String officeAddress = 'Corp A, Bulevardul Dacia 56, București 020061';
    const String phoneNumber = '+40 213169922';
    const String emailAddress = 'contact@ghidAI.ro';

    return CommonScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- E-mail Card (レイアウトプロパティを削除) ---
              ContactInfoCard(
                backgroundColor: const Color(0xFF00AEEF),
                iconAssetPath: 'assets/images/email.svg',
                fallbackIcon: Icons.email,
                title: 'E-mail',
                content: emailAddress,
                forceSingleLine: true, // 1行表示を強制
                onTap: () => _copyToClipboard(context, emailAddress),
              ),
              const SizedBox(height: 50),

              // --- Contact Form Button (変更なし) ---
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

              // --- Telefon Card (レイアウトプロパティを削除) ---
              ContactInfoCard(
                backgroundColor: const Color(0xFFCCCC00),
                iconAssetPath: 'assets/images/phone.svg',
                fallbackIcon: Icons.phone,
                title: 'Telefon',
                content: phoneNumber,
                forceSingleLine: true, // 1行表示を強制
                onTap: () => _launchPhone(phoneNumber),
              ),
              const SizedBox(height: 50),

              // --- Office Card (レイアウトプロパティを削除) ---
              ContactInfoCard(
                backgroundColor: const Color(0xFFFC9706),
                iconAssetPath: 'assets/images/pin.svg',
                fallbackIcon: Icons.location_city,
                title: 'Office',
                // .replaceAll で意図的に改行
                content: officeAddress.replaceAll(', ', ',\n'),
                // forceSingleLine: false (デフォルト) なので複数行表示される
                onTap: () => _launchMaps(officeAddress),
              ),
              const SizedBox(height: 50),

              // --- 仮の地図スクリーンショット (変更なし) ---
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/map_placeholder.png',
                  width: 338,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 338, height: 250, color: Colors.grey[300],
                        child: const Center(child: Text('Map Placeholder', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 連絡先情報カード (Stack/PositionedをRow/Columnレイアウトに変更)
class ContactInfoCard extends StatelessWidget {
  final Color backgroundColor;
  final String iconAssetPath;
  final IconData fallbackIcon;
  final String title;
  final String content;
  final VoidCallback? onTap;
  final bool forceSingleLine; // 👈 1行表示/複数行表示の切り替え

  const ContactInfoCard({
    super.key,
    required this.backgroundColor,
    required this.iconAssetPath,
    required this.fallbackIcon,
    required this.title,
    required this.content,
    this.onTap,
    this.forceSingleLine = false, // 👈 デフォルトはfalse (複数行許可)
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 338,
        // height: 109, // 👈 高さを固定しない
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // 👈 内側に余白
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.none, 
        child: Row( // 👈 StackをRowに変更
          crossAxisAlignment: CrossAxisAlignment.center, // 👈 アイコンとテキストブロックを中央揃え
          children: [
            // --- Icon ---
            SvgPicture.asset(
              iconAssetPath,
              width: 48,
              height: 49,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              placeholderBuilder: (context) => 
                  Icon(fallbackIcon, size: 48, color: Colors.white),
            ),
            const SizedBox(width: 10), // 👈 アイコンとテキストの間のスペース

            // --- Text Block ---
            Expanded( // 👈 残りの幅をすべてテキストブロックが使う
              child: Column(
                mainAxisSize: MainAxisSize.min, // 👈 縦方向は最小限の高さ
                crossAxisAlignment: CrossAxisAlignment.center, // 👈 テキストを中央揃え
                children: [
                  // --- Title ---
                  Text(
                    title, 
                    style: titleStyle, 
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 8), // 👈 タイトルとコンテンツの間のスペース

                  // --- Content ---
                  Text(
                    content, 
                    style: contentStyle, 
                    textAlign: TextAlign.center,
                    
                    // 👇 1行表示/複数行表示の制御
                    softWrap: !forceSingleLine, // trueなら自動改行 (Office)
                    overflow: forceSingleLine 
                                ? TextOverflow.ellipsis // 1行強制ならはみ出たら...
                                : TextOverflow.clip, // 複数行ならはみ出たら切り取る
                    maxLines: forceSingleLine ? 1 : null, // 1行強制 or 複数行許可 (null)
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