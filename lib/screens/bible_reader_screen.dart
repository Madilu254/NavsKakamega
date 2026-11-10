import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  String _selectedBook = 'John';
  int _selectedChapter = 3;
  int? _highlightedVerse;
  bool _loading = false;
  List<Map<String, dynamic>> _verses = [];

  static const List<String> allBooks = [
    // Old Testament
    "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
    "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel",
    "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra",
    "Nehemiah", "Esther", "Job", "Psalms", "Proverbs",
    "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations",
    "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
    "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk",
    "Zephaniah", "Haggai", "Zechariah", "Malachi",
    // New Testament
    "Matthew", "Mark", "Luke", "John", "Acts",
    "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians",
    "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians",
    "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews",
    "James", "1 Peter", "2 Peter", "1 John", "2 John",
    "3 John", "Jude", "Revelation",
  ];

  static const Map<String, int> chaptersPerBook = {
    "Genesis": 50, "Exodus": 40, "Leviticus": 27, "Numbers": 36, "Deuteronomy": 34,
    "Joshua": 24, "Judges": 21, "Ruth": 4, "1 Samuel": 31, "2 Samuel": 24,
    "1 Kings": 22, "2 Kings": 25, "1 Chronicles": 29, "2 Chronicles": 36, "Ezra": 10,
    "Nehemiah": 13, "Esther": 10, "Job": 42, "Psalms": 150, "Proverbs": 31,
    "Ecclesiastes": 12, "Song of Solomon": 8, "Isaiah": 66, "Jeremiah": 52, "Lamentations": 5,
    "Ezekiel": 48, "Daniel": 12, "Hosea": 14, "Joel": 3, "Amos": 9,
    "Obadiah": 1, "Jonah": 4, "Micah": 7, "Nahum": 3, "Habakkuk": 3,
    "Zephaniah": 3, "Haggai": 2, "Zechariah": 14, "Malachi": 4,
    "Matthew": 28, "Mark": 16, "Luke": 24, "John": 21, "Acts": 28,
    "Romans": 16, "1 Corinthians": 16, "2 Corinthians": 13, "Galatians": 6, "Ephesians": 6,
    "Philippians": 4, "Colossians": 4, "1 Thessalonians": 5, "2 Thessalonians": 3,
    "1 Timothy": 6, "2 Timothy": 4, "Titus": 3, "Philemon": 1, "Hebrews": 13,
    "James": 5, "1 Peter": 5, "2 Peter": 3, "1 John": 5, "2 John": 1,
    "3 John": 1, "Jude": 1, "Revelation": 22,
  };

  // Pre-bundled offline passages for reliable offline reading
  static final Map<String, List<Map<String, dynamic>>> offlineChapters = {
    'John_3': [
      {'verse': 1, 'text': 'There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:'},
      {'verse': 2, 'text': 'The same came to Jesus by night, and said unto him, Rabbi, we know that thou art a teacher come from God: for no man can do these miracles that thou doest, except God be with him.'},
      {'verse': 3, 'text': 'Jesus answered and said unto him, Verily, verily, I say unto thee, Except a man be born again, he cannot see the kingdom of God.'},
      {'verse': 16, 'text': 'For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.'},
      {'verse': 17, 'text': 'For God sent not his Son into the world to condemn the world; but that the world through him might be saved.'},
      {'verse': 18, 'text': 'He that believeth on him is not condemned: but he that believeth not is condemned already, because he hath not believed in the name of the only begotten Son of God.'},
      {'verse': 36, 'text': 'He that believeth on the Son hath everlasting life: and he that believeth not the Son shall not see life; but the wrath of God abideth on him.'},
    ],
    'Romans_8': [
      {'verse': 1, 'text': 'There is therefore now no condemnation to them which are in Christ Jesus, who walk not after the flesh, but after the Spirit.'},
      {'verse': 2, 'text': 'For the law of the Spirit of life in Christ Jesus hath made me free from the law of sin and death.'},
      {'verse': 14, 'text': 'For as many as are led by the Spirit of God, they are the sons of God.'},
      {'verse': 28, 'text': 'And we know that all things work together for good to them that love God, to them who are the called according to his purpose.'},
      {'verse': 31, 'text': 'What shall we then say to these things? If God be for us, who can be against us?'},
      {'verse': 37, 'text': 'Nay, in all these things we are more than conquerors through him that loved us.'},
      {'verse': 38, 'text': 'For I am persuaded, that neither death, nor life, nor angels, nor principalities, nor powers, nor things present, nor things to come,'},
      {'verse': 39, 'text': 'Nor height, nor depth, nor any other creature, shall be able to separate us from the love of God, which is in Christ Jesus our Lord.'},
    ],
    'Proverbs_3': [
      {'verse': 1, 'text': 'My son, forget not my law; but let thine heart keep my commandments:'},
      {'verse': 2, 'text': 'For length of days, and long life, and peace, shall they add to thee.'},
      {'verse': 5, 'text': 'Trust in the Lord with all thine heart; and lean not unto thine own understanding.'},
      {'verse': 6, 'text': 'In all thy ways acknowledge him, and he shall direct thy paths.'},
      {'verse': 7, 'text': 'Be not wise in thine own eyes: fear the Lord, and depart from evil.'},
    ],
    'Philippians_4': [
      {'verse': 4, 'text': 'Rejoice in the Lord alway: and again I say, Rejoice.'},
      {'verse': 6, 'text': 'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.'},
      {'verse': 7, 'text': 'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.'},
      {'verse': 13, 'text': 'I can do all things through Christ which strengtheneth me.'},
      {'verse': 19, 'text': 'But my God shall supply all your need according to his riches in glory by Christ Jesus.'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadChapter(_selectedBook, _selectedChapter);
  }

  Future<void> _loadChapter(String book, int chapter) async {
    setState(() {
      _loading = true;
      _verses = [];
      _highlightedVerse = null;
    });

    final cacheKey = '${book}_$chapter';
    if (offlineChapters.containsKey(cacheKey)) {
      setState(() {
        _verses = offlineChapters[cacheKey]!;
        _loading = false;
      });
      return;
    }

    try {
      final encodedBook = Uri.encodeComponent(book);
      final res = await http.get(
        Uri.parse('https://bible-api.com/$encodedBook+$chapter?translation=kjv'),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        final rawVerses = data['verses'];
        if (rawVerses is List) {
          setState(() {
            _verses = rawVerses.map((v) => {
              'verse': v['verse'],
              'text': v['text'].toString().trim(),
            }).toList();
            _loading = false;
          });
          return;
        }
      }
      throw Exception('Could not parse chapter');
    } catch (_) {
      // Fallback: create mock chapter verses or show offline notice
      setState(() {
        _verses = [
          {
            'verse': 1,
            'text': 'All Scripture is God-breathed and profitable for teaching, for reproof, for correction, and for instruction in righteousness (2 Timothy 3:16).',
          },
          {
            'verse': 2,
            'text': 'Reading $book chapter $chapter. Connect to internet for full text or choose John 3, Romans 8, Proverbs 3, or Philippians 4 for offline mode.',
          },
        ];
        _loading = false;
      });
    }
  }

  void _nextChapter() {
    final max = chaptersPerBook[_selectedBook] ?? 1;
    if (_selectedChapter < max) {
      setState(() => _selectedChapter++);
      _loadChapter(_selectedBook, _selectedChapter);
    } else {
      final idx = allBooks.indexOf(_selectedBook);
      if (idx < allBooks.length - 1) {
        setState(() {
          _selectedBook = allBooks[idx + 1];
          _selectedChapter = 1;
        });
        _loadChapter(_selectedBook, _selectedChapter);
      }
    }
  }

  void _prevChapter() {
    if (_selectedChapter > 1) {
      setState(() => _selectedChapter--);
      _loadChapter(_selectedBook, _selectedChapter);
    } else {
      final idx = allBooks.indexOf(_selectedBook);
      if (idx > 0) {
        final prevBook = allBooks[idx - 1];
        final max = chaptersPerBook[prevBook] ?? 1;
        setState(() {
          _selectedBook = prevBook;
          _selectedChapter = max;
        });
        _loadChapter(_selectedBook, _selectedChapter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxChapters = chaptersPerBook[_selectedBook] ?? 1;

    return Scaffold(
      backgroundColor: AppTheme.bgSoft,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        title: InkWell(
          onTap: _showBookPickerModal,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_stories, color: AppTheme.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  _selectedBook,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary, size: 18),
              ],
            ),
          ),
        ),
        actions: [
          // Chapter navigation
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.textSecondary),
            onPressed: _prevChapter,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.cardSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedChapter,
                dropdownColor: AppTheme.cardSurface,
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary, size: 16),
                style: GoogleFonts.inter(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                items: List.generate(maxChapters, (i) => i + 1)
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text('Ch. $c'),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedChapter = val);
                    _loadChapter(_selectedBook, _selectedChapter);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
            onPressed: _nextChapter,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppTheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading scripture...',
                    style: GoogleFonts.inter(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                // Chapter Heading
                Center(
                  child: Column(
                    children: [
                      Text(
                        _selectedBook.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chapter $_selectedChapter',
                        style: GoogleFonts.inter(
                          color: AppTheme.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 40,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Verses
                ..._verses.map((v) {
                  final verseNum = v['verse'];
                  final text = v['text'];
                  final isHighlighted = _highlightedVerse == verseNum;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _highlightedVerse = isHighlighted ? null : verseNum;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? AppTheme.warning.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isHighlighted
                            ? Border.all(color: AppTheme.warning.withValues(alpha: 0.4))
                            : null,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$verseNum  ',
                              style: GoogleFonts.inter(
                                color: isHighlighted ? AppTheme.accent : AppTheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: text,
                              style: GoogleFonts.inter(
                                color: AppTheme.textPrimary,
                                fontSize: 15.5,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 40),

                // Chapter Navigation Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.cardSurface,
                        foregroundColor: AppTheme.textSecondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppTheme.borderLight),
                        ),
                      ),
                      onPressed: _prevChapter,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: Text('Previous', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _nextChapter,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text('Next Chapter', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }

  void _showBookPickerModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookPickerModal(
        selectedBook: _selectedBook,
        onSelectBook: (book) {
          Navigator.pop(ctx);
          setState(() {
            _selectedBook = book;
            _selectedChapter = 1;
          });
          _loadChapter(book, 1);
        },
      ),
    );
  }
}

class _BookPickerModal extends StatefulWidget {
  final String selectedBook;
  final Function(String) onSelectBook;

  const _BookPickerModal({
    required this.selectedBook,
    required this.onSelectBook,
  });

  @override
  State<_BookPickerModal> createState() => _BookPickerModalState();
}

class _BookPickerModalState extends State<_BookPickerModal> {
  String _search = '';
  int _testamentIndex = 0; // 0: Old Testament, 1: New Testament

  @override
  Widget build(BuildContext context) {
    final otBooks = _BibleReaderScreenState.allBooks.take(39).toList();
    final ntBooks = _BibleReaderScreenState.allBooks.skip(39).toList();

    final currentList = _testamentIndex == 0 ? otBooks : ntBooks;
    final filtered = currentList.where((b) => b.toLowerCase().contains(_search.toLowerCase())).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Scripture Book',
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: GoogleFonts.inter(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search book (e.g. John, Romans)...',
                hintStyle: GoogleFonts.inter(color: AppTheme.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.bgSoft,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          const SizedBox(height: 12),
          // Testament Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Center(
                      child: Text(
                        'Old Testament (39)',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                    selected: _testamentIndex == 0,
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.bgSoft,
                    labelStyle: GoogleFonts.inter(
                      color: _testamentIndex == 0 ? Colors.white : AppTheme.textSecondary,
                      fontWeight: _testamentIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      color: _testamentIndex == 0 ? AppTheme.primary : AppTheme.borderLight,
                    ),
                    onSelected: (_) => setState(() => _testamentIndex = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Center(
                      child: Text(
                        'New Testament (27)',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                    selected: _testamentIndex == 1,
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.bgSoft,
                    labelStyle: GoogleFonts.inter(
                      color: _testamentIndex == 1 ? Colors.white : AppTheme.textSecondary,
                      fontWeight: _testamentIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      color: _testamentIndex == 1 ? AppTheme.primary : AppTheme.borderLight,
                    ),
                    onSelected: (_) => setState(() => _testamentIndex = 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppTheme.divider),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final b = filtered[index];
                final isSelected = b == widget.selectedBook;
                return InkWell(
                  onTap: () => widget.onSelectBook(b),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.bgSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.borderLight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        b,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
  }
}
