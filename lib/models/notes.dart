class Notes {
  String id;
  String title;
  String description;
  bool isArchived;
  DateTime createdAt;
  DateTime updatedAt;

  Notes({
    required this.id,
    required this.title,
    required this.description,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notes.fromJSON(Map<String, dynamic> json) {
    return Notes(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isArchived: json['isArchived'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isArchived': isArchived,
    };
  }
}
