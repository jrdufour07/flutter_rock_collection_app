part of 'reference_bloc.dart';

@immutable
abstract class ReferenceEvent {}

class SaveReferenceData extends ReferenceEvent{}

class LoadReferenceData extends ReferenceEvent{

}