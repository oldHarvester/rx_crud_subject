part of 'rx_crud_subject.dart';

extension RxCrudEventExtension<Created, Read, Updated, Deleted>
    on RxCrudEvent<Created, Read, Updated, Deleted> {
  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxCrudStandaloneEvent<Created, Read, Updated, Deleted> event,
    )
    onStandalone,
    required WhenValue Function(
      RxCrudBatchEvent<Created, Read, Updated, Deleted> event,
    )
    onBatch,
  }) {
    return switch (this) {
      final RxCrudStandaloneEvent<Created, Read, Updated, Deleted> event =>
        onStandalone(event),
      final RxCrudBatchEvent<Created, Read, Updated, Deleted> event => onBatch(
        event,
      ),
    };
  }
}

sealed class RxCrudEvent<Created, Read, Updated, Deleted> with EquatableMixin {
  const RxCrudEvent();
}

sealed class RxCrudStandaloneEvent<Created, Read, Updated, Deleted>
    extends RxCrudEvent<Created, Read, Updated, Deleted> {
  const RxCrudStandaloneEvent();

  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxCrudCreated<Created, Read, Updated, Deleted> event,
    )
    onCreated,
    required WhenValue Function(
      RxCrudRead<Created, Read, Updated, Deleted> event,
    )
    onRead,
    required WhenValue Function(
      RxCrudUpdated<Created, Read, Updated, Deleted> event,
    )
    onUpdated,
    required WhenValue Function(
      RxCrudDeleted<Created, Read, Updated, Deleted> event,
    )
    onDeleted,
  }) {
    return switch (this) {
      final RxCrudCreated<Created, Read, Updated, Deleted> event => onCreated(
        event,
      ),
      final RxCrudRead<Created, Read, Updated, Deleted> event => onRead(event),
      final RxCrudUpdated<Created, Read, Updated, Deleted> event => onUpdated(
        event,
      ),
      final RxCrudDeleted<Created, Read, Updated, Deleted> event => onDeleted(
        event,
      ),
    };
  }
}

sealed class RxCrudBatchEvent<Created, Read, Updated, Deleted>
    extends RxCrudEvent<Created, Read, Updated, Deleted> {
  const RxCrudBatchEvent();

  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxCrudBatchCreated<Created, Read, Updated, Deleted> event,
    )
    onCreated,
    required WhenValue Function(
      RxCrudBatchRead<Created, Read, Updated, Deleted> event,
    )
    onRead,
    required WhenValue Function(
      RxCrudBatchUpdated<Created, Read, Updated, Deleted> event,
    )
    onUpdated,
    required WhenValue Function(
      RxCrudBatchDeleted<Created, Read, Updated, Deleted> event,
    )
    onDeleted,
  }) {
    return switch (this) {
      final RxCrudBatchCreated<Created, Read, Updated, Deleted> event =>
        onCreated(event),
      final RxCrudBatchRead<Created, Read, Updated, Deleted> event => onRead(
        event,
      ),
      final RxCrudBatchUpdated<Created, Read, Updated, Deleted> event =>
        onUpdated(event),
      final RxCrudBatchDeleted<Created, Read, Updated, Deleted> event =>
        onDeleted(event),
    };
  }
}

/// Standalone events

final class RxCrudCreated<Created, Read, Updated, Deleted>
    extends RxCrudStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxCrudCreated({required this.value});
  final Created value;

  @override
  List<Object?> get props => [value];
}

final class RxCrudRead<Created, Read, Updated, Deleted>
    extends RxCrudStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxCrudRead({required this.value});

  final Read value;

  @override
  List<Object?> get props => [value];
}

final class RxCrudUpdated<Created, Read, Updated, Deleted>
    extends RxCrudStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxCrudUpdated({required this.value});
  final Updated value;

  @override
  List<Object?> get props => [value];
}

final class RxCrudDeleted<Created, Read, Updated, Deleted>
    extends RxCrudStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxCrudDeleted({required this.value});

  final Deleted value;

  @override
  List<Object?> get props => [value];
}

/// Batch events

final class RxCrudBatchCreated<Created, Read, Updated, Deleted>
    extends RxCrudBatchEvent<Created, Read, Updated, Deleted> {
  const RxCrudBatchCreated({required this.batch});
  final Iterable<Created> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxCrudBatchRead<Created, Read, Updated, Deleted>
    extends RxCrudBatchEvent<Created, Read, Updated, Deleted> {
  const RxCrudBatchRead({required this.batch});
  final Iterable<Read> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxCrudBatchUpdated<Created, Read, Updated, Deleted>
    extends RxCrudBatchEvent<Created, Read, Updated, Deleted> {
  const RxCrudBatchUpdated({required this.batch});

  final Iterable<Updated> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxCrudBatchDeleted<Created, Read, Updated, Deleted>
    extends RxCrudBatchEvent<Created, Read, Updated, Deleted> {
  const RxCrudBatchDeleted({required this.batch});
  final Iterable<Deleted> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}
