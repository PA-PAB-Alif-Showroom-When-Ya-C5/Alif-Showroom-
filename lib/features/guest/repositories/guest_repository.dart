import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:showroom_mobil/core/constants/supabase_table.dart';
import 'package:showroom_mobil/shared/models/mobil_model.dart';

class GuestRepository {
  final _supabase = Supabase.instance.client;


  Future<List<MobilModel>> getMobilTersedia() async {
    final response = await _supabase
        .from(SupabaseTable.mobil)
        .select()
        .eq(SupabaseColumn.statusMobil, 'tersedia')
        .order(SupabaseColumn.dibuatPada, ascending: false);

    return (response as List)
        .map((json) => MobilModel.fromJson(json))
        .toList();
  }


  Future<List<MobilModel>> getMobilTerbaru({int limit = 6}) async {
    final response = await _supabase
        .from(SupabaseTable.mobil)
        .select()
        .eq(SupabaseColumn.statusMobil, 'tersedia')
        .order(SupabaseColumn.dibuatPada, ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => MobilModel.fromJson(json))
        .toList();
  }
}