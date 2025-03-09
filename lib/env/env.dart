// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'OPEN_AI_PROMPT', obfuscate: false)
  static const String prompt = _Env.prompt;

  @EnviedField(varName: 'USER_PROMPT', obfuscate: false)
  static const String userPrompt = _Env.userPrompt;

  @EnviedField(varName: 'ANSWER_PROMPT', obfuscate: false)
  static const String answerPrompt = _Env.answerPrompt;

  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseURL = _Env.supabaseURL;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'SERVER_CLIENT_ID')
  static const String serverClientId = _Env.serverClientId;
}
