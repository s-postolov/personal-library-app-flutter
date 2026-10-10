class AddToLibraryRequest {
  final String title;
  final String externalId;
  final List<String>? authors;
  final String? isbn13;
  final String? coverUrl;
  final int? publishedYear;
  final String? description;

  AddToLibraryRequest({
    required this.title,
    required this.externalId,
    this.authors,
    this.isbn13,
    this.coverUrl,
    this.publishedYear,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'externalId': externalId,
    'authors': authors,
    'isbn13': isbn13,
    'coverUrl': coverUrl,
    'publishedYear': publishedYear,
    'description': description,
  };
}