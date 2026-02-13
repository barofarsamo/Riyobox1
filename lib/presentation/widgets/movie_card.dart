
import 'package:flutter/material.dart';
import 'package:riyobox/models/movie.dart';
import 'package:riyobox/presentation/widgets/shimmer_loading.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double height;

  const MovieCard({super.key, required this.movie, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Movie: ${movie.title}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ExcludeSemantics(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return ShimmerLoading.rectangular(height: height);
          },
              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }
}
