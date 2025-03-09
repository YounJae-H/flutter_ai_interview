// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class UserNotifier extends ChangeNotifier {
//   User? _user;

//   User? get user => _user;

//   UserNotifier() {
//     initStatus();
//   }

//   void initStatus() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//       await _setUser(user);
//       notifyListeners();
//     });
//   }
// }
