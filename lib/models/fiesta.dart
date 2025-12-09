class Fiesta {
  final int? id;
  final String userId;
  final String name;
  final String? description;
  final DateTime date;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  Fiesta({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.date,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  factory Fiesta.fromMap(Map<String, dynamic> map) {
    return Fiesta(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      // 'created_at' is handled by DB defaults usually, but can be sent if needed
    };
  }
}
