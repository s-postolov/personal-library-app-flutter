import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_library_app/models/library_entry.dart';
import 'package:personal_library_app/models/update_library_entry_request.dart';
import 'package:personal_library_app/providers/library_providers.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final int entryId;

  const BookDetailsScreen({super.key, required this.entryId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  final _notesController = TextEditingController();
  ReadingStatus? _status;
  int? _rating;

  bool _isSaving = false;
  String? _errorMessage;
  bool _initialized = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _initializeFromEntry(LibraryEntry entry) {
    if (_initialized) return;
    _status = entry.status;
    _rating = entry.rating;
    _notesController.text = entry.notes ?? '';
    _initialized = true;
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final request = UpdateLibraryEntryRequest(
      status: _status!,
      rating: _rating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    try {
      final apiService = ref.read(libraryApiServiceProvider);
      await apiService.updateEntry(widget.entryId, request);

      ref.invalidate(libraryEntriesProvider);
      ref.invalidate(libraryEntryProvider(widget.entryId));

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryAsync = ref.watch(libraryEntryProvider(widget.entryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: entryAsync.when(
        data: (entry) {
          _initializeFromEntry(entry);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  entry.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (entry.authors != null && entry.authors!.isNotEmpty)
                  Text(entry.authors!.join(', ')),
                const SizedBox(height: 24),

                DropdownButtonFormField<ReadingStatus>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ReadingStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
                DropdownButtonFormField<int?>(
                  initialValue: _rating,
                  decoration: const InputDecoration(labelText: 'Rating (1-5)'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('No rating'),
                    ),
                    ...List.generate(5, (i) => i + 1).map(
                      (r) =>
                          DropdownMenuItem<int?>(value: r, child: Text('$r')),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: 16,),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save changes'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}