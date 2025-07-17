import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'login.dart'; 
class ProfilePage extends StatelessWidget { 
const ProfilePage({super.key}); 
void logoutUser(BuildContext context) async { 
await FirebaseAuth.instance.signOut(); 
Navigator.pushAndRemoveUntil( 
context, 
MaterialPageRoute(builder: (_) => const LoginPage()), 
(route) => false, 
); 
} 
@override 
Widget build(BuildContext context) { 
final user = FirebaseAuth.instance.currentUser; 
return Scaffold( 
backgroundColor: Colors.black, 
appBar: AppBar( 
title: const Text("Account", style: TextStyle(color: Colors.black)), 
backgroundColor: Colors.cyanAccent, 
        foregroundColor: Colors.black, 
      ), 
      body: ListView( 
        padding: const EdgeInsets.all(20), 
        children: [ 
          const Icon(Icons.person, size: 100, color: Colors.cyanAccent), 
          const SizedBox(height: 10), 
 
          ///     Show email or phone or fallback 
          Text( 
            user != null 
                ? (user.email ?? user.phoneNumber ?? 'No user data') 
                : 'No user logged in', 
            textAlign: TextAlign.center, 
            style: const TextStyle(color: Colors.white, fontSize: 18), 
          ), 
 
          const SizedBox(height: 30), 
 
          ListTile( 
            leading: const Icon(Icons.language, color: Colors.cyanAccent), 
            title: const Text("Language", style: TextStyle(color: Colors.white)), 
            onTap: () {}, 
          ), 
          ListTile( 
            leading: const Icon(Icons.help_outline, color: Colors.cyanAccent), 
            title: const Text("Help Center", style: TextStyle(color: Colors.white)), 
            onTap: () {}, 
          ), 
          ListTile( 
            leading: const Icon(Icons.support_agent, color: Colors.cyanAccent), 
            title: const Text("Support", style: TextStyle(color: Colors.white)), 
            onTap: () {}, 
          ), 
 
          const SizedBox(height: 30), 
          ElevatedButton( 
            onPressed: () => logoutUser(context), 
            style: ElevatedButton.styleFrom( 
              backgroundColor: Colors.redAccent, 
              padding: const EdgeInsets.symmetric(vertical: 14), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
            ), 
            child: const Text("Logout", style: TextStyle(color: Colors.white)), 
          ), 
        ], 
      ), 
    ); 
  } 
} 