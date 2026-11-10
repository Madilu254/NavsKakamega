import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../data/navs_repository.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';
import '../widgets/member_tile.dart';
import '../widgets/empty_state.dart';
import 'chat_room_screen.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final NavsRepository _repo = NavsRepository();
  String _searchQuery = '';
  String _roleFilter = 'All';

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

  void _showAddMemberDialog() {
    final firstNameCtrl = TextEditingController();
    final lastNameCtrl = TextEditingController();
    final idCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedRole = 'Student';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Add New Member',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Register a student or staff member',
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                      ),
                      items: ['Student', 'Staff']
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setSheetState(() => selectedRole = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: firstNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: Icon(Icons.person_rounded, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: lastNameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: idCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ID Number',
                        hintText: 'e.g. NAV/KK/055',
                        prefixIcon: Icon(Icons.badge_rounded, size: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone_rounded, size: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final fn = firstNameCtrl.text.trim();
                              final ln = lastNameCtrl.text.trim();
                              final idNumber = idCtrl.text.trim();

                              if (fn.isEmpty || ln.isEmpty || idNumber.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter name and ID.')),
                                );
                                return;
                              }

                              final email = emailCtrl.text.trim();
                              final phone = phoneCtrl.text.trim();

                              final newMember = Member(
                                id: const Uuid().v4(),
                                idNumber: idNumber,
                                firstName: fn,
                                lastName: ln,
                                username: '${fn.toLowerCase()}_${ln.toLowerCase()}',
                                email: email.isNotEmpty ? email : '$fn.$ln@navigators.org',
                                phone: phone.isNotEmpty ? phone : '+254 700 000 000',
                                role: selectedRole,
                                attendedSessions: 1,
                                totalSessions: 8,
                              );

                              _repo.registerMember(newMember);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$selectedRole "$fn $ln" added!'),
                                  backgroundColor: AppTheme.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_add_rounded, size: 18),
                            label: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final members = _repo.members.where((m) {
      final matchesRole = _roleFilter == 'All' || m.role.toLowerCase() == _roleFilter.toLowerCase();
      final q = _searchQuery.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          m.fullName.toLowerCase().contains(q) ||
          m.idNumber.toLowerCase().contains(q) ||
          m.phone.toLowerCase().contains(q);
      return matchesRole && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryBg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Members Directory',
          style: GoogleFonts.inter(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMemberDialog,
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Add Member', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: NavskachBackground(
        variant: NavskachBgVariant.list,
        child: Column(
          children: [
            // ═══ SEARCH & FILTER ═══
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted, size: 20),
                      hintText: 'Search by name, ID, or phone...',
                      hintStyle: GoogleFonts.inter(fontSize: 13.5, color: AppTheme.textMuted),
                      filled: true,
                      fillColor: AppTheme.bgSoft,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ['All', 'Student', 'Staff'].map((role) {
                      final isSelected = _roleFilter == role;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            role == 'All' ? 'All (${_repo.members.length})' : role,
                          ),
                          selected: isSelected,
                          selectedColor: AppTheme.primary,
                          labelStyle: GoogleFonts.inter(
                            color: isSelected ? Colors.white : AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                          backgroundColor: AppTheme.bgSoft,
                          side: BorderSide(
                            color: isSelected ? AppTheme.primary : AppTheme.borderLight,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _roleFilter = role);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // ═══ MEMBERS LIST ═══
            Expanded(
              child: members.isEmpty
                  ? const Center(
                      child: EmptyState(
                        icon: Icons.people_outline_rounded,
                        title: 'No Members Found',
                        subtitle: 'Try adjusting your search or filter.',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final m = members[index];
                        return MemberTile(
                          member: m,
                          onTap: () => _showMemberProfileModal(m),
                          onChatTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomScreen(
                                  channelId: 'kakamega_general',
                                  channelTitle: m.fullName,
                                  channelSubtitle: '${m.role} • ${m.phone}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberProfileModal(Member m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: m.isStaff
                          ? [AppTheme.staffGold, AppTheme.accent]
                          : [AppTheme.primary, const Color(0xFF00A86B)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.surface,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: m.isStaff
                          ? AppTheme.staffGold.withValues(alpha: 0.12)
                          : AppTheme.primary.withValues(alpha: 0.12),
                      child: Text(
                        m.firstName.isNotEmpty ? m.firstName[0] : 'N',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: m.isStaff ? AppTheme.staffGold : AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  m.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: m.isStaff
                        ? AppTheme.staffGold.withValues(alpha: 0.15)
                        : AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    m.role.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      color: m.isStaff ? AppTheme.staffGold : AppTheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileRow(Icons.badge_outlined, 'ID', m.idNumber),
                _buildProfileRow(Icons.phone_outlined, 'Phone', m.phone),
                _buildProfileRow(Icons.email_outlined, 'Email', m.email),
                _buildProfileRow(
                  Icons.event_available_rounded,
                  'Attendance',
                  '${m.attendancePercentage}% (${m.attendedSessions}/${m.totalSessions})',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 17),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 10.5, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
