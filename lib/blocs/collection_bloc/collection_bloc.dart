import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Data/reference_db.dart';

import '../../Objects/collection_rock.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(CollectionInitial()) {
    on<CollectionEvent>((event, emit) async {
      if(event is LoadCollection){
        emit(CollectionLoading());
        List<CollectionRock> rocks = await DB.instance.getAllCollectionRocks();
        emit(CollectionLoaded(collectionRocks: rocks));
      }
      if(event is AddCollectionRock){
        emit(CollectionLoading());
        await DB.instance.insertCollectionRock(event.rock);
        add(LoadCollection());
      }
      if(event is RemoveCollectionRock){
        await DB.instance.deleteCollectionRock(event.rock);
      }
      if(event is SaveCollectionRock){
        await DB.instance.upDateCollectionRock(event.rock);
      }
    });
  }

}
