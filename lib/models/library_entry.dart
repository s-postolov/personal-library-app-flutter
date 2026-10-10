import 'package:json_annotation/json_annotation.dart';

part 'library_entry.g.dart';

enum ReadingStatus {
  @JsonValue('WANT_TO_READ')
  wantToRead,
  @JsonValue('READING')
  reading,
  @JsonValue('READ')
  read,
}

@JsonSerializable()
class LibraryEntry {
  final int id;
  final String title;
  final List<String>? authors;
  final String? coverUrl;
  final int? publishedYear;
  final ReadingStatus status;
  final int? rating;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  LibraryEntry({
    required this.id,
    required this.title,
    this.authors,
    this.coverUrl,
    this.publishedYear,
    required this.status,
    this.rating,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LibraryEntry.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryEntryToJson(this);
}
