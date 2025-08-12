import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../models/photo.dart';
import '../services/api_service.dart';
import '../widgets/photo_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(photoService: PhotoService())
        ..add(const PhotosRequested()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            'Findoc Gallery',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue.shade600,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                // Add refresh functionality
                BlocProvider.of<HomeBloc>(context).add(const PhotosRefreshed());
              },
            ),
          ],
        ),
        body: const PhotosList(),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
          case HomeStatus.loading:
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading beautiful photos...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          
          case HomeStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load photos',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'Please check your connection',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<HomeBloc>().add(const PhotosRequested()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          
          case HomeStatus.success:
            if (state.photos.isEmpty) {
              return const Center(
                child: Text(
                  'No photos available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const PhotosRefreshed());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  return PhotoCard(photo: state.photos[index]);
                },
              ),
            );
        }
      },
    );
  }
}
