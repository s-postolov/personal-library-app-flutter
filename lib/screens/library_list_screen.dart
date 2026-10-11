import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_library_app/providers/library_providers.dart';

class LibraryListScreen extends ConsumerWidget{
  const LibraryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(libraryEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Library'),),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text("No books yet."),);
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.title),
                subtitle: Text(entry.status.name),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(),),
        error: (error, stack) => Center(child: Text('Error: $error'),),
      ),
    );
  }
}