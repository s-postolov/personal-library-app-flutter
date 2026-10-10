import 'package:personal_library_app/models/library_entry.dart';

class UpdateLibraryEntryRequest {
  final ReadingStatus status;
  final int? rating;
  final String? notes;

  UpdateLibraryEntryRequest({
    required this.status,
    this.rating,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'status': _statusToJson(status),
    'rating': rating,
    'notes': notes,
  };

  String _statusToJson(ReadingStatus status){
    switch (status) {
      case ReadingStatus.wantToRead:
        return 'WANT_TO_READ';
      case ReadingStatus.reading:
        return 'READING';
      case ReadingStatus.read:
        return 'READ';
    }
  }
}