import 'package:flutter/material.dart';
import '../data/navs_repository.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';
import 'chat_room_screen.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final NavsRepository _repo = NavsRepository();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  // Conversation Items matching user reference structure
  List<Map<String, dynamic>> _getConversations() {
    final isStaff = _repo.isStaff;

    return [
      {
        'id': 'general',
        'title': 'William Conrad',
        'groupName': 'General Fellowship',
        'subtitle': 'Typing...',
        'isTyping': true,
        'hasMissedCall': false,
        'time': 'Just now',
        'unread': 1,
        'avatarColor': const Color(0xFF2E7D32),
        'avatarLetter': 'W',
        'category': 'Fellowship',
        'isChannel': true,
        'channelId': 'general',
        'staffOnly': false,
      },
      {
        'id': 'prayer',
        'title': 'James Tonky',
        'groupName': 'Prayer Requests',
        'subtitle': 'Missed Call',
        'isTyping': false,
        'hasMissedCall': true,
        'time': '4:30 AM',
        'unread': 2,
        'avatarColor': const Color(0xFF1E88E5),
        'avatarLetter': 'J',
        'category': 'Fellowship',
        'isChannel': true,
        'channelId': 'prayer',
        'staffOnly': false,
      },
      {
        'id': 'saturday_bs',
        'title': 'Brittany Conrad',
        'groupName': 'Saturday Bible Study',
        'subtitle': 'I believe that this is the best interpretation of Romans 8:28...',
        'isTyping': false,
        'hasMissedCall': false,
        'time': '11:30 AM',
        'unread': 1,
        'avatarColor': const Color(0xFF8E24AA),
        'avatarLetter': 'B',
        'category': 'Bible Study',
        'isChannel': true,
        'channelId': 'general',
        'staffOnly': false,
      },
      {
        'id': 'announcements',
        'title': 'Navs Kakamega Updates',
        'groupName': 'Announcements',
        'subtitle': 'Annual Discipleship Retreat registration is now open!',
        'isTyping': false,
        'hasMissedCall': false,
        'time': '8:30 AM',
        'unread': 0,
        'avatarColor': const Color(0xFFE65100),
        'avatarLetter': '📢',
        'category': 'Announcements',
        'isChannel': true,
        'channelId': 'announcements',
        'staffOnly': false,
      },
      {
        'id': 'retreat_planning',
        'title': 'Kakamega Retreat • 2026',
        'groupName': 'Special Project',
        'subtitle': 'Hey! How was your day? Ready for Friday prep? 🔥🔥🔥',
        'isTyping': false,
        'hasMissedCall': false,
        'time': '6:24 PM',
        'unread': 0,
        'avatarColor': const Color(0xFF00897B),
        'avatarLetter': '⛺',
        'category': 'Fellowship',
        'isChannel': true,
        'channelId': 'general',
        'staffOnly': false,
      },
      {
        'id': 'tms_drill_group',
        'title': 'BookTok & TMS Drills',
        'groupName': 'Memory Verse Squad',
        'subtitle': 'If you could travel anywhere in the Word, which book would you pick?',
        'isTyping': false,
        'hasMissedCall': false,
        'time': 'Yesterday',
        'unread': 0,
        'avatarColor': const Color(0xFF3949AB),
        'avatarLetter': '📖',
        'category': 'Bible Study',
        'isChannel': true,
        'channelId': 'general',
        'staffOnly': false,
      },
      {
        'id': 'staff',
        'title': 'Staff Preparatory Forum',
        'groupName': 'Leadership Team',
        'subtitle': isStaff ? 'Friday 5:00 PM agenda and lesson outline' : 'Locked for staff leaders only',
        'isTyping': false,
        'hasMissedCall': false,
        'time': 'Yesterday',
        'unread': isStaff ? 3 : 0,
        'avatarColor': AppTheme.error,
        'avatarLetter': '🔒',
        'category': 'Staff',
        'isChannel': true,
        'channelId': 'staff',
        'staffOnly': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final members = _repo.members;
    final allConversations = _getConversations();

    // Filter conversations by category and search
    final filteredConversations = allConversations.where((c) {
      final matchesCategory = _selectedCategory == 'All' || c['category'] == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          (c['title'] as String).toLowerCase().contains(query) ||
          (c['subtitle'] as String).toLowerCase().contains(query) ||
          (c['groupName'] as String).toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    // Calculate total unread
    int totalUnread = 0;
    for (var c in allConversations) {
      totalUnread += (c['unread'] as int);
    }
    if (totalUnread == 0) totalUnread = 12; // default badge if 0

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        children: [
          Column(
            children: [
              // --- TOP SECTION: DEEP FOREST GREEN HEADER & STORIES ---
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Title, Unread Pill Badge & Action Buttons
                      Row(
                        children: [
                          const Text(
                            'Messages',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Unread Count Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38D39F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$totalUnread',
                              style: const TextStyle(
                                color: Color(0xFF0C4524),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Search Action Button
                          _buildHeaderIconButton(
                            icon: _isSearching ? Icons.close_rounded : Icons.search_rounded,
                            onTap: () {
                              setState(() {
                                _isSearching = !_isSearching;
                                if (!_isSearching) {
                                  _searchQuery = '';
                                  _searchController.clear();
                                }
                              });
                            },
                          ),

                          const SizedBox(width: 10),

                          // Profile/Community Action Button
                          _buildHeaderIconButton(
                            icon: Icons.person_outline_rounded,
                            onTap: () => _showCommunityMembersModal(context, members),
                          ),
                        ],
                      ),

                      // Optional Animated Search Bar
                      if (_isSearching) ...[
                        const SizedBox(height: 12),
                        Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(color: Colors.white, fontSize: 13.5),
                            decoration: const InputDecoration(
                              hintText: 'Search chats, disciples or keywords...',
                              hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                              prefixIcon: Icon(Icons.search, color: Colors.white70, size: 18),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onChanged: (val) => setState(() => _searchQuery = val),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // --- HORIZONTAL STORIES & ACTIVE DISCIPLES ROW ---
                      SizedBox(
                        height: 84,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: members.length + 1,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // "Your Story" Item
                              return _buildYourStoryItem();
                            }
                            final member = members[index - 1];
                            return _buildMemberStoryItem(member);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- BOTTOM SECTION: CURVED WHITE CARD WITH CHATS ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 18,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),

                      // Horizontal Category Filter Pills
                      SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: [
                            _buildCategoryPill('All', totalCount: allConversations.length),
                            const SizedBox(width: 8),
                            _buildCategoryPill('Fellowship', totalCount: 32),
                            const SizedBox(width: 8),
                            _buildCategoryPill('Bible Study', totalCount: 14),
                            const SizedBox(width: 8),
                            _buildCategoryPill('Announcements', totalCount: 4),
                            const SizedBox(width: 8),
                            _buildCategoryPill('Staff', totalCount: 1, isLocked: !_repo.isStaff),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Color(0xFFF0F2F5)),

                      // Chat Conversations List
                      Expanded(
                        child: filteredConversations.isEmpty
                            ? Center(
                                child: Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No messages found matching "$_searchQuery"'
                                      : 'No messages in this folder',
                                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                                ),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(top: 8, bottom: 84),
                                itemCount: filteredConversations.length,
                                separatorBuilder: (_, _) => const Padding(
                                  padding: EdgeInsets.only(left: 78, right: 18),
                                  child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                                ),
                                itemBuilder: (context, index) {
                                  final item = filteredConversations[index];
                                  return _buildConversationTile(context, item);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Button (FAB) for New Chat / Message
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              elevation: 4,
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () => _showNewMessageDialog(context, members),
              child: const Icon(Icons.edit_rounded, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // Circular Translucent Header Button
  Widget _buildHeaderIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 19),
      ),
    );
  }

  // "Your Story" Item in Stories Row
  Widget _buildYourStoryItem() {
    final user = _repo.currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  user.firstName.isNotEmpty ? user.firstName[0] : 'Y',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Your Story',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Active Member Story Item with Neon Green Glow Ring
  Widget _buildMemberStoryItem(Member member) {
    // Generate brief display name e.g. "P.Judge"
    final initials = '${member.firstName[0]}.${member.lastName}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            // Glowing neon green story ring
            Container(
              width: 54,
              height: 54,
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF38D39F), width: 2.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38D39F).withValues(alpha: 0.45),
                    blurRadius: 6,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: member.isStaff
                    ? AppTheme.error.withValues(alpha: 0.8)
                    : const Color(0xFF1E3A2F),
                child: Text(
                  member.firstName[0] + (member.lastName.isNotEmpty ? member.lastName[0] : ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Online status dot
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 58,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Horizontal Category Pill with Count Badge
  Widget _buildCategoryPill(String label, {required int totalCount, bool isLocked = false}) {
    final isSelected = _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Staff Forum is restricted to Staff Leaders.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        setState(() => _selectedCategory = label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF4F6F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFE5E7EB),
            width: isSelected ? 1.4 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$totalCount',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Single Conversation Tile
  Widget _buildConversationTile(BuildContext context, Map<String, dynamic> item) {
    final channelId = item['channelId'] as String;
    final isLocked = item['staffOnly'] == true && !_repo.isStaff;
    final isTyping = item['isTyping'] == true;
    final hasMissedCall = item['hasMissedCall'] == true;
    final unread = item['unread'] as int;

    // Fetch dynamic last message if available from repo
    final repoLastMsg = _repo.getLastMessageForChannel(channelId);
    final displaySubtitle = repoLastMsg != null && !isTyping && !hasMissedCall
        ? repoLastMsg.text
        : (item['subtitle'] as String);

    return InkWell(
      onTap: () {
        if (isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Staff Preparatory Forum is restricted to Staff Leaders.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
              channelId: channelId,
              channelTitle: item['title'] as String,
              channelSubtitle: item['groupName'] as String,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        child: Row(
          children: [
            // Contact Avatar with Online Dot
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: item['avatarColor'] as Color,
                  child: Text(
                    item['avatarLetter'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // Name, Group Tag, and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item['time'] as String,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                          color: unread > 0 ? const Color(0xFF2E7D32) : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3.5),

                  Row(
                    children: [
                      // Typing indicator or Missed call icon
                      if (isTyping) ...[
                        const Text(
                          'Typing...',
                          style: TextStyle(
                            color: Color(0xFF25D366),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ] else if (hasMissedCall) ...[
                        const Icon(Icons.phone_missed_rounded, color: Color(0xFFEF4444), size: 14),
                        const SizedBox(width: 4),
                        const Text(
                          'Missed Call',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Text(
                            displaySubtitle,
                            style: TextStyle(
                              color: unread > 0 ? const Color(0xFF374151) : const Color(0xFF6B7280),
                              fontSize: 13,
                              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],

                      // Unread Badge or Double Checkmark
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] else if (!hasMissedCall && !isTyping) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all_rounded, color: Color(0xFF389FD6), size: 16),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compose New Message Bottom Sheet Dialog
  void _showNewMessageDialog(BuildContext context, List<Member> members) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Conversation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select a channel or direct disciple to chat with',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final m = members[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: m.isStaff ? AppTheme.error : AppTheme.primary,
                        child: Text(
                          m.firstName[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${m.role} · ${m.phone}'),
                      trailing: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Color(0xFF25D366)),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatRoomScreen(
                              channelId: 'general',
                              channelTitle: m.fullName,
                              channelSubtitle: 'Direct Discipleship Chat · ${m.role}',
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
        );
      },
    );
  }

  // View All Disciples / Community Members Modal
  void _showCommunityMembersModal(BuildContext context, List<Member> members) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Disciples & Leaders (${members.length})',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: Color(0xFF25D366)),
                        SizedBox(width: 5),
                        Text(
                          'All Active',
                          style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final m = members[i];
                    return ListTile(
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: m.isStaff ? AppTheme.error : AppTheme.primary,
                            child: Text(
                              m.firstName[0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${m.idNumber} · ${m.phone}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: m.isStaff
                              ? AppTheme.error.withValues(alpha: 0.1)
                              : AppTheme.staffGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          m.role,
                          style: TextStyle(
                            color: m.isStaff ? AppTheme.error : const Color(0xFF9E7416),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
