part of 'reference_bloc.dart';

@immutable
abstract class ReferenceState {}

class ReferenceInitial extends ReferenceState {}

class LoadingReferenceData extends ReferenceState{}

class ReferenceDataSaved extends ReferenceState{}

class ReferenceDataLoaded extends ReferenceState{
  final List<ReferenceRock> referenceRocks;
  ReferenceDataLoaded({required this.referenceRocks});
}