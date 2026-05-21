import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

part 'rx_crud_event.dart';
part 'typedefs.dart';

class RxCrudSubject<Created, Read, Updated, Deleted> {
  RxCrudSubject({this.sync = true});
  final bool sync;

  late final StreamController<RxCrudEvent<Created, Read, Updated, Deleted>>
  _controller = StreamController.broadcast(sync: sync);

  Stream<RxCrudEvent<Created, Read, Updated, Deleted>> get stream =>
      _controller.stream;

  Future<ListT> _handleItems<ListT, Item>(
    RxListConverter<Item, ListT> converter,
    Future<ListT> Function() handler,
    void Function(Iterable<Item> batch) onComplete,
  ) {
    return _handle(
      handler,
      onComplete: (value) {
        final items = converter(value);
        onComplete(items);
      },
    );
  }

  Future<T> _handle<T>(
    Future<T> Function() handler, {
    void Function(T value)? onComplete,
  }) async {
    final Completer<T> completer = Completer.sync();
    Future<void> execute() async {
      try {
        final result = await handler();
        completer.complete(result);
        onComplete?.call(result);
      } catch (e) {
        completer.completeError(e);
      }
    }

    execute();
    return completer.future;
  }

  Future<Created> create(Future<Created> Function() handler) {
    return _handle(
      handler,
      onComplete: (value) {
        _addCreated(value);
      },
    );
  }

  Future<Read> read(Future<Read> Function() handler) {
    return _handle(
      handler,
      onComplete: (value) {
        _addRead(value);
      },
    );
  }

  Future<Updated> update(Future<Updated> Function() handler) {
    return _handle(
      handler,
      onComplete: (value) {
        _addUpdated(value);
      },
    );
  }

  Future<Deleted> delete(Future<Deleted> Function() handler) {
    return _handle(
      handler,
      onComplete: (value) {
        _addDeleted(value);
      },
    );
  }

  Future<Res> createBatch<Res>(
    Future<Res> Function() handler,
    RxListConverter<Created, Res> converter,
  ) {
    return _handleItems(converter, handler, (batch) {
      _addBatchCreated(batch);
    });
  }

  Future<Res> updateBatch<Res>(
    Future<Res> Function() handler,
    RxListConverter<Updated, Res> converter,
  ) {
    return _handleItems(converter, handler, (batch) {
      _addBatchUpdated(batch);
    });
  }

  Future<Res> deleteBatch<Res>(
    Future<Res> Function() handler,
    RxListConverter<Deleted, Res> converter,
  ) {
    return _handleItems(converter, handler, (batch) {
      _addBatchDeleted(batch);
    });
  }

  Future<Res> readBatch<Res>(
    Future<Res> Function() handler,
    RxListConverter<Read, Res> converter,
  ) {
    return _handleItems(converter, handler, (batch) {
      _addBatchRead(batch);
    });
  }

  Future<void> dispose() async {
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }

  void _addCreated(Created value) {
    _controller.add(RxCrudCreated(value: value));
  }

  void _addRead(Read value) {
    _controller.add(RxCrudRead(value: value));
  }

  void _addDeleted(Deleted value) {
    _controller.add(RxCrudDeleted(value: value));
  }

  void _addUpdated(Updated value) {
    _controller.add(RxCrudUpdated(value: value));
  }

  void _addBatchCreated(Iterable<Created> batch) {
    _controller.add(RxCrudBatchCreated(batch: batch));
  }

  void _addBatchRead(Iterable<Read> batch) {
    _controller.add(RxCrudBatchRead(batch: batch));
  }

  void _addBatchUpdated(Iterable<Updated> batch) {
    _controller.add(RxCrudBatchUpdated(batch: batch));
  }

  void _addBatchDeleted(Iterable<Deleted> batch) {
    _controller.add(RxCrudBatchDeleted(batch: batch));
  }
}
