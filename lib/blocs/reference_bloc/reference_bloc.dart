import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Data/reference_db.dart';
import '../../Objects/reference_rock.dart';

part 'reference_event.dart';
part 'reference_state.dart';

class ReferenceBloc extends Bloc<ReferenceEvent, ReferenceState> {
  ReferenceBloc() : super(ReferenceInitial()) {
    on<ReferenceEvent>((event, emit) async {
      if(event is SaveReferenceData){
        emit(LoadingReferenceData());
        await DB.instance.loadRefData();
        emit(ReferenceDataSaved());
        add(LoadReferenceData());
      }

      if(event is LoadReferenceData){
        emit(LoadingReferenceData());
        List<ReferenceRock> rocks = await DB.instance.getAllRefRocks();
        emit(ReferenceDataLoaded(referenceRocks: rocks));
      }
    });
  }
}
