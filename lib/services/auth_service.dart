import 'package:supabase_flutter/supabase_flutter.dart';

/// Service d'authentification utilisant Supabase.
///
/// Ce service gère les opérations d'authentification telles que :
/// - La connexion (sign in)
/// - L'inscription (sign up)
/// - La déconnexion (sign out)
/// - La réinitialisation et la mise à jour du mot de passe
/// Il expose également la session courante via un getter.
class AuthService {
  // Utiliser une variable privée pour encapsuler le client Supabase
  final SupabaseClient _client = Supabase.instance.client;

  /// Connexion de l'utilisateur via email et mot de passe.
  ///
  /// Utilise la méthode [signInWithPassword]. En cas d'erreur ou si la session
  /// n'est pas créée, une exception est lancée avec un message explicite.
  Future<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw Exception(
          "Échec de l'authentification : aucune session créée. Veuillez vérifier vos identifiants.",
        );
      }
      return response.session!;
    } catch (e) {
      // Vous pouvez ici ajouter du logging avec un package tel que logger
      throw Exception("Une erreur est survenue lors de la connexion : $e");
    }
  }

  /// Inscription d'un nouvel utilisateur via email et mot de passe.
  ///
  /// Utilise la méthode [signUp]. Si l'inscription réussit mais qu'aucune session
  /// n'est créée, cela signifie généralement que l'utilisateur doit confirmer son email.
  /// Une exception est alors lancée avec un message détaillé.
  Future<Session> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.session == null) {
        throw Exception(
          "Inscription réussie, mais aucune session n'a été établie. Veuillez vérifier votre email pour confirmer votre inscription.",
        );
      }
      return response.session!;
    } catch (e) {
      throw Exception("Une erreur est survenue lors de l'inscription : $e");
    }
  }

  /// Déconnexion de l'utilisateur actuellement connecté.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception("Une erreur est survenue lors de la déconnexion : $e");
    }
  }

  /// Renvoie la session courante de l'utilisateur, ou null s'il n'est pas connecté.
  Session? get currentSession => _client.auth.currentSession;

  /// Envoi d'un email de réinitialisation du mot de passe à l'utilisateur.
  ///
  /// La méthode [resetPasswordForEmail] attend l'email en argument positionnel.
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception("Une erreur est survenue lors de la réinitialisation du mot de passe : $e");
    }
  }

  /// Mise à jour du mot de passe de l'utilisateur actuellement authentifié.
  ///
  /// Utilise la méthode [updateUser] en passant un objet [UserAttributes].
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception("Une erreur est survenue lors de la mise à jour du mot de passe : $e");
    }
  }
}
