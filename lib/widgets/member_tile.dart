import 'package:flutter/material.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;
  final VoidCallback onChatTap;

  const MemberTile({
    super.key,
    required this.member,
    required this.onTap,
    required this.onChatTap,
  });

  String get _initials {
    final f = member.firstName.isNotEmpty ? member.firstName[0] : '';
    final l = member.lastName.isNotEmpty ? member.lastName[0] : '';
    return (f + l).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isStaff = member.isStaff;
    final rate = member.attendancePercentage;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppTheme.divider, width: 0.8)),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: isStaff ? AppTheme.staffGold.withValues(alpha: 0.18) : AppTheme.primary.withValues(alpha: 0.14),
              child: Text(
                _initials,
                style: TextStyle(
                  color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isStaff ? AppTheme.accent.withValues(alpha: 0.3) : AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          member.role.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: isStaff ? AppTheme.staffGold : AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${member.idNumber} • ${member.phone}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Attendance Frequency Tag & Chat Action
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: rate >= 75
                        ? AppTheme.primary.withValues(alpha: 0.12)
                        : (rate >= 50 ? AppTheme.accent.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$rate% Att.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: rate >= 75
                          ? AppTheme.primary
                          : (rate >= 50 ? AppTheme.staffGold : Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: onChatTap,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 19,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
