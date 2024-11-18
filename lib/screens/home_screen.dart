import 'package:flutter/material.dart';
import '../models/show.dart';
import '../services/api_service.dart';
import 'details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Show> _shows = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  Future<void> _loadShows() async {
    try {
      final shows = await _apiService.getShows('all');
      setState(() {
        _shows = shows;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading shows: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : RefreshIndicator(
              onRefresh: _loadShows,
              child: CustomScrollView(
                slivers: [
                  // Featured Show Header
                  if (_shows.isNotEmpty)
                    SliverToBoxAdapter(
                      child: FeaturedShowHeader(show: _shows[0]),
                    ),

                  // Trending Shows
                  SliverToBoxAdapter(
                    child: ShowsSection(
                      title: 'Trending Now',
                      shows: _shows.take(10).toList(),
                    ),
                  ),

                  // Popular Shows
                  SliverToBoxAdapter(
                    child: ShowsSection(
                      title: 'Popular on Movie App',
                      shows: _shows.skip(10).take(10).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class FeaturedShowHeader extends StatelessWidget {
  final Show show;

  const FeaturedShowHeader({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Featured Image
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(show.imageUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
                Colors.black,
              ],
            ),
          ),
        ),
        // Content
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  show.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (show.genres.isNotEmpty)
                  Text(
                    show.genres.join(' • '),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      icon: Icons.play_arrow,
                      label: 'Play',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(show: show),
                          ),
                        );
                      },
                    ),
                    _ActionButton(
                      icon: Icons.info_outline,
                      label: 'More Info',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(show: show),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Top Gradient
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // App Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShowsSection extends StatelessWidget {
  final String title;
  final List<Show> shows;

  const ShowsSection({
    super.key,
    required this.title,
    required this.shows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: shows.length,
            itemBuilder: (context, index) {
              return ShowCard(show: shows[index]);
            },
          ),
        ),
      ],
    );
  }
}

class ShowCard extends StatelessWidget {
  final Show show;

  const ShowCard({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(show: show),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 130,
            child: show.imageUrl != null
                ? Image.network(
                    show.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.movie, size: 50, color: Colors.white54),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
} 