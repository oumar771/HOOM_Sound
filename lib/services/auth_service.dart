import 'package:supabase_flutter/supabase_flutter.dart';

/// Service d'authentification utilisant Supabase.
///
/// Fournit des méthodes pour la connexion, l'inscription, la déconnexion,
/// la réinitialisation et la mise à jour du mot de passe, ainsi qu'un accès à la session courante.
class AuthService {
  /// Instance du client Supabase initialisé.
  final SupabaseClient client = Supabase.instance.client;

  /// Connexion de l'utilisateur via email et mot de passe.
  ///
  /// Utilise la méthode moderne [signInWithPassword]. Si une erreur survient,
  /// une exception est lancée automatiquement.
  Future<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw Exception(
          "Aucune session créée. Vérifiez vos informations de connexion.",
        );
      }
      return response.session!;
    } catch (e) {
      throw Exception("Une exception est survenue lors de la connexion : $e");
    }
  }

  /// Inscription d'un nouvel utilisateur via email et mot de passe.
  ///
  /// Utilise [signUp]. Si l'inscription réussit mais qu'aucune session n'est créée,
  /// une exception est lancée pour informer l'utilisateur de vérifier son email.
  Future<Session> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw Exception(
          "Inscription réussie, mais aucune session n'a été établie. Vérifiez votre email pour confirmer votre inscription.",
        );
      }
      return response.session!;
    } catch (e) {
      throw Exception("Une exception est survenue lors de l'inscription : $e");
    }
  }

  /// Déconnexion de l'utilisateur actuellement connecté.
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception("Une exception est survenue lors de la déconnexion : $e");
    }
  }

  /// Renvoie la session courante de l'utilisateur, ou null s'il n'est pas connecté.
  Session? get currentSession => client.auth.currentSession;

  /// Envoi d'un email de réinitialisation du mot de passe à l'utilisateur.
  ///
  /// La méthode [resetPasswordForEmail] attend désormais l'email en argument positionnel.
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception(
        "Une exception est survenue lors de la réinitialisation du mot de passe : $e",
      );
    }
  }

  /// Mise à jour du mot de passe de l'utilisateur actuellement authentifié.
  ///
  /// Utilise la méthode [updateUser] qui retourne un [UserResponse]. En cas d'erreur,
  /// une exception est lancée.
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception(
        "Une exception est survenue lors de la mise à jour du mot de passe : $e",
      );
    }
  }
}
