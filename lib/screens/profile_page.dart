import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';
import '../widgets/attendance_gauge.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final NavsRepository _repo = NavsRepository();

  @override
  void initState() {
    super.initState();
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
    final user = _repo.currentUser;
    final isStaff = user.isStaff;

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Profile',
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: NavskachBackground(
        variant: NavskachBgVariant.detail,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          physics: const BouncingScrollPhysics(),
          children: [
            // ═══ PROFILE HEADER CARD ═══
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                children: [
                  // Avatar with gradient ring
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isStaff
                            ? [AppTheme.staffGold, AppTheme.accent]
                            : [AppTheme.primary, const Color(0xFF00A86B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: AppTheme.cardSurface,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: isStaff
                            ? AppTheme.staffGold.withValues(alpha: 0.12)
                            : AppTheme.primary.withValues(alpha: 0.12),
                        child: Text(
                          user.firstName.isNotEmpty ? user.firstName[0] : 'N',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isStaff
                            ? [AppTheme.staffGold.withValues(alpha: 0.2), AppTheme.accent.withValues(alpha: 0.15)]
                            : [AppTheme.primary.withValues(alpha: 0.15), AppTheme.primarySoft],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: isStaff
                            ? AppTheme.staffGold.withValues(alpha: 0.3)
                            : AppTheme.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      '${user.role.toUpperCase()} MODE',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ═══ ROLE SWITCHER CARD ═══
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.swap_horiz_rounded, color: AppTheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Role & Permission',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Switch between Student and Staff views',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRoleButton(
                          icon: Icons.school_rounded,
                          label: 'Student',
                          isActive: !isStaff,
                          activeColor: AppTheme.primary,
                          onTap: () => _repo.switchRole('Student'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildRoleButton(
                          icon: Icons.admin_panel_settings_rounded,
                          label: 'Staff',
                          isActive: isStaff,
                          activeColor: AppTheme.staffGold,
                          onTap: () => _repo.switchRole('Staff'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ═══ ATTENDANCE SECTION ═══
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Attendance & Ministry Track',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AttendanceGauge(
                  percentage: user.attendancePercentage,
                  attended: user.attendedSessions,
                  total: user.totalSessions,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ═══ DETAILS LIST ═══
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                children: [
                  _buildDetailTile(
                    icon: Icons.badge_outlined,
                    label: 'ID Number',
                    value: user.idNumber,
                    isFirst: true,
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.divider),
                  _buildDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: user.phone,
                  ),
                  const Divider(height: 1, indent: 56, color: AppTheme.divider),
                  _buildDetailTile(
                    icon: Icons.church_outlined,
                    label: 'Organization',
                    value: 'The Navigators Kenya (Kakamega)',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: AnimatedContainer(
        duration: AppTheme.animFast,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isActive ? activeColor.withValues(alpha: 0.5) : AppTheme.borderLight,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isActive ? activeColor : AppTheme.textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
