import 'package:equatable/equatable.dart';
import '../../models/photo.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Photo> photos;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.photos = const <Photo>[],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Photo>? photos,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, photos, errorMessage];
}
