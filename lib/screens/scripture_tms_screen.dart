import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/navs_repository.dart';
import '../models/tms_verse.dart';
import '../theme/app_theme.dart';
import '../widgets/navskach_background.dart';

class ScriptureTMSScreen extends StatefulWidget {
  const ScriptureTMSScreen({super.key});

  @override
  State<ScriptureTMSScreen> createState() => _ScriptureTMSScreenState();
}

class _ScriptureTMSScreenState extends State<ScriptureTMSScreen> {
  int _selectedPack = 0; // 0: All, 1: Pack 1, 2: Pack 2
  String _selectedTopic = 'All';

  @override
  Widget build(BuildContext context) {
    final repo = NavsRepository();

    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) {
        final allVerses = repo.tmsVerses;
        final currentUserId = repo.currentUser.id;

        // Topics list
        final topics = ['All', ...allVerses.map((v) => v.topic).toSet()];

        // Filtered list
        final filteredVerses = allVerses.where((v) {
          if (_selectedPack != 0 && v.pack != _selectedPack) return false;
          if (_selectedTopic != 'All' && v.topic != _selectedTopic) return false;
          return true;
        }).toList();

        final totalMemorized = allVerses.where((v) => v.isMemorizedBy(currentUserId)).length;
        final progressPercent = allVerses.isEmpty ? 0 : ((totalMemorized / allVerses.length) * 100).round();

        final pack1Total = allVerses.where((v) => v.pack == 1).length;
        final pack1Memorized = allVerses.where((v) => v.pack == 1 && v.isMemorizedBy(currentUserId)).length;

        final pack2Total = allVerses.where((v) => v.pack == 2).length;
        final pack2Memorized = allVerses.where((v) => v.pack == 2 && v.isMemorizedBy(currentUserId)).length;

        return Scaffold(
          backgroundColor: AppTheme.primaryBg,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryBg,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Scripture Memory (TMS)',
              style: GoogleFonts.inter(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            iconTheme: const IconThemeData(color: AppTheme.textPrimary),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.style_outlined, color: AppTheme.warning, size: 20),
                ),
                tooltip: 'Flashcard Drill',
                onPressed: () {
                  if (filteredVerses.isNotEmpty) {
                    _openFlashcardModal(context, filteredVerses.first, filteredVerses, repo);
                  }
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: NavskachBackground(
            variant: NavskachBgVariant.list,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              children: [
                // Progress Banner
                _buildProgressBanner(
                  totalMemorized: totalMemorized,
                  totalVerses: allVerses.length,
                  progressPercent: progressPercent,
                  pack1Memorized: pack1Memorized,
                  pack1Total: pack1Total,
                  pack2Memorized: pack2Memorized,
                  pack2Total: pack2Total,
                ),

                const SizedBox(height: 18),

                // Pack Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPackChip(0, 'All Packs'),
                      const SizedBox(width: 8),
                      _buildPackChip(1, 'Pack 1 ($pack1Total)'),
                      const SizedBox(width: 8),
                      _buildPackChip(2, 'Pack 2 ($pack2Total)'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Topic Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: topics.map((t) {
                      final isSelected = _selectedTopic == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(
                            t,
                            style: GoogleFonts.inter(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          backgroundColor: AppTheme.cardSurface,
                          selectedColor: AppTheme.primary,
                          side: BorderSide(
                            color: isSelected ? AppTheme.primary : AppTheme.borderLight,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (_) => setState(() => _selectedTopic = t),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                // Verses Count Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Verses (${filteredVerses.length})',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Tap card for Flashcard practice',
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Verses List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredVerses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final v = filteredVerses[index];
                    final isMemorized = v.isMemorizedBy(currentUserId);

                    return InkWell(
                      onTap: () => _openFlashcardModal(context, v, filteredVerses, repo),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                          border: Border.all(
                            color: isMemorized
                                ? AppTheme.success.withValues(alpha: 0.4)
                                : AppTheme.borderLight,
                            width: isMemorized ? 1.5 : 0.8,
                          ),
                          boxShadow: AppTheme.subtleShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primarySoft,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Pack ${v.pack} · ${v.topic}',
                                    style: GoogleFonts.inter(
                                      color: AppTheme.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                if (isMemorized)
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Memorized',
                                        style: GoogleFonts.inter(
                                          color: AppTheme.success,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              v.reference,
                              style: GoogleFonts.inter(
                                color: AppTheme.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '"${v.text}"',
                              style: GoogleFonts.inter(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people_outline, size: 14, color: AppTheme.textMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${v.memorizedMemberIds.length} memorized this',
                                      style: GoogleFonts.inter(
                                        color: AppTheme.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isMemorized
                                        ? AppTheme.successSoft
                                        : AppTheme.primary,
                                    foregroundColor: isMemorized ? AppTheme.success : Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => repo.toggleVerseMemorized(v.id),
                                  child: Text(
                                    isMemorized ? 'Memorized ✓' : 'Mark Memorized',
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPackChip(int packNumber, String label) {
    final isSelected = _selectedPack == packNumber;
    return ChoiceChip(
      selected: isSelected,
      label: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      backgroundColor: AppTheme.cardSurface,
      selectedColor: AppTheme.primary,
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.borderLight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (_) => setState(() => _selectedPack = packNumber),
    );
  }

  Widget _buildProgressBanner({
    required int totalMemorized,
    required int totalVerses,
    required int progressPercent,
    required int pack1Memorized,
    required int pack1Total,
    required int pack2Memorized,
    required int pack2Total,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00694A), Color(0xFF008250), Color(0xFF00A86B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.star_rounded, color: AppTheme.warning, size: 30),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Scripture Progress',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$totalMemorized',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            ' / $totalVerses verses',
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Pack 1: $pack1Memorized/$pack1Total',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pack 2: $pack2Memorized/$pack2Total',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalVerses == 0 ? 0 : totalMemorized / totalVerses,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.warning),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$progressPercent% mastered',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFlashcardModal(
    BuildContext context,
    TMSVerse initialVerse,
    List<TMSVerse> allFiltered,
    NavsRepository repo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FlashcardModalView(
        initialVerse: initialVerse,
        verses: allFiltered,
        repo: repo,
      ),
    );
  }
}

class _FlashcardModalView extends StatefulWidget {
  final TMSVerse initialVerse;
  final List<TMSVerse> verses;
  final NavsRepository repo;

  const _FlashcardModalView({
    required this.initialVerse,
    required this.verses,
    required this.repo,
  });

  @override
  State<_FlashcardModalView> createState() => _FlashcardModalViewState();
}

class _FlashcardModalViewState extends State<_FlashcardModalView> {
  late int _currentIndex;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.verses.indexWhere((v) => v.id == widget.initialVerse.id);
    if (_currentIndex == -1) _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.verses[_currentIndex];
    final isMemorized = v.isMemorizedBy(widget.repo.currentUser.id);

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flashcard Drill',
                      style: GoogleFonts.inter(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Card ${_currentIndex + 1} of ${widget.verses.length}',
                      style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.divider),

          // Main Interactive Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () => setState(() => _showText = !_showText),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00694A), Color(0xFF008250), Color(0xFF00A86B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                    border: Border.all(
                      color: isMemorized
                          ? AppTheme.warning.withValues(alpha: 0.6)
                          : Colors.white12,
                      width: isMemorized ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.30),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${v.topic} · Pack ${v.pack}',
                          style: GoogleFonts.inter(
                            color: AppTheme.warning,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        v.reference,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      if (_showText) ...[
                        Text(
                          '"${v.text}"',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 16,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap card to hide text',
                          style: GoogleFonts.inter(color: Colors.white54, fontSize: 11),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app_outlined, color: AppTheme.warning, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Tap to recite & reveal scripture text',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Controls & Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border(top: BorderSide(color: AppTheme.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: _currentIndex > 0 ? AppTheme.textPrimary : AppTheme.textLight,
                    size: 20,
                  ),
                  onPressed: _currentIndex > 0
                      ? () {
                          setState(() {
                            _currentIndex--;
                            _showText = false;
                          });
                        }
                      : null,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMemorized
                        ? AppTheme.successSoft
                        : AppTheme.primary,
                    foregroundColor: isMemorized ? AppTheme.success : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    widget.repo.toggleVerseMemorized(v.id);
                    setState(() {});
                  },
                  icon: Icon(isMemorized ? Icons.check_circle : Icons.star_border, size: 18),
                  label: Text(
                    isMemorized ? 'Memorized ✓' : 'Mark Memorized',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _currentIndex < widget.verses.length - 1
                        ? AppTheme.textPrimary
                        : AppTheme.textLight,
                    size: 20,
                  ),
                  onPressed: _currentIndex < widget.verses.length - 1
                      ? () {
                          setState(() {
                            _currentIndex++;
                            _showText = false;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
