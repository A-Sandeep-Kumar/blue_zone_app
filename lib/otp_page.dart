import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'set_password_page.dart'; 
class OTPPage extends StatefulWidget { 
final String input; 
final bool isResetPassword; 
const OTPPage({super.key, required this.input, required this.isResetPassword}); 
@override 
State<OTPPage> createState() => _OTPPageState(); 
} 
class _OTPPageState extends State<OTPPage> { 
final TextEditingController otpController = TextEditingController(); 
String verificationId = ''; 
bool isOTPSent = false; 
@override 
void initState() { 
super.initState(); 
_sendOTP(); 
} 
Future<void> _sendOTP() async { 
    await FirebaseAuth.instance.verifyPhoneNumber( 
      phoneNumber: '+91${widget.input}', 
      timeout: const Duration(seconds: 60), 
      verificationCompleted: (PhoneAuthCredential credential) {}, 
      verificationFailed: (FirebaseAuthException e) { 
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(content: Text(e.message ?? 'OTP failed')), 
        ); 
      }, 
      codeSent: (String verId, int? resendToken) { 
        setState(() { 
          verificationId = verId; 
          isOTPSent = true; 
        }); 
      }, 
      codeAutoRetrievalTimeout: (String verId) { 
        verificationId = verId; 
      }, 
    ); 
  } 
 
  Future<void> _verifyOTP() async { 
    final otp = otpController.text.trim(); 
    if (otp.isEmpty) return; 
    try { 
      final credential = PhoneAuthProvider.credential( 
        verificationId: verificationId, 
        smsCode: otp, 
      ); 
 
      await FirebaseAuth.instance.signInWithCredential(credential); 
 
      Navigator.pushReplacement( 
        context, 
        MaterialPageRoute( 
          builder: (_) => SetPasswordPage( 
            input: widget.input, 
            isReset: widget.isResetPassword, 
          ), 
        ), 
      ); 
    } catch (e) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar(content: Text('OTP verification failed')), 
      ); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.black, 
      appBar: AppBar( 
        title: const Text('Enter OTP'), 
        backgroundColor: Colors.cyanAccent, 
        foregroundColor: Colors.black, 
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(24.0), 
        child: Column( 
          children: [ 
            TextField( 
              controller: otpController, 
              keyboardType: TextInputType.number, 
              decoration: InputDecoration( 
                labelText: 'OTP', 
                prefixIcon: const Icon(Icons.lock_open), 
                filled: true, 
                fillColor: Colors.white10, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              style: const TextStyle(color: Colors.white), 
            ), 
            const SizedBox(height: 20), 
            ElevatedButton( 
              onPressed: _verifyOTP, 
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.cyanAccent, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              child: const Text('Verify', style: TextStyle(color: Colors.black)), 
            ) 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 