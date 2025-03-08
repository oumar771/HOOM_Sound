import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  static const String _supabaseUrl = 'https://qgazccagqcphwjtcwqrc.supabase.co';
  static const String _supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFnYXpjY2FncWNwaHdqdGN3cXJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4MTYxNDYsImV4cCI6MjA1NjM5MjE0Nn0.oHcsgA2XbCakipD_IijdDR0eOsiGHW0NT1kluH2DkN0';

  static SupabaseClient get client => Supabase.instance.client;
}
