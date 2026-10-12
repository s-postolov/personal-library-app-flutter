import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget{
  final int entryId;

  const BookDetailsScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book details'),),
      body: Center(child: Text('Details for entry id: $entryId'),),
    );
  }
}