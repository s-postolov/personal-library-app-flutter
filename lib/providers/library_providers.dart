import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_library_app/models/library_entry.dart';
import 'package:personal_library_app/services/library_api_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
});

final libraryApiServiceProvider = Provider<LibraryApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return LibraryApiService(dio);
});

final libraryEntriesProvider = FutureProvider<List<LibraryEntry>>((ref) async {
  final service = ref.watch(libraryApiServiceProvider);
  return service.getAll();
});
