import 'package:flutter/material.dart';
import '../upload/upload_screen.dart';
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  late TabController _tabController;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // --- VALIDASYON ---
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email boş olamaz';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Geçerli bir email giriniz';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre boş olamaz';
    if (value.length < 8) return 'Şifre en az 8 karakter olmalı';
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
    );
    if (!regex.hasMatch(value)) {
      return 'Şifre büyük/küçük harf ve rakam içermeli';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Şifre tekrar boş olamaz';
    if (value != _passwordController.text) return 'Şifreler eşleşmiyor';
    return null;
  }

  // --- İŞLEMLER ---
  void _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final apiService = ApiService();
        final result = await apiService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (result['token'] != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UploadScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['detail'] ?? 'Giriş başarısız'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı hatası: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final apiService = ApiService();
        final result = await apiService.register(
          _emailController.text.split(
            '@',
          )[0], // username olarak email'in @ öncesi
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (result['message'] != null) {
          _tabController.animateTo(0);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kayıt başarılı! Giriş yapabilirsiniz.'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['detail'] ?? 'Kayıt başarısız'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı hatası: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        size: 60,
                        color: Color(0xFF1E3A8A),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Hoş Geldiniz",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Giriş yapın veya kayıt olun",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF1E3A8A),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF1E3A8A),
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(text: "Giriş Yap"),
                          Tab(text: "Kayıt Ol"),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Form(key: _loginFormKey, child: _buildLoginForm()),
                            Form(
                              key: _registerFormKey,
                              child: _buildRegisterForm(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
          validator: _validateEmail,
        ),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Şifre",
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: _validatePassword,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("Giriş Yap"),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
          validator: _validateEmail,
        ),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Şifre",
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: _validatePassword,
        ),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: "Şifre Tekrar",
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
            ),
          ),
          obscureText: !_isConfirmPasswordVisible,
          validator: _validateConfirmPassword,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text("Kayıt Ol"),
        ),
      ],
    );
  }
}
