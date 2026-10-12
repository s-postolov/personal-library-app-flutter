import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_library_app/models/add_to_library_request.dart';
import 'package:personal_library_app/providers/library_providers.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _externalIdController = TextEditingController();
  final _authorsController = TextEditingController();
  final _isbn13Controller = TextEditingController();
  final _publishedYearController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _externalIdController.dispose();
    _authorsController.dispose();
    _isbn13Controller.dispose();
    _publishedYearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final request = AddToLibraryRequest(
      title: _titleController.text.trim(),
      externalId: _externalIdController.text.trim(),
      authors: _authorsController.text.trim().isEmpty
          ? null
          : _authorsController.text
                .split(',')
                .map((author) => author.trim())
                .toList(),
      isbn13: _isbn13Controller.text.trim().isEmpty
          ? null
          : _isbn13Controller.text.trim(),
      publishedYear: _publishedYearController.text.trim().isEmpty
          ? null
          : int.tryParse(_publishedYearController.text.trim()),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      final apiService = ref.read(libraryApiServiceProvider);
      await apiService.addToLibrary(request);

      ref.invalidate(libraryEntriesProvider);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to add book: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              TextFormField(
                controller: _externalIdController,
                decoration: const InputDecoration(
                  labelText: 'External ID (e.g. OL45805W)',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'External ID is required'
                    : null,
              ),
              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(
                  labelText: 'Authors (comma-separated)',
                ),
              ),
              TextFormField(
                controller: _isbn13Controller,
                decoration: const InputDecoration(labelText: 'ISBN-13'),
              ),
              TextFormField(
                controller: _publishedYearController,
                decoration: const InputDecoration(labelText: 'Published Year'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add to library'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
