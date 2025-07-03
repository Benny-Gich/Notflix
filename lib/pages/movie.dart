import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Movie extends StatelessWidget {
  final String title;
  final String poster;
  final String imdbID;
  final String year;
  final String type;

  const Movie({
    super.key,
    required this.title,
    required this.poster,
    required this.imdbID,
    required this.year,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('Movie'),
        centerTitle: true,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            // Movie Poster and Info
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster Image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(poster, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Movie Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(
                                label: Text(year),
                                backgroundColor: Colors.grey[800],
                              ),
                              Chip(
                                label: Text(type),
                                backgroundColor: Colors.grey[800],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: 0,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemBuilder: (context, _) =>
                                Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('PLAY NOW'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('MY LIST'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Synopsis
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SYNOPSIS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(imdbID, style: TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
