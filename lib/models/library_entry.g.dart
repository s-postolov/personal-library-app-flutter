// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryEntry _$LibraryEntryFromJson(Map<String, dynamic> json) => LibraryEntry(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  authors: (json['authors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  coverUrl: json['coverUrl'] as String?,
  publishedYear: (json['publishedYear'] as num?)?.toInt(),
  status: $enumDecode(_$ReadingStatusEnumMap, json['status']),
  rating: (json['rating'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LibraryEntryToJson(LibraryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'coverUrl': instance.coverUrl,
      'publishedYear': instance.publishedYear,
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'rating': instance.rating,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.wantToRead: 'WANT_TO_READ',
  ReadingStatus.reading: 'READING',
  ReadingStatus.read: 'READ',
};
