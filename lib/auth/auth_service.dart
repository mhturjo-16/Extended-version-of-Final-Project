import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;
  // sign_in method

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //sign_up
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  // sign_out
  Future<void> signOut() async {
    return await supabase.auth.signOut();
  }

  // get current user
  String? getCurrentUser() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
