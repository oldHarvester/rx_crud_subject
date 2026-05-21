part of 'rx_crud_subject.dart';

typedef RxListConverter<Item, Res> = Iterable<Item> Function(Res response);

typedef RxDefaultCrudEvent<State> = RxCrudEvent<State, State, State, int>;

typedef RxDefaultCrudSubject<State> = RxCrudSubject<State, State, State, int>;
