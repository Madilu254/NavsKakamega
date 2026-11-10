import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../data/navs_repository.dart';
import '../models/member.dart';
import '../theme/app_theme.dart';
import 'main_navigation_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final NavsRepository _repo = NavsRepository();
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  final _firstNameController = TextEditingController(text: 'Elvis');
  final _lastNameController = TextEditingController(text: 'Mowdi');
  final _emailController = TextEditingController(text: 'elvis.mowdi@navigators.org');
  final _phoneController = TextEditingController(text: '+254 712 345 678');
  final _idNumberController = TextEditingController(text: 'NAV/KK/2026/042');
  final _passwordController = TextEditingController(text: 'password123');

  String _selectedRole = 'Student';

  // Navskach Login Color Tokens — warm brand palette
  static const Color fieldBg = Color(0xFFF7F3ED);
  static const Color textDark = AppTheme.textPrimary;
  static const Color textMuted = AppTheme.textMuted;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_isRegisterMode) {
      final fn = _firstNameController.text.trim();
      final ln = _lastNameController.text.trim();
      final idNumber = _idNumberController.text.trim();
      final phone = _phoneController.text.trim();

      if (fn.isEmpty || ln.isEmpty || idNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required registration details.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final newMember = Member(
        id: const Uuid().v4(),
        idNumber: idNumber,
        firstName: fn,
        lastName: ln,
        username: fn.toLowerCase(),
        email: email,
        phone: phone.isNotEmpty ? phone : '+254 700 000 000',
        role: _selectedRole,
        attendedSessions: 7,
        totalSessions: 8,
      );

      await _repo.registerMember(newMember);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        children: [
          // Navskach Green Gradient Background
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF005C3A),
                  Color(0xFF008250),
                  Color(0xFF00A86B),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Radiant Glow Orb behind header
                Positioned(
                  top: 30,
                  left: MediaQuery.of(context).size.width * 0.5 - 100,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF00E08A).withValues(alpha: 0.35),
                          const Color(0xFF00A86B).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Header Content Area
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom Circular Back Button
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 17),
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                                );
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Center Solstice / Navigators Branding
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Navskach',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Kakamega Bible Study Community',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sliding White Card Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.68,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 25,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 28, right: 28, top: 20, bottom: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Custom Divider Handle
                    Center(
                      child: Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3E6EB),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign In / Register Title
                    Text(
                      _isRegisterMode ? 'Create Account' : 'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isRegisterMode
                          ? 'Join the Navigators Kakamega community'
                          : 'Welcome back! Let\'s grow together.',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Role Picker in Register Mode
                    if (_isRegisterMode) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Student')),
                              selected: _selectedRole == 'Student',
                              selectedColor: AppTheme.primary,
                              backgroundColor: fieldBg,
                              labelStyle: GoogleFonts.inter(
                                color: _selectedRole == 'Student' ? Colors.white : textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              onSelected: (val) {
                                if (val) setState(() => _selectedRole = 'Student');
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Staff Leader')),
                              selected: _selectedRole == 'Staff',
                              selectedColor: AppTheme.accent,
                              backgroundColor: fieldBg,
                              labelStyle: GoogleFonts.inter(
                                color: _selectedRole == 'Staff' ? Colors.white : textDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              onSelected: (val) {
                                if (val) setState(() => _selectedRole = 'Staff');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // First & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: _buildSunsetField(
                              controller: _firstNameController,
                              hint: 'First Name',
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSunsetField(
                              controller: _lastNameController,
                              hint: 'Last Name',
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Reg / ID Number
                      _buildSunsetField(
                        controller: _idNumberController,
                        hint: _selectedRole == 'Staff' ? 'Staff ID (e.g. STF-01)' : 'Student Reg (NAV/KK/042)',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 14),

                      // WhatsApp Phone
                      _buildSunsetField(
                        controller: _phoneController,
                        hint: 'WhatsApp Number (+254...)',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Email Address Field
                    _buildSunsetField(
                      controller: _emailController,
                      hint: 'Email address',
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 14),

                    // Password Field
                    _buildSunsetField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot Password Button
                    if (!_isRegisterMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset instructions sent to your email.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              color: AppTheme.accent,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Sign In / Register Gradient Button (SignInBTN)
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primary, AppTheme.primaryLight],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isRegisterMode ? 'Create Account' : 'Sign In',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Social Circles Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialCircle(
                          icon: 'G',
                          color: const Color(0xFFEA4335),
                          isText: true,
                        ),
                        const SizedBox(width: 18),
                        _buildSocialCircle(
                          iconData: Icons.apple,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 18),
                        _buildSocialCircle(
                          icon: 'f',
                          color: const Color(0xFF1877F2),
                          isText: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Create Account Toggle
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() => _isRegisterMode = !_isRegisterMode),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(fontSize: 13, color: textMuted),
                            children: [
                              TextSpan(
                                text: _isRegisterMode ? 'Already have an account? ' : 'New here? ',
                              ),
                              TextSpan(
                                text: _isRegisterMode ? 'Sign In' : 'Create Account',
                                style: GoogleFonts.inter(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunsetField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEFF2), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: textDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 13.5, color: textMuted),
          prefixIcon: Icon(icon, color: AppTheme.accent, size: 19),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSocialCircle({
    String? icon,
    IconData? iconData,
    required Color color,
    bool isText = false,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: isText
            ? Text(
                icon ?? '',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: icon == 'G' ? 'sans-serif' : 'serif',
                ),
              )
            : Icon(iconData, color: color, size: 22),
      ),
    );
  }
}
