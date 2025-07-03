import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notflix/pages/movie.dart';
import 'package:notflix/secrets/url.dart';
import 'package:notflix/models/tile.dart';
import 'package:notflix/widgets/mycard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  List<Tile> _tiles = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchAllMovies();
  }

  Future<void> _fetchAllMovies() async {
    try {
      final response = await http.get(Uri.parse(Url.url));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["Search"] != null) {
          setState(() {
            _tiles = (result["Search"] as List)
                .map((tile) => Tile.fromJson(tile))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No movies found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load movies: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching movies: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToMovie(Tile tile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Movie(
          title: tile.title,
          poster: tile.poster,
          imdbID: tile.imdbID,
          year: tile.year,
          type: tile.type,
        ),
      ),
    );
  }

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final response = await http.get(Uri.parse('${Url.url}&s=$query'));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["Search"] != null) {
          setState(() {
            _tiles = (result["Search"] as List)
                .map((tile) => Tile.fromJson(tile))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No results found for "$query"';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Search failed: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Search error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notflix'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                _fetchAllMovies();
                setState(() {
                  _isSearching = false;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search movies...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _fetchAllMovies();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: _searchMovies,
            ),
            const SizedBox(height: 20),
            if (!_isSearching) ...[
              const Text(
                'Hello, Gich!',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isSearching ? 'Search Results' : 'Trending Now!',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('View all')),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : _tiles.isEmpty
                  ? const Center(child: Text('No movies found'))
                  : SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        itemCount: _tiles.length,
                        itemBuilder: (context, index) {
                          final tile = _tiles[index];
                          return GestureDetector(
                            onTap: () => _navigateToMovie(tile),
                            child: MyCard(tile: tile),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
