import 'package:go_router/go_router.dart';
import 'package:personal_library_app/screens/add_book_screen.dart';
import 'package:personal_library_app/screens/book_details_screen.dart';
import 'package:personal_library_app/screens/library_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LibraryListScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddBookScreen(),
    ),
    GoRoute(
      path: '/entry/:id',
      builder: (context, state) {
        final idString = state.pathParameters['id']!;
        final id = int.parse(idString);
        return BookDetailsScreen(entryId: id);
      },
    ),
  ]
);