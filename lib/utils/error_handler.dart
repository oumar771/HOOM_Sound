// lib/utils/error_handler.dart

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    return error is Exception ? error.toString() : "Une erreur inattendue est survenue.";
  }
}
