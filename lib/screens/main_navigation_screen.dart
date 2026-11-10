import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'chats_page.dart';
import 'events_page.dart';
import 'bible_study_page.dart';
import 'assignments_page.dart';
import 'scripture_tms_screen.dart';
import 'bible_reader_screen.dart';
import 'directory_page.dart';
import 'profile_page.dart';
import 'staff_review_screen.dart';
import 'login_register_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final NavsRepository _repo = NavsRepository();
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(onNavigateTab: (idx) => setState(() => _currentIndex = idx)),
      const ChatsPage(),
      const BibleStudyPage(),
      const AssignmentsPage(),
      const EventsPage(),
    ];
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _repo.currentUser;
    final isStaff = currentUser.isStaff;

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      // Dashboard (index 0) has its own AppBar, Chats (1) also handles its own
      appBar: _currentIndex == 0 || _currentIndex == 1
          ? null
          : AppBar(
        backgroundColor: AppTheme.primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/navs.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.bookmark_added_rounded, size: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Navskach',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            // Role Badge
            InkWell(
              onTap: () {
                final newRole = isStaff ? 'Student' : 'Staff';
                _repo.switchRole(newRole);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Switched to $newRole Mode'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isStaff
                      ? AppTheme.staffGold.withValues(alpha: 0.12)
                      : AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(
                    color: isStaff
                        ? AppTheme.staffGold.withValues(alpha: 0.4)
                        : AppTheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentUser.role.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.sync_rounded,
                      size: 11,
                      color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: AppTheme.warning),
            tooltip: 'Scripture Memory (TMS)',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ScriptureTMSScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, color: AppTheme.info),
            tooltip: 'Bible Reader',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BibleReaderScreen()));
            },
          ),
          PopupMenuButton<String>(
            iconColor: AppTheme.textPrimary,
            onSelected: (val) {
              if (val == 'tms') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScriptureTMSScreen()));
              } else if (val == 'bible') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BibleReaderScreen()));
              } else if (val == 'directory') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectoryPage()));
              } else if (val == 'staff_review') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffReviewScreen()));
              } else if (val == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              } else if (val == 'toggle_role') {
                final newRole = isStaff ? 'Student' : 'Staff';
                _repo.switchRole(newRole);
              } else if (val == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginRegisterScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'toggle_role',
                child: Text('Switch to ${isStaff ? "Student" : "Staff"} Mode'),
              ),
              const PopupMenuItem(
                value: 'tms',
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, color: AppTheme.warning, size: 18),
                    SizedBox(width: 8),
                    Text('Scripture Memory (TMS)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bible',
                child: Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: AppTheme.info, size: 18),
                    SizedBox(width: 8),
                    Text('Digital Bible Reader'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'directory',
                child: Row(
                  children: [
                    Icon(Icons.people_outline, color: AppTheme.textSecondary, size: 18),
                    SizedBox(width: 8),
                    Text('Students Directory'),
                  ],
                ),
              ),
              if (isStaff)
                const PopupMenuItem(
                  value: 'staff_review',
                  child: Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: AppTheme.primary, size: 18),
                      SizedBox(width: 8),
                      Text('Staff Assignment Review'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: AppTheme.textSecondary, size: 18),
                    SizedBox(width: 8),
                    Text('Profile & Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.error, size: 18),
                    SizedBox(width: 8),
                    Text('Log Out', style: TextStyle(color: AppTheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(context, currentUser, isStaff),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2418).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppTheme.surface,
            surfaceTintColor: Colors.transparent,
            indicatorColor: AppTheme.primary.withValues(alpha: 0.12),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
              final isSelected = states.contains(WidgetState.selected);
              return GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
              final isSelected = states.contains(WidgetState.selected);
              return IconThemeData(
                size: 22,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            elevation: 0,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Badge(
                  label: const Text('3'),
                  backgroundColor: AppTheme.onlineGreen,
                  child: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                selectedIcon: Badge(
                  label: const Text('3'),
                  backgroundColor: AppTheme.onlineGreen,
                  child: const Icon(Icons.chat_bubble_rounded, color: AppTheme.primary),
                ),
                label: 'Messages',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded, color: AppTheme.primary),
                label: 'Attendance',
              ),
              const NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment_rounded, color: AppTheme.primary),
                label: 'Assignments',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: true,
                  backgroundColor: AppTheme.accent,
                  child: const Icon(Icons.campaign_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: true,
                  backgroundColor: AppTheme.accent,
                  child: const Icon(Icons.campaign_rounded, color: AppTheme.primary),
                ),
                label: 'Events',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, dynamic currentUser, bool isStaff) {
    return Drawer(
      backgroundColor: AppTheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/navs.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.bookmark_added_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navskach',
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Bible Study Community',
                        style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Role Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isStaff
                    ? AppTheme.staffGold.withValues(alpha: 0.10)
                    : AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: isStaff
                      ? AppTheme.staffGold.withValues(alpha: 0.3)
                      : AppTheme.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: isStaff ? AppTheme.staffGold : AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isStaff ? 'Staff Member' : 'Registered Student',
                    style: GoogleFonts.inter(
                      color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      final newRole = isStaff ? 'Student' : 'Staff';
                      _repo.switchRole(newRole);
                    },
                    child: Text(
                      'Toggle',
                      style: GoogleFonts.inter(
                        color: AppTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppTheme.divider),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerTile(
                    icon: Icons.home_rounded,
                    title: 'Home / Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.chat_bubble_rounded,
                    title: 'Messages & Channels',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.assignment_rounded,
                    title: 'Assignments & Review',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 3);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.star_rounded,
                    title: 'Scripture Memory (TMS)',
                    iconColor: AppTheme.warning,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ScriptureTMSScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.menu_book_rounded,
                    title: 'Digital Bible Reader',
                    iconColor: AppTheme.info,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const BibleReaderScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.calendar_month_rounded,
                    title: 'Upcoming Events',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 4);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.people_rounded,
                    title: 'Students & Members',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectoryPage()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.checklist_rounded,
                    title: 'Saturday Attendance',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentIndex = 2);
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.person_rounded,
                    title: 'Profile & Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.login_rounded,
                    title: 'Sign In / Register',
                    iconColor: AppTheme.accent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterScreen()));
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppTheme.divider),

            // User Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary,
                    child: Text(
                      currentUser.firstName.isNotEmpty ? currentUser.firstName[0] : 'N',
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.fullName,
                          style: GoogleFonts.inter(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentUser.email,
                          style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppTheme.error, size: 20),
                    tooltip: 'Log Out',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginRegisterScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: iconColor ?? AppTheme.textSecondary, size: 20),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: AppTheme.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
