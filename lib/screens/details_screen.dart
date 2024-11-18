import 'package:flutter/material.dart';
import '../models/show.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final Show show;

  const DetailsScreen({super.key, required this.show});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    try {
      final Uri uri = Uri.parse(urlString);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $urlString')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                show.name,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: show.imageUrl != null
                  ? Image.network(
                      show.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 100),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Genres
                  if (show.rating != null || show.genres.isNotEmpty)
                    Row(
                      children: [
                        if (show.rating != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 20),
                                Text(
                                  ' ${show.rating}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (show.genres.isNotEmpty)
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: show.genres
                                  .map((genre) => Chip(
                                        label: Text(genre),
                                        backgroundColor:
                                            Theme.of(context).colorScheme.secondary,
                                        labelStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Show Info
                  InfoSection(
                    title: 'Show Info',
                    children: [
                      if (show.status != null)
                        InfoRow(label: 'Status', value: show.status!),
                      InfoRow(label: 'Show Type', value: show.type),
                      if (show.language != null)
                        InfoRow(label: 'Language', value: show.language!),
                      if (show.premiered != null)
                        InfoRow(label: 'Premiered', value: show.premiered!),
                      if (show.ended != null)
                        InfoRow(label: 'Ended', value: show.ended!),
                      if (show.network != null)
                        InfoRow(label: 'Network', value: show.network!),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Schedule
                  if (show.schedule != null &&
                      (show.schedule!['time'] != null ||
                          show.schedule!['days'] != null))
                    InfoSection(
                      title: 'Schedule',
                      children: [
                        if (show.schedule!['time'] != null)
                          InfoRow(
                              label: 'Time',
                              value: show.schedule!['time'].toString()),
                        if (show.schedule!['days'] != null)
                          InfoRow(
                              label: 'Days',
                              value: (show.schedule!['days'] as List)
                                  .map((day) => day.toString())
                                  .join(', ')),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Official Site
                  if (show.officialSite != null && show.officialSite!.isNotEmpty) ...[
                    ElevatedButton.icon(
                      onPressed: () => _launchURL(context, show.officialSite!),
                      icon: const Icon(Icons.language),
                      label: const Text('Visit Official Website'),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Summary
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(show.summary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 