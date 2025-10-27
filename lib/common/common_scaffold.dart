import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonScaffold extends StatefulWidget {
  const CommonScaffold({
    super.key,
    required this.child,
    this.scrollable = true,
  });

  final Widget child;
  final bool scrollable; // 画面によってはスクロール不要の時にfalse

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
    final canGoBack = context.canPop();

    final content = widget.scrollable
        ? Scrollbar(
            controller: _scrollCtrl,
            thumbVisibility: true, // スクロール時に右側に常時サムを表示
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // 下部ロゴ分の余白
              child: widget.child,
            ),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: widget.child,
          );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: canGoBack
            ? IconButton(
                tooltip: 'Back',
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              )
            : null,
        // 中央：main_logo（タップでHomeへ）
        title: InkWell(
          onTap: () => context.go('/home'),
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/main_logo.png',
            height: 28, // 小さめロゴ
            fit: BoxFit.contain,
          ),
        ),
        // 右上：ハンバーガー（endDrawerを開く）
        actions: [
          IconButton(
            tooltip: 'Menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: _openMenu,
          ),
        ],
      ),

      // ページ本体（右スクロールバー付き）
      body: SafeArea(child: content),

      // 右側メニュー（ハンバーガーの中身）
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
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.explore),
                title: const Text('AI navigator'),
                onTap: () => context.go('/ai'),
              ),
              ListTile(
                leading: const Icon(Icons.fact_check),
                title: const Text('Digital screening'),
                onTap: () => context.go('/screening'),
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('View the guide'),
                onTap: () => context.go('/guide'),
              ),
              ListTile(
                leading: const Icon(Icons.mail_outline),
                title: const Text('Contact us'),
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
    );
  }
}
