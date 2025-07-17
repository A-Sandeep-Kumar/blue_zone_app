import 'package:flutter/material.dart'; 
import 'otp_page.dart'; 
class ForgotEntryPage extends StatefulWidget { 
const ForgotEntryPage({super.key}); 
@override 
State<ForgotEntryPage> createState() => _ForgotEntryPageState(); 
} 
class _ForgotEntryPageState extends State<ForgotEntryPage> { 
final TextEditingController inputController = TextEditingController(); 
void _continueToOTP() { 
final input = inputController.text.trim(); 
if (input.isEmpty) { 
ScaffoldMessenger.of(context).showSnackBar( 
const SnackBar(content: Text('Please enter email or phone')), 
); 
return; 
} 
Navigator.push( 
context, 
MaterialPageRoute( 
builder: (_) => OTPPage( 
          input: input, 
          isResetPassword: true, 
        ), 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: Colors.black, 
      appBar: AppBar( 
        title: const Text('Forgot Password'), 
        backgroundColor: Colors.cyanAccent, 
        foregroundColor: Colors.black, 
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(24.0), 
        child: Column( 
          children: [ 
            TextField( 
              controller: inputController, 
              decoration: InputDecoration( 
                labelText: 'Enter Email or Phone', 
                prefixIcon: const Icon(Icons.person), 
                filled: true, 
                fillColor: Colors.white10, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              style: const TextStyle(color: Colors.white), 
            ), 
            const SizedBox(height: 20), 
            ElevatedButton( 
              onPressed: _continueToOTP, 
              style: ElevatedButton.styleFrom( 
                backgroundColor: Colors.cyanAccent, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
              ), 
              child: const Text( 
                'Continue', 
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
              ), 
            ) 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 