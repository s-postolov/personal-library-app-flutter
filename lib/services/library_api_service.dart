import 'package:dio/dio.dart';
import 'package:personal_library_app/models/add_to_library_request.dart';
import 'package:personal_library_app/models/library_entry.dart';
import 'package:personal_library_app/models/update_library_entry_request.dart';

class LibraryApiService {
  final Dio _dio;

  LibraryApiService(this._dio);

  Future<List<LibraryEntry>> getAll() async {
    final response = await _dio.get('/api/library');
    final data = response.data as List;
    return data.map((json) => LibraryEntry.fromJson(json)).toList();
  }

  Future<LibraryEntry> getOne(int id) async {
    final response = await _dio.get('/api/library/$id');
    return LibraryEntry.fromJson(response.data);
  }

  Future<LibraryEntry> addToLibrary(AddToLibraryRequest request) async {
    final response = await _dio.post(
      '/api/library/add',
      data: request.toJson(),
    );
    return LibraryEntry.fromJson(response.data);
  }

  Future<LibraryEntry> updateEntry(
    int id,
    UpdateLibraryEntryRequest request,
  ) async {
    final response = await _dio.post(
      '/api/library/$id/edit',
      data: request.toJson(),
    );
    return LibraryEntry.fromJson(response.data);
  }

  Future<LibraryEntry> deleteEntry(int id) async {
    final response = await _dio.delete('/api/library/$id/delete');
    return LibraryEntry.fromJson(response.data);
  }
}