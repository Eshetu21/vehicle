// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  Future<List<Map<String, dynamic>>> fetchVehicles() async {
    try {
      final response =
          await _client.from("vehicles").select().order("created_at");
      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error while fetching $e");
      return [];
    }
  }

  Future<void> addOrUpdateVehicle(String? id, Map<String, dynamic> data) async {
    if (id == null) {
      await _client.from("vehicles").insert(data);
    } else {
      await _client.from("vehicles").update(data).eq("id", id);
    }
  }

  Future<void> deleteVehicle(String id) async {
    await _client.from("vehicles").delete().eq("id", "id");
  }
}

