class AppEvent {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime date;
  final String time;
  final String location;
  final double price;
  final String organizerId;
  final int attendeeCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.organizerId,
    required this.attendeeCount,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'category': category,
    'date': date.toIso8601String(),
    'time': time,
    'location': location,
    'price': price,
    'organizerId': organizerId,
    'attendeeCount': attendeeCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AppEvent.fromJson(Map<String, dynamic> json) => AppEvent(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    category: json['category'] as String,
    date: DateTime.parse(json['date'] as String),
    time: json['time'] as String,
    location: json['location'] as String,
    price: (json['price'] as num).toDouble(),
    organizerId: json['organizerId'] as String,
    attendeeCount: json['attendeeCount'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  AppEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    DateTime? date,
    String? time,
    String? location,
    double? price,
    String? organizerId,
    int? attendeeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    category: category ?? this.category,
    date: date ?? this.date,
    time: time ?? this.time,
    location: location ?? this.location,
    price: price ?? this.price,
    organizerId: organizerId ?? this.organizerId,
    attendeeCount: attendeeCount ?? this.attendeeCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
