import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../pagination_view.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent<T>, PaginationState<T>> {
  PaginationBloc(this.preloadedItems);

  final List<T> preloadedItems;

  @override
  PaginationState<T> get initialState => preloadedItems.isNotEmpty
      ? PaginationLoaded(items: preloadedItems, hasReachedEnd: false)
      : PaginationInitial<T>();

  @override
  Stream<PaginationState<T>> mapEventToState(PaginationEvent<T> event) async* {
    if (event is PageFetch) {
      final currentState = state;
      final fetchEvent = event as PageFetch<T>;
      if (!_hasReachedEnd(currentState)) {
        try {
          if (currentState is PaginationInitial) {
            final firstItems = await fetchEvent.callback(0, null);
            yield PaginationLoaded(
              items: firstItems,
              hasReachedEnd: firstItems.isEmpty,
            );
            return;
          }
          if (currentState is PaginationLoaded<T>) {
            final newItems = await fetchEvent.callback(
                _getAbsoluteOffset(currentState.items.length),
                currentState.items[currentState.items.length - 1]);
            yield currentState.copyWith(
              items: currentState.items + newItems,
              hasReachedEnd: newItems.isEmpty,
            );
          }
        } on Exception catch (error) {
          yield PaginationError(error: error);
        }
      }
    }
    if (event is PageRefreshed) {
      yield PaginationInitial();
    }
  }

  bool _hasReachedEnd(PaginationState state) =>
      state is PaginationLoaded && state.hasReachedEnd;

  int _getAbsoluteOffset(int offset) => offset - preloadedItems.length;
}
