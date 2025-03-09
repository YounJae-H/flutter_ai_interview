import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(Supabase
                .instance.client.auth.currentUser!.userMetadata?['avatar_url']),
          ),
          title: Text(Supabase
              .instance.client.auth.currentUser!.userMetadata!['email']
              .toString()),
        ),
        TextButton(
            onPressed: () => onGoogleLogoutPress(context), child: Text('로그아웃'))
      ],
    );
  }

  Future<void> onGoogleLogoutPress(BuildContext context) async {
    // 임시로 추가함 authProvider로 이동 예정
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
