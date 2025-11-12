import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold({
    super.key,
    required this.child,
    this.scrollable = true,
    this.centerContent = true, // 追加: 中央寄せON/OFF
    this.maxContentWidth = 600, // 追加: コンテンツ最大幅
  });

  final Widget child;
  final bool scrollable;
  final bool centerContent;
  final double maxContentWidth;

  @override
  State<CommonScaffold> createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  final _scrollCtrl = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openMenu() => _scaffoldKey.currentState?.openEndDrawer();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 現在のルート
    final location = GoRouterState.of(context).uri.toString();
    final showBackButton = !(location == '/welcome' || location == '/home');

    // ------- 太字・見やすいローカルテーマ（全ページに効く） -------
    final base = Theme.of(context);
    final textTheme = base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        height: 1.5,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w800,
      ),
    );

    final themed = base.copyWith(
      textTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.black),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      listTileTheme: base.listTileTheme.copyWith(
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        dense: true,
        iconColor: Colors.black,
        textColor: Colors.black,
      ),
    );
    // -------------------------------------------------------------

    // 中央寄せ用ラッパ（最大幅を制限）
    Widget wrapContent(Widget child) {
      if (!widget.centerContent) return child;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxContentWidth),
          child: child,
        ),
      );
    }

    // スクロール有無で切り替え（下部ロゴ分の余白は共通）
    final content = widget.scrollable
        ? Scrollbar(
            controller: _scrollCtrl,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: wrapContent(widget.child),
            ),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: wrapContent(widget.child),
          );

    return Theme(
      data: themed, // ← 太字テーマをこのScaffold配下に適用
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: showBackButton
              ? IconButton(
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                )
              : null,
          // 中央：main_logo（タップでHomeへ）
          title: InkWell(
            onTap: () => context.go('/home'),
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/main_logo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          // 右上：ハンバーガー
          actions: [
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu_rounded),
              onPressed: _openMenu,
            ),
          ],
        ),

        body: SafeArea(child: content),

        endDrawer: Drawer(
          width: 300,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        'Menu',
                        style: textTheme.titleMedium, // 太字系
                      ),
                    ],
                  ),
                ),
                _DrawerItem(
                  iconPath: 'assets/images/supporter.svg',
                  label: 'AI navigator',
                  onTap: () => context.go('/ai'),
                ),
                _DrawerItem(
                  iconPath: 'assets/images/skill.svg',
                  label: 'Digital screening',
                  onTap: () => context.go('/screening'),
                ),
                _DrawerItem(
                  iconPath: 'assets/images/guide.svg',
                  label: 'View the guide',
                  onTap: () => context.go('/guide'),
                ),
                _DrawerItem(
                  iconPath: 'assets/images/mail.svg',
                  label: 'Contact us',
                  onTap: () => context.go('/contact'),
                ),
              ],
            ),
          ),
        ),

        // 画面最下部：会社ロゴ（常に表示）
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
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String iconPath; // assets/images/... (svg or png)
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  bool _isSvg(String path) => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      leading: _isSvg(iconPath)
          ? SvgPicture.asset(
              iconPath,
              height: 28,
              fit: BoxFit.contain,
              color: Colors.black, // 統一
            )
          : Image.asset(iconPath, height: 28, fit: BoxFit.contain),
      title: Text(
        label,
        // ListTileTheme の titleTextStyle にも乗るが、ここで強制上書き
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black54),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }
}
