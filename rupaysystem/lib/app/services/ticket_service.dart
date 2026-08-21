import 'package:supabase_flutter/supabase_flutter.dart';

class TicketService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getTicket(String paymentId) async {
    final response = await supabase
        .from("payments")
        .select("""
          *,
          students(
            full_name,
            registration,
            course,
            campus,
            profile_photo_url
          ),
          meals(
            name
          )
        """)
        .eq("id", paymentId)
        .single();

    return response;
  }

  Future markAsUsed(String paymentId) async {
    await supabase
        .from("payments")
        .update({"used": true, "used_at": DateTime.now().toIso8601String()})
        .eq("id", paymentId);
  }
}
