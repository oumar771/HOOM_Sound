// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    final response = await client.auth.signIn(email: email, password: password);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  Future<void> signUp(String email, String password) async {
    final response = await client.auth.signUp(email, password);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
