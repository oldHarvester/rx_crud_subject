part of 'rx_crud_subject.dart';

extension RxEventExtension<Created, Read, Updated, Deleted>
    on RxEvent<Created, Read, Updated, Deleted> {
  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxStandaloneEvent<Created, Read, Updated, Deleted> event,
    )
    onStandalone,
    required WhenValue Function(
      RxBatchEvent<Created, Read, Updated, Deleted> event,
    )
    onBatch,
  }) {
    return switch (this) {
      final RxStandaloneEvent<Created, Read, Updated, Deleted> event =>
        onStandalone(event),
      final RxBatchEvent<Created, Read, Updated, Deleted> event => onBatch(
        event,
      ),
    };
  }
}

sealed class RxEvent<Created, Read, Updated, Deleted> with EquatableMixin {
  const RxEvent();
}

sealed class RxStandaloneEvent<Created, Read, Updated, Deleted>
    extends RxEvent<Created, Read, Updated, Deleted> {
  const RxStandaloneEvent();

  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxCreateEvent<Created, Read, Updated, Deleted> event,
    )
    onCreate,
    required WhenValue Function(
      RxReadEvent<Created, Read, Updated, Deleted> event,
    )
    onRead,
    required WhenValue Function(
      RxUpdateEvent<Created, Read, Updated, Deleted> event,
    )
    onUpdate,
    required WhenValue Function(
      RxDeleteEvent<Created, Read, Updated, Deleted> event,
    )
    onDelete,
  }) {
    return switch (this) {
      final RxCreateEvent<Created, Read, Updated, Deleted> event => onCreate(
        event,
      ),
      final RxReadEvent<Created, Read, Updated, Deleted> event => onRead(event),
      final RxUpdateEvent<Created, Read, Updated, Deleted> event => onUpdate(
        event,
      ),
      final RxDeleteEvent<Created, Read, Updated, Deleted> event => onDelete(
        event,
      ),
    };
  }
}

sealed class RxBatchEvent<Created, Read, Updated, Deleted>
    extends RxEvent<Created, Read, Updated, Deleted> {
  const RxBatchEvent();

  WhenValue when<WhenValue>({
    required WhenValue Function(
      RxBatchCreated<Created, Read, Updated, Deleted> event,
    )
    onCreated,
    required WhenValue Function(
      RxBatchRead<Created, Read, Updated, Deleted> event,
    )
    onRead,
    required WhenValue Function(
      RxBatchUpdated<Created, Read, Updated, Deleted> event,
    )
    onUpdated,
    required WhenValue Function(
      RxBatchDeleted<Created, Read, Updated, Deleted> event,
    )
    onDeleted,
  }) {
    return switch (this) {
      final RxBatchCreated<Created, Read, Updated, Deleted> event => onCreated(
        event,
      ),
      final RxBatchRead<Created, Read, Updated, Deleted> event => onRead(event),
      final RxBatchUpdated<Created, Read, Updated, Deleted> event => onUpdated(
        event,
      ),
      final RxBatchDeleted<Created, Read, Updated, Deleted> event => onDeleted(
        event,
      ),
    };
  }
}

/// Standalone events

final class RxCreateEvent<Created, Read, Updated, Deleted>
    extends RxStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxCreateEvent({required this.value});
  final Created value;

  @override
  List<Object?> get props => [value];
}

final class RxReadEvent<Created, Read, Updated, Deleted>
    extends RxStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxReadEvent({required this.value});

  final Read value;

  @override
  List<Object?> get props => [value];
}

final class RxUpdateEvent<Created, Read, Updated, Deleted>
    extends RxStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxUpdateEvent({required this.value});
  final Updated value;

  @override
  List<Object?> get props => [value];
}

final class RxDeleteEvent<Created, Read, Updated, Deleted>
    extends RxStandaloneEvent<Created, Read, Updated, Deleted> {
  const RxDeleteEvent({required this.value});

  final Deleted value;

  @override
  List<Object?> get props => [value];
}

/// Batch events

final class RxBatchCreated<Created, Read, Updated, Deleted>
    extends RxBatchEvent<Created, Read, Updated, Deleted> {
  const RxBatchCreated({required this.batch});
  final Iterable<Created> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxBatchRead<Created, Read, Updated, Deleted>
    extends RxBatchEvent<Created, Read, Updated, Deleted> {
  const RxBatchRead({required this.batch});
  final Iterable<Read> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxBatchUpdated<Created, Read, Updated, Deleted>
    extends RxBatchEvent<Created, Read, Updated, Deleted> {
  const RxBatchUpdated({required this.batch});

  final Iterable<Updated> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

final class RxBatchDeleted<Created, Read, Updated, Deleted>
    extends RxBatchEvent<Created, Read, Updated, Deleted> {
  const RxBatchDeleted({required this.batch});
  final Iterable<Deleted> batch;

  @override
  List<Object?> get props => [IterableEquality().hash(batch)];
}

typedef RxListConverter<Item, Res> = Iterable<Item> Function(Res response);

typedef RxDefaultEvent<State> = RxEvent<State, State, State, int>;

typedef RxDefaultCrudSubject<State> = RxCrudSubject<State, State, State, int>;
