import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PhotoService _photoService;

  HomeBloc({required PhotoService photoService})
      : _photoService = photoService,
        super(const HomeState()) {
    on<PhotosRequested>(_onPhotosRequested);
    on<PhotosRefreshed>(_onPhotosRefreshed);
  }

  // Load photos when requested
  Future<void> _onPhotosRequested(
    PhotosRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    
    try {
      // Fetch photos from API
      final photos = await _photoService.fetchPhotos();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          photos: photos,
        ),
      );
    } catch (error) {
      // Handle any errors that occur
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  // Refresh photos when user pulls to refresh
  Future<void> _onPhotosRefreshed(
    PhotosRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final photos = await _photoService.fetchPhotos();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          photos: photos,
        ),
      );
    } catch (error) {
      // Show error but don't show loading state since this is a refresh
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
