import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class PhotosRequested extends HomeEvent {
  const PhotosRequested();
}

class PhotosRefreshed extends HomeEvent {
  const PhotosRefreshed();
}
