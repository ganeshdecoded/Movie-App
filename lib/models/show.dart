class Show {
  final int id;
  final String name;
  final String? imageUrl;
  final String summary;
  final double? rating;
  final List<String> genres;
  final String? status;
  final String? premiered;
  final String? ended;
  final String? language;
  final String type;
  final Map<String, dynamic>? schedule;
  final String? officialSite;
  final String? network;

  Show({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.summary,
    this.rating,
    required this.genres,
    this.status,
    this.premiered,
    this.ended,
    this.language,
    required this.type,
    this.schedule,
    this.officialSite,
    this.network,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    final show = json['show'];
    
    // Handle potential null values and type conversions
    return Show(
      id: show['id'] ?? 0,
      name: show['name'] ?? 'Unknown',
      imageUrl: show['image']?['medium'],
      // Remove HTML tags from summary if present, or provide default text
      summary: show['summary']?.toString().replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No summary available',
      rating: show['rating']?['average']?.toDouble(),
      genres: List<String>.from(show['genres'] ?? []),
      status: show['status']?.toString(),
      premiered: show['premiered']?.toString(),
      ended: show['ended']?.toString(),
      language: show['language']?.toString(),
      type: show['type']?.toString() ?? 'Unknown',
      schedule: show['schedule'] as Map<String, dynamic>?,
      officialSite: show['officialSite']?.toString(),
      network: show['network']?['name']?.toString(),
    );
  }
} 