import 'package:flutter/material.dart';
 import 'package:firebase_auth/firebase_auth.dart';
 import 'login.dart';
 class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
 }
 class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showOTPField = false;
  bool showPasswordField = false;
  bool isLoading = false;
  String verificationId = '';
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
  Future<void> sendOTP() async {
    final input = userController.text.trim();
    if (input.isEmpty) {
      showMessage('Please enter email or phone number');
      return;
    }
    if (input.contains('@')) {
      setState(() {
        showPasswordField = true;
        showOTPField = false;
      });
    } else {
      String phone = input.startsWith('+91') ? input : '+91$input';
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (!mounted) return;
            setState(() {
              showPasswordField = true;
              showOTPField = false;
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            showMessage(e.message ?? 'OTP sending failed');
          },
          codeSent: (String verId, int? resendToken) {
            setState(() {
              verificationId = verId;
              showOTPField = true;
            });
            showMessage('OTP sent to $phone');
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
        );
      } catch (e) {
        showMessage('Failed to send OTP');
      }
    }
  }
  Future<void> verifyOTPAndShowPassword() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      showMessage('Please enter the OTP');
      return;
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      setState(() {
        showPasswordField = true;
        showOTPField = false;
      });
    } catch (e) {
      showMessage('OTP verification failed');
    }
  }
  Future<void> registerUser() async {
    final input = userController.text.trim();
    final password = passwordController.text.trim();
    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }
    setState(() => isLoading = true);
    try {
      if (input.contains('@')) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: input,
          password: password,
        );
      } else {
        final pseudoEmail = "$input@bluezone.com";
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: pseudoEmail,
          password: password,
        );
      }
      showMessage('Account created successfully!');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? 'Account creation failed');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(
                labelText: 'Email or Phone',
                prefixText: '+91 ',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            if (showOTPField)
              Column(
                children: [
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      prefixIcon: const Icon(Icons.lock_open),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: verifyOTPAndShowPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Verify OTP', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            if (showPasswordField)
              Column(
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Set Password',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Create Account',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            if (!showPasswordField)
              ElevatedButton(
                onPressed: sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Send OTP / Continue', style: TextStyle(color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
 }