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

class PageRefreshed<T> implements PaginationEvent<T> {
  PageRefreshed({
    @required this.callback,
    @required this.scrollController,
  });

  final PaginationBuilder<T> callback;
  final ScrollController scrollController;

  PageRefreshed<T> copyWith(
      {Future<List<T>> Function(int currentListSize, T currentListItem)
          callback,
      ScrollController scrollController}) {
    return PageRefreshed<T>(
      callback: callback ?? this.callback,
      scrollController: scrollController ?? this.scrollController,
    );
  }
}
