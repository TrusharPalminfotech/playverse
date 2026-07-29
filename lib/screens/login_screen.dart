import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  LoginScreen({
    super.key,
    AuthService? authService,
  }) : authService = authService ?? AuthService();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedRole = 'Super Admin';
  bool _isLoading = false;

  final List<String> _roles = ['Super Admin', 'Ground Partner', 'Organizer'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      widget.authService.login(
        _emailController.text,
        _passwordController.text,
        _selectedRole,
      ).then((success) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.accentNeonCyan,
                content: Text(
                  'Success: Authenticated as $_selectedRole!',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  'Error: Authentication failed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Error: ${error.toString()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 900;

    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient,
        child: SafeArea(
          child: Row(
            children: [
              // Left Section - Branding & Live Dashboard Overview (Desktop/Web only)
              if (isDesktop) Expanded(flex: 5, child: _buildBrandingSection()),

              // Right Section - Login Console Form (Always visible)
              Expanded(
                flex: 4,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Small branding header for mobile screens
                          if (!isDesktop) ...[
                            _buildMobileHeader(),
                            const SizedBox(height: 32),
                          ],

                          // Glassmorphic Login Card
                          _buildLoginCard(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Left Section content: Visual features showing Live Status & Brand details
  Widget _buildBrandingSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.glassCardBorder, width: 1),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.obsidianBgStart,
            Color(0x66000000), // Equivalent to Colors.black.withOpacity(0.4)
          ],
        ),
      ),
      padding: const EdgeInsets.all(48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(
                    0x1ACCFF00,
                  ), // Equivalent to AppColors.accentNeonGreen.withOpacity(0.1)
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0x4DCCFF00),
                    width: 1.5,
                  ), // Equivalent to withOpacity(0.3)
                ),
                child: const Icon(
                  Icons.sports_tennis_rounded,
                  color: AppColors.accentNeonGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'GAMEVERSE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentNeonCyan,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "India's AI-Powered\nSports Ecosystem",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Access the administrative control center to manage bookings, live scoring, multi-sport tournaments, AI analytics, and merchant operations.",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 48),

          // Dashboard Live Status Widgets
          const Text(
            "ECOSYSTEM MONITOR",
            style: TextStyle(
              color: AppColors.accentNeonGreen,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusItem(
            "Active Tournaments",
            "124 Live Now",
            Icons.emoji_events_outlined,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            "Ground Bookings Today",
            "3,481 Booked",
            Icons.stadium_outlined,
          ),
          const SizedBox(height: 12),
          _buildStatusItem(
            "AI Scoring Engines",
            "Operational (99.8%)",
            Icons.psychology_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassCardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentNeonCyan, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accentNeonGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentNeonGreen,
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Branding header for Mobile/Tablet layout
  Widget _buildMobileHeader() {
    return Column(
      children: [
        const Icon(
          Icons.sports_tennis_rounded,
          color: AppColors.accentNeonGreen,
          size: 48,
        ),
        const SizedBox(height: 16),
        const Text(
          'PLAYVERSE ADMIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "India's AI-Powered Sports Ecosystem",
          style: TextStyle(
            color: AppColors.accentNeonCyan,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // The actual glassmorphic Card displaying role selectors and text forms
  Widget _buildLoginCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.glassCardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassCardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0x4D000000,
            ), // Equivalent to Colors.black.withOpacity(0.3)
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "System Login",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Sign in to your administrative dashboard",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Custom Role Selector Tab Bar
            _buildRoleSelector(),
            const SizedBox(height: 28),

            // Email Field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Admin Email',
                hintText: 'Enter your admin email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 20),

            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Security Passcode',
                hintText: 'Enter account password',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: Validators.validatePassword,
            ),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  foregroundColor: AppColors.textSecondary,
                ),
                child: const Text(
                  'Forgot Passcode?',
                  style: TextStyle(
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            _buildLoginButton(),
            const SizedBox(height: 24),

            // Register Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "New Partner? ",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Request Access",
                    style: TextStyle(
                      color: AppColors.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  // Interactive tab selector for role selection
  Widget _buildRoleSelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(
          0x4D000000,
        ), // Equivalent to Colors.black.withOpacity(0.3)
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassCardBorder),
      ),
      child: Row(
        children: _roles.map((role) {
          final isSelected = _selectedRole == role;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRole = role;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentNeonGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0x4DCCFF00,
                            ), // Equivalent to AppColors.accentNeonGreen.withOpacity(0.3)
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  role,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Glowing neon button for form execution
  Widget _buildLoginButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppColors.accentNeonGreen, AppColors.accentNeonCyan],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0x40CCFF00,
            ), // Equivalent to AppColors.accentNeonGreen.withOpacity(0.25)
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SECURE LOG IN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.vpn_key_outlined, color: Colors.black, size: 18),
                ],
              ),
      ),
    );
  }
}
