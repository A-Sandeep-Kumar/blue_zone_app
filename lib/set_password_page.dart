import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'login.dart'; 
class SetPasswordPage extends StatefulWidget { 
final String input; 
final bool isReset; 
const SetPasswordPage({super.key, required this.input, required this.isReset}); 
@override 
State<SetPasswordPage> createState() => _SetPasswordPageState(); 
} 
class _SetPasswordPageState extends State<SetPasswordPage> { 
final TextEditingController passwordController = TextEditingController(); 
bool isLoading = false; 
Future<void> _submit() async { 
final password = passwordController.text.trim(); 
if (password.length < 6) { 
ScaffoldMessenger.of(context).showSnackBar( 
const SnackBar(content: Text('Password must be at least 6 characters')), 
); 
return; 
} 
 
    setState(() => isLoading = true); 
 
    try { 
      if (widget.isReset) { 
        await FirebaseAuth.instance.currentUser?.updatePassword(password); 
      } else { 
        final email = widget.input.contains('@') 
            ? widget.input 
            : '${widget.input}@bluezone.com'; 
 
        await FirebaseAuth.instance.createUserWithEmailAndPassword( 
          email: email, 
          password: password, 
        ); 
      } 
 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar(content: Text('Password saved successfully')), 
      ); 
 
      Navigator.pushAndRemoveUntil( 
        context, 
        MaterialPageRoute(builder: (_) => const LoginPage()), 
        (route) => false, 
      ); 
    } on FirebaseAuthException catch (e) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        SnackBar(content: Text(e.message ?? 'Something went wrong')), 
      ); 
    } finally { 
      setState(() => isLoading = false); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.black, 
      appBar: AppBar( 
        title: const Text('Set Password'), 
        backgroundColor: Colors.cyanAccent, 
        foregroundColor: const Color.from(alpha: 0.947, red: 0.961, green: 0.941, blue: 0.941), 
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(24.0), 
        child: Column( 
          children: [ 
            TextField( 
              controller: passwordController, 
              obscureText: true, 
              decoration: InputDecoration( 
                labelText: 'New Password', 
                prefixIcon: const Icon(Icons.lock), 
                filled: true, 
                fillColor: Colors.white10, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              style: const TextStyle(color: Colors.white), 
            ), 
            const SizedBox(height: 24), 
            ElevatedButton( 
              onPressed: isLoading ? null : _submit, 
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.cyanAccent, 
                padding: const EdgeInsets.symmetric(vertical: 14), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.black) 
                  : const Text('Save Password', style: TextStyle(color: Colors.black)), 
            ) 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 