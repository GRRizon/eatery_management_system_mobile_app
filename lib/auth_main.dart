import 'package:flutter/material.dart';
import 'auth_login_screen.dart';
import 'auth_signup_screen.dart';
import 'auth_forgot_password_screen.dart';

class LoginSelectionScreen extends StatefulWidget {
  const LoginSelectionScreen({super.key});

  @override
  State<LoginSelectionScreen> createState() => _LoginSelectionScreenState();
}

class _LoginSelectionScreenState extends State<LoginSelectionScreen> {
  // Active selected role state
  String? selectedRole = 'Consumer';

  // Authentication mode state (Login, SignUp, ForgotPassword)
  String authMode = 'Login'; // 'Login', 'SignUp', 'ForgotPassword'

  // Design theme color palette
  final Color bgColor = const Color(0xFFF4F6F9);
  final Color textColor = const Color(0xFF2D3748);
  final Color subTextColor = const Color(0xFF718096);
  final Color buttonColor = const Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    // Determine layout mode based on screen width (Web/Tablet vs Mobile)
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Container(
              // Limit layout width on web to keep the design elegant
              constraints: BoxConstraints(maxWidth: isLargeScreen ? 1000 : 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Header Section ---
                  Text(
                    'Fashion Design\nStudio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 40 : 32,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AI-Powered Personalized Garment Design Platform',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Adaptive Dynamic Content Layout ---
                  isLargeScreen
                      ? _buildWebLayout() // Side-by-side view for Web / Desktop
                      : _buildMobileLayout(), // Stacked view for Mobile devices
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Layout optimized for mobile devices (Vertical stack)
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildRoleSelection(isLargeScreen: false),
        const SizedBox(height: 32),
        _buildLoginForm(),
      ],
    );
  }

  // Layout optimized for larger web/desktop screens (Side-by-side splits)
  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role cards taking left side space
        Expanded(flex: 5, child: _buildRoleSelection(isLargeScreen: true)),
        const SizedBox(width: 48),
        // Login form taking right side space
        Expanded(flex: 4, child: _buildLoginForm()),
      ],
    );
  }

  // Widget builder for Role Selection Section
  Widget _buildRoleSelection({required bool isLargeScreen}) {
    final List<Widget> cards = [
      RoleCard(
        title: 'Consumer',
        subtitle: 'Personal fashion design & customization',
        iconData: Icons.person_outline,
        gradientColors: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
        isSelected: selectedRole == 'Consumer',
        onTap: () => setState(() => selectedRole = 'Consumer'),
      ),
      RoleCard(
        title: 'Industrial Client',
        subtitle: 'Bulk orders & production workflows',
        iconData: Icons.business_outlined,
        gradientColors: const [Color(0xFFDA22FF), Color(0xFF9733EE)],
        isSelected: selectedRole == 'Industrial Client',
        onTap: () => setState(() => selectedRole = 'Industrial Client'),
      ),
      RoleCard(
        title: 'Administrator',
        subtitle: 'System management & analytics',
        iconData: Icons.shield_outlined,
        gradientColors: const [Color(0xFFFF512F), Color(0xFFDD2476)],
        isSelected: selectedRole == 'Administrator',
        onTap: () => setState(() => selectedRole = 'Administrator'),
      ),
    ];

    // Web uses a row for cards, while mobile stacks them vertically
    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cards
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: card,
                ),
              ),
            )
            .toList(),
      );
    } else {
      return Column(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: card,
              ),
            )
            .toList(),
      );
    }
  }

  // Widget builder for authentication form with tab switching
  Widget _buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tab Navigation ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAuthTab('Login', 'Login'),
                const SizedBox(width: 12),
                _buildAuthTab('Sign Up', 'SignUp'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Dynamic Content Based on Auth Mode ---
          if (authMode == 'Login')
            AuthLoginScreen(
              selectedRole: selectedRole ?? 'Consumer',
              onForgotPassword: () =>
                  setState(() => authMode = 'ForgotPassword'),
            ),
          if (authMode == 'SignUp')
            AuthSignupScreen(
              onBackToLogin: () => setState(() => authMode = 'Login'),
            ),
          if (authMode == 'ForgotPassword')
            AuthForgotPasswordScreen(
              onBackToLogin: () => setState(() => authMode = 'Login'),
            ),
        ],
      ),
    );
  }

  // Tab button widget
  Widget _buildAuthTab(String label, String mode) {
    final isActive = authMode == mode;
    return GestureDetector(
      onTap: () => setState(() => authMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? buttonColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? buttonColor : Colors.transparent,
              width: 3,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : subTextColor,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// Custom Widget: Role Cards featuring dynamic Hover & Selection Effects
// =========================================================================
class RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final List<Color> gradientColors;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.gradientColors,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          // Subtle pop-out animation trigger on desktop hover
          transform: Matrix4.diagonal3Values(
            isHovered ? 1.03 : 1.0,
            isHovered ? 1.03 : 1.0,
            1.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF1E2B3C)
                  : (isHovered ? Colors.grey.shade400 : Colors.grey.shade200),
              width: widget.isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? const Color(0xFF1E2B3C).withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: isHovered ? 0.08 : 0.02),
                blurRadius: isHovered ? 20 : 10,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(widget.iconData, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF718096),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
