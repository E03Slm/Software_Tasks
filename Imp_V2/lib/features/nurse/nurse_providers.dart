import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'simulation/models/drug.dart';
import 'simulation/infusion_state_machine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

part 'nurse_providers.g.dart';

@riverpod
Future<List<Drug>> drugList(Ref ref) async {
  final response = await Supabase.instance.client
      .from('drug')
      .select();
  
  return (response as List).map((e) => Drug.fromJson(e)).toList();
}

@riverpod
class SelectedDrug extends _$SelectedDrug {
  @override
  Drug? build() => null;

  void select(Drug drug) => state = drug;
}

@riverpod
Stream<List<Map<String, dynamic>>> activeAlarms(Ref ref) {
  final session = ref.watch(infusionProvider);
  if (session.id.isEmpty) return Stream.value([]);

  return Supabase.instance.client
      .from('alarm')
      .stream(primaryKey: ['event_id'])
      .eq('session_id', session.id)
      .order('alarm_time', ascending: false);
}
