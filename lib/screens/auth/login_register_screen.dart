import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';

class LoginRegisterScreen extends StatefulWidget {
  final Function(UserModel user) onAuthSuccess;
  final Function(UserModel newUser) onRegisterSubmitted;

  const LoginRegisterScreen({
    Key? key,
    required this.onAuthSuccess,
    required this.onRegisterSubmitted,
  }) : super(key: key);

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  // ═══ State Variables ═══
  bool _isSignup = false; // false = login, true = signup
  UserRole _role = UserRole.student;
  bool _isLoading = false;
  String? _errorMessage;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network

    final newUser = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      role: _role,
      department: 'General',
      accountStatus: AccountStatus.pendingAdmin,
      registeredAt: DateTime.now().toIso8601String(),
    );

    widget.onRegisterSubmitted(newUser);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_role == UserRole.student || _role == UserRole.teacher
              ? 'Account created. Waiting for admin approval.'
              : 'Account created successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        if (_role == UserRole.student || _role == UserRole.teacher) {
          _isSignup = false;
        }
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network

    final email = _emailCtrl.text.trim().toLowerCase();
    UserModel loggedInUser;
    
    if (email.contains('admin') || email.contains('manager')) {
      loggedInUser = UserModel(
        id: 'ADM-001',
        name: 'System Administrator',
        email: 'admin@learnspace.edu',
        role: UserRole.admin,
        department: 'Governance',
        accountStatus: AccountStatus.approved,
        registeredAt: '2026-01-01',
      );
    } else if (email.contains('teacher') || email.contains('vasquez')) {
      loggedInUser = UserModel(
        id: 'TCH-101',
        name: 'Dr. Elena Vasquez',
        email: 'e.vasquez@uni.edu',
        role: UserRole.teacher,
        department: 'Computer Science',
        accountStatus: AccountStatus.approved,
        registeredAt: '2026-02-10',
      );
    } else {
      loggedInUser = UserModel(
        id: 'STD-201',
        name: 'Amara Diallo',
        email: 'a.diallo@student.edu',
        role: UserRole.student,
        department: 'Computer Science',
        accountStatus: AccountStatus.approved,
        registeredAt: '2026-03-15',
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      widget.onAuthSuccess(loggedInUser);
    }
  }

  void _quickLogin(UserRole role) {
    UserModel loggedInUser;
    switch (role) {
      case UserRole.admin:
        loggedInUser = UserModel(
          id: 'ADM-001',
          name: 'System Administrator',
          email: 'admin@learnspace.edu',
          role: UserRole.admin,
          department: 'Governance',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-01-01',
        );
        break;
      case UserRole.teacher:
        loggedInUser = UserModel(
          id: 'TCH-101',
          name: 'Dr. Elena Vasquez',
          email: 'e.vasquez@uni.edu',
          role: UserRole.teacher,
          department: 'Computer Science',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-02-10',
        );
        break;
      case UserRole.student:
        loggedInUser = UserModel(
          id: 'STD-201',
          name: 'Amara Diallo',
          email: 'a.diallo@student.edu',
          role: UserRole.student,
          department: 'Computer Science',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-03-15',
        );
        break;
    }
    widget.onAuthSuccess(loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF4C1D95), Color(0xFF6B21A8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppGradients.violet,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.violet.withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        Text(
                          _isSignup ? 'Create Account' : 'Welcome Back',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isSignup ? 'Sign up to get started' : 'Login to your account',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error Message
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Name Field (Signup only)
                        if (_isSignup)
                          Column(
                            children: [
                              TextFormField(
                                controller: _nameCtrl,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                                  prefixIcon: const Icon(Icons.person_rounded, color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                ),
                                validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // Email Field
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                            prefixIcon: const Icon(Icons.email_rounded, color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'Enter email';
                            if (!v.contains('@')) return 'Enter valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                            prefixIcon: const Icon(Icons.lock_rounded, color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) return 'Enter password';
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Role Selection (Signup only)
                        if (_isSignup) ...[
                          Text(
                            'Select Your Role',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<UserRole>(
                                  title: const Text('Student', style: TextStyle(color: Colors.white)),
                                  value: UserRole.student,
                                  groupValue: _role,
                                  onChanged: (v) => setState(() => _role = v!),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<UserRole>(
                                  title: const Text('Teacher', style: TextStyle(color: Colors.white)),
                                  value: UserRole.teacher,
                                  groupValue: _role,
                                  onChanged: (v) => setState(() => _role = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : (_isSignup ? _handleSignup : _handleLogin),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.violet,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: AppColors.violet.withValues(alpha: 0.5),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isSignup ? 'Create Account' : 'Login',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Toggle Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignup ? 'Already have an account? ' : 'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _isSignup = !_isSignup;
                                        _errorMessage = null;
                                        _formKey.currentState?.reset();
                                      });
                                    },
                              child: Text(
                                _isSignup ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                  color: AppColors.fuchsia,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Quick Logins (Keep for Dev)
                        Text(
                          'Quick Dev Login',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ActionChip(
                              label: const Text('Admin', style: TextStyle(fontSize: 11)),
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              onPressed: () => _quickLogin(UserRole.admin),
                            ),
                            ActionChip(
                              label: const Text('Teacher', style: TextStyle(fontSize: 11)),
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              onPressed: () => _quickLogin(UserRole.teacher),
                            ),
                            ActionChip(
                              label: const Text('Student', style: TextStyle(fontSize: 11)),
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              onPressed: () => _quickLogin(UserRole.student),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
