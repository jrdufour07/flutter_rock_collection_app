part of 'collection_bloc.dart';

@immutable
abstract class CollectionState {}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState{}

class CollectionLoaded extends CollectionState{
  final List<CollectionRock> collectionRocks;

  CollectionLoaded({required this.collectionRocks});
}