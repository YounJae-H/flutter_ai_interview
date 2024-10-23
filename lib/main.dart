import 'package:flutter/material.dart';
import 'package:flutter_interview/env/env.dart';
import 'package:flutter_interview/providers/bottom_navigation_provider.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/keyboard_provider.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:flutter_interview/providers/pick_subject_provider.dart';
import 'package:flutter_interview/route/router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseURL,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(
    const _App(),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ChatProvider('Flutter')),
          ChangeNotifierProvider(create: (_) => KeyboardProvider()),
          ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
          ChangeNotifierProvider(create: (_) => PickSubjectProvider()),
          ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ],
        child: MaterialApp.router(
          title: 'MOAI',
          routerConfig: router,
        ));
  }
}
