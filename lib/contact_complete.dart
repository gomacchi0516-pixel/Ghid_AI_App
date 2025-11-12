import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ... (TextStyleの定義は変更なし) ...
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
    return Scaffold(
      backgroundColor: Colors.white,
      
      // 👇 common_scaffold.dart からフッターロゴの部分をコピー
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Center(
            child: Image.asset(
              'assets/images/company_logo.png',
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      // 👆 ここまでフッターロゴ

      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // "Thank you!" (変更なし)
            Positioned(
              top: 289,
              child: const Text(
                'Thank you!',
                style: kThankYouStyle,
                textAlign: TextAlign.center,
              ),
            ),

            // "Your message has been sent..." (変更なし)
            Positioned(
              top: 389,
              width: 353,
              child: const Text(
                'Your message has been sent successfully. Please wait for a reply to the E-mail address you provided.',
                style: kSuccessMessageStyle,
                textAlign: TextAlign.center,
              ),
            ),

            // "BACK TO HOME" ボタン (変更なし)
            Positioned(
              top: 576,
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
      ),
    );
  }
}