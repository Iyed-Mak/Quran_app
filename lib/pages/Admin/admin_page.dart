import 'package:flutter/material.dart';
import '../login_page.dart';
import 'screens/dashboard_screen.dart';
import 'screens/registration/registration_screen.dart';
import 'screens/teacher_manage/teacher_management_screen.dart';
import 'screens/student_manage/student_management_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/administration/administration_screen.dart';
import 'screens/settings_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Breakpoints
// ─────────────────────────────────────────────────────────────────────────────
class _BP {
  static const double tablet = 1024;
}

bool _isDesktop(BuildContext c) => MediaQuery.of(c).size.width >= _BP.tablet;

// ─────────────────────────────────────────────────────────────────────────────
// Nav items model
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const List<_NavItem> _navItems = [
  _NavItem(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: 'الرئيسية',
  ),
  _NavItem(
    icon: Icons.app_registration_outlined,
    selectedIcon: Icons.app_registration,
    label: 'التسجيل',
  ),
  _NavItem(
    icon: Icons.people_outline,
    selectedIcon: Icons.people,
    label: 'الطلبة',
  ),
  _NavItem(
    icon: Icons.school_outlined,
    selectedIcon: Icons.school,
    label: 'الأساتذة',
  ),
  _NavItem(
    icon: Icons.bar_chart_outlined,
    selectedIcon: Icons.bar_chart,
    label: 'الإحصائيات',
  ),
  _NavItem(
    icon: Icons.campaign_outlined,
    selectedIcon: Icons.campaign,
    label: 'التنبيهات',
  ),
  _NavItem(
    icon: Icons.admin_panel_settings_outlined,
    selectedIcon: Icons.admin_panel_settings,
    label: 'الإدارة',
  ),
  _NavItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'الإعدادات',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Root widget
// ─────────────────────────────────────────────────────────────────────────────
class AdminPage extends StatefulWidget {
  final String adminName;
  const AdminPage({super.key, required this.adminName});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _sideNavExpanded = true; // desktop rail expand/collapse
  final int _notificationCount = 5; // mock badge

  // All top-level pages — order must match _navItems
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(adminName: widget.adminName, onNavigate: _navigateTo),
      RegistrationScreen(),
      StudentManagementScreen(),
      TeacherManagementScreen(),
      StatisticsScreen(),
      AnnouncementsScreen(),
      AdministrationScreen(),
      SettingsScreen(adminName: widget.adminName, onLogout: _logout),
    ];
  }

  void _navigateTo(int index) => setState(() => _selectedIndex = index);

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // ── colour ──
  static const Color _primary = Color(0xff1565C0); // blue.shade800
  static const Color _surface = Color(0xffF5F7FA);
  static const Color _railBg = Color(0xff0D47A1); // blue.shade900
  static const Color _railSelBg = Color(0xff1976D2); // blue.shade700

  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: _isDesktop(context)
          ? _buildDesktopScaffold(context)
          : _buildMobileScaffold(context),
    );
  }

  // ─────────────────────────────────────────────
  // DESKTOP layout
  // ─────────────────────────────────────────────
  Widget _buildDesktopScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Top AppBar ──
          _buildTopBar(context),
          // ── Body row ──
          Expanded(
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Side navigation
                  _buildSideNav(context),
                  // Content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.03, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_selectedIndex),
                        child: _pages[_selectedIndex],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MOBILE/TABLET layout
  // ─────────────────────────────────────────────
  Widget _buildMobileScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: _buildMobileAppBar(context),
        ),
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Top bar (desktop)
  // ─────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: _primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Collapse toggle
            IconButton(
              icon: Icon(
                _sideNavExpanded ? Icons.menu_open : Icons.menu,
                color: Colors.white,
              ),
              tooltip: _sideNavExpanded ? 'طي القائمة' : 'فتح القائمة',
              onPressed: () =>
                  setState(() => _sideNavExpanded = !_sideNavExpanded),
            ),
            const SizedBox(width: 8),

            // Logo + title
            _SchoolLogo(),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نظام إدارة المدرسة القرآنية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'لوحة تحكم المدير',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Search
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'بحث',
              onPressed: () {},
            ),

            // Notification badge
            _NotificationBell(count: _notificationCount),

            const SizedBox(width: 4),

            // Profile menu
            _ProfileChip(
              adminName: widget.adminName,
              onLogout: _logout,
              onSettings: () => setState(() => _selectedIndex = 7),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Mobile AppBar
  // ─────────────────────────────────────────────
  AppBar _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.shade700,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SchoolLogo(size: 28),
          const SizedBox(width: 8),
          const Text(
            'لوحة تحكم المدير',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
      actions: [
        _NotificationBell(count: _notificationCount),
        const SizedBox(width: 4),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Side navigation (desktop)
  // ─────────────────────────────────────────────
  Widget _buildSideNav(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOut,
      width: _sideNavExpanded ? 220 : 68,
      decoration: BoxDecoration(
        color: _railBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Admin greeting
          if (_sideNavExpanded) _buildSideNavHeader(),

          const SizedBox(height: 8),

          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _navItems.length,
              itemBuilder: (context, i) => _buildSideNavItem(i),
            ),
          ),

          // Logout
          _buildSideNavLogout(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSideNavHeader() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xff1976D2),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.adminName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'مدير النظام',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(int index) {
    final item = _navItems[index];
    final selected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? _railSelBg.withValues(alpha: 0.85)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            selected ? item.selectedIcon : item.icon,
            color: selected ? Colors.white : Colors.white60,
            size: 22,
          ),
          title: _sideNavExpanded
              ? Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: _sideNavExpanded ? 12 : 14,
            vertical: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () => setState(() => _selectedIndex = index),
          selectedTileColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildSideNavLogout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
        title: _sideNavExpanded
            ? const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _sideNavExpanded ? 12 : 14,
          vertical: 2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: _logout,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Drawer (mobile/tablet)
  // ─────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _railBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          topLeft: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade700],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SchoolLogo(size: 44),
                const SizedBox(height: 10),
                const Text(
                  'نظام إدارة المدرسة القرآنية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.adminName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _navItems.length,
              itemBuilder: (context, i) {
                final item = _navItems[i];
                final selected = _selectedIndex == i;
                return ListTile(
                  leading: Icon(
                    selected ? item.selectedIcon : item.icon,
                    color: selected ? Colors.white : Colors.white60,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: selected
                      ? Colors.blue.shade700.withValues(alpha: 0.7)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  onTap: () {
                    setState(() => _selectedIndex = i);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: _logout,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

/// School logo circle
class _SchoolLogo extends StatelessWidget {
  const _SchoolLogo({this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text('📖', style: TextStyle(fontSize: size * 0.55)),
      ),
    );
  }
}

/// Notification bell with badge
class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
          tooltip: 'الإشعارات',
        ),
        if (count > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Profile chip with popup menu
class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.adminName,
    required this.onLogout,
    required this.onSettings,
  });
  final String adminName;
  final VoidCallback onLogout;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'الحساب',
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (v) {
        if (v == 'logout') onLogout();
        if (v == 'settings') onSettings();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adminName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Text(
                'مدير النظام',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18),
              SizedBox(width: 8),
              Text('الإعدادات'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('تسجيل الخروج', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              adminName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
