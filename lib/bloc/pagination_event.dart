part of 'pagination_bloc.dart';

@immutable
abstract class PaginationEvent<T> {}

class PageFetch<T> implements PaginationEvent<T> {
  PageFetch({
    @required this.callback,
  });

  final PaginationBuilder<T> callback;

  PageFetch<T> copyWith({
    Future<List<T>> Function(int currentListSize, T currentListItem) callback,
  }) {
    return PageFetch<T>(
      callback: callback ?? this.callback,
    );
  }
}

class PageRefreshed<T> implements PaginationEvent<T> {}
