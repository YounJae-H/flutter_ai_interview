import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:flutter_interview/env/env.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        // appBar: AppBar(
        //   title: const Text(
        //     "MOAI",
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   backgroundColor: primaryColor,
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text.rich(TextSpan(
                  text: '\n\n\n\n\n면접과 학습을 한번에!\n',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: 'MOAI',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: buttonColor))
                  ])),

              Image.asset('assets/images/moai.png'),
              SignInButton(
                Buttons.google,
                text: "Goolge 계정으로 로그인",
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                onPressed: () => onGoogleLoginPress(context),
              ),
              // TextButton(
              //     onPressed: () => onGoogleLogoutPress(context),
              //     child: const Text('로그아웃'))
            ],
          ),
        ));
  }

  Future<void> onGoogleLoginPress(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn =
          GoogleSignIn(serverClientId: Env.serverClientId);
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      if (context.mounted) context.go('/home');
    } catch (e) {
      debugPrint('Google 로그인 오류: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Google 로그인 실패: $e')));
    }
  }

  Future<void> onGoogleLogoutPress(BuildContext context) async {
    try {
      // 1. Supabase 로그아웃
      await Supabase.instance.client.auth.signOut();

      // 2. Google 로그아웃
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // 3. 로그인 화면으로 이동
      if (context.mounted) {
        context.go('/auth');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다.')));
      }
    } catch (error) {
      debugPrint('로그아웃 오류: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 실패: $error')),
      );
    }
  }
}
