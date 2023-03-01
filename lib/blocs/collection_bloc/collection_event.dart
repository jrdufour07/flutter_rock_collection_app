part of 'collection_bloc.dart';

@immutable
abstract class CollectionEvent {}

class LoadCollection extends CollectionEvent{}

class AddCollectionRock extends CollectionEvent{
  final CollectionRock rock;
  AddCollectionRock({required this.rock});
}

class SaveCollectionRock extends CollectionEvent{
  final CollectionRock rock;
  SaveCollectionRock({required this.rock});
}

class RemoveCollectionRock extends CollectionEvent{
  final CollectionRock rock;
  RemoveCollectionRock({required this.rock});
}


