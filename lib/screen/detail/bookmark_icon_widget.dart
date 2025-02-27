import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourism_app/data/model/tourism.dart';
import 'package:tourism_app/provider/bookmark/local_databse_provider.dart';
import 'package:tourism_app/provider/detail/bookmark_icon_provider.dart';

class BookmarkIconWidget extends StatefulWidget {
  final Tourism tourism;
  const BookmarkIconWidget({
    Key? key,
    required this.tourism,
  }) : super(key: key);

  @override
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget> {
  @override
  void initState() {
    final localDatabseProvider = context.read<LocalDatabseProvider>();
    final bookmarkIconProvider = context.read<BookmarkIconProvider>();

    Future.microtask(() async {
      await localDatabseProvider.loadTourismById(widget.tourism.id);
      final value = localDatabseProvider.tourism == null
          ? false
          : localDatabseProvider.tourism!.id == widget.tourism.id;
      bookmarkIconProvider.isBookmarked = value;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabseProvider = context.read<LocalDatabseProvider>();
        final bookmarkIconProvider = context.read<BookmarkIconProvider>();
        final isBookmarked = bookmarkIconProvider.isBookmarked;

        if (!isBookmarked) {
          await localDatabseProvider.saveTourism(widget.tourism);
        } else {
          await localDatabseProvider.removeTourismById(widget.tourism.id);
        }
        bookmarkIconProvider.isBookmarked = !isBookmarked;
        localDatabseProvider.loadAllTourism();
      },
      icon: Icon(
        context.watch<BookmarkIconProvider>().isBookmarked
            ? Icons.bookmark
            : Icons.bookmark_outline,
      ),
    );
  }
}
